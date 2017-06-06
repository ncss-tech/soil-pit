Compare range of soil temperature models


# Analysis of Mojave Mean Annual Soil Temperature (MAST) Dataset

setwd("C:/Users/stephen/Documents/Work/Workspace/hobo/davidh")

# Read MAST data
mast=read.csv("hoboDataSummary2009v2.csv")
mast=na.exclude(mast)

# Read geodata
grid.list=c("savi.sdat",
            "pos.sdat",
            "cosasp.sdat",
            "elev.sdat",
            "slope.sdat",
            "solann.sdat",
            "solsum.sdat",
            "northing.sdat",
            "pptsumpct.sdat")
library(raster)
geodata=stack(c(grid.list))
grid.names=c("SAVI","POS","COSASP","ELEV","SLOPE","SOLANN","SOLSUM","NORTHING","PPTSUMPCT")
layerNames(geodata)=c(grid.names)

# Join mast data and geodata
library(sp)
mast.sp=mast
coordinates(mast.sp)=~X+Y
geoinfo=extract(geodata,mast.sp)
geoinfo=as.data.frame(geoinfo)
MAST=(mast.sp[[2]])
data=cbind(MAST,geoinfo)

# Exploratory data analysis
# Summary of MAST data
TR.levels<-c(8,15,19,22,25,29)
mast$TR.levels<-cut(mast$MAST,breaks=TR.levels)
levels(mast$TR.levels)<-c("8-15","15-19","19-22","22-25","22-25")

png(filename="mast_distribution.png",width=8.5,height=5,units="in",res=200)
par(mfcol=c(1,2))
par(pty="s")
hist(mast$MAST,probability=T,col="grey",xlab="MAST",main="Histogram of MAST")
lines(density(mast$MAST))
barplot(summary(mast$TR.levels),xlab="MAST",ylab="Frequency",main="Barplot of MAST ranges")
dev.off()

qqPlot(mast$MAST, dist="norm")

# Compare environmental representativeness of hobo locations 
geodata.s=(sampleRandom(geodata,10000))
geodata.s=as.data.frame(geodata.s)

library(Hmisc)
options(digits=1)
png(filename="histbb_geodata.png",width=8.5,height=11,units="in",res=200)
  par(mfrow=c(3,2))
  pty="s"
  histbackback(geoinfo$Z,geodata.s$Z,prob=TRUE,xlab=c("samples","population"),ylab="Elevation (m)")
  histbackback(geoinfo$SRcv,geodata.s$SRcv,prob=TRUE,xlab=c("samples","population"),ylab="Variation in solar radiation (%)")
  histbackback(geoinfo$TC1,geodata.s$TC1,prob=TRUE,xlab=c("samples","population"),ylab="TC1 (albedo)")
  histbackback(geoinfo$TC2,geodata.s$TC2,prob=TRUE,xlab=c("samples","population"),ylab="TC2 (vegetation)")
  histbackback(geoinfo$SG,geodata.s$SG,prob=TRUE,xlab=c("samples","population"),ylab="Slope gradient (%)")
  histbackback(geoinfo$TWI,geodata.s$TWI,prob=TRUE,xlab=c("samples","population"),ylab="TWI")
  dev.off()

# Estimate MAST model
mast.lm=lm(MAST~Z,data=data)
mast.full=lm(MAST~.,data=data)

mast.lm=lm(MAST~Z+SRcv+TC1,data=data)

plot(data$MAST~predict(mast.lm),ylab="Observed MAST",
     xlab="Predicted MAST",main="Observed vs. predicted MAST")
abline(0,1)

png(filename="mast_diagnostics.png",width=8.5,height=8.5,units="in",res=200)
par(mfcol=c(2,2))
pty="s"
plot(mast.lm)
dev.off()

# Validate MAST model
mast.ols=ols(MAST~Z+SRcv+TC1,data=data,x=T,y=T)
mastt.ols=ols(MAST^2~Z+SRcv+TC1,data=data,x=T,y=T)

validate(mast.ols,B=10,method="crossvalidation",bw=T)
validate(mastt.ols,B=10,method="crossvalidation",bw=T)

# Predict MAST model
predfun <- function(model, data) {
  v <- predict(model, data, se.fit=TRUE)
  cbind(p=as.vector(v$fit), se=as.vector(v$se.fit))
}
mast.raster=predict(geodata,mast.lm,fun=predfun,index=1:2)
writeRaster(mast.raster[[1]],filename="mast.raster.tif",format="GTiff",datatype="FLT4S",overwrite=T,NAflag=-99999)
writeRaster(mast.se.raster[[2]],filename="mast.se.raster.tif",format="GTiff",datatype="FLT4S",overwrite=T,NAflag=-99999)
