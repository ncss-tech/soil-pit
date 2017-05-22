# Analysis of Mojave Mean Annual Soil Temperature (tempC) Dataset

setwd("M:/projects/soilTemperatureMonitoring/R")

library(sp)
library(raster)
library(plyr)
library(car)
library(caret)

# Read tempC data
sites_df <- read.csv("HOBO_List_2013_0923_master.csv")
mast_df <- read.csv("mastSites.csv")

mast_df <- join(mast_df, sites_df, by = "siteid")
mast_df <- subset(mast_df, select = c(siteid, tempF, numDays, utmeasting, utmnorthing))
mast_df$tempC <- (mast_df$tempF - 32) * (5 / 9)

mast_sp <- mast_df
coordinates(mast_sp) <- ~ utmeasting + utmnorthing
proj4string(mast_sp)<- ("+init=epsg:26911")

# Read geodata
folder <- "M:/geodata/project_data/8VIC/"
files <- c(elev = "ned30m_8VIC.tif",
           solar = "ned30m_8VIC_solarcv.tif",
           tc = "landsat30m_8VIC_tc123.tif",
           precip = "prism30m_8VIC_ppt_1981_2010_annual_mm.tif",
           temp = "prism30m_8VIC_tmean_1981_2010_annual_C.tif"
)

geodata_f <- sapply(files, function(x) paste0(folder, x))

geodata_r <- stack(geodata_f)

data <- data.frame(mast_df, extract(geodata_r, mast_sp))

# Exploratory data analysis
# Summary of tempC data
qqnorm(data$tempC)
qqline(data$tempC)
spm(data[, c("tempC", names(geodata_r))])

# Compare environmental representativeness of hobo locations 
ned.sp <- readGDAL("ned60m_deserts.tif")
proj4string(ned.sp)<- ("+init=epsg:26911")
ned.s <- spsample(ned.sp, n = 5000, type = "stratified")
geodata.s <- extract(geodata, ned.s, sp = TRUE)
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
full <- lm(tempC ~ .,data = data, weights = numDays)
mast_lm <- lm(tempC ~ temp + solar + precip + tc_1, data = data, weights = numDays)

plot(data$tempC ~ predict(mast_lm),
     ylab = "Observed tempC",
     xlab = "Predicted tempC",
     main = "Observed vs. predicted tempC")
abline(0,1)

png(filename="mast_diagnostics.png", width=8.5, height=8.5, units = "in", res = 200)
par(mfcol = c(2, 2))
pty = "s"
plot(mast_lm)
dev.off()

# Validate tempC model
# Create folds
folds <- createFolds(data$tempC, k = 10)
train <- data

# Cross validate
cv_results <- lapply(folds, function(x) {
  train <- train[-x,]
  test <- train[x,]
  model <- lm(tempC ~ temp + solar + precip + tc_1, weights = numDays, data = train)
  actual <- test$tempC
  predict <- predict(model, test)
  RMSE <- sqrt(mean((actual - predict)^2, na.rm = TRUE))
  R2 <- cor(actual, predict, use = "pairwise")^2
  return(c(RMSE = RMSE, R2 = R2))
}
)

# Convert to a data.frame
cv_results <- do.call(rbind, cv_results)

# Summarize results
summary(cv_results)

# Predict tempC model
predfun <- function(model, data) {
  v <- predict(model, data, se.fit=TRUE)
}
mast.raster <- predict(geodata, mast.lm, fun=predfun, index=1:2, progress='text')
writeRaster(mast.raster[[1]],filename="I:/workspace/soilTemperatureMonitoring/R/mast.raster.new.tif",format="GTiff",datatype="INT1S",overwrite=T,NAflag=-127, options=c("COMPRESS=DEFLATE", "TILED=YES"), progress='text')
test <- raster(mast.raster,layer=2)
writeRaster(test,filename="I:/workspace/soilTemperatureMonitoring/R/mast.se.raster.new.tif",format="GTiff",datatype="INT1S",overwrite=T,NAflag=-127, options=c("COMPRESS=DEFLATE", "TILED=YES"), progress='text')

