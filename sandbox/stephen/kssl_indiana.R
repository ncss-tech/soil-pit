library(aqp)
library(soilDB)
library(ggplot2)
library(sf)

st <- maps::map("county", "indiana", fill = TRUE, plot = FALSE)
st_sf <- st_as_sf(maptools::map2SpatialPolygons(st, IDs = st$names))
st_crs(st_sf) <- "+init=epsg:4326"

bb <- st_bbox(st_sf)

f1 <- fetchKSSL(bbox = c(-84,  37, -86,  42))
f2 <- fetchKSSL(bbox = c(-86,  37, -87,  42))
f3 <- fetchKSSL(bbox = c(-87,  37, -88,  42))
f4 <- fetchKSSL(bbox = c(-88,  37, -89,  42))

f <- list(f1, f2, f3, f4)
h <- do.call("rbind", lapply(f, function(x) aqp::horizons(x)))
s <- do.call("rbind", lapply(f, function(x) aqp::site(x)))
s <- s[!duplicated(s$pedon_id), ]

p <- h
p$hzID <- NULL
depths(p) <- pedon_key ~ hzn_top + hzn_bot
site(p) <- s

idx <- complete.cases(p$x, p$y)
p_sp <- p[idx, ]
coordinates(p_sp) <- ~ x + y
proj4string(p_sp) <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
p_sf <- st_as_sf(as(p_sp, "SpatialPointsDataFrame"))

idx  <- st_intersects(st_sf, p_sf)
p_sf <- p_sf[unique(idx[[1]]), ]



ggplot() + 
  geom_sf(data = st_sf, fill = "white") +
  geom_sf(data = p_sf, alpha = 0.3, size = 2)
  
plot(p[sample(1:length(p), 5)], label = "taxonname", name = "hzn_desgn", color = "clay", main = "Sample")
     