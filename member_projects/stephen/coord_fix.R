lon <- as.numeric.DMS(char2dms(paste(87, "d", 14, "'", 40, "\"N")))
lat <- as.numeric.DMS(char2dms(paste(40, "d", 3, "'", 9, "\"N")))
test <- data.frame(lat, lon)
coordinates(test) <- ~lon+lat
proj4string(test) <- CRS("+proj=longlat +datum=NAD83")
spTransform(test, CRS("+init=epsg:4326"))

library(maps)
map("state")
plot(test, add=T)


test <- read.csv("test.csv", stringsAsFactor=T)
test2 <- ddply(test, .(Office, Project.Name), summarize, nSSA=length(unique(Area.Symbol)), nProjects=length(unique(Project.Name)))