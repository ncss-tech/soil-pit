library(soilDB)
library(plyr)
library(sp)

# Load data
site <- get_site_data_from_NASIS_db()
veg <- get_vegplot_from_NASIS_db()

# Merge and subset only vegplots with coordinates
test <- join(veg$inventory, site, by = "siteiid", type = "left")
test2 <- test[complete.cases(test$x, test$y), ]

# Convert to a spatial object and project
coordinates(test2) <- ~x+y
proj4string(test2) <- CRS("+init=epsg:4326")

# Write a shapefile
writeOGR(test2, dsn = getwd(), layer = "veg11", driver = "ESRI Shapefile")
