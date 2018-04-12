Repository for Dave White's DSM scripts and related tools   

DSM Tools 1.0.zip   
An ArcGIS toolbox containing common tools used during preprocessing of raster data. Included are quite a few batch processes that work by adding the input and output folders for your raster layers.
   
Random Forest Model   
r script utilizing the caret package to run Random Forest. This script utilizes parallel processing to speed up calculations

Underactive development - Still need to finish code for producing probability maps, and some of the code for utilizing RF output to ArcSIE   

cLHS   
A tutorial providing several methods for implementing cLHS.

http://ncss-tech.github.io/soil-pit/sandbox/dave/clhs.html

Will be updating soon to include a section on how to use the Gower's similarity index, developed by Colby Brungard to select replacement points.   

CovariateReduction_v0.1.R   
Several functions to reduce the number of covariates by statistical means. 
Correlation reduction - Creates a correlation matrix and then removes highly correlated covariates.
Near Zero Variance - Calculates the variance of each covariate and removes the ones that are at or near zero.
Iterative Principal Component Analisys (iPCA) - Method of iterating through PCAs to reduce the number of covariates down to the ones that account for the majority of the overall population variance.   

polypedon_points_v0.3.R   
A method I developed to generate model training points based on the concept of the polypedon.





