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
#library(ggplot2)

# set working directory
setwd("C:avp_cov")

# load in raster data
# read in raster layers names from modeling folder and create list
rlist=list.files(getwd(), pattern="D.tif$", full.names = FALSE)
rlist

# create raster stack
rstackDEM <- stack(rlist)
names(rstackDEM)

length(rstackDEM)# almots 2 billion cells
length(rstackDEM@layers)# number of covariates
res(rstackDEM)#10m resolution


# change resolution from 10m to 30m for faster processing times
rsDEM30 <- aggregate(rstackDEM, fact=3, fun=mean, na.rm = TRUE)
res(rsDEM30)
length(rsDEM30)# roughly 200 million cells


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




###### data reduction
library(doParallel)




# georegion ####

# creating a new georegion.df by combining the pied and basin df that way when filtering it is all the same data for comparisons.
georegion.df <- rbind.data.frame(pied.df, basin.df)

# nearZero filtering

# removes covariates in which the variance is near 
cl <- makeCluster(detectCores()-1)
registerDoParallel(cl)
zeroVar <- nearZeroVar(georegion.df, foreach = TRUE, allowParallel = TRUE)
stopCluster(cl)

# removing unused items from memory
gc()

# check the zeroVar object
head(zeroVar)
# remove column 97
names(georegion.df)
#removes vertdiststream

# *note integer(0), means that there are no covariates to be removed

# remove covariates with zeroVar
georegion.df <- if(length(zeroVar) > 0){
  georegion.df[, -zeroVar]
} else {
  georegion.df
}

names(georegion.df)


# filtering by correlation

# create correlation matrix
corMat <- cor(georegion.df)

# visually examine the correlation matrix
#corrplot(corMat, method = "circle")

# find high degree of correlation, 
highCorr <- findCorrelation(corMat, cutoff = 0.85)

highCorr

names(georegion.df[,highCorr])
#> names(georegion.df[,highCorr])
#[1] "augcalsed"   "juncalsed"  
#[3] "naipb2"      "marcalsed"  
#[5] "naipb3"      "marmsavi2"  
#[7] "augmsavi2"   "jun7o4"     
#[9] "tcilow"      "mar7o4"     
#[11] "aug7o4"      "slp"        
#[13] "catchslp"    "marndvi"    
#[15] "slopedi"     "junmsavi2"  
#[17] "jun6o2"      "lsfactor"   
#[19] "ctid8"       "augndvi"    
#[21] "trugidx"     "junndvi"    
#[23] "ctidi"       "mar7o6"     
#[25] "margypsic"   "marnatric"  
#[27] "mincrv"      "maxcrv"     
#[29] "stdht"       "aug6o5"     
#[31] "jun7o6"      "jungypsic"  
#[33] "jun6o5"      "junnatric"  
#[35] "aug7o6"      "auggypsic"  
#[37] "upcrv"       "dirinsol10m"
#[39] "dwncrv"      "localupcrv" 
#[41] "mar4o3"      "localdwncrv"
#[43] "tpi"         "localcrv"   
#[45] "mar5o6" 



# remove covariates with high degree of correlation
georegion.df <- if(length(highCorr) > 0){
  georegion.df[, -highCorr]
} else {
  georegion.df
}


#iPCA function, returns the names of covariates to keep
iPCA <- function(df, thresh = 95, ...){
  repeat{
    # create progress bar
    pb <- txtProgressBar(min = 0, max = 100, style = 3)
    # run pca on dataframe, can pass center and scale values
    pca.df <- prcomp(df, ...)
    sdev <- pca.df$sdev # extract the std dev
    evector <- pca.df$rotation # extract the eigen vectors
    evalue.df <- get_eigenvalue(pca.df) # extracts the eigenvalues and cumulative variance using the facto extra package
    evalue <- evalue.df$eigenvalue
    cum.var <- evalue.df$cumulative.variance.percent
    loadings <- as.data.frame((evector*evalue)/(sdev)) # calculate loadings per Jensen
    loadings$lf <- rowSums(abs(loadings))
    loadings <- loadings[order(-loadings$lf), ]
    loadings$cumVar <- cum.var
    idealthresh = thresh + 1
    score <- sum(tail(cum.var, 2))
    if(score >= (idealthresh + 100)){
      remove <- which(loadings$cumVar >= idealthresh)
      tokeep <- row.names(loadings[-c(remove),])
      df <- subset(df, select = tokeep)
      # progress bar for each iteration
      for(i in 1:100){
        Sys.sleep(0.1)
        # update progress bar
        setTxtProgressBar(pb, i)
      }
      close(pb)
    } 
    else if (score <= idealthresh + 100) break
  }
  return(df)
}
names(georegion.df)
[1] "aspect"       "aspectdi"     "aug4o3"       "aug4o7"      
[5] "aug5o6"       "aug6o2"       "aug6o7"       "augnatric"   
[9] "augsavi"      "catcharea"    "convexity"    "convidx"     
[13] "convidxsr"    "crvclass"     "ctimfd"       "dianheat"    
[17] "difinsol10m"  "flowcon"      "flowdir"      "flowpathlen" 
[21] "flowwidth"    "jun4o3"       "jun4o7"       "jun5o6"      
[25] "jun6o7"       "junsavi"      "longcrv"      "mar4o7"      
[29] "mar6o2"       "mar6o5"       "mar6o7"       "marsavi"     
[33] "midslppos"    "modcatcharea" "mrrtf"        "mrvbf"       
[37] "naipb1"       "normht"       "plancrv"      "profcrv"     
[41] "proidx"       "relslppos"    "sagawi"       "slpht"       
[45] "slplen"       "slplimflacc"  "spi"          "surfacearea" 
[49] "totinsol10m"  "upheightdi"   "valleydepth"  "xseccrv" 



# The iPCA function 
georegion.df <- iPCA(georegion.df, thresh = 95, center = T, scale = T)

names(georegion.df)
> names(georegion.df)
[1] "aug4o3" "aug4o7" "aug6o2"



# piedmont ####
# nearZero filtering


cl <- makeCluster(detectCores()-1) 
registerDoParallel(cl)
zeroVar <- nearZeroVar(pied.df, foreach = TRUE, allowParallel = TRUE)
stopCluster(cl)

# removing unused items from memory
gc()

# check the zeroVar object
head(zeroVar)

# same one 97 vert dist to stream

# *note integer(0), means that there are no covariates to be removed

# remove covariates with zeroVar
pied.df <- if(length(zeroVar) > 0){
  pied.df[, -zeroVar]
} else {
  pied.df
}


# filtering by correlation
# a correlation matrix is determined and covariates with high degree of correlation are returned

# create correlation matrix
corMat <- cor(pied.df)

# visually examine the correlation matrix
#corrplot(corMat, method = "circle")

# find high degree of correlation, cutoff is the threshold to set. If cutoff = 0.75 then covariates that are >= 75% correlated are removed
highCorr <- findCorrelation(corMat, cutoff = 0.85)

#check which covariates will be removed
names(pied.df[,highCorr])
names(pied.df[,highCorr])
[1] "augcalsed"   "juncalsed"   "marcalsed"   "naipb2"     
[5] "tcilow"      "marmsavi2"   "augmsavi2"   "naipb3"     
[9] "slp"         "catchslp"    "slopedi"     "marndvi"    
[13] "junmsavi2"   "lsfactor"    "jun7o4"      "aug7o4"     
[17] "mar7o4"      "ctid8"       "augndvi"     "jun6o2"     
[21] "trugidx"     "mar7o6"      "margypsic"   "junndvi"    
[25] "ctidi"       "marnatric"   "mincrv"      "maxcrv"     
[29] "jun7o6"      "jungypsic"   "aug6o5"      "aug7o6"     
[33] "jun6o5"      "auggypsic"   "dirinsol10m" "upcrv"      
[37] "dwncrv"      "localupcrv"  "localdwncrv" "tpi"        
[41] "localcrv"    "jun4o3"      "jun5o6"      "mar5o6"     

# remove covariates with high degree of correlation
pied.df <- if(length(highCorr) > 0){
  pied.df[, -highCorr]
} else {
  pied.df
}



# The iPCA function 
pied.df <- iPCA(pied.df, thresh = 95, center = T, scale = T)
> names(pied.df)
[1] "aug4o3" "aug4o7" "aug6o2"





# basin ####
# nearZero filtering

# 
cl <- makeCluster(detectCores()-1) 
registerDoParallel(cl)
zeroVar <- nearZeroVar(basin.df, foreach = TRUE, allowParallel = TRUE)
stopCluster(cl)

# removing unused items from memory
gc()

# check the zeroVar object
head(zeroVar)

# *note integer(0), means that there are no covariates to be removed

# same one again

# remove covariates with zeroVar
basin.df <- if(length(zeroVar) > 0){
  basin.df[, -zeroVar]
} else {
  basin.df
}


# filtering by correlation
# a correlation matrix is determined and covariates with high degree of correlation are returned

# create correlation matrix
corMat <- cor(basin.df)

# visually examine the correlation matrix
#corrplot(corMat, method = "circle")

# find high degree of correlation, cutoff is the threshold to set. If cutoff = 0.75 then covariates that are >= 75% correlated are removed
highCorr <- findCorrelation(corMat, cutoff = 0.85)

names(basin.df[,highCorr])
> names(basin.df[,highCorr])
[1] "augcalsed"   "juncalsed"   "naipb3"      "naipb2"     
[5] "marcalsed"   "jun7o4"      "mar7o4"      "augmsavi2"  
[9] "marmsavi2"   "aug7o4"      "jun6o2"      "tcilow"     
[13] "marndvi"     "junmsavi2"   "slp"         "catchslp"   
[17] "slopedi"     "ctid8"       "augndvi"     "lsfactor"   
[21] "junsavi"     "mar6o5"      "ctidi"       "trugidx"    
[25] "mar7o6"      "jun6o5"      "margypsic"   "aug6o5"     
[29] "mincrv"      "stdht"       "maxcrv"      "aug7o6"     
[33] "jun7o6"      "jungypsic"   "auggypsic"   "upcrv"      
[37] "dwncrv"      "dirinsol10m" "localupcrv"  "localdwncrv"
[41] "tpi"         "localcrv"    "mar4o7"      "jun4o3" 


# remove covariates with high degree of correlation
basin.df <- if(length(highCorr) > 0){
  basin.df[, -highCorr]
} else {
  basin.df
}


#iPCA function, returns the names of covariates to keep


# The iPCA function 
basin.df <- iPCA(basin.df, thresh = 95, center = T, scale = T)



names(basin.df)
> names(basin.df)
[1] "aug4o3"    "augnatric" "aug4o7"    "aug6o2" 


# not much seperation maybe my buffers were to big?