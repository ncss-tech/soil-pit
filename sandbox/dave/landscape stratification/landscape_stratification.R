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
georegion.df <- sampleRegular(rstack30m, size = 5000000)

# bring in piedmont shapefile
pied.shp <- readOGR("piedmont_buffer.shp")

# clip to boundary
pied.stk <- crop(rstack30m, pied.shp)




