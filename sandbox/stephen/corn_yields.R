# USDA-NASS Corn Yield Data https://github.com/potterzot/rnassqs

# devtools::install_github('potterzot/rnassqs')
# library(rnassqs)

# source("C:/Users/steph/Nextcloud/code/api_keys.R")

data(state)
st <- state.abb

# corn_us <- lapply(st, function(x) {
#   cat("getting", x, as.character(Sys.time()), "\n")
#   tryCatch({
#     corn = nassqs_yield(
#       list("commodity_desc"="CORN", 
#            "agg_level_desc"="COUNTY", 
#            "state_alpha"=x
#            ),
#       key = nass_key
#       )}, 
#     error = function(err) {
#       print(paste("Error occured:  ",err))
#       return(NULL)
#       }
#     )
#   })
# corn_us <- do.call("rbind", corn_us)
# 
# save(corn_us, file = "C:/workspace2/corn_us.RData")
# write.csv(corn_us, file = "nass_corn_us.csv", row.names = FALSE)
load(file = "C:/Users/Stephen.Roecker/Nextcloud/data/corn_us.RData")

corn_yield <- subset(corn_us, short_desc == "CORN, GRAIN - YIELD, MEASURED IN BU / ACRE")
corn_yield <- within(corn_yield, {
  Value      = as.numeric(Value)
  year       = as.numeric(year)
  state_name = NULL
  state      = state_alpha
  agency     = "NASS"
})

cnty_corn <- merge(cnty, corn_yield, 
                   by.x = c("state_abbr", "countyfp"), 
                   by.y = c("state_alpha", "county_code"), 
                   all.x = TRUE
)



# USDA-NRCS NASIS Corn Yield Data

library(dplyr)
library(sf)
library(soilDB)

yields <- read_sf(dsn = "M:/geodata/soils/SSURGO_CONUS_FY19.gdb", layer = "cocropyld", query = "SELECT * FROM cocropyld WHERE cropname = 'Corn'")
comp   <- read_sf(dsn = "M:/geodata/soils/SSURGO_CONUS_FY19.gdb", layer = "component")
mu     <- read_sf(dsn = "M:/geodata/soils/SSURGO_CONUS_FY19.gdb", layer = "mapunit")
leg    <- read_sf(dsn = "M:/geodata/soils/SSURGO_CONUS_FY19.gdb", layer = "legend")
# interp <- read_sf(dsn = "M:/geodata/soils/SSURGO_CONUS_FY19.gdb", layer = "cointerp", query = "SELECT * FROM cointerp WHERE mrulename = 'NCCPI - NCCPI Corn Submodel (I)'")
sapolygon <- read_sf(dsn = "M:/geodata/soils/SSURGO_CONUS_FY19.gdb", layer = "SAPOLYGON")

corn_states <- c("IL", "IA", "IN", "MI", "MN", "MO", "NE", "ND", "OH", "SD", "WI")
idx <- grepl(paste0(corn_states, collapse = "|"), sapolygon$AREASYMBOL)

test = lapply(sort(sapolygon$AREASYMBOL[idx]), function(x) {
  cat("getting", x, as.character(Sys.time()), "\n")
  get_cointerp_from_SDA(WHERE = paste0("areasymbol = '", x, "'"), mrulename = "NCCPI%")
})
nccpi <- do.call("rbind", test)

# save(yields, mu, comp, leg, nccpi, file = "C:/Users/Stephen.Roecker/Nextcloud/data/corn_yield_nasis.RData")
load(file = "C:/Users/Stephen.Roecker/Nextcloud/data/corn_yield_nasis.RData")

nccpi <- nccpi[!duplicated(nccpi), ]
nccpi$cokey <- as.character(nccpi$cokey)

yld <- inner_join(leg[c("lkey", "areasymbol")], 
                  mu[c("mukey", "muacres", "lkey")], 
                  by = "lkey"
                  ) %>%
  inner_join(comp[c("cokey", "compname", "mukey", "comppct_r")], by = "mukey") %>%
  left_join(yields, by = "cokey") %>%
  left_join(nccpi[nccpi$mrulename == "NCCPI - National Commodity Crop Productivity Index (Ver 3.0)", c("cokey", "interplr")], by = "cokey") %>%
  mutate(coacres = muacres * comppct_r)


yld_sum <- yld %>%
  # assume only map units with corn yield estimates are used to grow corn
  filter(yldunits == "Bu" & (nonirryield_r > 0 | irryield_r > 0) & muacres > 0) %>%
  # assume if irryield_r is present all corn is irrigated
  mutate(yield_r = ifelse(!is.na(irryield_r), irryield_r, nonirryield_r)
         # yield_r = nonirryield_r
         ) %>%
  group_by(areasymbol) %>%
  summarize(
    yield_med = Hmisc::wtd.quantile(yield_r, weights = coacres, probs = 0.5, na.rm = TRUE),
    yield_l   = Hmisc::wtd.quantile(yield_r, weights = coacres, probs = 0.05, na.rm = TRUE),
    yield_h   = Hmisc::wtd.quantile(yield_r, weights = coacres, probs = 0.95, na.rm = TRUE),
    nccpi_r   = weighted.mean(interplr,      w = coacres, na.rm = TRUE)
  ) %>%
  mutate(state = substr(areasymbol, 1, 2)) %>%
  group_by(state) %>%
  summarize(yield_min = min(yield_med, na.rm = TRUE),
            yield_med = median(yield_med, na.rm = TRUE),
            yield_max = max(yield_med, na.rm = TRUE),
            nccpi_med = median(nccpi_r, na.rm = TRUE)
            ) %>%
  mutate(agency = "NASIS")


# Correlate NASS yields with NCCPI
yld_areasymbol <- yld %>%
  # assume only map units with corn yield estimates are used to grow corn
  filter(yldunits == "Bu" & (nonirryield_r > 0 | irryield_r > 0) & muacres > 0) %>%
  # assume if irryield_r is present all corn is irrigated
  mutate(yield_r = ifelse(!is.na(irryield_r), irryield_r, nonirryield_r)
         # yield_r = nonirryield_r
  ) %>%
  group_by(areasymbol) %>%
  summarize(
    nccpi_r   = weighted.mean(interplr,      w = coacres, na.rm = TRUE)
    ) %>%
  mutate(state_alpha = substr(areasymbol, 1, 2),
         county_code = substr(areasymbol, 3, 5)
         ) %>%
  inner_join(corn_yield, by = c("state_alpha", "county_code")) %>%
  mutate(decade = substr(year, 3, 4))

yld_areasymbol %>%
  filter(state %in% corn_states) %>%
  ggplot(aes(x = nccpi_r, y = Value, col = year)) +
  geom_point(alpha = 0.2, pch = 19) +
  geom_smooth() +
  scale_color_viridis_c() +
  facet_wrap(~ state) +
  ylab("corn yield (bu/acre)") +
  ggtitle("Comparison of USDA-NASS and USDA-NRCS NCCPI")
  


# yld_sum2 <- {
#   split(yld_sum, yld_sum$state) ->.;
#   lapply(., function(x) {
#     data.frame(
#       x[1:4],
#       year = 1910:2018
#     )
#   }) ->.;
#   do.call("rbind", .)
# }


# plot results

library(ggplot2)

corn_states <- c("IL", "IA", "IN", "MI", "MN", "MO", "NE", "ND", "OH", "SD", "WI")
idx <- yld_sum$state %in% corn_states

group_by(corn_yield, state, year, agency) %>%
  summarize(
    yield_min    = min(Value, na.rm = TRUE),
    yield_median = median(Value, na.rm = TRUE),
    yield_max    = max(Value, na.rm = TRUE)
  ) %>%
  filter(state %in% corn_states) %>%
  ggplot() +
  geom_line(aes(x = year, y = yield_median, col = agency)) +
  geom_ribbon(aes(x = year, ymin = yield_min, ymax = yield_max, fill = agency), alpha = 0.5) +
  facet_wrap(~ state) +
  geom_pointrange(data = yld_sum[idx, ], aes(x = 2018, y = yield_med, ymin = yield_min, ymax = yield_max, col = agency)) +
  # scale_fill_manual(values = "blue") +
  scale_color_manual(values = c("orange", "blue")) +
  ylab("median yield per county (bu/acre)") +
  ggtitle("Comparison of USDA-NASS and USDA-NRCS Corn Yields")



