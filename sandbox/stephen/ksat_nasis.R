library(rvest)
library(xml2)
library(ggplot2)
library(aqp)
library(soilDB)

ksat_html <- read_html("C:/ProgramData/USDA/NASIS/Temp/get_pedon_ksat_from_NWR.html")
ksat_list <- html_table(ksat_html, header = TRUE)
ksat <- do.call("rbind", ksat_list)
names(ksat)[4:5] <- c("lat", "lon")
# ksat$lat <- as.numeric(gsub(",", "", ksat$lat))

# method
idx_fh <- apply(ksat[, names(ksat)[grepl("ksat_fh", names(ksat))]], 1, function(x) any(!is.na(x)))
idx_ch <- apply(ksat[, names(ksat)[grepl("ksat_ch", names(ksat))]], 1, function(x) any(!is.na(x)))
idx_ri <- apply(ksat[, names(ksat)[grepl("ksat_ri", names(ksat))]], 1, function(x) any(!is.na(x)))
idx_am <- apply(ksat[, names(ksat)[grepl("ksat_am", names(ksat))]], 1, function(x) any(!is.na(x)))

ksat <- within(ksat, {
  method = "NULL"
  method = ifelse(idx_fh, "falling head", method)
  method = ifelse(idx_ch, "constant head", method)
  method = ifelse(idx_ri, "ring", method)
  method = ifelse(idx_am, "amoozemeter", method)
  peiid  = gsub(",", "", `Rec ID`)
  })


# phorizon data
ksat_html <- read_html("C:/ProgramData/USDA/NASIS/Temp/get_phorizon_ksat_from_NWR.html")
ksat_h_list <- html_table(ksat_html, header = TRUE)
ksat_h <- do.call("rbind", ksat_h_list)
names(ksat)[4:5] <- c("lat", "lon")
# ksat$lat <- as.numeric(gsub(",", "", ksat$lat))

test <- fetchNASIS()
h <- horizons(test)

# filter stepped values
ksat_n <- sort(table(round(h$ksatpedon)), decreasing = TRUE)
idx <- which(ksat_n > 800)
idx <- names(ksat_n[idx])

h_sub <- filter(h, ! as.character(round(ksatpedon)) %in% idx)
ksat2 <- ksat %>%
  mutate(peiid = as.numeric(gsub(",", "", `Rec ID`))) %>%
  filter(peiid %in% h_sub$peiid | idx_am | idx_ri | idx_ch | idx_fh)


# loads data from maps package
st <- map_data("state")

ggplot() +
  geom_point(data = ksat2, aes(x = lon, y = lat, col = method), alpha = 0.5) +
  geom_path(data = st, aes(x = long, y = lat, group = group)) +
  xlim(range(st$lon)) +
  ylim(range(st$lat)) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  ggtitle("Location of Pedons with Ksat")

ggplot(h_sub, aes(x = round(ksatpedon))) + geom_bar() + ylab("count (n)") + xlab("Ksat values") + ggtitle("Bar plot of ksatpedon values from the phorizon table")
