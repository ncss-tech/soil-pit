#-----------------------------------------------------------------------------------------------------------------
#
#   Predictive Soil Modeling 05/31/2015
#
#   There are many ways to accomplish the tasks in this script. Below is the method that I have been working on.
#   Feel free to use and modify the code below. If there are any questions, or if you have ideas
#   for improvement contact david.white@nm.usda.gov.
#
#-----------------------------------------------------------------------------------------------------------------

# load libraries
library(caret)
library(corrplot)
library(psych)
library(ggplot2)
library(car)
#library(Boruta)
library(maptools)
library(rgdal)
library(doParallel)
#library(clhs)
library(raster)
#-----------------------------------------------------------------------------------------------------------------


##### 

# 1.0 PrePocessing covariates
# Load Raster Data

# set working directory for the basin covariates
setwd("E:/PSSAT_Random_Forest/StraddlebugMtGIS/tif/")

r.asr1m.tif <- raster("asr1m.tif")
r.asr500k.tif <- raster("asr500k.tif")
r.ass1m.tif <- raster("ass1m.tif")
r.avr1m.tif <- raster("avr1m.tif")
r.avr500k.tif <- raster("avr500k.tif")
r.avs1m.tif <- raster("avs1m.tif")
r.avs500k.tif <- raster("avs500k.tif")
r.cti.tif <- raster("cti.tif")
r.lnaip_visb.tif <- raster("lnaip_visb.tif")
r.ls8_carb_b4b3.tif <- raster("ls8_carb_b4b3.tif")
r.ls8_ferr_b6b5.tif <- raster("ls8_ferr_b6b5.tif")
r.ls8_iron_b4b7.tif <- raster("ls8_iron_b4b7.tif")
r.ls8_rock_b6b3.tif <- raster("ls8_rock_b6b3.tif")
r.ls8_swir_b6b7.tif <- raster("ls8_swir_b6b7.tif")
r.massbalance.tif <- raster("massbalance.tif")
r.mrrtf.tif <- raster("mrrtf.tif")
r.mrvbf.tif <- raster("mrvbf.tif")
r.naip_nir.tif <- raster("naip_nir.tif")
r.naip_visg.tif <- raster("naip_visg.tif")
r.naip_visr.tif <- raster("naip_visr.tif")
r.ndgi_naip.tif <- raster("ndgi_naip.tif")
r.ndvi_naip.tif <- raster("ndvi_naip.tif")
r.relief.tif <- raster("relief.tif")
r.saga_solar.tif <- raster("saga_solar.tif")
r.saga_wet.tif <- raster("saga_wet.tif")
r.si_b1b3_naip.tif <- raster("si_b1b3_naip.tif")
r.slp.tif <- raster("slp.tif")
r.spi.tif <- raster("spi.tif")
r.std_slp_ht.tif <- raster("std_slp_ht.tif")



# 1.2 Create a raster Stack

r.stack.all <- stack(r.asr1m.tif, r.asr500k.tif, r.ass1m.tif, r.avr1m.tif, r.avr500k.tif, r.avs1m.tif, 
                     r.avs500k.tif, r.cti.tif, r.lnaip_visb.tif, r.ls8_carb_b4b3.tif, r.ls8_ferr_b6b5.tif, 
                     r.ls8_iron_b4b7.tif, r.ls8_rock_b6b3.tif, r.ls8_swir_b6b7.tif, r.massbalance.tif, 
                     r.mrrtf.tif, r.mrvbf.tif, r.naip_nir.tif, r.naip_visg.tif, r.naip_visr.tif, r.ndgi_naip.tif, 
                     r.ndvi_naip.tif, r.relief.tif, r.saga_solar.tif, r.saga_wet.tif, r.si_b1b3_naip.tif, 
                     r.slp.tif, r.spi.tif, r.std_slp_ht.tif)
  

#-----------------------------------------------------------------------------------------------------------------
# 2.0 Covariate preprocessing
#

# 2.1 checking NA values to make sure every raster has the same number, this is an important step for the script... if the NA values
# are differnt amongst the covariates there will be problems producing raster outputs at the end

summary(r.stack.all)

## there are 53737 NA values for every covariate, okay to proceed


# 2.2 Convert to a data frame and remove NA's

# Convert to spatial pixels data frame to maintain spatial information
stack.spdf <- as(r.stack.all, "SpatialPixelsDataFrame")

# convert to data frame, xy is true here to keep spatial information incase needed in the future...
stack.df.all <- as.data.frame(stack.spdf, xy=TRUE, na.rm=TRUE)

# removing xy
stack.df <- within(stack.df.all, rm(x,y))


# 2.3 Near Zero filtering - this section checks covariates that have a variance near zero and removes them. 
# It can take some time to run this depending on the size of your data set.

# Find covariates with near zero variance and save them to zerovar.
zerovar <- nearZeroVar(stack.df)

# check zerovar
head(zerovar)
length(zerovar)

# If there are covariates with zero variance remove them
if(length(zerovar) > 0){
  stack.df <- stack.df[, -zerovar]
}


# 2.4 Filtering covariates by correlation.
# High degree of correlation between covariates is determined, then the function returns column
# numbers denoting the covariates that are recomended for deleation.

# generate a correlation matirx
stack.corr <- cor(stack.df)

# visually examin the correlation structure
corrplot(stack.corr)

# Filtering by correlations
# The cutoff value is arbitrarily set anything with a correlation higher than .85 will be removed, you can change this value to 
# anything you want, the lower the value the more covariates that will be removed

stack.highCorr <- findCorrelation(stack.corr, cutoff = .85) 

# check to see if any are correlated
head(stack.highCorr)
#colnames(stack.df[, (13,6,19,26,9,27)])

# filter to remove covariates

stack.df <- stack.df[, -stack.highCorr]

colnames(stack.df)
# this is the output from the console, these covariates will be used in the raster stack below
#> colnames(stack.df)
#[1] "asr1m"         "asr500k"       "ass1m"         "avr1m"         "avs500k"       "cti"           "ls8_carb_b4b3"
#[8] "ls8_ferr_b6b5" "ls8_iron_b4b7" "ls8_swir_b6b7" "massbalance"   "mrrtf"         "mrvbf"         "naip_nir"     
#[15] "naip_visr"     "ndgi_naip"     "ndvi_naip"     "relief"        "saga_solar"    "saga_wet"      "spi"          
#[22] "std_slp_ht" 

# 2.5 crate a new raster stack


r.stack.filtered <- stack(r.asr1m.tif, r.asr500k.tif, r.ass1m.tif, r.avr1m.tif, r.avs500k.tif, r.cti.tif, r.ls8_carb_b4b3.tif, r.ls8_ferr_b6b5.tif, 
                          r.ls8_iron_b4b7.tif, r.ls8_swir_b6b7.tif, r.massbalance.tif, r.mrrtf.tif, r.mrvbf.tif, r.naip_nir.tif, r.naip_visr.tif, 
                          r.ndgi_naip.tif, r.ndvi_naip.tif, r.relief.tif, r.saga_solar.tif, r.saga_wet.tif, r.spi.tif, r.std_slp_ht.tif)


#-----------------------------------------------------------------------------------------------------------------
# 3.0 Build model training data set


# 3.1 set working directory for points
setwd("E:/PSSAT_Random_Forest/StraddlebugMtGIS/")

# 3.2 Bring in points shapefile. This shapefile needs to contain a column with the
# heading of "Class"
comp <- readShapePoints("Pedons.shp") 

# 3.2.1 inspect comp
str(comp)
describe(comp@data)
plot(comp)


# 3.3 Extract values from r.stack.all and set up a new dataframe
all.df <- extract(r.stack.filtered, comp, df=T, na.rm=TRUE)   

# 3.3.1 Inspect dataframe
head(all.df)
names(all.df)
describe(all.df)
summary(all.df)

# 3.4 Add component information to the dataframe
###
all.df$Class <- comp@data$Class

#3.4.1 Inspect dataframe
head(all.df)
names(all.df)


# 3.5 Prepare data for feature selection and model training

# 3.5.1 Drop column ID, and Move colum Class to front
# 3.5.1.1 get number of colums from dataframe
length(all.df)

# 3.5.1.2 output from above
#> length(all.df)
#[1] 24

# 3.5.2 Dropping column ID. use the length from above for the first number, subtract 1 for the second
comp1 <- cbind(all.df[ ,24], data.frame(all.df[ ,2:23]))
 
# 3.5.2.1 inspect comp1
names(comp1)

# 3.5.3 add Class as the first column
names(comp1)[c(1)] <- c('Class')

# 3.5.3.1 Inspect comp1, Class should be the first column, followed by the 43 covariates
names(comp1)
describe(comp1)   
summary(comp1)



#-----------------------------------------------------------------------------------------------------------------
# 4.0 Recursive Feature Selection (RFE)
# 
#  If data include levels that have only 1 cases,  it does not work... 
#  Gives  Error in { : task 3 failed - "Can't have empty classes in y."

# 4.1.1 #  ###  Select levels that have more than 1 cases to proceed with the rfe 
# Select components that have > 1 cases
subset(table(comp1$Class), table(comp1$Class) > 1)


names(subset(table(comp1$Class), table(comp1$Class) > 1))



# 4.1.2 Use this to get names of factors that have more than one case
cat(paste(shQuote(names(subset(table(comp1$Class), table(comp1$Class) > 1)), type="cmd"), collapse=", "))


# 4.1.3 manually paste the result here and add the 'c(' and the ')' to bookend the list
# manually paste the new list here for subsetting the dataframe
comp.sub <- subset(comp1, Class %in% c("Beewon", "Beewon2", "Musgrave", "Musgrave2", "Quadria", "Quadria2", "Quadriasaline"))

nrow(comp.sub)



# 4.1.4 CRITICAL STEP! You must assign the new subset as a factor for this to work

comp.sub$Class <- factor(comp.sub$Class)




# 4.2 Run Recursive Feature Eliminataion. This selects the covariates that will build the best RF model

# This process is setup to run as a parallel process. Set you number of cpu cores
# in the make cluster function. This example uses detect cores to use all available. To set
# the number of cores just type the number in place of detect cores(). Next, change the subsets
# to match the number of covariates that you have. In this case we had 24. 


#The simulation will fit models with subset sizes of 24, 23, 22.....1 
subsets <- c(1:24)

# set seeds to get reporducable results when running the process in parallel
set.seed(12)
seeds <- vector(mode = "list", length=51)
for(i in 1:50) seeds[[i]] <- sample.int(1000, length(subsets) + 1)
seeds[[51]] <- sample.int(1000, 1)


# set up the rfe control
ctrl.RFE <- rfeControl(functions = rfFuncs,
                       method = "repeatedcv",
                       number = 10,
                       repeats = 5,
                       seeds = seeds, 
                       verbose = FALSE)

## highlight and run everything from c1 to stopCluster(c1) to run RFE
 
c1 <- makeCluster(detectCores(), type='PSOCK')
registerDoParallel(c1)
set.seed(9)
rf.RFE <- rfe(x = comp.sub[,-1],
              y = comp.sub$Class,
              sizes = subsets,
              rfeControl = ctrl.RFE,
              allowParallel = TRUE
)
stopCluster(c1)              



# 4.3  Look at the results
rf.RFE
plot(rf.RFE) # default plot is for Accuracy, but it can also be changed to Kappa
plot(rf.RFE, metric="Kappa", main='RFE Kappa')
plot(rf.RFE, metric="Accuracy", main='RFE Accuracy')

# 4.4 See list of predictors
predictors(rf.RFE)


# 4.5 Variables selected using RFE, put into a formula for easy modelling later. 
head(comp.sub[,c("Class",predictors(rf.RFE))])
RFE.train.all <- (comp.sub[,c("Class",predictors(rf.RFE))])


# 4.6 Setting up New Data raster stack of entire basin using only those rasters from rfe
# 4.6.1 get list of covariates from rfe
predictors(rf.RFE)

# 4.6.1.1 output from above
#> predictors(rf.RFE)
#[1] "mrvbf"      "std_slp_ht" "saga_solar" "mrrtf"      "saga_wet"   "asr500k"    "ass1m"      "avs500k"    "avr1m"      "relief" 

# 4.6.2 create new raster stack to for model development from the predictors above
r.stack.model <- stack(r.mrvbf.tif, r.std_slp_ht.tif, r.saga_solar.tif, r.mrrtf.tif, r.saga_wet.tif, r.asr500k.tif, r.ass1m.tif, 
                       r.avs500k.tif, r.avr1m.tif, r.relief.tif)



# 4.6.3 convert to spatial pixels dataframe for use later
stack.model.spdf <- as(r.stack.model, "SpatialPixelsDataFrame")

# convert to dataframe maintain xy to convert back to raster later, but remove NA's
stack.model.df <- as.data.frame(stack.model.spdf, xy = TRUE, na.rm=TRUE)



#-----------------------------------------------------------------------------------------------------------------

# 5.0 MODEL TRAINING


# set seeds to get reporducable results when running the process in parallel
set.seed(12)
seeds <- vector(mode = "list", length=51)
for(i in 1:50) seeds[[i]] <- sample.int(1000, length(subsets) + 1)
seeds[[51]] <- sample.int(1000, 1)

# set up the train control
fitControl <- trainControl(method = "repeatedcv", 
                           number = 10,
                           repeats = 5,
                           p = 0.7, #30% used for test set, 70% used for training set
                           selectionFunction = 'best', 
                           classProbs = T,
                           savePredictions = T, 
                           returnResamp = 'final',
                           search = "random",
                           seeds = seeds)


# 5.1  Random Forest - Parallel process, highlight and run from c1 to stopCluster(c1)
c1 <- makeCluster(detectCores(), type='PSOCK')
registerDoParallel(c1)
set.seed(48)
rfFit = train(Class ~ ., data = RFE.train.all,
              "rf", 
              trControl = fitControl, 
              ntree = 500, #number of trees default is 500, which seems to work best anyway. 
              tuneLength=10, 
              metric = 'Kappa', 
              na.action=na.pass)
stopCluster(c1)


# 5.1.2 Inspect rfFit
rfFit

# Get print out of final model
rfFit$finalModel

# Extract confusion matrix and inspect
confusion.mat <- as.data.frame(rfFit$finalModel$confusion)

confusion.mat

# save confusion matrix as tab delimited txt file to import into excel
#set working directory on where to save raster layer

setwd("E:/PSSAT_Random_Forest/StraddlebugMtGIS/ModelOutputs/")

write.table(confusion.mat, "basinconfusion_matrix.txt", sep = "\t")


#checking out stats of final model
confusionMatrix(data=rfFit$finalModel$predicted, 
                reference=rfFit$finalModel$y,
                positive = 'yes')


# Create plot of variable importance
varImpPlot(rfFit$finalModel, main = "RF Variable Importance")

#plot model
plot(rfFit)

# plot final model
plot(rfFit$finalModel)



#-----------------------------------------------------------------------------------------------------
# 6.0 Predict Classes using the Random Forest Model


#6.1 predict

r.stack.model.spdf <- as(r.stack.model, "SpatialPixelsDataFrame")

pred.comp <- predict(rfFit, newdata=r.stack.model.spdf@data)


#6.2 Inspect pred.comp
summary(pred.comp)


# 6.3 In order to create a raster layer,The following should have the same values, 
# if not there are likely covariates with NA's

length(pred.comp)
nrow(stack.model.spdf)



# 6.4 add the class predictions to the raster stack and convert to a raster layer
stack.model.spdf@data$Class <- pred.comp


RF.class <- as(stack.model.spdf["Class"], "RasterLayer")


RF.class$Class


# this is the legend for the raster map
levels(RF.class$Class)

# 6.5 set working directory on where to save raster layer
setwd("E:/PSSAT_Random_Forest/StraddlebugMtGIS/ModelOutputs/")

# 6.6 save raster layer
writeRaster(RF.class$Class, filename = 'RF_ClassTree.tif', format="GTiff", datatype='INT1U', overwrite=TRUE)

plot(RF.class)



#6.7 Generate class probabilities

# predicting using the type as probability to return the prob of each cell
pred.prob <-predict(rfFit, newdata=r.stack.model.spdf@data, type="prob")


# Each pixel has a probability for every class, the highest probability is the class
# selected for the component map. 
# Extraxt the max probability from pred.pob and store in pred.prob$max

pred.prob$max <- apply(pred.prob, 1, max)



# 6.3 In order to create a raster layer,The following should have the same values, 
# if not there are likely covariates with NA's

length(pred.prob$max)
nrow(stack.model.spdf)

# create probability raster
r.stack.model.spdf@data$prob <- pred.prob$max

RF.prob <- as(r.stack.model.spdf["prob"], "RasterLayer")

# 6.5 set working directory on where to save raster layer
setwd("E:/PSSAT_Random_Forest/StraddlebugMtGIS/ModelOutputs/")


# 6.6 save raster layer
writeRaster(RF.prob, filename='RF_ProbTree.tif', overwrite=TRUE)

# Inspect probability raster
plot(RF.prob)




####################################################
# Get individual component probability maps
# Beewon
stack.model.spdf@data$Beewon <- pred.prob$Beewon
RF.Beewon <- as(stack.model.spdf["Beewon"], "RasterLayer")
# 6.5 set working directory on where to save raster layer
setwd("E:/PSSAT_Random_Forest/StraddlebugMtGIS/ModelOutputs/")
# 6.6 save raster layer
writeRaster(RF.Beewon, filename='RF_Beewon.tif', overwrite=TRUE)
# Inspect Raster
plot(RF.Beewon)
#######################################################
