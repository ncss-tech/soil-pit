
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

#Download hdf WELD tiles
weld <- "http://e4ftl01.cr.usgs.gov/WELD/"
yr <- "WELDUSYR.001/"
years <- c(2010, 2011, 2012)
yearp <- c("2010.12.01/", "2011.12.01/", "2012.12.01/")
se <- "WELDUSSE.001/"
seasons <- c(".12.01/", ".03.01/", ".06.01/", ".09.01/")


SE <- unlist(lapply(years, paste0, seasons))
yr.p <- paste0(weld, yr, yearp)
se.p <- paste0(weld, se, SE)



test <- getURL(url)
test <- strsplit(strsplit(test, "CONUS.")[[1]], ".hdf")
test <- grep(pattern="v1.5", x=unlist(test), value=T)


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
