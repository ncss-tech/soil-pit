# Prep site and veg data
library(plyr)
library(car)

setwd("G:/workspace/speciesDistributionModeling")

library(soilDB)

# load data
f <- fetchNASIS()
ext_data <- get_extended_data_from_NASIS_db()

# extended data tables
str(ext_data)
# site existing veg data
head(ext_data$veg)

#subset siteexisting veg data to species
d <- ext_data$veg[ext_data$veg$plantsym == 'CORA', ]

# join subset to the site data by common siteiid
site(f) <- d

# create new dataframe from site(f)
idx <- complete.cases(site(f)[, c("site_id", "x_std",  "y_std")])
species.df <- site(f)[idx, c("site_id", "x_std",  "y_std", "plantsym")]

table(factor(species.df$plantsym))
head(species.df)

sites.df <- read.csv("sites.csv")
boer4.df <- read.csv("boer4.csv")
boer4.df <- join(sites.df, boer4.df, by="User.Site.ID")
boer4.df <- subset(boer4.df, select=c(User.Site.ID, UTM.Easting, UTM.Northing, Plant.Symbol))
boer4.df$Plant.Symbol <- as.numeric(boer4.df$Plant.Symbol)
boer4.df[is.na(boer4.df)] <- 0 
boer4.df$Plant.Symbol <- as.factor(boer4.df$Plant.Symbol)
levels(boer4.df$Plant.Symbol) <- c("noboer4", "boer4")
names(boer4.df) <-c ("id", "easting", "northing", "boer4")
boer4.df <- boer4.df

library(sp)
library(rgdal)

boer4.sp <- boer4.df
coordinates(boer4.sp) <- ~ easting+northing
proj4string(boer4.sp)<- ("+init=epsg:26911")
writeOGR(boer4.sp,dsn=getwd(),layer="boer4.sp",driver="ESRI Shapefile",overwrite_layer=TRUE)

# Load geodata
setwd("G:/workspace/soilTemperatureMonitoring/geodata")

grid.list <- c(
  "ned60m_deserts_sgp3ev.tif",
  "ned60m_deserts_mrvbf.tif",
  "ned60m_deserts_twi.tif",
  "ned60m_deserts_ch.tif",
  "ned60m_deserts_srcv.tif",
  "landsat60m_deserts_tc1avg.tif",
  "landsat60m_deserts_tc2avg.tif",
  "landsat60m_deserts_tc3avg.tif",
  "ned60m_deserts.tif",  
  "mast.raster2.new.tif",
  "prism30as_deserts_tavg_1981_2010_annual_C.tif",
  "prism30as_deserts_tavg_1981_2010_dif_C.tif",
  "prism30as_deserts_ppt_1981_2010_annual_mm.tif",
  "prism30as_deserts_ppt_1981_2010_summer_percent.tif",
  "prism30as_deserts_ffp_1971_2000_annual_days.tif"
)

library(raster)
geodata.r <- stack(grid.list)
names(geodata.r) <- c("slope","flatness","wetness", "cheight", "solar","brightness","greeness","yellowness","elev","mast", "maat","dwst","map","psp","ffp")

# Join veg and geodata
setwd("G:/workspace/speciesDistributionModeling")
geodata.df <- extract(geodata.r, boer4.sp, df=T)
boer4.df <- cbind(boer4.df, geodata.df)

# Exploratory analysis
library(lattice)

geo <- boer4.df[,6:20]
test.df <- data.frame(type = rep(boer4.df$boer4, 15),
                      y = as.vector(as.matrix(geo)),
                      meas = factor(rep(1:15, each = nrow(geo)), labels = names(geo)))
bwplot(type ~ y | meas, data = test.df, scales = list(x="free"),
       strip = function(...) strip.default(..., style=1), xlab = "")

aggregate(slope~boer4, quantile, c(0.1,0.25,0.5,0.75,0.9), data=boer4.df)
aggregate(greeness~boer4, quantile, c(0.1,0.25,0.5,0.75,0.9), data=boer4.df)
aggregate(elev~boer4, quantile, c(0.1,0.25,0.5,0.75,0.9), data=boer4.df)
aggregate(mast~boer4, quantile, c(0.1,0.25,0.5,0.75,0.9), data=boer4.df)
aggregate(atemp~boer4, quantile, c(0.1,0.25,0.5,0.75,0.9), data=boer4.df)
aggregate(aprecip~boer4, quantile, c(0.1,0.25,0.5,0.75,0.9), data=boer4.df)
aggregate(rprecipwinsum~boer4, quantile, c(0.1,0.25,0.5,0.75,0.9), data=boer4.df)

ddply(dfx, .(group), summarize,
      +       quantile = round(quantile(age,probs=0.5), 2))
group quantile
1     A    45.48
2     B    37.01
3     C    38.37

panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}
panel.hist <- function(x, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col = "cyan", ...)
}

pairs(na.exclude(boer4.df[,c(6:13)]), panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor)
pairs(na.exclude(boer4.df[,c(14:20)]), panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor)

# Compute multivariate mean of species presense
test <- subset(boer4.df, boer4 == 'boer4')
test.sp <- test; coordinates(test.sp) <- ~ easting+northing; proj4string(test.sp)<- ("+init=epsg:26911")
test <- na.exclude(test)
test2 <- as.data.frame(cbind("Mean", 0, 0, "boer4", 0))
test3 <- as.data.frame(rbind(apply(test[,6:ncol(test)],2,mean)))
test4 <- cbind(test2,test3)
names(test4) <- names(test)
test5 <- rbind(boer4.df,test4)

# Compute geometric distance from multivariate mean of species presense
library(cluster)

test5 <- subset(test5, select=c("slope","wetness","elev","msp"))
boer4.dist <- daisy(test5, stand=T)
boer4.m <- as.matrix(boer4.dist)
boer4.d <- boer4.m[nrow(test5),1:nrow(test5)-1]
boer4.df <- cbind(boer4.df,boer4.d)

aggregate(boer4.d~boer4, quantile, c(0.1,0.25,0.5,0.75,0.9), data=boer4.df)

# Exploratory analysis
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}
panel.hist <- function(x, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col = "cyan", ...)
}

pairs(na.exclude(boer4.df[,c(6:12,20)]), panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor)
pairs(na.exclude(boer4.df[,c(13:20)]), panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor)

# boer4
pairs(boer4.df[,c(5:12,18)], panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor, na.action=na.exclude)
pairs(na.exclude(boer4.df[,c(13:18)]), panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor, na.action=na.exclude)
round(cor(boer4.df),2)

# Mahalanbis distance model using regression splines
library(MASS)
library(splines)
boer4.full <- lm(boer4.d ~ ns(atemp,3)+rprecipwinsum+slope, data=boer4.df)
boer4.lm <- lm(boer4.d ~ ns(elev,3)+ns(msp,3)+ns(slope,5)+ns(wetness,5), data=boer4.df)
termplot(boer4.lm, partial.resid=T)

boer4.raster <- predict(geodata.r, boer4.lm, index=1, progress='text')
writeRaster(boer4.raster,filename="G:/workspace/boer4.raster.tif",format="GTiff",datatype="FLT4S",overwrite=T,NAflag=-99999)

# GLM
# boer4
boer4.full <- glm(boer4~.+ns(atemp,2)+ns(mast,2)+ns(map,3),data=boer4.df[,c(4,6:19)],family=binomial)
boer4.glm <- glm(boer4~ns(maat,2)+ns(psp,3),data=boer4.df[,c(4,6:19)],family=binomial)

par(pty = "s"); par(mfrow=c(1,2)); termplot(boer4.glm)

predfun <- function(model, data) {
  v <- predict(model, data, type="response")
  }
boer4.raster <- predict(geodata.r, boer4.glm, fun=predfun, index=1, progress='text')
writeRaster(boer4.raster,filename="G:/workspace/boer4.glm2.raster.tif",format="GTiff",datatype="FLT4S",overwrite=T,NAflag=-99999, progress="text")


# Bioclim
library(dismo)
geodata.sb.r <- geodata.r[[c(11,14)]]
boer4.sb.df <- subset(boer4.df, boer4=="boer4")
boer4.sb.sp <- boer4.sb.df ; coordinates(boer4.sb.sp) <- ~easting+northing
boer4.bc <- bioclim(geodata.sb.r,boer4.sb.sp)
boer4.bc.r <- predict(geodata.sb.r, boer4.bc, progress="text")
writeRaster(boer4.bc.r,filename="G:/workspace/boer4.bioclim.raster.tif",format="GTiff",datatype="FLT4S",overwrite=T,NAflag=-99999, progress="text")

