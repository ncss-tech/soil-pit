#
#
#    Covariate Reduction Methods 03/28/2018
#
# This method is currently being developed by Dave White, Soil Scientist, USDA-NRCS
# For questions or comments please contact Dave at : david.white@nm.usda.gov
#
#
#
# Covariate reduction using near zero variance, correlation reduction, and iterative principal
# component analysis.
# 
# Introduction: There are numerous types and ways to create environmental covariates (rasters) to 
# use in predictive soil modeling. A lot of times, the more covariates you have the better the 
# outcome will be. However, some covariates may not provide very much information, or you may
# have limited computer resources to process large raster stacks. This script is a work in progress
# utilizing some very well known techniques to reduce the number of covariates you have to work with.
# the idea is to maximize the amount of information while maintaining a minimum dataset. Some covariates
# are redundant, some don't add much to describing the variance of the overall population.
# 
# 1. near zero variance filtering
#     finds which covariates have variance near or equal to 0 and removes them
#     *there are other parameters which may be implemented in the future
# 2. correlation reduction
#     finds covariates that have a high degree of correlation and removes them
# 3. iterative principal component analysis
#     
#     iterative principal component analysis utilizes pca to select covariates that account for the 
#     majority of a populations variance.
#     The function below is working, but not on an iterative level, you can rerun the function up to one 
#     more time to further reduce the covariates. Future updates with have the function iterate automatically
#     until the threshold is reached.
#
#     for more information on iPCA see: 
#     Matthew R. Levi, Craig Rasmussen, Covariate selection with iterative principal component analysis for   predicting physical soil properties,Geoderma,Volumes 219–220, 2014,Pages 46-57,ISSN 0016-7061,https://doi.org/10.1016/j.geoderma.2013.12.013.(http://www.sciencedirect.com/science/article/pii/S0016706113004412)
#     and
#     J.R. Jensen, Introductory Digital Image Processing: A Remote Sensing Perspective, (3rd. ed.), Prentice Hall, Upper Saddle River, NJ (2005)
#




# load libraries
library(raster)
library(caret)
library(corrplot)
library(psych)
library(amap)
library(doParallel)
library(dplyr)
library(foreach)



# Load Raster Data
setwd("E:/Animas_Valley_Playa/AVP_Modeling_04102017/covariates/clipWhole/")


r.convexity <- raster("convexity.tif")
r.convidx <- raster("convidx.tif")
r.cti <- raster("ctid8.tif")
r.dwncrv <- raster("dwncrv.tif")
r.localcrv. <- raster("localcrv.tif")
r.localdwncrv <- raster("localdwncrv.tif")
r.localupcrv <- raster("localupcrv.tif")
r.longcrv <- raster("longcrv.tif")
r.maxcrv <- raster("maxcrv.tif")
r.maxht <- raster("maxht.tif")
r.midslppos <- raster("midslppos.tif")
r.mincrv <- raster("mincrv.tif")
r.mrrtf <- raster("mrrtf.tif")
r.mrvbf <- raster("mrvbf.tif")
r.plancrv <- raster("plancrv.tif")
r.profcrv <- raster("profcrv.tif")
r.proidx <- raster("proidx.tif")
r.relslppos <- raster("relslppos.tif")
r.ridgelevel <- raster("ridgelevel.tif")
r.sagawi <- raster("sagawi.tif")
r.spi <- raster("spi.tif")
r.stdht <- raster("stdht.tif")
r.tpi <- raster("tpi.tif")
r.trugidx <- raster("trugidx.tif")
r.upcrv <- raster("upcrv.tif")
r.upheightdi <- raster("upheightdi.tif")
r.valleydepth <- raster("valleydepth.tif")
r.vertdiststream <- raster("vertdiststream.tif")
r.vrm <- raster("vrm.tif")
r.xseccrv<- raster("xseccrv.tif")
r.augmsavi2 <- raster("augmsavi2.tif")
r.jun4o3 <- raster("jun4o3.tif")
r.jun4o7 <- raster("jun4o7.tif")
r.jun5o6 <- raster("jun5o6.tif")
r.jun6o2 <- raster("jun6o2.tif")
r.jun6o5 <- raster("jun6o5.tif")
r.jun6o7 <- raster("jun6o7.tif")
r.jun7o6 <- raster("jun7o6.tif")
r.juncalsed <- raster("juncalsed.tif")
r.jungypsic <- raster("jungypsic.tif")
r.junmsavi2 <- raster("junmsavi2.tif")
r.junnatric <- raster("junnatric.tif")
r.marmsavi2 <- raster("marmsavi2.tif")
r.naipb1 <- raster("naipb1.tif")
r.naipb2 <- raster("naipb2.tif")
r.naipb3 <- raster("naipb3.tif")



# Create a raster stack of all covariates
r.stack <- stack(r.convexity, r.convidx, r.cti, r.dwncrv, r.localcrv., r.localdwncrv, r.localupcrv, 
                 r.longcrv, r.maxcrv, r.maxht, r.midslppos, r.mincrv, r.mrrtf, r.mrvbf, r.plancrv, 
                 r.profcrv, r.proidx, r.relslppos, r.ridgelevel, r.sagawi, r.spi, r.stdht, r.tpi, 
                 r.trugidx, r.upcrv, r.upheightdi, r.valleydepth, r.vertdiststream, r.vrm, r.xseccrv, 
                 r.augmsavi2, r.jun4o3, r.jun4o7, r.jun5o6, r.jun6o2, r.jun6o5, r.jun6o7, r.jun7o6, 
                 r.juncalsed, r.jungypsic, r.junmsavi2, r.junnatric, r.marmsavi2, r.naipb1, r.naipb2, 
                 r.naipb3)

# remove all rasters from the environment but keep the raster stack
to.remove <- ls()
to.remove <- c(to.remove[!grepl("r.stack", to.remove)], "to.remove")
rm(list=to.remove)

# create data frame from raster stack
stack.df <- as.data.frame(r.stack, na.rm = TRUE)

# removing unused items from memory
gc()

# nearZero filtering
# removes covariates whose variance is near or equal to zero
# this process is parallelized to enable faster processing
# caution this process eats up a lot of memory, if you have very large datasets thing about
# using this process at the end
cl <- makeCluster(detectCores()-1) # makes a cluster using all but 1 cpu cores
registerDoParallel(cl)
# the actual zeroVar function, creates a vector containing which covariates should be removed
zeroVar <- nearZeroVar(stack.df, foreach = TRUE, allowParallel = TRUE)
stopCluster(cl)

# removing unused items from memory
gc()

# check the zeroVar object
head(zeroVar)

# *note integer(0), means that there are no covariates to be removed

# remove covariates with zeroVar
stack.df <- if(length(zeroVar) > 0){
  stack.df[, -zeroVar]
} else {
  stack.df
}

    
# filtering by correlation
# a correlation matrix is determined and covariates with high degree of correlation are returned

# create correlation matrix
cor.mat <- cor(stack.df)

# visually examin the correlation matrix
corrplot(cor.mat)

# find high degree of correlation, cutoff is the threshold to set. If cutoff = 0.8 then covariates
# > or = 80 correlated are removed
highCorr <- findCorrelation(cor.mat, cutoff = 0.75)

# remove covariates with high degree of correlation
stack.df <- if(length(highCorr) > 0){
  stack.df[, -highCorr]
} else {
  stack.df
}

    
    
    
#iPCA function, returns the names of covariates to keep
iPCA <- function(stack.df){
  # creates a correlation matrix
  cor.mat <- cor(stack.df)
  
  # runs the principal component analysis
  trans <- pca(cor.mat, center = TRUE, reduce = TRUE)
  
  # obtain the eigan vectors
  evectors <- trans$loadings
  
  # for use converting rows to a matrix for calculations
  len <- length(stack.df)
  
  # obtain the eigan values
  evalue <- trans$eig
  evalues <- matrix((trans$eig), nrow = len, ncol = len, byrow = TRUE)
  
  # obtain the stdev
  sdev <- matrix((trans$sdev), nrow = len, ncol = len, byrow = TRUE)
  
  # compute loading factors and convert to a data frame
  lf <- as.data.frame(abs((evectors*(sqrt(evalues)))/(sdev)))
  
  # add column and sum up the loading factors
  lf$loadings <- rowSums(lf[, c(1:len)])
  
  # sort by loadings
  lf <- lf[order(-lf$loadings), ]
  
  # sort by loadings
  lf <- lf[order(-lf$loadings), ]
  
  # now we need to determine which covariates to drop
  esum <- sum(evalue)
  len <- length(evalue)
  cum.var <- matrix(evalue, nrow = len, byrow = TRUE)
  cum.var <- as.data.frame.matrix(cum.var)
  esum <- rep(esum, len)
  cum.var$esum <- esum
  cum.var$var <- cum.var$V1 / cum.var$esum
  cum.var$cumvar <- cumsum(cum.var$var)
  
  cum.var.len <- nrow(cum.var) # starting number of covariates
  pc.len <- nrow(filter(cum.var, cumvar <= .95)) #number of covariates to keep
  
  # narrowing down the list
  lf.subset <- lf[1:pc.len, ]
  
  stack.names <- rownames(lf.subset)
  
  
  stack.df <- (stack.df[,c(stack.names)])
  return(stack.df)
  
}    

# run the function on some data
stack.df.2 <- iPCA(stack.df)

# run the function again
stack.df.3 <- iPCA(stack.df.2)
    

#  stk.names <- DataReduction(r.stack = r.stack, polypeds = polypeds, cutoff = cutoff)

# subset r.stack to crate a new raster stack of reduced covariates for use in other applications
r.stk.2 <- subset(r.stack, names(stack.df.3))

# view names
names(r.stk.2)
  


  
 