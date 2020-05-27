# Landscape Stratification to improve sampling for use in DSM
# Utilizing the Animas Valley Playa dataset generated duing update field work.
#

# Set up working environment
# load and install required packages ####
#required.packages <- c("raster", "caret", "corrplot", "psych", "doParallel", "foreach", "sp", "rgdal", "factoextra")
#new.packages <- required.packages[!(required.packages %in% installed.packages()[,"Package"])]
#if(length(new.packages)) install.packages(new.packages)
#lapply(required.packages, require, character.only=T)
#rm(required.packages, new.packages)
library(raster)
library(rgdal)
library(caret)
library(corrplot)
library(factoextra)


# set working directory
setwd("C:avp_cov")

# load in raster data
# read in raster layers names from modeling folder and create list
rlist=list.files(getwd(), pattern="tif$", full.names = FALSE)
rlist

# create raster stack
rstack <- stack(rlist)
names(rstack)
str(rstack)
length(rstack)# almots 2 billion cells
length(rstack@layers)# number of covariates
res(rstack)#10m resolution


# change resolution from 10m to 30m for faster processing times
rstack30m <- aggregate(rstack, fact=3, fun=mean, na.rm = TRUE)
res(rstack30m)
length(rstack30m)# roughly 200 million cells

# generate a regular sample of points representative of the geographic region
beginCluster()
georegion.df <- sampleRegular(rstack30m, size = 5000000)
endCluster()

georegion.df <- na.omit(as.data.frame(georegion.df))

# bring in piedmont shapefile
pied.shp <- readOGR("piedmont_buffer.shp")
pied.shp@proj4string
rstack30m@crs@projargs

# reproject shp to align with raster stack
pied.shp <- spTransform(pied.shp, crs(rstack30m@crs))


# clip to boundary
pied.stk <- crop(rstack30m, pied.shp)

# how big is it
length(pied.stk)
beginCluster()
pied.df <- sampleRegular(pied.stk, size = 500000)
endCluster()

pied.df <- na.omit(as.data.frame(pied.df))


# bring in basin shapefile
basin.shp <- readOGR("basin_buffer.shp")
#check projection
basin.shp@proj4string
rstack30m@crs

basin.shp <- spTransform(basin.shp, crs(rstack30m@crs))
basin.stk <- crop(rstack30m, basin.shp)
length(basin.stk)
beginCluster()
basin.df <- sampleRegular(basin.stk, size = 500000)
endCluster()
basin.df <- na.omit(as.data.frame(basin.df))


# we have 3 data.frames lets compare some of the covariates
# subset the dataframes to a few selected covariates
names(georegion.df)


#compare.df <- as.data.frame(rbind(method = "georegion", georegion.df, method = "piedmont", pied.df,  method = "basin", basin.df))






