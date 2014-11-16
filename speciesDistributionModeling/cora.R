# Load existing veg data from site table
setwd("D:/workspace/speciesDistributionModeling")
sites.df <- read.csv("sites.csv")
sitesCORA.df <- read.csv("sitesCORA.csv")

# Prep data
library(plyr)
library(car)
cora.df <- join(sites.df, sitesCORA.df, by="User.Site.ID")
cora.df <- subset(cora.df, select=c(User.Site.ID, UTM.Easting, UTM.Northing, Plant.Symbol))
cora.df$Plant.Symbol <- as.numeric(cora.df$Plant.Symbol)
cora.df[is.na(cora.df)] <- 0 
cora.df$Plant.Symbol <- as.factor(cora.df$Plant.Symbol)
levels(cora.df$Plant.Symbol) <- c("NOCORA", "CORA")

# Load geodata
library(sp)
cora.sp <- cora.df
coordinates(cora.sp) <- ~ UTM.Easting+UTM.Northing
proj4string(cora.sp)<- ("+init=epsg:26911")
writeOGR(cora.sp,dsn=getwd(),layer="cora.sp",driver="ESRI Shapefile",overwrite_layer=TRUE)

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

geodata <- stack(sg, twi, po, no, srcv, tc1, tc2, tc3, temp1, precip1, temp2, precip2, mast)
names(geodata) <- c("sg","twi","po", "no", "srcv","tc1","tc2","tc3","temp1","precip1","temp2","precip2","mast")

# Join CORA and geodata
setwd("D:/workspace/speciesDistributionModeling")
geoinfo <- extract(geodata,cora.sp)
geoinfo <- as.data.frame(geoinfo)
data <- cbind(cora.df,geoinfo)

# Compute multivariate mean of CORA presense
test <- subset(data, Plant.Symbol == 'CORA')
test <- na.exclude(test)
test2 <- as.data.frame(cbind("Modal", 0, 0, "CORA"))
test3 <- as.data.frame(rbind(apply(test[,5:17],2,mean)))
test4 <- cbind(test2,test3)
names(test4) <- names(test)
test5 <- rbind(data,test4)

# Compute geometric distance from multivariate mean of CORA presense
library(cluster)
cora.dist <- daisy(test5[,5:17], stand=T)
cora.m <- as.matrix(cora.dist)
cora.d <- cora.m[nrow(test5),1:nrow(test5)-1]
cora.df <- cbind(data,cora.d)

# Exploratory analysis
pairs(latr2.df[,c(5:12,17)], panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor)
pairs(latr2.df[,c(13:17)], panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor)
round(cor(cora.df),2)

# Create model using regression splines
cora.full <- lm(cora.d ~ ns(mast,3)+ns(temp1,3)+precip1+ns(z,3)+sg+ns(zms,3)+znh+twi+tc2, data=cora.df[,5:21])
library(MASS)
cora.step <- stepAIC(cora.full, trace=F)
library(splines)
cora.lm <- lm(test.d ~ ns(temp1,3)+ns(srcv,3)+twi, data=cora.df[,5:21])
termplot(cora.lm, partial.resid=T)

# Create and export spatial model
cora.raster <- predict(geodata, cora.lm, index=1, progress='text')
writeRaster(cora.raster,filename="D:/workspace/cora.raster6.tif",format="GTiff",datatype="FLT4S",overwrite=T,NAflag=-99999)

library(mgcv)
cora.gam <- gam(test.d ~ s(temp1)+s(tc2)+zms+sg+s(srcv)+s(znh), data=cora.df)
cora2.raster <- predict(geodata, cora.gam, progress='text')
writeRaster(cora2.raster,filename="C:/Users/stephen.roecker/Documents/work/workspace/cora2.raster.tif",format="GTiff",datatype="FLT4S",overwrite=T,NAflag=-99999)

