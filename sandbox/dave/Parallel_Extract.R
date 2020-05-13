# Parallel Extract

# Original code by Travis Nauman(tnauman@usgs.gov), modified by Dave White(david.white@usda.gov)

# Extracts raster values at each point in parallel, this process is useful for large datasets


## Install and Load packages
required.packages <- c("rgdal", "raster", "sp", "snow", "snowfall")
new.packages <- required.packages[!(required.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(required.packages, require, character.only=T)
rm(required.packages, new.packages)

setwd("C:/cov/")## Folder with points
shp.pts <-readOGR(dsn=".", layer="field_data_0206")


setwd("C:/cov/")## Folder with rasters
# read in raster layers to create raster stack
r.list=list.files(getwd(), pattern="tif$", full.names = FALSE)
r.list

#create raster stack of covariates
r.stack <- stack(r.list)
names(r.stack)

# convert raster stack to list of single raster layers
r.stack.list <- unstack(r.stack)
names(r.stack.list) <- names(r.stack)

## Parallelized extract: (larger datasets)
sfInit(parallel=TRUE, cpus=parallel:::detectCores()-1)
sfLibrary(raster)
sfLibrary(rgdal)

# run parallelized 'extract' 
e.df <- sfSapply(r.stack.list, extract, y=shp.pts)
sfStop()

gc()
# convert to dataframe a
DF <- as.data.frame(e.df)
names(DF) = tools::file_path_sans_ext(basename(names(r.stack.list)))
names(DF)
head(DF)

DF$ID <- seq.int(nrow(DF))
shp.pts$ID <- seq.int(nrow(shp.pts))

# merge by ID creating spatial points
train.pts = merge(shp.pts, DF, by="ID")


## Save points
#setwd("D:/Jornada LRU Update/Modeling/")
writeOGR(train.pts,dsn=".", layer= "trainptscov", driver="ESRI Shapefile", overwrite=TRUE)
