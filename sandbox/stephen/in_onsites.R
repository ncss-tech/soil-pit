options(stringsAsFactors = FALSE)

library(sp)
library(sf)

ssa_sso_max <- read.csv("C:/workspace2/ssa_sso_max.csv")
ssa_r11ind <- subset(ssa_sso_max, NEW_SSAID == "11-IND", select = "AREASYMBOL")

# r11ind_mupolyong <- read_sf(dsn = "M:/geodata/project_data/R11-IND/RTSD_R11-IND_FY17.gdb", layer = "MUPOLYGON")
st_crs(r11ind_mupolygon) <- 5070
r11ind_mupolygon$idx <- 1:nrow(r11ind_mupolygon)
# save(r11ind_mupolygon, file = "r11ind_mupolygon.Rdata")
load(file = "r11ind_mupolygon.Rdata")

os <- read_sf(dsn = "C:/workspace2/CWD_Master.gdb", layer = "partial_cwd")
st_crs(os) <- 26916
names(os) <- tolower(names(os))

n <- 3
os <- within(os, {
  idx    = 0:(nrow(os) - 1)
  acres  = shape_area * 0.000247
  samp_n = ifelse(acres < n, 1, round(acres / n))
})

# Generate samples
os_samp <- by(os, os$idx, function(x) {
  os_sp = as(x, "Spatial")
  os_samp = spsample(os_sp, x$samp_n, type = "regular", iter = 500)
  if ("x1" %in% names(as.data.frame(os_samp))) {
    test = data.frame(as.data.frame(os_samp), idx = x$idx)
    coordinates(test) = ~ x1 + x2
    proj4string(test) = "+init=epsg:26916"
    return(test)
  }
})
os_samp2 <- do.call("rbind", os_samp)
os_sf <- st_as_sf(os_samp2)
os_sf <- st_transform(os_sf, crs = 5070)

# intersect data
idx  <- st_intersects(os_sf, r11ind_mupolygon)


# merge data
os_sf$idx2 <- unlist(lapply(idx, function(x) x[1]))
st_write(os_sf, dsn = "C:/workspace2/os_test.shp", layer = "os", delete_dsn = TRUE)
os_sf <- st_read(dsn = "C:/workspace2/os_test.shp")
os_sf$geometry <- NULL
class(os_sf) <- "data.frame"

mu_sub <- r11ind_mupolygon
mu_sub$Shape <- NULL
class(mu_sub) <- "data.frame"
mu_sub <- mu_sub[mu_sub$idx %in% unlist(idx), ]


os_mu <- merge(os_sf, mu_sub, by.x = "idx2", by.y = "idx", all.x = TRUE)
os_mu_r11ind <- subset(os_mu, AREASYMBOL %in% ssa_r11ind$AREASYMBOL)

sort(table(os_mu_r11ind$MUNAME), decreasing = TRUE)[1:10]

mukey <- subset(os_mu_r11ind, MUNAME %in% c(
  "Brookston silty clay loam, 0 to 2 percent slopes",
  "Treaty silty clay loam, 0 to 1 percent slopes",
  "Patton silty clay loam, 0 to 2 percent slopes",
  "Cyclone silty clay loam, 0 to 2 percent slopes"),
  select = MUKEY)
paste(unique(mukey$MUKEY), collapse = "' , '")
