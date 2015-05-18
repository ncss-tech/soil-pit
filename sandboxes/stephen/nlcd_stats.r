# Aggregate NLCD categories by Soil Survey Areas using Zonal Stats from SAGA. Adolfo suggested this approach and it's much faster than any of the other approaches I tried.
# Sampling NLCD raster was unsatificatory because it gave variable acreage totals no matter how high the sampling density. This approach is probably only legitimate to estimate statistical parameters (e.g. means, percentiles)
# Polygonizing the NLCD raster into a Shapefile didn't work because the maximum file size for a Shapefile is 2GB.

setwd("C:/Users/stephen.roecker/Documents/geodata/land_use_land_cover")

data.df <- read.table("Zonal Statistics2.txt", header=T, sep="\t")
nlcd.df <- read.csv("nlcdCodes.csv")

names(data.df) <- c("Value", "OBJECTID", "Count")
data.df$Value <- as.factor(data.df$Value)

nlcd.l <- data.frame(levels(data.df$Value))
names(nlcd.l) <- "Value"
nlcd.l <- join(nlcd.l, nlcd.df, by="Value")
levels(data.df$Value) <- nlcd.l$Definition
data.j <- join(data.df, data.frame(ssa.a), by="OBJECTID")
data.s <- subset(data.j, select=c("NEW_SSAID", "MLRARSYM", "Value", "Count"))

data.sdf  <- ddply(data.j, .(NEW_SSAID, MLRARSYM, Value), summarize, sum(Count))
data.sdf2 <- data.sdf
data.sdf2$..1 <- data.sdf2$..1*900*0.0002471
data.rc <- recast(data.sdf2, NEW_SSAID+MLRARSYM~Value)

write.csv(t2, "R11_NLCD_TA_new.csv")

# ESRI Zonal Stats

test <- read.dbf("Export_Output.dbf")

test2 <- data.frame(t(test))
test3 <- test2[2:nrow(test2),2:ncol(test2)]
id <- ldply(strsplit(row.names(test2)[2:nrow(test2)], "_"))[,2]
row.names(test3) <- id
test3$OBJECTID <- id
names(test3) <- as.character(test2[1,2:ncol(test2)])
head(test3)