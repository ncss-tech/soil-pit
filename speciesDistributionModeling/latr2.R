# Load existing veg data from site table
setwd("D:/workspace/speciesDistributionModeling")
sites.df <- read.csv("sites.csv")
# Prep data
library(plyr)
library(car)
# CORA
cora.df <- read.csv("cora.csv")
cora.df <- join(sites.df, cora.df, by="User.Site.ID")
cora.df <- subset(cora.df, select=c(User.Site.ID, UTM.Easting, UTM.Northing, Plant.Symbol))
cora.df$Plant.Symbol <- as.numeric(cora.df$Plant.Symbol)
cora.df[is.na(cora.df)] <- 0
cora.df$Plant.Symbol <- as.factor(cora.df$Plant.Symbol)
levels(cora.df$Plant.Symbol) <- c("nocora", "cora")
names(cora.df) <-c ("id", "easting", "northing", "cora")
veg.df <- cora.df
# LATR2
latr2.df <- read.csv("latr2.csv")
latr2.df <- join(sites.df, latr2.df, by="User.Site.ID")
latr2.df <- subset(latr2.df, select=c(User.Site.ID, UTM.Easting, UTM.Northing, Plant.Symbol))
latr2.df$Plant.Symbol <- as.numeric(latr2.df$Plant.Symbol)
latr2.df[is.na(latr2.df)] <- 0
latr2.df$Plant.Symbol <- as.factor(latr2.df$Plant.Symbol)
levels(latr2.df$Plant.Symbol) <- c("NOlatr2", "latr2")
names(latr2.df) <-c ("id", "easting", "northing", "latr2")
veg.df <- latr2.df
# Merge data
# Load geodata
library(sp)
library(rgdal)
veg.sp <- veg.df
coordinates(veg.sp) <- ~ easting+northing
proj4string(veg.sp)<- ("+init=epsg:26911")
writeOGR(veg.sp,dsn=getwd(),layer="veg.sp",driver="ESRI Shapefile",overwrite_layer=TRUE)
library(raster)
setwd("D:/workspace/soilTemperatureMonitoring/geodata")
sg <- raster("ned60m_deserts_sgp5ev.sdat", crs=CRS("+init=epsg:26911"))
srcv <- raster("ned60m_deserts_srcv.sdat", crs=CRS("+init=epsg:26911"))
no <- raster("ned60m_deserts_nopen.sdat", crs=CRS("+init=epsg:26911"))
po <- raster("ned60m_deserts_popen.sdat", crs=CRS("+init=epsg:26911"))
twi <- raster("ned60m_deserts_twi.sdat", crs=CRS("+init=epsg:26911"))
tc1 <- raster("landsat60m_deserts_tc1avg.sdat", crs=CRS("+init=epsg:26911"))
tc2 <- raster("landsat60m_deserts_tc2avg.sdat", crs=CRS("+init=epsg:26911"))
tc3 <- raster("landsat60m_deserts_tc3avg.sdat", crs=CRS("+init=epsg:26911"))
temp1 <- raster("prism30as_deserts_tavg_1981_2010_annual_C.sdat", crs=CRS("+init=epsg:26911"))
precip1 <- raster("prism30as_deserts_ppt_1981_2010_annual_mm.sdat", crs=CRS("+init=epsg:26911"))
temp2 <- raster("prism30as_deserts_tavg_1981_2010_dif_C.sdat", crs=CRS("+init=epsg:26911"))
precip2 <- raster("prism30as_deserts_ppt_1981_2010_dif_mm.sdat", crs=CRS("+init=epsg:26911"))
mast <- raster("mast.raster2.new.tif", crs=CRS("+init=epsg:26911"))
geodata.r <- stack(sg, twi, po, no, srcv, tc1, tc2, tc3, temp1, precip1, temp2, precip2, mast)
names(geodata.r) <- c("sg","twi","po", "no", "srcv","tc1","tc2","tc3","temp1","precip1","temp2","precip2","mast")
# Join latr2 and geodata
setwd("D:/workspace/speciesDistributionModeling")
geodata.df <- extract(geodata.r,veg.sp)
geodata.df <- as.data.frame(geodata.df)
veg.df <- cbind(veg.df,geodata.df)
# Compute multivariate mean of latr2 presense
test <- subset(veg.df, cora == 'cora')
test <- na.exclude(test)
test2 <- as.data.frame(cbind("Modal", 0, 0, "cora"))
test3 <- as.data.frame(rbind(apply(test[,5:17],2,mean)))
test4 <- cbind(test2,test3)
names(test4) <- names(test)
test5 <- rbind(veg.df,test4)
# Compute geometric distance from multivariate mean of latr2 presense
library(cluster)
# CORA
cora.dist <- daisy(test5[,5:17], stand=T)
cora.m <- as.matrix(cora.dist)
cora.d <- cora.m[nrow(test5),1:nrow(test5)-1]
cora.df <- cbind(veg.df,cora.d)
# LATR2
latr2.dist <- daisy(test5[,5:17], stand=T)
latr2.m <- as.matrix(latr2.dist)
latr2.d <- latr2.m[nrow(test5),1:nrow(test5)-1]
latr2.df <- cbind(data,latr2.d)
# Exploratory analysis
pairs(cora.df[,c(5:12,18)], panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor, na.action=na.exclude)
pairs(na.exclude(cora.df[,c(13:18)]), panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor, na.action=na.exclude)
round(cor(latr2.df),2)
# Create model using regression splines
library(MASS)
library(splines)
# CORA
cora.full <- lm(cora.d ~ ns(mast,3)+ns(temp1,3)+ns(precip1,3)+ns(temp2,3)+ns(precip2,3)+ns(srcv,3)+sg+po+no+twi+tc2+ns(tc1,3)+tc3, data=cora.df[,5:18])
cora.lm <- lm(cora.d ~ sg+ns(mast,3)+ns(srcv,3)+no+po+twi, data=cora.df[,5:18])
termplot(cora.lm, partial.resid=T)
# LATR2
latr2.full <- lm(latr2.d ~ ns(mast,3)+ns(temp1,3)+ns(precip1,3)+ns(temp2,3)+ns(precip2,3)+ns(srcv,3)+sg+po+no+twi+tc2+tc1+tc3, data=latr2.df[,5:18])
latr2.step <- stepAIC(latr2.full, trace=F)
latr2.lm <- lm(latr2.d ~ sg+ns(mast,3)+ns(srcv,3)+no+po+twi, data=latr2.df[,5:18])
termplot(latr2.lm, partial.resid=T)
# Create and export spatial model
cora.raster <- predict(geodata.r, cora.lm, index=1, progress='text')
writeRaster(cora.raster,filename="D:/workspace/cora.raster.tif",format="GTiff",datatype="FLT4S",overwrite=T,NAflag=-99999)
latr2.raster <- predict(geodata.r, latr2.lm, index=1, progress='text')
writeRaster(latr2.raster,filename="D:/workspace/latr2.raster.tif",format="GTiff",datatype="FLT4S",overwrite=T,NAflag=-99999)
library(mgcv)
latr2.gam <- gam(test.d ~ s(temp1)+s(tc2)+zms+sg+s(srcv)+s(znh), data=latr2.df)
latr22.raster <- predict(geodata, latr2.gam, progress='text')
writeRaster(latr22.raster,filename="C:/Users/stephen.roecker/Documents/work/workspace/latr22.raster.tif",format="GTiff",datatype="FLT4S",overwrite=T,NAflag=-99999)
