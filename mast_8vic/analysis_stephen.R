# Analysis of Mojave Mean Annual Soil Temperature (tempC) Dataset

setwd("I:/workspace/soilTemperatureMonitoring/R")

library(sp)
library(raster)
library(plyr)
library(rms)

# Read tempC data
mastList.df <- read.csv("HOBO_List_2013_0923_master.csv", header=T)
mastSites.df <- read.csv("mastSites.csv")
mast.df <- join(mastSites.df,mastList.df,by="siteid")
mast.df <- subset(mast.df, select=c(siteid, tempF, numDays, utmeasting, utmnorthing))
mast.df$tempC <- (mast.df$tempF-32)*(5/9)

mast.sp <- mast.df
coordinates(mast.sp) <- ~ utmeasting+utmnorthing
proj4string(mast.sp)<- ("+init=epsg:26911")

# Read geodata
setwd("C:/geodata/project_data/vic8/")
grid.list <- c("ned30m_vic8.tif",
               "ned30m_vic8_solarcv.tif",
               "landsat30m_vic8_tc123.tif",
               "prism30m_vic8_ppt_1981_2010_annual_mm.tif",
               "prism30m_vic8_tavg_1981_2010_annual_C.tif"
)

library(raster)
geodata <- stack(c(grid.list))
grid.names <- c("elev","solar","tc1", "tc2", "tc3", "precip", "temp")
names(geodata) <- c(grid.names)

geodata.df <- extract(geodata, mast.sp, df=TRUE)
data <- cbind(mast.df, geodata.df)

# Exploratory data analysis
# Summary of tempC data
qqnorm(data$tempC, dist="norm")
pairs(data[,c(3,4,6,7,11,14,15)], panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor)

# Compare environmental representativeness of hobo locations 
ned.sp <- readGDAL("ned60m_deserts.tif")
proj4string(ned.sp)<- ("+init=epsg:26911")
ned.s <- spsample(ned.sp,n=5000,type="stratified")
geodata.s <- extract(geodata,ned.s,sp=T)
geodata.s <- geodata.s@data

library(Hmisc)
options(digits=1)
png(filename="P:/R/plots/histbb_geodata.png",width=8.5,height=11,units="in",res=200)
  par(mfrow=c(4,1))
  pty="s"
  histbackback(geoinfo$tavg,geodata.s$tavg,prob=TRUE,xlab=c("samples","population"),ylab="tavg") 
  histbackback(geoinfo$ppt,geodata.s$ppt,prob=TRUE,xlab=c("samples","population"),ylab="ppt") 
  histbackback(geoinfo$tc1,geodata.s$tc1,prob=TRUE,xlab=c("samples","population"),ylab="TC1 (albedo)")
  histbackback(geoinfo$srcv,geodata.s$srcv,prob=TRUE,xlab=c("samples","population"),ylab="solar")
dev.off()

# Estimate tempC model
mast.lm <- lm(tempC~temp+solar+precip+tc1,data=data, weights=numDays)
mast.full <- lm(tempC~.,data=data, weights=numDays)

plot(data$tempC~predict(mast.lm),ylab="Observed tempC",
     xlab="Predicted tempC",main="Observed vs. predicted tempC")
abline(0,1)

png(filename="P:/R/mast_diagnostics.png",width=8.5,height=8.5,units="in",res=200)
par(mfcol=c(2,2))
pty="s"
plot(mast.lm)
dev.off()

# Validate tempC model
mast.ols1<-ols(tempC~temp+solar+precip+tc1,data=data,x=T,y=T,weights=numDays)
mast.ols2<-ols(tempC~elev+solar+precip+tc1,data=data,x=T,y=T,weights=numDays)
mast.ols3<-ols(tempC~temp+solar+tc2+tc1,data=data,x=T,y=T,weights=numDays)
mast.ols4<-ols(tempC~elev+solar+tc2+tc1,data=data,x=T,y=T,weights=numDays)
validate(mast.ols1,B=6,method="crossvalidation",bw=T)
validate(mast.ols2,B=6,method="crossvalidation",bw=T)
validate(mast.ols3,B=6,method="crossvalidation",bw=T)
validate(mast.ols4,B=6,method="crossvalidation",bw=T)

# Predict tempC model
predfun <- function(model, data) {
  v <- predict(model, data, se.fit=TRUE)
}
mast.raster <- predict(geodata, mast.lm, fun=predfun, index=1:2, progress='text')
writeRaster(mast.raster[[1]],filename="I:/workspace/soilTemperatureMonitoring/R/mast.raster.new.tif",format="GTiff",datatype="INT1S",overwrite=T,NAflag=-127, options=c("COMPRESS=DEFLATE", "TILED=YES"), progress='text')
test <- raster(mast.raster,layer=2)
writeRaster(test,filename="I:/workspace/soilTemperatureMonitoring/R/mast.se.raster.new.tif",format="GTiff",datatype="INT1S",overwrite=T,NAflag=-127, options=c("COMPRESS=DEFLATE", "TILED=YES"), progress='text')

