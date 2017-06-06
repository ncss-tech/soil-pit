#Create a user entry prompt
series <- function()
{
  as.character(readline("Enter the Series to export:>>> "))
}

input_series <- series()

# query spatial data
seriesExtentShp <- seriesExtent(input_series)

# save using the coordinate reference system associated with this object (GCS WGS84)
writeOGR(seriesExtentShp, dsn = ".", layer = input_series, driver = "ESRI Shapefile")

# project to UTM zone xx NAD83 and save
seriesExtentShp.utm <- spTransform(seriesExtentShp, CRS("+proj=utm +zone=15 +datum=NAD83"))
writeOGR(seriesExtentShp.utm, dsn = ".", layer = paste(input_series,"utm"), driver = "ESRI Shapefile")
source("rmenu.R")