library(maps)
library(sp)
# this may not be necessary, unless I want to use spplot?, simply use
# map package and plot function
state=map("state",plot=FALSE)
p4s=CRS("+proj=longlat +ellps=WGS84")
state.sl=map2SpatialLines(state,proj4string=p4s)
data(us.cities)
names(us.cities)[4:5]=c("y","x")
coordinates(us.cities)<-~x+y
proj4string(us.cities)=p4s

map("state",xlim=c(-87,-74),ylim=c(33,44))
data(world.cities)
map.cities(world.cities,minpop=500000,label=T)
map.axes()

forest=readOGR(dsn="C:/Users/stephen/Documents/Research/Projects/Thesis/Geodata/Overlays/Forest",layer="mnf_proc_bndy_n83_0504")
proj4string(test)
forest=spTransform(forest,CRS("+init=epsg:4326"))
plot(forest,add=T,col="grey")
watershed=readShapePoly("C:/Users/stephen/Documents/Research/Projects/Thesis/Geodata/Covariates/ws16.shp")
proj4string(watershed)=CRS("+init=epsg:26917")
watershed=spTransform(watershed,CRS("+init=epsg:4326"))
plot(watershed,add=T,col="blue")
polygon(c(-81,-81,-80,-80),c(38,39,39,38))

library(maps)
library(maptools)
library(rgdal)

# Extract data from maps package
s <- map('state', fill=T)
test <- map2SpatialPolygons(s, IDs=1:63)
test2 <- SpatialPolygonsDataFrame(test, data.frame(s$names))
proj4string(test2) <- CRS('+proj=longlat +datum=WGS84')
test3 <- spTransform(test2, CRS("+init=epsg:5070"))
writeOGR(dsn=getwd(), test3, 'states4', driver='ESRI Shapefile')