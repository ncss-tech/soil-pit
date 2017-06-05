#-----------------------------------------------------------------------------------------------------------------
#
#   Animas Valley Playa Predictive Soil Modeling
#
#   Part 1: covariate reduction for polypedon development


#
#-----------------------------------------------------------------------------------------------------------------

# load libraries
library(raster)
library(caret)
library(corrplot)
library(psych)



#-----------------------------------------------------------------------------------------------------------------
# 1.0 PrePocessing DEM covariates


# 1.1 #  Load DEM layers

setwd("E:/Animas_Valley_Playa/IFSAR/All_Covariates/10m/")


# Raster Data

r.aspt100m.tif <- raster("aspt100m.tif")
r.aspt10m.tif <- raster("aspt10m.tif")
r.aspt30m.tif <- raster("aspt30m.tif")
r.aspt50m.tif <- raster("aspt50m.tif")
r.aspt5m.tif <- raster("aspt5m.tif")
r.catcharea100m.tif <- raster("catcharea100m.tif")
r.catcharea10m.tif <- raster("catcharea10m.tif")
r.catcharea30m.tif <- raster("catcharea30m.tif")
r.catcharea50m.tif <- raster("catcharea50m.tif")
r.catcharea5m.tif <- raster("catcharea5m.tif")
r.catchslp100m.tif <- raster("catchslp100m.tif")
r.catchslp10m.tif <- raster("catchslp10m.tif")
r.catchslp30m.tif <- raster("catchslp30m.tif")
r.catchslp50m.tif <- raster("catchslp50m.tif")
r.catchslp5m.tif <- raster("catchslp5m.tif")
r.convidx100m.tif <- raster("convidx100m.tif")
r.convidx10m.tif <- raster("convidx10m.tif")
r.convidx30m.tif <- raster("convidx30m.tif")
r.convidx50m.tif <- raster("convidx50m.tif")
r.convidx5m.tif <- raster("convidx5m.tif")
r.difinsol100m.tif <- raster("difinsol100m.tif")
r.difinsol10m.tif <- raster("difinsol10m.tif")
r.difinsol30m.tif <- raster("difinsol30m.tif")
r.difinsol50m.tif <- raster("difinsol50m.tif")
r.difinsol5m.tif <- raster("difinsol5m.tif")
r.dirinsol100m.tif <- raster("dirinsol100m.tif")
r.dirinsol10m.tif <- raster("dirinsol10m.tif")
r.dirinsol30m.tif <- raster("dirinsol30m.tif")
r.dirinsol50m.tif <- raster("dirinsol50m.tif")
r.dirinsol5m.tif <- raster("dirinsol5m.tif")
r.elev100m.tif <- raster("elev100m.tif")
r.elev10m.tif <- raster("elev10m.tif")
r.elev30m.tif <- raster("elev30m.tif")
r.elev50m.tif <- raster("elev50m.tif")
r.elev5m.tif <- raster("elev5m.tif")
r.fpl100m.tif <- raster("fpl100m.tif")
r.fpl10m.tif <- raster("fpl10m.tif")
r.fpl30m.tif <- raster("fpl30m.tif")
r.fpl50m.tif <- raster("fpl50m.tif")
r.fpl5m.tif <- raster("fpl5m.tif")
r.insoldur100m.tif <- raster("insoldur100m.tif")
r.insoldur10m.tif <- raster("insoldur10m.tif")
r.insoldur30m.tif <- raster("insoldur30m.tif")
r.insoldur50m.tif <- raster("insoldur50m.tif")
r.insoldur5m.tif <- raster("insoldur5m.tif")
r.insolratio100m.tif <- raster("insolratio100m.tif")
r.insolratio10m.tif <- raster("insolratio10m.tif")
r.insolratio30m.tif <- raster("insolratio30m.tif")
r.insolratio50m.tif <- raster("insolratio50m.tif")
r.insolratio5m.tif <- raster("insolratio5m.tif")
r.longcrv100m.tif <- raster("longcrv100m.tif")
r.longcrv10m.tif <- raster("longcrv10m.tif")
r.longcrv30m.tif <- raster("longcrv30m.tif")
r.longcrv50m.tif <- raster("longcrv50m.tif")
r.longcrv5m.tif <- raster("longcrv5m.tif")
r.maxcrv100m.tif <- raster("maxcrv100m.tif")
r.maxcrv10m.tif <- raster("maxcrv10m.tif")
r.maxcrv30m.tif <- raster("maxcrv30m.tif")
r.maxcrv50m.tif <- raster("maxcrv50m.tif")
r.maxcrv5m.tif <- raster("maxcrv5m.tif")
r.mincrv100m.tif <- raster("mincrv100m.tif")
r.mincrv10m.tif <- raster("mincrv10m.tif")
r.mincrv30m.tif <- raster("mincrv30m.tif")
r.mincrv50m.tif <- raster("mincrv50m.tif")
r.mincrv5m.tif <- raster("mincrv5m.tif")
r.modcatcharea100m.tif <- raster("modcatcharea100m.tif")
r.modcatcharea10m.tif <- raster("modcatcharea10m.tif")
r.modcatcharea30m.tif <- raster("modcatcharea30m.tif")
r.modcatcharea50m.tif <- raster("modcatcharea50m.tif")
r.modcatcharea5m.tif <- raster("modcatcharea5m.tif")
r.nopen100m.tif <- raster("nopen100m.tif")
r.nopen10m.tif <- raster("nopen10m.tif")
r.nopen30m.tif <- raster("nopen30m.tif")
r.nopen50m.tif <- raster("nopen50m.tif")
r.nopen5m.tif <- raster("nopen5m.tif")
r.plancrv100m.tif <- raster("plancrv100m.tif")
r.plancrv10m.tif <- raster("plancrv10m.tif")
r.plancrv30m.tif <- raster("plancrv30m.tif")
r.plancrv50m.tif <- raster("plancrv50m.tif")
r.plancrv5m.tif <- raster("plancrv5m.tif")
r.popen100m.tif <- raster("popen100m.tif")
r.popen10m.tif <- raster("popen10m.tif")
r.popen30m.tif <- raster("popen30m.tif")
r.popen50m.tif <- raster("popen50m.tif")
r.popen5m.tif <- raster("popen5m.tif")
r.profcrv100m.tif <- raster("profcrv100m.tif")
r.profcrv10m.tif <- raster("profcrv10m.tif")
r.profcrv30m.tif <- raster("profcrv30m.tif")
r.profcrv50m.tif <- raster("profcrv50m.tif")
r.profcrv5m.tif <- raster("profcrv5m.tif")
r.proind100m.tif <- raster("proind100m.tif")
r.proind10m.tif <- raster("proind10m.tif")
r.proind30m.tif <- raster("proind30m.tif")
r.proind50m.tif <- raster("proind50m.tif")
r.proind5m.tif <- raster("proind5m.tif")
r.rtflat100m.tif <- raster("rtflat100m.tif")
r.rtflat10m.tif <- raster("rtflat10m.tif")
r.rtflat30m.tif <- raster("rtflat30m.tif")
r.rtflat50m.tif <- raster("rtflat50m.tif")
r.rtflat5m.tif <- raster("rtflat5m.tif")
r.sagawi100m.tif <- raster("sagawi100m.tif")
r.sagawi10m.tif <- raster("sagawi10m.tif")
r.sagawi30m.tif <- raster("sagawi30m.tif")
r.sagawi50m.tif <- raster("sagawi50m.tif")
r.sagawi5m.tif <- raster("sagawi5m.tif")
r.slp100m.tif <- raster("slp100m.tif")
r.slp10m.tif <- raster("slp10m.tif")
r.slp30m.tif <- raster("slp30m.tif")
r.slp50m.tif <- raster("slp50m.tif")
r.slp5m.tif <- raster("slp5m.tif")
r.slplen100m.tif <- raster("slplen100m.tif")
r.slplen10m.tif <- raster("slplen10m.tif")
r.slplen30m.tif <- raster("slplen30m.tif")
r.slplen50m.tif <- raster("slplen50m.tif")
r.slplen5m.tif <- raster("slplen5m.tif")
r.spi100m.tif <- raster("spi100m.tif")
r.spi10m.tif <- raster("spi10m.tif")
r.spi30m.tif <- raster("spi30m.tif")
r.spi50m.tif <- raster("spi50m.tif")
r.spi5m.tif <- raster("spi5m.tif")
r.totinsol100m.tif <- raster("totinsol100m.tif")
r.totinsol10m.tif <- raster("totinsol10m.tif")
r.totinsol30m.tif <- raster("totinsol30m.tif")
r.totinsol50m.tif <- raster("totinsol50m.tif")
r.totinsol5m.tif <- raster("totinsol5m.tif")
r.tpi100m.tif <- raster("tpi100m.tif")
r.tpi10m.tif <- raster("tpi10m.tif")
r.tpi30m.tif <- raster("tpi30m.tif")
r.tpi50m.tif <- raster("tpi50m.tif")
r.tpi5m.tif <- raster("tpi5m.tif")
r.trugind100m.tif <- raster("trugind100m.tif")
r.trugind10m.tif <- raster("trugind10m.tif")
r.trugind30m.tif <- raster("trugind30m.tif")
r.trugind50m.tif <- raster("trugind50m.tif")
r.trugind5m.tif <- raster("trugind5m.tif")
r.vbflat100m.tif <- raster("vbflat100m.tif")
r.vbflat10m.tif <- raster("vbflat10m.tif")
r.vbflat30m.tif <- raster("vbflat30m.tif")
r.vbflat50m.tif <- raster("vbflat50m.tif")
r.vbflat5m.tif <- raster("vbflat5m.tif")
r.xseccrv100m.tif <- raster("xseccrv100m.tif")
r.xseccrv10m.tif <- raster("xseccrv10m.tif")
r.xseccrv30m.tif <- raster("xseccrv30m.tif")
r.xseccrv50m.tif <- raster("xseccrv50m.tif")
r.xseccrv5m.tif <- raster("xseccrv5m.tif")





# 1.2 Create a raster stack


r.stack.dem <- stack(r.aspt10m.tif, r.fpl10m.tif, r.slp10m.tif, r.tpi10m.tif, 
                     r.convidx100m.tif, r.convidx10m.tif, r.convidx30m.tif, r.convidx50m.tif, 
                     r.difinsol10m.tif, r.dirinsol10m.tif, r.totinsol10m.tif, r.insoldur10m.tif,
                     r.longcrv100m.tif, r.longcrv10m.tif, r.longcrv30m.tif, r.longcrv50m.tif, 
                     r.maxcrv100m.tif, r.maxcrv10m.tif, r.maxcrv30m.tif, r.maxcrv50m.tif, 
                     r.mincrv100m.tif, r.mincrv10m.tif, r.mincrv30m.tif, r.mincrv50m.tif, 
                     r.plancrv100m.tif, r.plancrv10m.tif, r.plancrv30m.tif, r.plancrv50m.tif, 
                     r.profcrv100m.tif, r.profcrv10m.tif, r.profcrv30m.tif, r.profcrv50m.tif, 
                     r.proind100m.tif, r.proind10m.tif, r.proind30m.tif, r.proind50m.tif, 
                     r.rtflat100m.tif, r.rtflat10m.tif, r.rtflat30m.tif, r.rtflat50m.tif, 
                     r.sagawi100m.tif, r.sagawi10m.tif, r.sagawi30m.tif, r.sagawi50m.tif, 
                     r.slplen100m.tif, r.slplen10m.tif, r.slplen30m.tif, r.slplen50m.tif, 
                     r.spi100m.tif, r.spi10m.tif, r.spi30m.tif, r.spi50m.tif, 
                     r.trugind100m.tif, r.trugind10m.tif, r.trugind30m.tif, r.trugind50m.tif, 
                     r.vbflat100m.tif, r.vbflat10m.tif, r.vbflat30m.tif, r.vbflat50m.tif, 
                     r.xseccrv100m.tif, r.xseccrv10m.tif, r.xseccrv30m.tif, r.xseccrv50m.tif)


# 1.3 Convert to a data frame and remove NA's

dem.spdf <- as(r.stack.dem, "SpatialPixelsDataFrame")

head(dem.spdf)

dem.df.all <- as.data.frame(dem.spdf, xy = TRUE, na.rm = TRUE)

#removing xy


dem.df <- within(dem.df.all, rm(x, y))

# When data has negative balues corrplot does not work, produces question marks ??  
# need to center and scale first

trans.dem.df <- preProcess(dem.df, method = c("BoxCox", "center", "scale"))

head(trans.dem.df)

# 1.4 Filtering covariates by correlation.
# 
# High degree of correlation between covariates is determined, then the function returns column
# numbers denoting the covariates that are recomended for deleation.


# 1.4.1 generate a correlation matirx

dem.corr <- cor(dem.df)


# 1.4.1.1 visually examin the correlation structure



corrplot(dem.corr)


# 1.4.2 filtering by correlations
# The cutoff value is arbitrarily set anything with a correlation higher than .75 will be removed

dem.highCorr <- findCorrelation(dem.corr, cutoff = .8) 

head(dem.highCorr)

# 1.4.3 filter to remove covariates

dem.filter <- dem.df[, -dem.highCorr]

head(dem.filter)


# the filtering by correlation removed 7 of 26 covariates

# 1.5 Further Data Reduction by Principal Component Analysis

# 1.5.1 Near Zero filtering

zeroVar <- nearZeroVar(dem.filter)

head(zeroVar)

dem.filter <- dem.filter[, -zeroVar]

#> nearZeroVar(dem.filter)
#integer(0)

# integer(0) means there are no problematic predictors
# When predictors should be removed, a vector of integers is
# returned that indicates which columns should be removed.


# 1.5.2 Review and process data

summary(dem.filter)

# note fast is false by default but becomes true with large datasets, this does not allow
# for skew to be calculated, neet to set fast = False below.
describe(dem.filter, skew = TRUE, fast = FALSE)

# some covariates are skewed will apply data transformations below

# 1.5.3 Box-Cox transformations, center, scale applied prior to pca


trans <- preProcess(dem.filter,
                    method = c("BoxCox", "center", "scale", "pca"))


trans

Created from 4562175 samples and 26 variables

Pre-processing:
  - Box-Cox transformation (4)
- centered (26)
- ignored (0)
- principal component signal extraction (26)
- scaled (26)

Lambda estimates for Box-Cox transformation:
  2, 2, 2, 0.1
PCA needed 19 components to capture 95 percent of the variance

# trans$rotation stores the variables loading factors
head(trans$rotation)

dem.loadings <- as.data.frame(trans$rotation)

# convert to absolut values
dem.loadings.abs <- abs(dem.loadings)

head(dem.loadings.abs)

# add column to sum loadings

dem.loadings.abs$loadings <- rowSums(dem.loadings.abs[, c(1:19)])

head(dem.loadings.abs)

# sort by loadings
sort <- dem.loadings.abs[ order(-dem.loadings.abs$loadings), ]

# remove rows, dropping covariates

dem.covariates <- sort[-c(20:26), ]

# get list of covariates 

print(rownames(dem.covariates))

> print(rownames(dem.covariates))
[1] "insolratio10m" "rtflat10m"     "difinsol10m"   "plancrv100m"   "slplen10m"     "plancrv30m"    "convidx10m"    "profcrv100m"   "fpl10m"       
[10] "plancrv50m"    "mincrv100m"    "profcrv10m"    "plancrv10m"    "vbflat10m"     "insoldur10m"   "xseccrv10m"    "profcrv30m"    "aspt10m"      
[19] "maxcrv10m"

r.stack.dem.2 <- stack(r.insoldur10m.tif, r.rtflat10m.tif, r.difinsol10m.tif, r.plancrv100m.tif, r.slplen10m.tif, r.plancrv30m.tif, r.convidx10m.tif, 
                       r.profcrv100m.tif, r.fpl10m.tif, r.plancrv50m.tif, r.mincrv100m.tif, r.profcrv10m.tif, r.plancrv10m.tif, r.vbflat10m.tif, 
                       r.insoldur10m.tif, r.xseccrv10m.tif, r.profcrv30m.tif, r.aspt10m.tif, r.maxcrv10m.tif)


dem.spdf.2 <- as(r.stack.dem.2, "SpatialPixelsDataFrame")

dem.df.all.2 <- as.data.frame(dem.spdf.2, xy = TRUE, na.rm = TRUE)

#removing xy


dem.df.2 <- within(dem.df.all.2, rm(x, y))


trans <- preProcess(dem.df.2,
                    method = c("BoxCox", "center", "scale", "pca"))


trans

Created from 4562175 samples and 19 variables

Pre-processing:
  - Box-Cox transformation (3)
- centered (19)
- ignored (0)
- principal component signal extraction (19)
- scaled (19)

Lambda estimates for Box-Cox transformation:
  2, 2, 2
PCA needed 15 components to capture 95 percent of the variance

# trans$rotation stores the variables loading factors
head(trans$rotation)

dem.loadings <- as.data.frame(trans$rotation)

# convert to absolut values
dem.loadings.abs <- abs(dem.loadings)

head(dem.loadings.abs)

# add column to sum loadings

dem.loadings.abs$loadings <- rowSums(dem.loadings.abs[, c(1:15)])

head(dem.loadings.abs)

# sort by loadings
sort <- dem.loadings.abs[ order(-dem.loadings.abs$loadings), ]

# remove rows, dropping covariates

dem.covariates <- sort[-c(16:19), ]

# get list of covariates 

print(rownames(dem.covariates))

[1] "plancrv10m"  "plancrv30m"  "difinsol10m" "profcrv100m" "xseccrv10m"  "slplen10m"   "fpl10m"      "convidx10m"  "plancrv100m" "profcrv10m" 
[11] "profcrv30m"  "rtflat10m"   "plancrv50m"  "vbflat10m"   "mincrv100m" 

r.stack.dem.3 <- stack(r.plancrv10m.tif, r.plancrv30m.tif, r.difinsol10m.tif, r.profcrv100m.tif, r.xseccrv10m.tif, r.slplen10m.tif, 
                       r.fpl10m.tif, r.convidx10m.tif, r.plancrv100m.tif, r.profcrv10m.tif, r.profcrv30m.tif, r.rtflat10m.tif, 
                       r.plancrv50m.tif, r.vbflat10m.tif, r.mincrv100m.tif)


dem.spdf.3 <- as(r.stack.dem.3, "SpatialPixelsDataFrame")

dem.df.all.3 <- as.data.frame(dem.spdf.3, xy = TRUE, na.rm = TRUE)

#removing xy


dem.df.3 <- within(dem.df.all.3, rm(x, y))


trans <- preProcess(dem.df.3,
                    method = c("BoxCox", "center", "scale", "pca"))


trans

Created from 4562175 samples and 15 variables

Pre-processing:
  - Box-Cox transformation (1)
- centered (15)
- ignored (0)
- principal component signal extraction (15)
- scaled (15)

Lambda estimates for Box-Cox transformation:
  2
PCA needed 14 components to capture 95 percent of the variance

# trans$rotation stores the variables loading factors
head(trans$rotation)

dem.loadings <- as.data.frame(trans$rotation)

# convert to absolut values
dem.loadings.abs <- abs(dem.loadings)

head(dem.loadings.abs)

# add column to sum loadings

dem.loadings.abs$loadings <- rowSums(dem.loadings.abs[, c(1:14)])

head(dem.loadings.abs)

# sort by loadings
sort <- dem.loadings.abs[ order(-dem.loadings.abs$loadings), ]

# remove rows, dropping covariates

dem.covariates <- sort[-c(15:15), ]

# get list of covariates 

print(rownames(dem.covariates))

[1] "fpl10m"      "plancrv30m"  "plancrv100m" "plancrv10m"  "slplen10m"   "profcrv30m"  "xseccrv10m"  "difinsol10m" "profcrv10m"  "mincrv100m" 
[11] "convidx10m"  "rtflat10m"   "profcrv100m" "plancrv50m"

r.stack.dem.4 <- stack(r.fpl10m.tif, r.plancrv30m.tif, r.plancrv100m.tif, r.plancrv10m.tif, r.slplen10m.tif, r.profcrv30m.tif, 
                       r.xseccrv10m.tif, r.difinsol10m.tif, r.profcrv10m.tif, r.mincrv100m.tif, r.convidx10m.tif, r.rtflat10m.tif, 
                       r.profcrv100m.tif, r.plancrv50m.tif)


dem.spdf.4 <- as(r.stack.dem.4, "SpatialPixelsDataFrame")

dem.df.all.4 <- as.data.frame(dem.spdf.4, xy = TRUE, na.rm = TRUE)

#removing xy


dem.df.4 <- within(dem.df.all.4, rm(x, y))


trans <- preProcess(dem.df.4,
                    method = c("BoxCox", "center", "scale", "pca"))


trans

Created from 4562175 samples and 14 variables

Pre-processing:
  - Box-Cox transformation (1)
- centered (14)
- ignored (0)
- principal component signal extraction (14)
- scaled (14)

Lambda estimates for Box-Cox transformation:
  2
PCA needed 13 components to capture 95 percent of the variance

# trans$rotation stores the variables loading factors
head(trans$rotation)

dem.loadings <- as.data.frame(trans$rotation)

# convert to absolut values
dem.loadings.abs <- abs(dem.loadings)

head(dem.loadings.abs)

# add column to sum loadings

dem.loadings.abs$loadings <- rowSums(dem.loadings.abs[, c(1:13)])

head(dem.loadings.abs)

# sort by loadings
sort <- dem.loadings.abs[ order(-dem.loadings.abs$loadings), ]

# remove rows, dropping covariates

dem.covariates <- sort[-c(13:13), ]

# get list of covariates 

print(rownames(dem.covariates))

> print(rownames(dem.covariates))
[1] "plancrv30m"  "plancrv10m"  "plancrv100m" "rtflat10m"   "difinsol10m" "mincrv100m"  "xseccrv10m"  "convidx10m"  "slplen10m"   "fpl10m"     
[11] "profcrv10m"  "plancrv50m"  "profcrv100m"

r.stack.dem.5 <- stack(r.plancrv30m.tif, r.plancrv10m.tif, r.plancrv100m.tif, r.rtflat10m.tif, r.difinsol10m.tif, r.mincrv100m.tif, 
                       r.xseccrv10m.tif, r.convidx10m.tif, r.slplen10m.tif, r.fpl10m.tif, r.profcrv10m.tif, r.plancrv50m.tif, r.profcrv100m.tif)


dem.spdf.5 <- as(r.stack.dem.5, "SpatialPixelsDataFrame")

dem.df.all.5 <- as.data.frame(dem.spdf.5, xy = TRUE, na.rm = TRUE)

#removing xy


dem.df.5 <- within(dem.df.all.5, rm(x, y))


trans <- preProcess(dem.df.5,
                    method = c("BoxCox", "center", "scale", "pca"))


trans

Created from 4562175 samples and 13 variables

Pre-processing:
  - Box-Cox transformation (1)
- centered (13)
- ignored (0)
- principal component signal extraction (13)
- scaled (13)

Lambda estimates for Box-Cox transformation:
  2
PCA needed 12 components to capture 95 percent of the variance

# trans$rotation stores the variables loading factors
head(trans$rotation)

dem.loadings <- as.data.frame(trans$rotation)

# convert to absolut values
dem.loadings.abs <- abs(dem.loadings)

head(dem.loadings.abs)

# add column to sum loadings

dem.loadings.abs$loadings <- rowSums(dem.loadings.abs[, c(1:12)])

head(dem.loadings.abs)

# sort by loadings
sort <- dem.loadings.abs[ order(-dem.loadings.abs$loadings), ]

# remove rows, dropping covariates

dem.covariates <- sort[-c(12:12), ]

# get list of covariates 

print(rownames(dem.covariates))
[1] "profcrv10m"  "plancrv30m"  "plancrv100m" "convidx10m"  "rtflat10m"   "xseccrv10m"  "plancrv10m"  "profcrv100m" "mincrv100m"  "plancrv50m" 
[11] "difinsol10m" "fpl10m" 

r.stack.dem.6 <- stack(r.profcrv10m.tif, r.plancrv30m.tif, r.plancrv100m.tif, r.convidx10m.tif, r.rtflat10m.tif, r.xseccrv10m.tif, 
                       r.plancrv10m.tif, r.profcrv100m.tif, r.mincrv100m.tif, r.plancrv50m.tif, r.difinsol10m.tif, r.fpl10m.tif)


dem.spdf.6 <- as(r.stack.dem.6, "SpatialPixelsDataFrame")

dem.df.all.6 <- as.data.frame(dem.spdf.6, xy = TRUE, na.rm = TRUE)

#removing xy


dem.df.6 <- within(dem.df.all.6, rm(x, y))


trans <- preProcess(dem.df.6,
                    method = c("BoxCox", "center", "scale", "pca"))


trans

Created from 4562175 samples and 12 variables

Pre-processing:
  - Box-Cox transformation (1)
- centered (12)
- ignored (0)
- principal component signal extraction (12)
- scaled (12)

Lambda estimates for Box-Cox transformation:
  2
PCA needed 11 components to capture 95 percent of the variance

# trans$rotation stores the variables loading factors
head(trans$rotation)

dem.loadings <- as.data.frame(trans$rotation)

# convert to absolut values
dem.loadings.abs <- abs(dem.loadings)

head(dem.loadings.abs)

# add column to sum loadings

dem.loadings.abs$loadings <- rowSums(dem.loadings.abs[, c(1:11)])

head(dem.loadings.abs)

# sort by loadings
sort <- dem.loadings.abs[ order(-dem.loadings.abs$loadings), ]

# remove rows, dropping covariates

dem.covariates <- sort[-c(11:11), ]

# get list of covariates 

print(rownames(dem.covariates))

[1] "profcrv10m"  "plancrv30m"  "plancrv10m"  "xseccrv10m"  "convidx10m"  "profcrv100m" "fpl10m"      "plancrv100m" "plancrv50m"  "rtflat10m"  
[11] "difinsol10m"

r.stack.dem.7 <- stack(r.profcrv10m.tif, r.plancrv30m.tif, r.plancrv100m.tif, r.convidx10m.tif, r.rtflat10m.tif, r.xseccrv10m.tif, 
                       r.plancrv10m.tif, r.profcrv100m.tif, r.plancrv50m.tif, r.difinsol10m.tif, r.fpl10m.tif)


dem.spdf.7 <- as(r.stack.dem.7, "SpatialPixelsDataFrame")

dem.df.all.7 <- as.data.frame(dem.spdf.7, xy = TRUE, na.rm = TRUE)

#removing xy


dem.df.7 <- within(dem.df.all.7, rm(x, y))


trans <- preProcess(dem.df.7,
                    method = c("BoxCox", "center", "scale", "pca"))


trans

Created from 4562175 samples and 11 variables

Pre-processing:
  - Box-Cox transformation (1)
- centered (11)
- ignored (0)
- principal component signal extraction (11)
- scaled (11)

Lambda estimates for Box-Cox transformation:
  2
PCA needed 11 components to capture 95 percent of the variance

[1] "profcrv10m"  "plancrv30m"  "plancrv10m"  "xseccrv10m"  "convidx10m"  "profcrv100m" "fpl10m"      "plancrv100m" "plancrv50m"  "rtflat10m"  
[11] "difinsol10m"

#-----------------------------------------------------------------------------------------------------------------
# 2.0 PrePocessing Landsat8 covariates


# 2.1 #  Load ls8 layers

setwd("E:/Animas_Valley_Playa/basinRaster/10m/")


# Raster Data
r.aug4o2.tif <- raster("aug4o2.tif")
r.aug4o3.tif <- raster("aug4o3.tif")
r.aug4o7.tif <- raster("aug4o7.tif")
r.aug5o6.tif <- raster("aug5o6.tif")
r.aug6o2.tif <- raster("aug6o2.tif")
r.aug6o5.tif <- raster("aug6o5.tif")
r.aug6o7.tif <- raster("aug6o7.tif")
r.aug7o4.tif <- raster("aug7o4.tif")
r.aug7o6.tif <- raster("aug7o6.tif")
r.augcalsed.tif <- raster("augcalsed.tif")
r.auggypsic.tif <- raster("auggypsic.tif")
r.augmsavi2.tif <- raster("augmsavi2.tif")
r.augnatric.tif <- raster("augnatric.tif")
r.jun4o2.tif <- raster("jun4o2.tif")
r.jun4o3.tif <- raster("jun4o3.tif")
r.jun4o7.tif <- raster("jun4o7.tif")
r.jun5o6.tif <- raster("jun5o6.tif")
r.jun6o2.tif <- raster("jun6o2.tif")
r.jun6o5.tif <- raster("jun6o5.tif")
r.jun6o7.tif <- raster("jun6o7.tif")
r.jun7o4.tif <- raster("jun7o4.tif")
r.jun7o6.tif <- raster("jun7o6.tif")
r.juncalsed.tif <- raster("juncalsed.tif")
r.jungypsic.tif <- raster("jungypsic.tif")
r.junmsavi2.tif <- raster("junmsavi2.tif")
r.junnatric.tif <- raster("junnatric.tif")



# 2.2 Create a raster stack

r.stack.ls8 <- stack(r.aug4o2.tif, r.aug4o3.tif, r.aug4o7.tif, r.aug5o6.tif, r.aug6o2.tif, r.aug6o5.tif, 
                      r.aug6o7.tif, r.aug7o4.tif, r.aug7o6.tif, r.augcalsed.tif, r.auggypsic.tif, 
                      r.augmsavi2.tif, r.augnatric.tif, r.jun4o2.tif, r.jun4o3.tif, r.jun4o7.tif, 
                      r.jun5o6.tif, r.jun6o2.tif, r.jun6o5.tif, r.jun6o7.tif, r.jun7o4.tif, r.jun7o6.tif, 
                      r.juncalsed.tif, r.jungypsic.tif, r.junmsavi2.tif, 
                      r.junnatric.tif)
  
  

# 2.3 Convert to a data frame and remove NA's

ls8.spdf <- as(r.stack.ls8, "SpatialPixelsDataFrame")

ls8.df.all <- as.data.frame(ls8.spdf, xy = TRUE, na.rm = TRUE)

head(ls8.df.all)

#removing xy


ls8.df <- within(ls8.df.all, rm(x, y))

head(ls8.df)

# 2.4 Filtering covariates by correlation.
# 
# High degree of correlation between covariates is determined, then the function returns column
# numbers denoting the covariates that are recomended for deleation.


# 2.4.1 generate a correlation matirx

ls8.corr <- cor(ls8.df)


# 2.4.1.1 visually examin the correlation structure



corrplot(ls8.corr)


# 2.4.2 filtering by correlations
# The cutoff value is arbitrarily set anything with a correlation higher than .75 will be removed

ls8.highCorr <- findCorrelation(ls8.corr, cutoff = .8) 

head(ls8.highCorr)

# 2.4.3 filter to remove covariates

ls8.filter <- ls8.df[, -ls8.highCorr]

head(ls8.filter)


# the filtering by correlation removed 27 of 39 covariates

# 2.5 Further Data Reduction by Principal Component Analysis

# 2.5.1 Near Zero filtering

nearZero <- nearZeroVar(ls8.filter)

head(nearZero)

#> nearZeroVar(ls8.filter)
#integer(0)

# integer(0) means there are no problematic predictors
# When predictors should be removed, a vector of integers is
# returned that indicates which columns should be removed.


# 2.5.2 Review and process data

summary(ls8.filter)

# note fast is false by default but becomes true with large datasets, this does not allow
# for skew to be calculated, need to set fast = False below.
describe(ls8.filter, skew = TRUE, fast = FALSE)

# some covariates are skewed will apply data transformations below

# 2.5.3 Box-Cox transformations, center, scale applied prior to pca


ls8.trans <- preProcess(ls8.filter,
                    method = c("BoxCox", "center", "scale", "pca"))


ls8.trans

Created from 4562175 samples and 10 variables

Pre-processing:
  - Box-Cox transformation (7)
- centered (10)
- ignored (0)
- principal component signal extraction (10)
- scaled (10)

Lambda estimates for Box-Cox transformation:
  2, -1.1, 0.2, -2, 0.5, -1.4, 2
PCA needed 5 components to capture 95 percent of the variance

# note above 7 of 12 need to drop 5 covariates

# trans$rotation stores the variables loading factors
head(ls8.trans$rotation)

ls8.loadings <- as.data.frame(ls8.trans$rotation)

head(ls8.loadings)

# convert to absolut values
ls8.loadings.abs <- abs(ls8.loadings)

head(ls8.loadings.abs)

# add column to sum loadings

ls8.loadings.abs$loadings <- rowSums(ls8.loadings.abs[, c(1:5)])

head(ls8.loadings.abs)

# sort by loadings
ls8.sort <- ls8.loadings.abs[ order(-ls8.loadings.abs$loadings), ]

head(ls8.sort)

# remove rows, dropping covariates

ls8.covariates <- ls8.sort[-c(6:10), ]

# get list of covariates 

print(rownames(ls8.covariates))

 
> print(rownames(ls8.covariates))
> print(rownames(ls8.covariates))
[1] "jun4o2"    "augnatric" "aug4o3"    "jun7o6"    "junmsavi2"

# 2.2 Create a raster stack

r.stack.ls8.2 <- stack(r.jun4o2.tif, r.augnatric.tif, r.aug4o3.tif, r.jun7o6.tif, r.junmsavi2.tif)



# 2.3 Convert to a data frame and remove NA's

ls8.spdf.2 <- as(r.stack.ls8.2, "SpatialPixelsDataFrame")

ls8.df.all.2 <- as.data.frame(ls8.spdf.2, xy = TRUE, na.rm = TRUE)

head(ls8.df.all.2)

#removing xy


ls8.df.2 <- within(ls8.df.all.2, rm(x, y))

head(ls8.df.2)




ls8.trans <- preProcess(ls8.df.2,
                        method = c("BoxCox", "center", "scale", "pca"))


ls8.trans

Created from 4562175 samples and 5 variables

Pre-processing:
  - Box-Cox transformation (3)
- centered (5)
- ignored (0)
- principal component signal extraction (5)
- scaled (5)

Lambda estimates for Box-Cox transformation:
  0.5, 2, 2
PCA needed 4 components to capture 95 percent of the variance

# note above 7 of 12 need to drop 5 covariates

# trans$rotation stores the variables loading factors
head(ls8.trans$rotation)

ls8.loadings <- as.data.frame(ls8.trans$rotation)

head(ls8.loadings)

# convert to absolut values
ls8.loadings.abs <- abs(ls8.loadings)

head(ls8.loadings.abs)

# add column to sum loadings

ls8.loadings.abs$loadings <- rowSums(ls8.loadings.abs[, c(1:4)])

head(ls8.loadings.abs)

# sort by loadings
ls8.sort <- ls8.loadings.abs[ order(-ls8.loadings.abs$loadings), ]

head(ls8.sort)

# remove rows, dropping covariates

ls8.covariates <- ls8.sort[-c(5:5), ]

# get list of covariates 

print(rownames(ls8.covariates))




[1] "jun7o6"    "junmsavi2" "jun4o2"    "augnatric"

# 2.2 Create a raster stack

r.stack.ls8.3 <- stack(r.jun4o2.tif, r.augnatric.tif, r.jun7o6.tif, r.junmsavi2.tif)



# 2.3 Convert to a data frame and remove NA's

ls8.spdf.3 <- as(r.stack.ls8.3, "SpatialPixelsDataFrame")

ls8.df.all.3 <- as.data.frame(ls8.spdf.3, xy = TRUE, na.rm = TRUE)

head(ls8.df.all.3)

#removing xy


ls8.df.3 <- within(ls8.df.all.3, rm(x, y))

head(ls8.df.3)




ls8.trans <- preProcess(ls8.df.3,
                        method = c("BoxCox", "center", "scale", "pca"))


ls8.trans

Created from 4562175 samples and 4 variables

Pre-processing:
  - Box-Cox transformation (2)
- centered (4)
- ignored (0)
- principal component signal extraction (4)
- scaled (4)

Lambda estimates for Box-Cox transformation:
  0.5, 2
PCA needed 4 components to capture 95 percent of the variance



#-----------------------------------------------------------------------------------------------------------------

# 3.0 PrePocessing DEM & Landsat8 covariates selected from above


# 3.1 #  Load DEM & ls8 layers

setwd("E:/Animas_Valley_Playa/Avp_Modeling_4212016/basin/10m/")



> print(rownames(dem.covariates))
[1] "profcrv10m"  "plancrv30m"  "plancrv10m"  "xseccrv10m"  "convidx10m"  "profcrv100m" "fpl10m"      "plancrv100m" "plancrv50m"  "rtflat10m"  
[11] "difinsol10m"

[1] "jun7o6"    "junmsavi2" "jun4o2"    "augnatric" 



# 3.2 Create a raster stack

r.stack.all <- stack(r.profcrv10m.tif, r.plancrv30m.tif, r.plancrv10m.tif, r.xseccrv10m.tif, r.convidx10m.tif, r.profcrv100m.tif, 
                     r.fpl10m.tif, r.plancrv100m.tif, r.plancrv50m.tif, r.rtflat10m.tif, r.difinsol10m.tif, 
                     r.jun7o6.tif, r.junmsavi2.tif, r.jun4o2.tif, r.augnatric.tif)



# 3.3 Convert to a data frame and remove NA's

all.spdf <- as(r.stack.all, "SpatialPixelsDataFrame")

all.df.all <- as.data.frame(all.spdf, xy = TRUE, na.rm = TRUE)

head(all.df.all)

#removing xy


all.df <- within(all.df.all, rm(x, y))

head(all.df)

# 3.4 Filtering covariates by correlation.
# 
# High degree of correlation between covariates is determined, then the function returns column
# numbers denoting the covariates that are recomended for deleation.


# 3.4.1 generate a correlation matirx

all.corr <- cor(all.df)


# 3.4.1.1 visually examin the correlation structure



corrplot(all.corr)


# 3.4.2 filtering by correlations
# The cutoff value is arbitrarily set anything with a correlation higher than .75 will be removed

all.highCorr <- findCorrelation(all.corr, cutoff = .75) 

head(all.highCorr)

# 3.4.3 filter to remove covariates
> head(all.highCorr)
integer(0)
# no need to filter, none are highly correlated
#all.filter <- all.df[, -all.highCorr]

#head(all.filter)


# the filtering by correlation removed 27 of 39 covariates

# 3.5 Further Data Reduction by Principal Component Analysis

# 3.5.1 Near Zero filtering

nearZeroVar(all.corr)

#> nearZeroVar(all.corr)
#integer(0)

# integer(0) means there are no problematic predictors
# When predictors should be removed, a vector of integers is
# returned that indicates which columns should be removed.


# 3.5.2 Review and process data

summary(all.corr)

# note fast is false by default but becomes true with large datasets, this does not allow
# for skew to be calculated, need to set fast = False below.
describe(all.corr, skew = TRUE, fast = FALSE)

# some covariates are skewed will apply data transformations below

# 3.5.3 Box-Cox transformations, center, scale applied prior to pca


all.trans <- preProcess(all.df,
                        method = c("BoxCox", "center", "scale", "pca"))


all.trans

Created from 4562175 samples and 15 variables

Pre-processing:
  - Box-Cox transformation (3)
- centered (15)
- ignored (0)
- principal component signal extraction (15)
- scaled (15)

Lambda estimates for Box-Cox transformation:
  2, 2, 0.5
PCA needed 14 components to capture 95 percent of the variance


# note above 11 of 21 need to drop 10 covariates

# trans$rotation stores the variables loading factors
head(all.trans$rotation)

all.loadings <- as.data.frame(all.trans$rotation)

head(all.loadings)

# convert to absolut values
all.loadings.abs <- abs(all.loadings)

head(all.loadings.abs)

# add column to sum loadings

all.loadings.abs$loadings <- rowSums(all.loadings.abs[, c(1:14)])

head(all.loadings.abs)

# sort by loadings
all.sort <- all.loadings.abs[ order(-all.loadings.abs$loadings), ]

head(all.sort)

# remove rows, dropping covariates

all.covariates <- all.sort[-c(15:15), ]

# get list of covariates 

print(rownames(all.covariates))



> print(rownames(all.covariates))
[1] "plancrv10m"  "xseccrv10m"  "profcrv10m"  "plancrv30m"  "rtflat10m"   "convidx10m"  "profcrv100m" "augnatric"   "fpl10m"      "plancrv100m"
[11] "difinsol10m" "jun4o2"      "plancrv50m"  "jun7o6"   

r.stack.all.2 <- stack(r.plancrv10m.tif, r.xseccrv10m.tif, r.profcrv10m.tif, r.plancrv30m.tif, r.rtflat10m.tif, r.convidx10m.tif, 
                       r.profcrv100m.tif, r.augnatric.tif, r.fpl10m.tif, r.plancrv100m.tif, r.difinsol10m.tif, r.jun4o2.tif, 
                       r.plancrv50m.tif, r.jun7o6.tif)



# 3.3 Convert to a data frame and remove NA's

all.spdf.2 <- as(r.stack.all.2, "SpatialPixelsDataFrame")

all.df.all.2 <- as.data.frame(all.spdf.2, xy = TRUE, na.rm = TRUE)

head(all.df.all.2)

#removing xy


all.df.2 <- within(all.df.all.2, rm(x, y))

head(all.df)


#3 Box-Cox transformations, center, scale applied prior to pca


all.trans.2 <- preProcess(all.df.2, method = c("BoxCox", "center", "scale", "pca"))


all.trans.2

Created from 4562175 samples and 14 variables

Pre-processing:
  - Box-Cox transformation (3)
- centered (14)
- ignored (0)
- principal component signal extraction (14)
- scaled (14)

Lambda estimates for Box-Cox transformation:
  2, 0.5, 2
PCA needed 13 components to capture 95 percent of the variance


# note above 11 of 21 need to drop 10 covariates

# trans$rotation stores the variables loading factors
head(all.trans.2$rotation)

all.loadings <- as.data.frame(all.trans.2$rotation)

head(all.loadings)

# convert to absolut values
all.loadings.abs <- abs(all.loadings)

head(all.loadings.abs)

# add column to sum loadings

all.loadings.abs$loadings <- rowSums(all.loadings.abs[, c(1:13)])

head(all.loadings.abs)

# sort by loadings
all.sort <- all.loadings.abs[ order(-all.loadings.abs$loadings), ]

head(all.sort)

# remove rows, dropping covariates

all.covariates <- all.sort[-c(14:14), ]

# get list of covariates 

print(rownames(all.covariates))



> print(rownames(all.covariates))
[1] "plancrv10m"  "xseccrv10m"  "profcrv10m"  "plancrv30m"  "rtflat10m"   "convidx10m"  "profcrv100m" "augnatric"   "fpl10m"      "plancrv100m"
[11] "difinsol10m" "jun4o2"      "plancrv50m"  "jun7o6"

r.stack.all.3 <- stack(r.plancrv10m.tif, r.xseccrv10m.tif, r.profcrv10m.tif, r.plancrv30m.tif, r.rtflat10m.tif, r.convidx10m.tif, 
                       r.profcrv100m.tif, r.augnatric.tif, r.fpl10m.tif, r.plancrv100m.tif, r.difinsol10m.tif, r.jun4o2.tif, 
                       r.plancrv50m.tif, r.jun7o6.tif)



# 3.3 Convert to a data frame and remove NA's

all.spdf.3 <- as(r.stack.all.3, "SpatialPixelsDataFrame")

all.df.all.3 <- as.data.frame(all.spdf.3, xy = TRUE, na.rm = TRUE)

head(all.df.all.3)

#removing xy


all.df.3 <- within(all.df.all.3, rm(x, y))

head(all.df)


#3 Box-Cox transformations, center, scale applied prior to pca


all.trans.3 <- preProcess(all.df.3, method = c("BoxCox", "center", "scale", "pca"))


all.trans.3

Created from 4562175 samples and 14 variables

Pre-processing:
  - Box-Cox transformation (3)
- centered (14)
- ignored (0)
- principal component signal extraction (14)
- scaled (14)

Lambda estimates for Box-Cox transformation:
  2, 0.5, 2
PCA needed 13 components to capture 95 percent of the variance


# note above 11 of 21 need to drop 10 covariates

# trans$rotation stores the variables loading factors
head(all.trans.3$rotation)

all.loadings <- as.data.frame(all.trans.3$rotation)

head(all.loadings)

# convert to absolut values
all.loadings.abs <- abs(all.loadings)

head(all.loadings.abs)

# add column to sum loadings

all.loadings.abs$loadings <- rowSums(all.loadings.abs[, c(1:13)])

head(all.loadings.abs)

# sort by loadings
all.sort <- all.loadings.abs[ order(-all.loadings.abs$loadings), ]

head(all.sort)

# remove rows, dropping covariates

all.covariates <- all.sort[-c(14:15), ]

# get list of covariates 

print(rownames(all.covariates))



> print(rownames(all.covariates))
[1] "plancrv10m"  "xseccrv10m"  "profcrv10m"  "convidx10m"  "augnatric"   "plancrv30m"  "plancrv100m" "jun7o6"      "fpl10m"      "rtflat10m"  
[11] "plancrv50m"  "profcrv100m" "difinsol10m"


r.stack.all.4 <- stack(r.plancrv10m.tif, r.xseccrv10m.tif, r.profcrv10m.tif, r.convidx10m.tif, r.augnatric.tif, r.plancrv30m.tif, 
                       r.plancrv100m.tif, r.jun7o6.tif, r.fpl10m.tif, r.rtflat10m.tif, r.plancrv50m.tif, r.profcrv100m.tif, r.difinsol10m.tif)



# 3.4 Convert to a data frame and remove NA's

all.spdf.4 <- as(r.stack.all.4, "SpatialPixelsDataFrame")

all.df.all.4 <- as.data.frame(all.spdf.4, xy = TRUE, na.rm = TRUE)

head(all.df.all.4)

#removing xy


all.df.4 <- within(all.df.all.4, rm(x, y))

head(all.df.4)


#3 Box-Cox transformations, center, scale applied prior to pca


all.trans.4 <- preProcess(all.df.4, method = c("BoxCox", "center", "scale", "pca"))


all.trans.4

Created from 4562175 samples and 13 variables

Pre-processing:
  - Box-Cox transformation (2)
- centered (13)
- ignored (0)
- principal component signal extraction (13)
- scaled (13)

Lambda estimates for Box-Cox transformation:
  2, 2
PCA needed 12 components to capture 95 percent of the variance


# note above 11 of 21 need to drop 10 covariates

# trans$rotation stores the variables loading factors
head(all.trans.4$rotation)

all.loadings <- as.data.frame(all.trans.4$rotation)

head(all.loadings)

# convert to absolut values
all.loadings.abs <- abs(all.loadings)

head(all.loadings.abs)

# add column to sum loadings

all.loadings.abs$loadings <- rowSums(all.loadings.abs[, c(1:12)])

head(all.loadings.abs)

# sort by loadings
all.sort <- all.loadings.abs[ order(-all.loadings.abs$loadings), ]

head(all.sort)

# remove rows, dropping covariates

all.covariates <- all.sort[-c(13:14), ]

# get list of covariates 

print(rownames(all.covariates))



> print(rownames(all.covariates))
[1] "plancrv10m"  "xseccrv10m"  "profcrv10m"  "convidx10m"  "plancrv30m"  "plancrv100m" "plancrv50m"  "augnatric"   "jun7o6"      "fpl10m"     
[11] "rtflat10m"   "profcrv100m"

r.stack.all.5 <- stack(r.plancrv10m.tif, r.xseccrv10m.tif, r.profcrv10m.tif, r.convidx10m.tif, r.augnatric.tif, r.plancrv30m.tif, 
                       r.plancrv100m.tif, r.jun7o6.tif, r.fpl10m.tif, r.rtflat10m.tif, r.plancrv50m.tif, r.profcrv100m.tif)



# 3.5 Convert to a data frame and remove NA's

all.spdf.5 <- as(r.stack.all.5, "SpatialPixelsDataFrame")

all.df.all.5 <- as.data.frame(all.spdf.5, xy = TRUE, na.rm = TRUE)

head(all.df.all.5)

#removing xy


all.df.5 <- within(all.df.all.5, rm(x, y))

head(all.df.5)


#3 Box-Cox transformations, center, scale applied prior to pca


all.trans.5 <- preProcess(all.df.5, method = c("BoxCox", "center", "scale", "pca"))


all.trans.5

Created from 4562175 samples and 12 variables

Pre-processing:
  - Box-Cox transformation (1)
- centered (12)
- ignored (0)
- principal component signal extraction (12)
- scaled (12)

Lambda estimates for Box-Cox transformation:
  2
PCA needed 11 components to capture 95 percent of the variance


# note above 11 of 21 need to drop 10 covariates

# trans$rotation stores the variables loading factors
head(all.trans.5$rotation)

all.loadings <- as.data.frame(all.trans.5$rotation)

head(all.loadings)

# convert to absolut values
all.loadings.abs <- abs(all.loadings)

head(all.loadings.abs)

# add column to sum loadings

all.loadings.abs$loadings <- rowSums(all.loadings.abs[, c(1:11)])

head(all.loadings.abs)

# sort by loadings
all.sort <- all.loadings.abs[ order(-all.loadings.abs$loadings), ]

head(all.sort)

# remove rows, dropping covariates

all.covariates <- all.sort[-c(12:14), ]

# get list of covariates 

print(rownames(all.covariates))



> print(rownames(all.covariates))
[1] "profcrv10m"  "xseccrv10m"  "plancrv10m"  "plancrv30m"  "plancrv100m" "fpl10m"      "profcrv100m" "convidx10m"  "plancrv50m"  "augnatric"  
[11] "jun7o6"  



r.stack.all.6 <- stack(r.profcrv10m.tif, r.xseccrv10m.tif, r.plancrv10m.tif, r.plancrv30m.tif, r.plancrv100m.tif, r.fpl10m.tif, 
                       r.profcrv100m.tif, r.convidx10m.tif, r.plancrv50m.tif, r.augnatric.tif, r.jun7o6.tif)



# 3.6 Convert to a data frame and remove NA's

all.spdf.6 <- as(r.stack.all.6, "SpatialPixelsDataFrame")

all.df.all.6 <- as.data.frame(all.spdf.6, xy = TRUE, na.rm = TRUE)

head(all.df.all.6)

#removing xy


all.df.6 <- within(all.df.all.6, rm(x, y))

head(all.df.6)


#3 Box-Cox transformations, center, scale applied prior to pca


all.trans.6 <- preProcess(all.df.6, method = c("BoxCox", "center", "scale", "pca"))


all.trans.6

Created from 4562175 samples and 11 variables

Pre-processing:
  - Box-Cox transformation (1)
- centered (11)
- ignored (0)
- principal component signal extraction (11)
- scaled (11)

Lambda estimates for Box-Cox transformation:
  2
PCA needed 11 components to capture 95 percent of the variance

[1] "profcrv10m"  "xseccrv10m"  "plancrv10m"  "plancrv30m"  "plancrv100m" "fpl10m"      "profcrv100m" "convidx10m"  "plancrv50m"  "augnatric"  
[11] "jun7o6"  

