library(soilDB)
library(rgdal)

test <- fetchNASIS() # import data from NASIS
test <- test[complete.cases(site(test)[c("x", "y")])] # substract pedon with missing coordinates
coordinates(test) <- ~ x + y # add coords to pedon object
proj4string(test) <- CRS("+init=epsg:4326") # assign projection
test.sp <- test@sp # extract properly formatted coords
test.sp$p <- site(test)
writeOGR(test.sp, dsn = getwd(), layer = "test.locations", driver = "ESRI Shapefile")

