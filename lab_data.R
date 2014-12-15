# Lab database "ftp://ftp-fc.sc.egov.usda.gov/NSSC/pub/NCSS_Laboratory_Databases/NCSS_Soil_Characterization_Database_Sept_2014.zip"
setwd("C:/Users/stephen.roecker/Documents/")
download.file(
  "ftp://ftp-fc.sc.egov.usda.gov/NSSC/pub/NCSS_Laboratory_Databases/NCSS_Soil_Characterization_Database_Sept_2014.zip", 
  destfile="NCSS_Soil_Characterization_Database_Sept_2014.zip"
  ) # only work in vanilla R console not Rstudio

unzip(
  zipfile="NCSS_Soil_Characterization_Database_Sept_2014.zip",
  files="NCSS_Soil_Characterization_Database_Sept_2014.mdb",
  overwrite=F
  )

# Query NCSS_Layer_Lab_Data.txt
setwd("C:/Users/stephen.roecker/Documents/")
lab <- read.csv("NCSS_Layer_Lab_Data.txt", header=T)

par(pty="s")
attach(lab)
plot(clay_f, clay_tot_psa, xlim=c(0,100), ylim=c(0,100), col="blue")
abline(0,1)

clay_dif <- clay_tot_psa - clay_f

summary(clay_dif)
cor(clay_f, clay_tot_psa, use="complete.obs")


# Site locations
library(maps)
library(sp)
library(rgdal)

setwd("C:/Users/stephen.roecker/Documents/")
loc <- read.csv("NCSS_Pedon_Taxonomy.txt", header=T)
sapolygon <- readOGR(dsn="M:/geodata/project_data/11REGION/RTSD_Region_11_FY15.gdb", layer="SAPOLYGON", encoding="OpenFileGDB")

loc.s <- subset(loc, latitude_decimal_degrees > 0)
loc.na <- subset(loc, is.na(latitude_decimal_degrees))
coordinates(loc.s) <- ~longitude_decimal_degrees+latitude_decimal_degrees
proj4string(loc.s) <- CRS("+init=epsg:4326")
loc.aea <- spTransform(loc.s, CRS("+init=epsg:5070"))
sapolygon.wgs <- spTransform(sapolygon, CRS("+init=epsg:4326"))

par(mfcol=c(1,2))
par(pty="s")
map("state")
plot(loc.s, add=T)
map("state", col="blue", add=T)
plot(sapolygon.wgs)
plot(loc.s, add=T)

