# Iterative Principal Component Analysis (iPCA) for covariate data reduction
#
# This method is currently being implemented in R by Dave White, Soil Scientist, USDA-NRCS
#
# For questions or comments please contact Dave at : david.white@nm.usda.gov
#
# Iterative principal component analysis (iPCA)
#     
# iPCA utilizes principal component analysis to narrow down a set of covariates.
#
# For more information on iPCA see: 
#     Matthew R. Levi, Craig Rasmussen, Covariate selection with iterative principal component analysis for   predicting physical soil properties, Geoderma, Volumes 219-220, 2014,Pages 46-57,ISSN 0016-7061,https://doi.org/10.1016/j.geoderma.2013.12.013.(http://www.sciencedirect.com/science/article/pii/S0016706113004412)
#
# and
#
# J.R. Jensen, Introductory Digital Image Processing: A Remote Sensing Perspective, (3rd. ed.), Prentice Hall, Upper Saddle River, NJ (2005)
#


# The following is the iPCA process written as a function that loops through until you reach your selected threshold.

# load and install required packages ####
required.packages <- c("raster", "sp", "rgdal", "factoextra")
new.packages <- required.packages[!(required.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(required.packages, require, character.only=T)
rm(required.packages, new.packages)


# The iPCA process implemented as a function
#----

# Load Raster Data
setwd("C:/DSM/test_cov")

# read in raster layer names
r.list=list.files(getwd(), pattern="tif$", full.names = FALSE)
r.list

#create raster stack of covariates
r.stack <- stack(r.list)
names(r.stack)

# create a dataframe
df <- na.omit(as.data.frame(r.stack, na.rm=T, xy=F))


############## The iPCA function

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
dfReduced <- iPCA(df, thresh = 95, center = T, scale = T)

# Parameters
# df - dataframe of raster values(raster stack converted to a dataframe)
# thresh - threshold of variance to capture. default is 95 
# center, scale - centering and scaling of data, default is T

