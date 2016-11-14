# Analysis of 11-FIN ArcSIE Erosion Classes
Stephen Roecker  
November 7, 2016  








## Introduction

This analysis looks at the field data collected for the following 2016 MLRA projects:
- MLRA 111E - Cardington and Centerburg silt loams, 2 to 6 percent slopes 
- MLRA 111E - Cardington and Centerburg silt loams, 2 to 6 percent slopes, eroded

One of the goals of these projects was to develop an ArcSIE model in order to differentiate erosion classes. The analysis below is intended to evaluate the field data and ArcSIE model.


## Import Data and Transform


```r
data <- read.csv("C:/workspace/neil_arcsie/Pedon_Data_DumpSIE.csv")

names(data) <- gsub(" ", "", names(data))
names(data) <- gsub("\\.", "", names(data))
data <- transform(data,
                  EroClassFD = as.factor(EroClassFD),
                  EroClassSIE = as.factor(EroClassSIE),
                  hzthk = hzdepb - hzdept,
                  rgb = munsell2rgb(mxhue, mxvalue, mxchroma, return_triplets = TRUE)
                  )
```


## Evaluation of the Accuracy of the ArcSIE Predictions


```r
cm <- confusionMatrix(data = data$EroClassSIE, reference = data$EroClassFD)

cm$table
```

```
##           Reference
## Prediction  0  1  2  3
##          0  0  0  0  0
##          1  0 17 10  2
##          2  1  8 14  7
##          3  0  3  1  4
```

```r
round(cm$overall, 2)
```

```
##       Accuracy          Kappa  AccuracyLower  AccuracyUpper   AccuracyNull 
##           0.52           0.24           0.40           0.65           0.42 
## AccuracyPValue  McnemarPValue 
##           0.05            NaN
```

The overall accuracy of the ArcSIE predictions is 0.52. The confusion matrix above shows that the ArcSIE model wasn't able to discriminate EroClassFD class 2 well. However since the initial sampling, Tonie Endres has reviewed some of the observations that were misclassified in the field and determined the ArcSIE classes to be correct, thus the overall accuracy is somewhat higher.


### Boxplots of the Erosion Classes


```r
vals <- c("hzthk", "SolumDp", "CaCO3Dp", "claytotest", "SurfFrags", "mxvalue", "mxchroma", "SlopeSIE", "ProfCrv", "PlanCrv")
data_lo1 <- melt(data, id.vars = "EroClassFD", measure.vars = vals)
data_lo2 <- melt(data, id.vars = "EroClassSIE", measure.vars = vals)

names(data_lo1)[1] <- "EroClass"
data_lo1 <- transform(data_lo1, method = "FD")
names(data_lo2)[1] <- "EroClass"
data_lo2 <- transform(data_lo2, method = "SIE")
data_lo <- rbind(data_lo1, data_lo2)

bwplot(EroClass ~ value | variable + method, data = data_lo, 
       scales = list(x ="free"), as.table = TRUE, layout = c(5, 4)
       )
```

![](neil_arcsie_files/figure-html/EroClassFD boxplots-1.png)<!-- -->

```r
# ggplot(data_lo, aes(x = EroClass, y = value)) +
#   geom_boxplot() +
#   facet_wrap(~ variable + method, scales="free_y")
```

The box plots show that the FD erosion classes have a linear trend for some variables, while other variables only show class 3 or 1 deviating from the other two classes. Overall the variation within each of classes overlap considerably, such that in many cases the median values of one class fall within the interquartile range of the other two classes. This overlap suggests that it is difficult/impractical to separate all the classes. In comparison, the trends between the SIE classes and variables appear to be less linear. In addition, the trends between the SIE classes and digital elevation model (DEM) derivatives (i.e. slope) don't match those observed for FD classes. This mismatch suggests that the membership functions for the SIE classes are poor fit, and should be redefined to more accurately represent the relationship between the FD classes and DEM derivatives.


### Scatterplots of the Erosion Classes


```r
soil_vals <- c("hzthk", "SolumDp", "CaCO3Dp", "claytotest", "SurfFrags") # excluded color, only observed a narrow range thus small differences swamp everthing else
geo_vals <- c("SlopeSIE", "ProfCrv", "PlanCrv")
vals <- c(soil_vals, geo_vals)

test <- subset(data, select = vals)
test_d <- daisy(scale(test), metric = "gower")
test_mds <- metaMDS(test_d, distance = "gower", autotransform = FALSE)
```

```
## Run 0 stress 0.23203 
## Run 1 stress 0.2349196 
## Run 2 stress 0.2439623 
## Run 3 stress 0.2326249 
## Run 4 stress 0.2351623 
## Run 5 stress 0.2321023 
## ... Procrustes: rmse 0.007839919  max resid 0.04404928 
## Run 6 stress 0.2446368 
## Run 7 stress 0.237126 
## Run 8 stress 0.239715 
## Run 9 stress 0.2318015 
## ... New best solution
## ... Procrustes: rmse 0.03205832  max resid 0.150004 
## Run 10 stress 0.2337066 
## Run 11 stress 0.2605978 
## Run 12 stress 0.234554 
## Run 13 stress 0.2349203 
## Run 14 stress 0.2326871 
## Run 15 stress 0.233583 
## Run 16 stress 0.2342458 
## Run 17 stress 0.2347648 
## Run 18 stress 0.2361121 
## Run 19 stress 0.2356716 
## Run 20 stress 0.2464842 
## *** No convergence -- monoMDS stopping criteria:
##     20: stress ratio > sratmax
```

```r
test_pts <- cbind(as.data.frame(test_mds$points), EroClassFD = data$EroClassFD)

p1 <- xyplot(hzthk ~ SolumDp, groups = data$EroClassFD, data = data, 
             type = c("g", "p"), aspect = 1, alpha = 0.7,
             auto.key = list(space = "right")
             )
p2 <- xyplot(MDS2 ~ MDS1, groups = test_pts$EroClassFD, data = test_pts,
             type = c("g", "p"), aspect = 1, alpha = 0.7,
             auto.key = list(space = "right"),
             )
plot(p1, split = c(1, 1, 2, 1))
plot(p2, split = c(2, 1, 2, 1), newpage = FALSE)
```

![](neil_arcsie_files/figure-html/mda-1.png)<!-- -->

```r
# p1 <- ggplot(data, aes(x = hzthk, y = SolumDp,  col = EroClassFD)) +
#   geom_point(cex = 3) +
#   theme(aspect.ratio = 1)
# p2 <- ggplot(test_pts, aes(x = MDS1, y = MDS2, col = EroClassFD)) +
#   geom_point(cex = 3) +
#   theme(aspect.ratio = 1)
# grid.arrange(p1, p2, ncol = 2)
```

Scatter plots of the erosion classes displayed over various dimensions, including using multidimensional (MD) scaling, again show their is considerable overlap between the erosion classes. 



## Comparison of the Erosion Classes and Hierachical Clusters



```r
test_c <- hclust(test_d, method = "ward")
plot(test_c, labels = data$upedonid)
rect.hclust(test_c, k = 3)
```

![](neil_arcsie_files/figure-html/ca-1.png)<!-- -->

A hierarchical classification of the field data was generated in order to compare with the FD classes and determine if a more compact classification could be achieved. An threshold of 3 classes was selected. In examing the dendrogram it is apparent that the 1 class it much smaller than the other 2.



```r
clusters <- cbind(data, test_pts, clusters = factor(cutree(test_c, k = 3), levels = 0:3))

with(clusters, table(EroClassFD, clusters))
```

```
##           clusters
## EroClassFD  0  1  2  3
##          0  0  0  0  1
##          1  0  7 18  3
##          2  0 15 10  0
##          3  0 11  1  1
```

```r
with(clusters, table(EroClassSIE, clusters))
```

```
##            clusters
## EroClassSIE  0  1  2  3
##           1  0 15 13  1
##           2  0 13 16  2
##           3  0  5  1  2
```

The contingency table shows that the FD classes (EroClassFD) 1 overlaps the most with cluster 2, while FD class 2 overlap the most with the cluster 3. The ArcSIE predictions don't appear to have any correspondence with the hierarchical clusters.


### Scatter Plots of the Erosion Classes vs the Hierachical Clusters


```r
p1 <- xyplot(MDS2 ~ MDS1, groups = EroClassFD, data = clusters,
             type = c("g", "p"), aspect = 1, alpha = 0.7,
             auto.key = list(space = "right")
             )
p2 <- xyplot(MDS2 ~ MDS1, groups = clusters, data = clusters,
             type = c("g", "p"), aspect = 1, alpha = 0.7,
             auto.key = list(space = "right")
             )
plot(p1, split = c(1, 1, 2, 1))
plot(p2, split = c(2, 1, 2, 1), newpage = FALSE)
```

![](neil_arcsie_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

```r
# p1 <- ggplot(clusters, aes(x = MDS1, y = MDS2, col = EroClassFD)) +
#   geom_point(cex = 3) +
#   theme(aspect.ratio = 1)
# p2 <- ggplot(clusters, aes(x = MDS1, y = MDS2, col = clusters), main = "test") +
#   geom_point(cex = 3) + 
#   theme(aspect.ratio = 1)
# grid.arrange(p1, p2, ncol = 2)
```

In comparison the hierarchical clusters have less considerably less overlap when viewed along the multidimensional scaled axes.


### Box Plots fo the Erosion Classes vs the Hierachical Clusters


```r
vals <- c("claytotest", "CaCO3Dp", "SurfFrags", "hzthk", "SolumDp", "PlanCrv", "ProfCrv", "SlopeSIE", "mxvalue", "mxchroma")

data_lo1 <- melt(data, id.vars = "EroClassFD", measure.vars = vals)
names(data_lo1)[1] <- "EroClass"
data_lo1 <- transform(data_lo1, method = "FD")

data_lo2 <- melt(clusters, id.vars = "clusters", measure.vars = vals)
names(data_lo2)[1] <- "EroClass"
data_lo2 <- transform(data_lo2, method = "clusters")

data_lo <- rbind(subset(data_lo1, as.character(variable) %in% vals), data_lo2)

bwplot(EroClass ~ value | variable + method, data = data_lo, 
       scales = list(x ="free"), as.table = TRUE, layout = c(5, 4)
       )
```

![](neil_arcsie_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

```r
# ggplot(data_lo, aes(x = EroClass, y = value)) +
#   geom_boxplot() +
#   facet_wrap(~ variable + method, scales="free_y", ncol = 2)
```

In comparison the erosion classes and hierarchical clusters show a similarly degree of separability, but appear to be split on different variables. Amongst the clusters, the separation primarily appears to be based on the solum and carbonates depth. The FD classes appear to be based most on the surface soil properties of the Ap horizon (hzthk, claytotest, SurfFrags).





### Classification Trees

In order to interpret the FD classes and clusters several classifications trees were constructed. Trees were constructed using both the soil properties and DEM derivatives separately, in order to determine what thresholds best defined the groups internally and externally (e.g. mapped). It is worth mentioning that classification trees only look for the single best split amongst individual nodes, while an SIE model are typically a weighted average of several variables. 


#### FD Classes vs Soil Properties


```r
clusters <- subset(clusters, !is.na(EroClassFD))

test1 <- ctree(EroClassFD ~ ., data = clusters[, c("EroClassFD", soil_vals)])
plot(test1)
```

![](neil_arcsie_files/figure-html/tree-1.png)<!-- -->

```r
cm1 <- confusionMatrix(data = predict(test1, type = "response"), reference = clusters$EroClassFD)
cm1$table
```

```
##           Reference
## Prediction  0  1  2  3
##          0  0  0  0  0
##          1  0 26  9  1
##          2  1  2 16 12
##          3  0  0  0  0
```

```r
round(cm1$overall, 2)
```

```
##       Accuracy          Kappa  AccuracyLower  AccuracyUpper   AccuracyNull 
##           0.63           0.38           0.50           0.74           0.42 
## AccuracyPValue  McnemarPValue 
##           0.00            NaN
```

The classification tree of the FD classes using only the soil properties as predictors split the classes on horizon thickness (hzthk) using a break of 21-cm, and had an overall accuracy of 0.63. The breakdown the of individual nodes show that node 2 is more mixed than node 3. This result is similar to the SIE model with had difficulty separating class 2 and 3. The split at 21-cm corresponds with the typically depth associated with tillage.


#### Clusters vs Soil Properties


```r
test2 <- ctree(clusters ~ ., data = clusters[, c("clusters", soil_vals)])
plot(test2)
```

![](neil_arcsie_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

```r
cm2 <- confusionMatrix(data = predict(test2, type = "response"), reference = clusters$clusters)
cm2$table
```

```
##           Reference
## Prediction  0  1  2  3
##          0  0  0  0  0
##          1  0 29  3  0
##          2  0  4 24  0
##          3  0  0  2  5
```

```r
round(cm2$overall, 2)
```

```
##       Accuracy          Kappa  AccuracyLower  AccuracyUpper   AccuracyNull 
##           0.87           0.77           0.76           0.94           0.49 
## AccuracyPValue  McnemarPValue 
##           0.00            NaN
```

The classification tree for the hierachical clusters using only soil properties as predictors, had several splits based on solum depth (SolumDp) and surface rock fragments (SurfFrags), and had an overall accuracy of 0.87.


#### FD Classes vs DEM Derivatives


```r
test3 <- ctree(EroClassFD ~ ., data = clusters[, c("EroClassFD", geo_vals)])
plot(test3)
```

![](neil_arcsie_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

```r
cm3 <- confusionMatrix(data = predict(test3, type = "response"), reference = clusters$EroClassFD)
cm3$table
```

```
##           Reference
## Prediction  0  1  2  3
##          0  0  0  0  0
##          1  1 26 23  7
##          2  0  0  0  0
##          3  0  2  2  6
```

```r
cm3$overall
```

```
##       Accuracy          Kappa  AccuracyLower  AccuracyUpper   AccuracyNull 
##      0.4776119      0.1512848      0.3540149      0.6032516      0.4179104 
## AccuracyPValue  McnemarPValue 
##      0.1925839            NaN
```

The classification tree of the FD classes using only the DEM derivates as predictors found the best split using a slope gradient of 6 percent, and had an overal accuracy of 0.48. This tree however was only able to map classes 1 and 3. The split at a slope of 6 percent matches the matches the original slope break used within Morrow (OH117) and Knox (OH083) Counties.  


#### Clusters vs DEM Derivatives


```r
test4 <- ctree(clusters ~ ., data = clusters[, c("clusters", geo_vals)])
plot(test4)
```

![](neil_arcsie_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

```r
cm4 <- confusionMatrix(data = predict(test4, type = "response"), reference = clusters$clusters)
cm4$table
```

```
##           Reference
## Prediction  0  1  2  3
##          0  0  0  0  0
##          1  0 23  3  2
##          2  0 10 26  3
##          3  0  0  0  0
```

```r
round(cm4$overall, 2)
```

```
##       Accuracy          Kappa  AccuracyLower  AccuracyUpper   AccuracyNull 
##           0.73           0.50           0.61           0.83           0.49 
## AccuracyPValue  McnemarPValue 
##           0.00            NaN
```

The classification tree of the clusters using only the DEM derivates as predictors found the best split using across slope (PlanCrv) curvature, and had an overal accuracy of 0.73.


## Summary

It was discussed that in practice the definition of the erosion classes is somewhat subjective. This makes it difficult to separate the classes in the field consistently, which correspondingly make them difficult to model.

Test additional DEM derivatives, such as the topographic wetness index (TWI) and relative elevation.

Their are other applicable DSM models that could be evaluated. 
