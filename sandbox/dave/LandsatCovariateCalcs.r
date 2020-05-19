### Landsat covariate development

# Dave White 05/19/2020
# 

# The landsat data was dounloaded using the USFS implementations in google earth engine. The following is a link to those modules : https://earthengine.googlesource.com/users/USFS_GTAC/modules/+/master. To represent dry periods of time Jan 1 to Feb 28th was used from 2015 to 2019. To represent wet periods of time July 1st to Sept 30th was used from 2015 to 2019. Time buffer was set to 2, weights was set to 1,2,3,2,1, median and SR was selected for each season. This algorithim calculates the median values for each date range. The final band combonations reflect those of Landsat 7.

# For reference, the bands in the calculations below correspond to the following:
# 1)	Blue
# 2)	Green
# 3)	Red
# 4)	NIR
# 5)	SWIR1
# 6)	SWIR2


## Load packages
required.packages <- c("raster", "sp", "rgdal", "RStoolbox", 
                       "snow", "snowfall","parallel", "itertools","doParallel")
new.packages <- required.packages[!(required.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(required.packages, require, character.only=T)
rm(required.packages, new.packages)

# If using a laptop this section of code may be usefull for memory handling
## Increase actuve memory useable by raster package
#memory.limit(110000)
#rasterOptions(maxmemory = 5e+08, chunksize = 3e+07)

# Bring in our LS raster stacks and clip to our covariate development boundary

# load ls raster stacks

# set directory that contains the ls rasters 
# *** pay attention to the / below
setwd("E:/Big_Cypress/data/spectral/")

# read in raster layers to create raster stack
ls.wet <- stack("LSwet.tif")
ls.dry <- stack("LSdry.tif")



# read in shapefile to clip rasters
# NOTE - this is our huc 10 buffer bndry 
setwd("E:/Big_Cypress/data/huc12")

poly <- readOGR(dsn = ".", layer = "huc12") # reads in shapefile

# crop raster stack by group - this clips the raster stack to the extent of the polygon
stack.crop.wet <- crop(ls.wet, poly) 
stack.crop.dry <- crop(ls.dry, poly)

# converts polygon to a raster for faster masking of raster stacks
poly.r <- rasterize(poly, stack.crop.wet$LSwet.1)

# mask raster stacks
ls.wet <- mask(stack.crop.wet, poly.r)
ls.dry <- mask(stack.crop.dry, poly.r)

# save raster data
# setwd("E:/Big_Cypress/data/spectral/clip")
# saveRDS(ls.wet, "ls_wet.rds")
# writeRaster(ls.wet, filename = "ls_wet.tif", format = "GTiff", overwrite = TRUE)
# saveRDS(ls.dry, "ls_dry.rds")
# writeRaster(ls.dry, filename = "ls_dry.tif", format = "GTiff", overwrite = TRUE)

# visually inspect the raster
plot(ls.dry$LSdry.1)


#### Extract individual bands from raster stacks.
# added a constant to each band. there were some issues in calculating the indices, where it was 
# returning no data cells. 

setwd("E:/Big_Cypress/data/spectral/clip/wet")

lswetb1 <- ls.wet$LSwet.1 + 1
writeRaster(lswetb1, filename = "lswet1.tif", format = "GTiff", overwrite = TRUE)
lswetb2 <- ls.wet$LSwet.2 + 1
writeRaster(lswetb2, filename = "lswet2.tif", format = "GTiff", overwrite = TRUE)
lswetb3 <- ls.wet$LSwet.3 + 1
writeRaster(lswetb3, filename = "lswet3.tif", format = "GTiff", overwrite = TRUE)
lswetb4 <- ls.wet$LSwet.4 + 1
writeRaster(lswetb4, filename = "lswet4.tif", format = "GTiff", overwrite = TRUE)
lswetb5 <- ls.wet$LSwet.5 + 1
writeRaster(lswetb5, filename = "lswet5.tif", format = "GTiff", overwrite = TRUE)
lswetb6 <- ls.wet$LSwet.7 + 1
writeRaster(lswetb6, filename = "lswet6.tif", format = "GTiff", overwrite = TRUE)
lswetb7 <- ls.wet$LSwet.6 + 1
writeRaster(lswetb7, filename = "lswet7.tif", format = "GTiff", overwrite = TRUE)



setwd("E:/Big_Cypress/data/spectral/clip/dry")
lsdryb1 <- ls.dry$LSdry.1 + 1
writeRaster(lsdryb1, filename = "lsdry1.tif", format = "GTiff", overwrite = TRUE)
lsdryb2 <- ls.dry$LSdry.2 + 1
writeRaster(lsdryb2, filename = "lsdry2.tif", format = "GTiff", overwrite = TRUE)
lsdryb3 <- ls.dry$LSdry.3 + 1
writeRaster(lsdryb3, filename = "lsdry3.tif", format = "GTiff", overwrite = TRUE)
lsdryb4 <- ls.dry$LSdry.4 + 1
writeRaster(lsdryb4, filename = "lsdry4.tif", format = "GTiff", overwrite = TRUE)
lsdryb5 <- ls.dry$LSdry.5 + 1
writeRaster(lsdryb5, filename = "lsdry5.tif", format = "GTiff", overwrite = TRUE)
lsdryb6 <- ls.dry$LSdry.7 + 1
writeRaster(lsdryb6, filename = "lsdry6.tif", format = "GTiff", overwrite = TRUE)
lsdryb7 <- ls.dry$LSdry.6 + 1
writeRaster(lsdryb7, filename = "lsdry7.tif", format = "GTiff", overwrite = TRUE)



######################################################################




## Development of Landsat dry covariates

## set working directory for landsat 8 dry data
setwd("E:/Big_Cypress/data/spectral/clip/dry")

## load ls drt data as a raster stack
r.list=list.files(getwd(), pattern="tif$", full.names = FALSE)
ls.dry <- stack(r.list)

## get individual bands
b1dry <- ls.dry$lsdry1
b2dry <- ls.dry$lsdry2
b3dry <- ls.dry$lsdry3
b4dry <- ls.dry$lsdry4
b5dry <- ls.dry$lsdry5
b6dry <- ls.dry$lsdry6
b7dry <- ls.dry$lsdry7

## Normalized Difference index function
nd_fn <- function(bd1,bd2) {ind <- (bd1 - bd2)/(bd1 + bd2)*100
return(ind)
}

## set up cluster
beginCluster()
#### set workspace for leaf dry covariates
setwd("E:/Big_Cypress/data/spectral/cov")


## ratio calcs for dry
# note the  compression and datatypes are commented out, check the data ranges of each raster produced and select the appropriate datatype. Use ?raster::datatype to see the different choices.
s3t1dry <- stack(b3dry,b1dry) 
clusterR(s3t1dry, overlay, args=list(fun=nd_fn),progress='text',filename="nd3t1dry.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s3t2dry <- stack(b3dry,b2dry) 
clusterR(s3t2dry, overlay, args=list(fun=nd_fn),progress='text',filename="nd3t2dry.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s3t7dry <- stack(b3dry,b7dry) 
clusterR(s3t7dry, overlay, args=list(fun=nd_fn),progress='text',filename="nd3t7dry.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s4t5dry <- stack(b4dry,b5dry) 
clusterR(s4t5dry, overlay, args=list(fun=nd_fn),progress='text',filename="nd4t5dry.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s5t1dry <- stack(b5dry,b1dry) 
clusterR(s5t1dry, overlay, args=list(fun=nd_fn),progress='text',filename="nd5t1dry.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s5t4dry <- stack(b5dry,b4dry)
clusterR(s5t4dry, overlay, args=list(fun=nd_fn), progress='text', filename="nd5t4dry.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s7t3dry <- stack(b7dry,b3dry) 
clusterR(s7t3dry, overlay, args=list(fun=nd_fn),progress='text',filename="nd7t3dry.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s7t5dry <- stack(b7dry,b5dry) 
clusterR(s7t5dry, overlay, args=list(fun=nd_fn),progress='text',filename="nd7t5dry.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

## Other normalized indices
# calcareous sediment index
calsed.dry <- stack(b5dry, b2dry)
clusterR(calsed.dry, overlay, args=list(fun=nd_fn),progress='text',filename="calseddry.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

# ndvi - normalized difference vegitation index
ndvi.dry <- stack(b4dry, b3dry)
clusterR(ndvi.dry, overlay, args=list(fun=nd_fn),progress='text',filename="ndvidry.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)


# msavi2 - modified soil adjusted vegitation index - for areas of sparce vegetation
msavi_fn <- function(bd1,bd2) {ind <- ((2*bd1+1)-(sqrt((2*bd1+1)^2-8*(bd1-bd2))))/2 
return(ind)
}
msavi.dry <- stack(b4dry, b3dry)
clusterR(msavi.dry, overlay, args=list(fun=msavi_fn),progress='text',filename="msavidry.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

# rock outcrop index
rock.dry <- stack(b5dry, b3dry)
clusterR(rock.dry, overlay, args=list(fun=nd_fn),progress='text',filename="rockdry.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)


endCluster()
gc()



## Tasseled Cap
beginCluster()
dry.tc <- tasseledCap(ls.dry[[c(1:5,7)]], sat = "Landsat7ETM", progress='text')

# extract TC
dry.brightness <- dry.tc$brightness
dry.greenness <- dry.tc$greenness
dry.wetness <- dry.tc$wetness

# write TC rasters
writeRaster(dry.brightness, filename = "TCbrightdry.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(dry.greenness, filename = "TCgreendry.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(dry.wetness, filename = "TCwetdry.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')


# plot TC
plot(dry.tc)



## Principal Component Analysis
dry.pca <- rasterPCA(ls.dry[[c(1:7)]], maskCheck = F, progress = 'text')

# get individual PCs
drypc1 <- dry.pca$map$PC1
drypc2 <- dry.pca$map$PC2
drypc3 <- dry.pca$map$PC3
drypc4 <- dry.pca$map$PC4
drypc5 <- dry.pca$map$PC5
drypc6 <- dry.pca$map$PC6
drypc7 <- dry.pca$map$PC7


# save rasters
writeRaster(drypc1,filename="drypc1.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(drypc2,filename="drypc2.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(drypc3,filename="drypc3.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(drypc4,filename="drypc4.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(drypc5,filename="drypc5.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(drypc6,filename="drypc6.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(drypc7,filename="drypc7.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')

# end parallel cluster
endCluster()

# clear working environment and memory
rm(list=ls())
gc()






##################################################################################################
## Development of Landsat wet covariates

## set working directory for landsat wet data
setwd("E:/Big_Cypress/data/spectral/clip/wet")

## load ls drt data as a raster stack
r.list=list.files(getwd(), pattern="tif$", full.names = FALSE)
ls.wet <- stack(r.list)

## get individual bands
b1wet <- ls.wet$lswet1
b2wet <- ls.wet$lswet2
b3wet <- ls.wet$lswet3
b4wet <- ls.wet$lswet4
b5wet <- ls.wet$lswet5
b6wet <- ls.wet$lswet6
b7wet <- ls.wet$lswet7

## Normalized Difference index function
nd_fn <- function(bd1,bd2) {ind <- (bd1 - bd2)/(bd1 + bd2)*100
return(ind)
}

## set up cluster
beginCluster()
#### set workspace for leaf wet covariates
setwd("E:/Big_Cypress/data/spectral/cov")


## ratio calcs for wet
# note the  compression and datatypes are commented out, check the data ranges of each raster produced and select the appropriate datatype. Use ?raster::datatype to see the different choices.
s3t1wet <- stack(b3wet,b1wet) 
clusterR(s3t1wet, overlay, args=list(fun=nd_fn),progress='text',filename="nd3t1wet.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s3t2wet <- stack(b3wet,b2wet) 
clusterR(s3t2wet, overlay, args=list(fun=nd_fn),progress='text',filename="nd3t2wet.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s3t7wet <- stack(b3wet,b7wet) 
clusterR(s3t7wet, overlay, args=list(fun=nd_fn),progress='text',filename="nd3t7wet.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s4t5wet <- stack(b4wet,b5wet) 
clusterR(s4t5wet, overlay, args=list(fun=nd_fn),progress='text',filename="nd4t5wet.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s5t1wet <- stack(b5wet,b1wet) 
clusterR(s5t1wet, overlay, args=list(fun=nd_fn),progress='text',filename="nd5t1wet.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s5t4wet <- stack(b5wet,b4wet)
clusterR(s5t4wet, overlay, args=list(fun=nd_fn), progress='text', filename="nd5t4wet.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s7t3wet <- stack(b7wet,b3wet) 
clusterR(s7t3wet, overlay, args=list(fun=nd_fn),progress='text',filename="nd7t3wet.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

s7t5wet <- stack(b7wet,b5wet) 
clusterR(s7t5wet, overlay, args=list(fun=nd_fn),progress='text',filename="nd7t5wet.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

## Other normalized indices
# calcareous sediment index
calsed.wet <- stack(b5wet, b2wet)
clusterR(calsed.wet, overlay, args=list(fun=nd_fn),progress='text',filename="calsedwet.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

# ndvi - normalized difference vegitation index
ndvi.wet <- stack(b4wet, b3wet)
clusterR(ndvi.wet, overlay, args=list(fun=nd_fn),progress='text',filename="ndviwet.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)


# msavi2 - modified soil adjusted vegitation index - for areas of sparce vegetation
msavi_fn <- function(bd1,bd2) {ind <- ((2*bd1+1)-(sqrt((2*bd1+1)^2-8*(bd1-bd2))))/2 
return(ind)
}
msavi.wet <- stack(b4wet, b3wet)
clusterR(msavi.wet, overlay, args=list(fun=msavi_fn),progress='text',filename="msaviwet.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)

# rock outcrop index
rock.wet <- stack(b5wet, b3wet)
clusterR(rock.wet, overlay, args=list(fun=nd_fn),progress='text',filename="rockwet.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE)


endCluster()
gc()



## Tasseled Cap
beginCluster()
wet.tc <- tasseledCap(ls.wet[[c(1:5,7)]], sat = "Landsat7ETM", progress='text')

# extract TC
wet.brightness <- wet.tc$brightness
wet.greenness <- wet.tc$greenness
wet.wetness <- wet.tc$wetness

# write TC rasters
writeRaster(wet.brightness, filename = "TCbrightwet.tif", options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(wet.greenness, filename = "TCgreenwet.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(wet.wetness, filename = "TCwetwet.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')


# plot TC
plot(wet.tc)



## Principal Component Analysis
wet.pca <- rasterPCA(ls.wet[[c(1:7)]], maskCheck = F, progress = 'text')

# get individual PCs
wetpc1 <- wet.pca$map$PC1
wetpc2 <- wet.pca$map$PC2
wetpc3 <- wet.pca$map$PC3
wetpc4 <- wet.pca$map$PC4
wetpc5 <- wet.pca$map$PC5
wetpc6 <- wet.pca$map$PC6
wetpc7 <- wet.pca$map$PC7


# save rasters
writeRaster(wetpc1,filename="wetpc1.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(wetpc2,filename="wetpc2.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(wetpc3,filename="wetpc3.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(wetpc4,filename="wetpc4.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(wetpc5,filename="wetpc5.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(wetpc6,filename="wetpc6.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')
writeRaster(wetpc7,filename="wetpc7.tif",options=c("COMPRESS=DEFLATE"),datatype='INT2S', overwrite=TRUE, progress='text')

# end parallel cluster
endCluster()

# clear working environment and memory
rm(list=ls())
gc()


##################################################################################################


#### Comparisons of wet abd dry landsat scenes ###

## load rasters
#### set workspace for leaf on covariates
setwd("E:/Big_Cypress/data/spectral/cov/")

ndviwet <- raster("ndviwet.tif")
msaviwet <- raster("msaviwet.tif")
tcgwet <- raster("TCgreenwet.tif")
tcwwet <- raster("TCwetwet.tif")

ndvidry <- raster("ndvidry.tif")
msavidry <- raster("msavidry.tif")
tcgdry <- raster("TCgreendry.tif")
tcwdry <- raster("TCwetdry.tif")

## Veg compare function
# originally the function had a multiplication factor of 1000 (bd1-bd2)*1000
# this caused errors because the data values were outside the range of the datatype
# could have changed the data type, but instead removed the multiplication factor
vc_fn <- function(bd1,bd2) {ind <- (bd1 - bd2) 
return(ind)
}

## Veg index differences
setwd("E:/Big_Cypress/data/spectral/cov/")


## set up cluster
beginCluster()


# compare ndvi
ndvind <- stack(ndviwet, ndvidry) 
clusterR(ndvind, overlay, args=list(fun=vc_fn),progress='text',
         filename="ndvi_c.tif", options=c("COMPRESS=DEFLATE"), datatype='INT2S', na.omit=TRUE)

# compare msavi
msavind <- stack(msaviwet,msavidry) 
clusterR(msavind, overlay, args=list(fun=vc_fn),progress='text',
         filename="msavi_c.tif", options=c("COMPRESS=DEFLATE"), datatype='INT2S', na.omit=TRUE)

# compare greenness
tcgnd <- stack(tcgwet, tcgdry) 
clusterR(tcgnd, overlay, args=list(fun=vc_fn),progress='text',
         filename="tc_green_c.tif", options=c("COMPRESS=DEFLATE"), datatype='INT2S', na.omit=TRUE)
tcwetnd <- stack(tcwwet, tcwdry) 
clusterR(tcgnd, overlay, args=list(fun=vc_fn),progress='text',
         filename="tc_wet_c.tif", options=c("COMPRESS=DEFLATE"), datatype='INT2S', na.omit=TRUE)



endCluster()

######################################################################
