library(rgdal)
library(maptools)
library(spatstat)

mlra <- readOGR(dsn=getwd(), layer="MLRA_Soil_Survey_Offices_Oct2014", encoding="ESRI ShapeFile")
regions <- readShapePoints(fn="M:/geodata/soils/MO_Regional_Offices_Oct2012", repair=T)
proj4string(mlra)
proj4string(regions) <- CRS("+init=epsg:4326")
mlra5 <- subset(mlra, NEW_MO == 5)
region5 <- subset(regions, CITY == "DENVER")
mlra5.c <- data.frame(coordinates(mlra5))
mlra5 <- cbind(mlra5, mlra5.c)
mlra5.t <- data.frame(mlra5)

region5.c <- data.frame(coordinates(region5))
region5 <- cbind(region5, region5.c)
region5.t <- data.frame(region5)

t2 <- region5.t[c("CITY", "coords.x1", "coords.x2")]
t1 <- mlra5.t[c("CITY", "coords.x1", "coords.x2")]
test <- rbind(t1, t2)
test.sp <- test
coordinates(test.sp) <- ~coords.x1+coords.x2
test.ppp <- as.ppp(test.sp)
test.ppp$marks <- as.character(test.ppp$marks)
plot(test.ppp)
region5.pd <- data.frame(pairdist(test.ppp))
cbind(sort(apply(region5.pd, 2, mean)))
