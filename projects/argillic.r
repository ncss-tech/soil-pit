# Set working directory
setwd("C:/Workspace/DSM")

# Create lists
dem.pc.list=paste("rs_dem_pc",c(1:9),"_ifsar_ned30m_oi.tif",sep="")
sr.pc.list=paste("rs_sr_pc",c(1:2),"_ifsar_ned30m_oi.tif.sgrd.tif",sep="")
landsat.pc.list=paste("rs_filtered_leafon_pc",c(1:6),"_landsat30m_oi.tif.sgrd.tif",sep="")
prism.list=c(
"rs_temp_F_avg_prism30m_oi.sgrd.tif",
"rs_temp_F_mr_prism30m_oi.sgrd.tif",
"rs_precip_in_sum_prism30m_oi.sgrd.tif",
"rs_precip_cv_prism30m_oi.sgrd.tif")

# Create raster stack
library(raster)
ancdata=stack(c(dem.pc.list,sr.pc.list,landsat.pc.list,prism.list))
NAvalue(ancdata)=-99999

# Relabel raster stack column names
dem.names=paste("dem_pc",c(1:9),sep="")
sr.names=paste("sr_pc",c(1:2),sep="")
landsat.names=paste("ls_pc",c(1:6),sep="")
prism.names=c("tp_avg","tp_mr","pc_sum","pc_cv")

layerNames(ancdata)=c(dem.names,sr.names,landsat.names,prism.names)
 
# Extract ancillary data and append to PedonPC plus query
pedons=read.csv("export_pedon_NASIS.csv")
names(pedons)=c("usiteid","descname","y","x","zone","argillic","scarb","ps",
"tdeps","tdeph","tdepr","wtsand","wtclay","wtsilt","wtcf")
coordinates(pedons)= ~x+y
ancdata_values=xyValues(ancdata,pedons)
pedons=as.data.frame(pedons)
data=cbind(pedons,ancdata_values)

# Subset data into pedons and dem pc
demdata=subset(data[,c(1:24)])

# Response variable - presence/absence of agrillic horizons
# Predictor variables - dem pc
# Statistical model - generalized linear model

source("C:/Workspace/DSM/Gfits.R")

demdata.glm<-glm(argillic~.,demdata[,c(6,16:24)],family=binomial)
summary(demdata.glm)
glmfit(demdata.glm)

library(MASS)
demdata.step<-stepAIC(demdata.glm,trace=F)
summary(demdata.step)
glmfit(demdata.step)

test2 = predict(ancdata, demdata.glm, progess='text', type='response')
writeRaster(test2,filename='test2.tif',format="GTiff",overwrite=TRUE)
rsaga.gtiff.to.sgrd("test2.tif")

# Create model
# Response variable - presence/absence of agrillic horizons
# Predictor variables - dem pc, landsat pc, prism data
# Statistical model - generalized linear model

argillic.glm<-glm(argillic~.,data[,c(6,16:36)],family=binomial)
summary(argillic.glm)
glmfit(argillic.glm)

# Automated variable selection
library(MASS)
argillic.step<-stepAIC(argillic.glm,trace=F)
summary(argillic.step)

# Model evaluation
glmfit(argillic.step)

    MSE  RMSE    D2 adjD2
1 0.056 0.237 0.555 0.527

anova(argillic.step)

Analysis of Deviance Table

Model: binomial, link: logit

Response: argillic

Terms added sequentially (first to last)


        Df Deviance Resid. Df Resid. Dev
NULL                      266     232.38
dem_pc1  1    7.387       265     225.00
dem_pc2  1   44.036       264     180.96
dem_pc3  1    2.962       263     178.00
dem_pc4  1    1.384       262     176.61
dem_pc5  1    4.491       261     172.12
dem_pc6  1    0.156       260     171.97
dem_pc7  1   16.998       259     154.97
dem_pc9  1    3.104       258     151.86
sr_pc1   1    0.435       257     151.43
sr_pc2   1    0.320       256     151.11
ls_pc1   1    0.002       255     151.11
ls_pc4   1   20.242       254     130.86
ls_pc6   1   11.942       253     118.92
tp_mr    1    0.016       252     118.91
pc_sum   1    4.934       251     113.97
pc_cv    1   10.545       250     103.43

library(caret)
argillic.p=predict(argillic.step,data,type='response')
data$argillic.p[argillic.p < 0.5] <- 'no'
data$argillic.p[argillic.p >= 0.5] <- 'yes'
confusionMatrix(data$argillic,data$argillic.p)

Confusion Matrix and Statistics

          Reference
Prediction  no yes
       no  218  14
       yes   7  28
                                          
               Accuracy : 0.9213          
                 95% CI : (0.8823, 0.9507)
    No Information Rate : 0.8427          
    P-Value [Acc > NIR] : 9.883e-05       
                                          
                  Kappa : 0.6818          
 Mcnemar's Test P-Value : 0.1904          
                                          
            Sensitivity : 0.9689          
            Specificity : 0.6667          
         Pos Pred Value : 0.9397          
         Neg Pred Value : 0.8000          
             Prevalence : 0.8427          
         Detection Rate : 0.8165          
   Detection Prevalence : 0.8689          
                                          
       'Positive' Class : no              

# Apply model to raster stack  
argillic = predict(ancdata, argillic.glm, progess='text', type='response')
writeRaster(argillic,filename='argillic.tif',format="GTiff",overwrite=TRUE)
rsaga.gtiff.to.sgrd("argillic.tif")
