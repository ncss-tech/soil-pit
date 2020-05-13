#Covariate Reduction Methods 03/28/2018
#
# These methods are currently being implemented and developed by Dave White, Soil Scientist, USDA-NRCS: david.white@nm.usda.gov
#
#
# Covariate reduction using near zero variance, correlation reduction, and iterative principal component analysis.
# 
# Introduction: There are numerous types and ways to create environmental covariates (rasters) which may lead to an abundance of data. Some of these covariates may not add value to the dataset when model building, or computer resources may be limited.
#
# This script is a work in progress utilizing some very well known techniques to reduce the number of covariates you have to work with, by reducing redundancy an maximizing the variance. The idea is to maximize the amount of information with the smallest data set possible.
 
# 1. near zero variance filtering
# Finds which covariates have variance near or equal to 0 and removes them.
# Note*, there are other parameters which may be implemented in the future.
# From the caret package: https://topepo.github.io/caret/pre-processing.html#zero--and-near-zero-variance-predictors

# 2. correlation reduction
# Finds covariates that have a high degree of correlation and removes them.
# From the caret package:https://topepo.github.io/caret/pre-processing.html#identifying-correlated-predictors

# 3. iterative principal component analysis
# iPCA analysis utilizes pca to select covariates that account for the majority of a population's variance.
# For more information on iPCA see: 
# Matthew R. Levi, Craig Rasmussen, Covariate selection with iterative principal component analysis for predicting physical soil properties, Geoderma, Volumes 219–220, 2014,Pages 46-57,ISSN 0016-7061,https://doi.org/10.1016/j.geoderma.2013.12.013.(http://www.sciencedirect.com/science/article/pii/S0016706113004412)
# and
# J.R. Jensen, Introductory Digital Image Processing: A Remote Sensing Perspective, (3rd. ed.), Prentice Hall, Upper Saddle River, NJ (2005)
#



# load and install required packages ####
required.packages <- c("raster", "caret", "corrplot", "psych", "doParallel", "foreach", "sp", "rgdal", "factoextra")
new.packages <- required.packages[!(required.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(required.packages, require, character.only=T)
rm(required.packages, new.packages)


# Load Raster Data
# set working directory
setwd("C:/DSM/test_cov")

# read in raster layer names
rList=list.files(getwd(), pattern="tif$", full.names = FALSE)
rList

#create raster stack of covariates
rStack <- stack(rList)
names(rStack)

# create a dataframe
# for the following data reduction techniques, it is necessary to convert the raster stack into a data frame. This may cause problems with large raster stacks. my recommendation is to subset the raster stack by creating a regular sample of points. 
# If you need to create a regular sample due to a large set of covariates, that could be completed as follows:
#df <- na.omit(as.data.frame(sampleRegular(rStack, na.rm=T, xy=F, size = (length(rStack$gnp_clay_index57)/2))))

df <- na.omit(as.data.frame(rStack, na.rm=T, xy=F))


# nearZero filtering ####

# removes covariates in which the variance is near or equal to zero this process is parallelized to enable faster processing - caution this process eats up a lot of memory, if you have very large datasets think about using a regular sample of your covariate stack as mentioned above.
cl <- makeCluster(detectCores()-1) # makes a cluster using all but 1 cpu cores
registerDoParallel(cl)
# the actual zeroVar function, creates a vector containing which covariates should be removed
zeroVar <- nearZeroVar(df, foreach = TRUE, allowParallel = TRUE)
stopCluster(cl)

# removing unused items from memory
gc()

# check the zeroVar object
head(zeroVar)

# *note integer(0), means that there are no covariates to be removed

# remove covariates with zeroVar
df <- if(length(zeroVar) > 0){
  df[, -zeroVar]
} else {
  df
}


# filtering by correlation
# a correlation matrix is determined and covariates with high degree of correlation are returned

# create correlation matrix
corMat <- cor(df)

# visually examine the correlation matrix
corrplot(corMat, method = "circle")

# find high degree of correlation, cutoff is the threshold to set. If cutoff = 0.75 then covariates that are >= 75% correlated are removed
highCorr <- findCorrelation(corMat, cutoff = 0.75)

# remove covariates with high degree of correlation
df <- if(length(highCorr) > 0){
  df[, -highCorr]
} else {
  df
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

# The iPCA function 
df <- iPCA(df, thresh = 95, center = T, scale = T)



# subset rStack to crate a new raster stack of reduced covariates for use in other applications
rStackReduced <- subset(rStack, names(df))

# view names
names(rStackReduced)
