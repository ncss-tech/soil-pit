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


# The following is the step by step walk through of iPCA.

# load and install required packages ####
required.packages <- c("raster", "sp", "rgdal", "factoextra")
new.packages <- required.packages[!(required.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(required.packages, require, character.only=T)
rm(required.packages, new.packages)



# Load Raster Data
setwd("C:/DSM/test_cov")

# read raster layer names to create raster stack
r.list=list.files(getwd(), pattern="tif$", full.names = FALSE)
r.list

#create raster stack of covariates
r.stack <- stack(r.list)
names(r.stack)

# for the following data reduction technique it is necessary to convert the raster stack into a data frame. This may cause problems with large raster stacks. my recommendation is to subset the raster stack by creating a regular sample of points. 
# If you need to create a regular sample due to a large set of covariates, that could be completed as follows:
#df.sR <- na.omit(as.data.frame(sampleRegular(r.stack, na.rm=T, xy=F, size = (length(r.stack$gnp_clay_index57)/2))))
#
# Another method is to run through the iPCA on the DEM derived covariates. Then run through the process on Spectral derived covariates. Finally combine the two reduced DEM and Spectral covariates into one data frame and run the iPCA process one last time.

df <- na.omit(as.data.frame(r.stack, na.rm=T, xy=F))


##########################################################################

# iterative principal component analysis - iPCA reduction, the step by step process

thresh = 95 # amount of variance to capture in %


# Run the principal component analysis

#First PCA####
#
pca.df <- prcomp(df, center = T, scale = T)

sdev <- pca.df$sdev
evector <- pca.df$rotation
evector
evalue.df <- get_eigenvalue(pca.df)
evalue <- evalue.df$eigenvalue
cum.var <- evalue.df$cumulative.variance.percent

loadings <- as.data.frame((evector*evalue) / (sdev)) # calculate loadings from Jensen

loadings$lf <- rowSums(abs(loadings))# sum up the absolute value of the loadings for the loading factors

# sort by loadings factors
loadings <- loadings[order(-loadings$lf), ]

# add cumulative variance to loadings
loadings$cumVar <- cum.var
loadings

#add covariate names to loadings
loadings$covNames <- rownames(loadings)
loadings
print(loadings[, c("covNames","cumVar")])

# figure out how many PCs capture ~(thresh)% of variance

# the threshold is the amount of variance that we want to capture, in this example it is set to 95 so the idea is that we have to select the covariates that capture a cumulative variance equal to but no less than our threshold.             
idealthresh = thresh+1
remove <- which(loadings$cumVar > idealthresh)

loadingsReduced <- loadings[-c(remove:(length(loadings))),]

tokeep <- rownames(loadingsReduced)

df2 <- subset(df, select=tokeep)

df.original <- df


##Second PCA####
# run through the pca again
df <- df2
pca.df <- prcomp(df, center = T, scale = T)
#summary(pca.df)

sdev <- pca.df$sdev
evector <- pca.df$rotation
evector
evalue.df <- get_eigenvalue(pca.df)
evalue <- evalue.df$eigenvalue
cum.var <- evalue.df$cumulative.variance.percent

loadings <- as.data.frame((evector*evalue) / (sdev)) # calculate loadings from Jensen

loadings$lf <- rowSums(abs(loadings))# sum up the absolute value of the loadings for the loading factors

# sort by loadings factors
loadings <- loadings[order(-loadings$lf), ]

# add cumulative variance to loadings
loadings$cumVar <- cum.var
loadings

#add covariate names to loadings
loadings$covNames <- rownames(loadings)
loadings
print(loadings[, c("covNames","cumVar")])

# figure out how many PCs capture ~(thresh)% of variance

# the threshold is the amount of variance that we want to capture, in this example it is set to 95 so the idea is that we have to select the covariates that capture a cumulative variance equal to but no less than our threshold.             
idealthresh = thresh+1
remove <- which(loadings$cumVar > idealthresh)

loadingsReduced <- loadings[-c(remove:(length(loadings))),]

tokeep <- rownames(loadingsReduced)

df2 <- subset(df, select=tokeep)



#Third PCA####
# run through the pca again
df <- df2
pca.df <- prcomp(df, center = T, scale = T)
#summary(pca.df)

sdev <- pca.df$sdev
evector <- pca.df$rotation
evector
evalue.df <- get_eigenvalue(pca.df)
evalue <- evalue.df$eigenvalue
cum.var <- evalue.df$cumulative.variance.percent

loadings <- as.data.frame((evector*evalue) / (sdev)) # calculate loadings from Jensen

loadings$lf <- rowSums(abs(loadings))# sum up the absolute value of the loadings for the loading factors

# sort by loadings factors
loadings <- loadings[order(-loadings$lf), ]

# add cumulative variance to loadings
loadings$cumVar <- cum.var
loadings

#add covariate names to loadings
loadings$covNames <- rownames(loadings)
loadings
print(loadings[, c("covNames","cumVar")])

# figure out how many PCs capture ~(thresh)% of variance

# the threshold is the amount of variance that we want to capture, in this example it is set to 95 so the idea is that we have to select the covariates that capture a cumulative variance equal to but no less than our threshold.             

idealthresh = thresh+1
remove <- which(loadings$cumVar > idealthresh)

loadingsReduced <- loadings[-c(remove:(length(loadings))),]

tokeep <- rownames(loadingsReduced)

df2 <- subset(df, select=tokeep)



#Fourth PCA####
# run through the pca again
df <- df2
pca.df <- prcomp(df, center = T, scale = T)
#summary(pca.df)

sdev <- pca.df$sdev
evector <- pca.df$rotation
evector
evalue.df <- get_eigenvalue(pca.df)
evalue <- evalue.df$eigenvalue
cum.var <- evalue.df$cumulative.variance.percent

loadings <- as.data.frame((evector*evalue) / (sdev)) # calculate loadings from Jensen

loadings$lf <- rowSums(abs(loadings))# sum up the absolute value of the loadings for the loading factors

# sort by loadings factors
loadings <- loadings[order(-loadings$lf), ]

# add cumulative variance to loadings
loadings$cumVar <- cum.var
loadings

#add covariate names to loadings
loadings$covNames <- rownames(loadings)
loadings
print(loadings[, c("covNames","cumVar")])

# stop here because we have reached our threshold

# What you want to see is that the last covariate adds up to 100% of the cumulative variance, and the next to last covariate to be <= your threshold. In the test data I used It was done in 4 iterations. Often the last iteration, is a check to see if you've met your threshold, and no further reduction is done.


#
##################################################################
