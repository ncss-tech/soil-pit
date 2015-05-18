library(rgdal)
library(plyr)

nwca <- readOGR(dsn="M:/geodata/project_data/NWCA", layer="NWCA2016_Sites_wPAD_031115", encoding="ESRI Shapefile", stringsAsFactors=FALSE)
r11 <- readOGR(dsn="M:/geodata/project_data/11Region", layer="MLRA_Soil_Survey_Areas_May2014_r11", stringsAsFactors=FALSE)
nwca <- cbind(nwca, data.frame(coordinates(nwca)))

coordinates(nwca) <- ~ coords.x1+coords.x2
proj4string(nwca) <- proj4string(r11)

nwca.df <- data.frame(nwca, stringsAsFactors=FALSE)
nwca.r11 <- over(nwca, r11)
nwca.r11 <- cbind(nwca.r11, nwca.df)
nwca.r11 <- subset(nwca.r11, NEW_MO == "11")
nwca.r11_base <- subset(nwca.r11, PANEL16 != "OverSamp")

nwca.sp_base <- nwca.r11_base
coordinates(nwca.sp_base) <- ~ coords.x1+coords.x2
proj4string(nwca.sp_base) <- CRS("+init=epsg:5070")
plot(r11)
plot(nwca.sp_base, add=T)

nwca.sp <- nwca.r11
coordinates(nwca.sp) <- ~ coords.x1+coords.x2
proj4string(nwca.sp) <- CRS("+init=epsg:5070")
plot(r11)
plot(nwca.sp, add=T)

nwca.sso <- ddply(nwca.r11_base, .(NEW_SSAID), summarize, n=length(SITEID16))
print(nwca.sso)

writeOGR(nwca.sp, dsn="M:/geodata/project_data/NWCA", layer="NWCA2016_Sites_wPAD_031115_r113", driver="ESRI Shapefile")

test <- gIntersection(nwca, r11)
test <- intersect(nwca, r11)
