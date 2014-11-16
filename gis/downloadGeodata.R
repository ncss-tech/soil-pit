
library(rgdal)

# Download img NED tiles
# For some reason this only works from the R console not Rstudio
img <- readOGR(dsn="I:/geodata/elevation/ned/tiles", layer="ned_meta_R11", encoding="ESRI_Shapefile")
img <- sort(data.frame(img)$FILE_ID)

url <- paste("ftp://rockyftp.cr.usgs.gov/vdelivery/Datasets/Staged/NED/13/IMG/", img, ".zip", sep="")
dest <- paste("I:/geodata/elevation/ned/tiles/img/", img, ".zip", sep="")

for(i in seq(img)){
  download.file(url=url[i], destfile=dest[i])
}

# Download NHD by State
# The FileGDB are to big to be read into R, so they need to be converted using ogr2ogr with gdalUtils. However these FileGDB first need to be upgrade to ArcGIS 10.0. The ESRI File Geodatabase driver doesn't work with 
setwd("I:/geodata/hydrography/")
states <- c("IA", "IL", "IN", "KS", "KY", "MI", "MN", "MO", "NE", "OH", "OK", "SD", 
            "WI")
version <- c("v210", "v220", "v220", "V210", "v210", "v210", "v220", "v220", "v220", "v220", "v210", "v220", "v210")
zipname <- paste("NHDH_", states, "_931", version, ".zip", sep="")
url <- paste("ftp://nhdftp.usgs.gov/DataSets/Staged/States/FileGDB/HighResolution/", zipname, sep="")
dest <- paste(getwd(), "/", zipname, sep="")

for(i in seq(states)){
  download.file(url=url[i], destfile=dest[i])
}

for(i in seq(states)){
  unzip(zipfile=dest[i])
}

gdal_setInstallation(search_path="C:/ProgramData/QGIS/QGISDufour/bin", rescan=T)

ogr2ogr(
  src_datasource_name="I:/geodata/hydrography/NHDH_IN.gdb",
  dst_datasource_name="C:/Users/stephen.roecker/Documents/NHDH_IN_Flowline.shp",
  layer="NHDFlowline",
  overwrite=T,
  verbose=T) 
