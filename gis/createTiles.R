# Create tiles (example taken from Hengl getSRTM.R)
tiles <- expand.grid(KEEP.OUT.ATTRS=FALSE, lon=seq(-125,-66,by=1), lat=seq(24,50,by=1))
tiles.points <- tiles
tiles.points$label <- paste(tiles.points$lon, ",", tiles.points$lat, sep="")
coordinates(tiles.points) <- ~ lon+lat
proj4string(tiles.points) <- CRS("+init=epsg:4326")
tiles.poly <- tiles.points
gridded(tiles.poly) <- TRUE
tiles.poly <- rasterToPolygons(raster(tiles.poly, values=T))
tiles.poly@data <- over(tiles.poly, tiles.points, fun=mode)
tiles.poly <- spTransform(tiles.poly, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))
writePolyShape(tiles.poly["label"], "tilespoly.shp")


# Test script to generate list of tiles
lat <- rep(33:47, 1)
lon <- rep(79:97, 1)

l <- list()
for (i in seq(lat)){
  l[i] <- list(paste("n", lat[i], "w", lon, sep=""))
}
ned <- unlist(l)
