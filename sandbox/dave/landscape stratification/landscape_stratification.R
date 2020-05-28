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
library(snowfall)
library(ggplot2)

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
reg.samp <- sampleRegular(rstack30m$aspect, size = 5000000, sp=T)
endCluster()


# convert raster stack to list of single raster layers
rstack30m.list <- unstack(rstack30m)
names(rstack30m.list) <- names(rstack30m)

## Parallelized extract: (larger datasets)
sfInit(parallel=TRUE, cpus=parallel:::detectCores()-1)
sfLibrary(raster)
sfLibrary(rgdal)

# run parallelized 'extract' 
e.df <- sfSapply(rstack30m.list, extract, y=reg.samp)
sfStop()

gc()
# convert to dataframe a
georegion.df <- na.omit(as.data.frame(e.df))
names(georegion.df) = tools::file_path_sans_ext(basename(names(rstack30m.list)))
names(georegion.df)
head(georegion.df)

gc()



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
reg.samp <- sampleRegular(pied.stk, size = 5000000, sp=T)
endCluster()


# convert raster stack to list of single raster layers
pied.stk.list <- unstack(pied.stk)
names(pied.stk.list) <- names(pied.stk)

## Parallelized extract: (larger datasets)
sfInit(parallel=TRUE, cpus=parallel:::detectCores()-1)
sfLibrary(raster)
sfLibrary(rgdal)

# run parallelized 'extract' 
e.df <- sfSapply(pied.stk.list, extract, y=reg.samp)
sfStop()

gc()
# convert to dataframe a
pied.df <- na.omit(as.data.frame(e.df))
names(pied.df) = tools::file_path_sans_ext(basename(names(pied.stk.list)))
names(pied.df)
head(pied.df)

gc()



# bring in basin shapefile
basin.shp <- readOGR("basin_buffer.shp")
#check projection
basin.shp@proj4string
rstack30m@crs

basin.shp <- spTransform(basin.shp, crs(rstack30m@crs))
basin.stk <- crop(rstack30m, basin.shp)


length(basin.stk)
beginCluster()
reg.samp <- sampleRegular(basin.stk, size = 5000000, sp=T)
endCluster()


# convert raster stack to list of single raster layers
basin.stk.list <- unstack(basin.stk)
names(basin.stk.list) <- names(basin.stk)

## Parallelized extract: (larger datasets)
sfInit(parallel=TRUE, cpus=parallel:::detectCores()-1)
sfLibrary(raster)
sfLibrary(rgdal)

# run parallelized 'extract' 
e.df <- sfSapply(basin.stk.list, extract, y=reg.samp)
sfStop()

gc()
# convert to dataframe a
basin.df <- na.omit(as.data.frame(e.df))
names(basin.df) = tools::file_path_sans_ext(basename(names(basin.stk.list)))
names(basin.df)
head(basin.df)

save.image("C:/avp_cov/land_strat_data.RData")

gc()


# subset the data frames to check out some covariates
names(georegion.df)


geo.sub <- subset(georegion.df[,c(1,5,81,90)])
pied.sub <- subset(pied.df[,c(1,5,81,90)])
basin.sub <- subset(basin.df[,c(1,5,81,90)])

cov.comp <- rbind(data.frame(landscape = "georegion", geo.sub), data.frame(landscape="piedmont", pied.sub), data.frame(landscape="basin", basin.sub))

names(cov.comp)
ggplot(cov.comp, aes(x = landscape, y = sagawi, color = landscape)) + geom_boxplot(cex = 1)
