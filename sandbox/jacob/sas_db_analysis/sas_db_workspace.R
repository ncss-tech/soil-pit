# Author: Jacob Isleib
# Objective: Explore existing SAS soil property data to determine statistically significant groupings of soil properties that explain the variability in bulk density.  We will only use SAS data from marine and estuarine areas and will exclude freshwater SAS data.
# Research question: To explain variability in bulk density, should SAS data be summarized by individual USDA texture classes or other soil properties?

setwd("C:/workspace/sandbox/jacob/sas_db_analysis")

library(ggplot2)
library(car)

# load csv of available SAS Db data
data <- read.csv("C:/workspace/sas_db_analysis/sas_db_analysis.csv")

# subset data to hzn_bot, texture class, total sand/silt/clay, satiated Db, and SOC%
# and only include mineral or mucky mineral textures
data1 <- subset(data[ which(data$oc_qc!="organic"),c(7, 9:14)])
## subset data1 for complete cases
datacomplete <- data1[complete.cases(data1),]

# Create scatterplot matrix of subset data
spm(datacomplete)

# Run prcomp, sca, and correlation matrix

## run pca (exclude texture class FACTOR data)
datacomplete.cont <- datacomplete[, c(3:7)]
datacomplete.cat <- datacomplete[, c(2)]

datapca <- prcomp(datacomplete.cont, scale = TRUE)
print(datapca)
summary(datapca)
x <- predict(datapca, datacomplete.cont)

# Summary statistics by USDA texture class

library(plyr)
library(dplyr)
datacomplete2 <- datacomplete[, c(2,3:7)]
data.tex.sum <- ddply(datacomplete2, ~texture, summarise, 
                      n=n(),
                      min=min(db_satiated), 
                      min2sigma=round(((mean(db_satiated))-(2*(sd(db_satiated)))), 2),
                      sd=sd(db_satiated, 2),
                      mean=round(mean(db_satiated), 2),
                      median=median(db_satiated),
                      max2sigma=round(((mean(db_satiated))+(2*(sd(db_satiated)))), 2),
                      max=max(db_satiated),
                      range=((max(db_satiated))-(min(db_satiated))))
                      
## Basic histogram from the vector "db_satiated".
# Draw with black outline, white fill

ggplot(datacomplete2, aes(x=db_satiated)) +
  geom_histogram(binwidth=.05,
                 colour="black", fill="white") +
  facet_wrap(~ texture)

# Histogram overlaid with kernel density curve

# Find the mean of each group
library(plyr)
cdat <- ddply(datacomplete2, "texture", summarise, db_satiated.mean=mean(db_satiated))

# plot with vertical mean line
ggplot(datacomplete2, aes(x=db_satiated)) + 
  geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
                 binwidth=.05,
                 colour="black", fill="white") +
  geom_density(alpha=.2, fill="#FF6666") +   # Overlay with transparent density plot
  facet_wrap(~ texture) +
  geom_vline(data=cdat, aes(xintercept=db_satiated.mean,  colour=texture),
             linetype="dashed", size=1)

# PCA biplot
library(devtools)
#install_github("vqv/ggbiplot")
library(ggbiplot)
g <- ggbiplot(datapca, obs.scale = 1, var.scale = 1, 
              groups = datacomplete.cat, ellipse = TRUE, 
              labels = datacomplete.cat, circle = FALSE)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal', 
               legend.position = 'top')
print(g)

# Create correlation matrix
round(cor(datacomplete[,-2]), 2)
round(cor(datacomplete[,-2], method= "spearman"), 2)

# Perform hard clustering and evaluate silhouette widths to aid in determining appropriate number of clusters
library(cluster)
data.std <- data.frame(datacomplete.cont, scale(datacomplete.cont))
sil.widths <- vector(mode='numeric')

for(i in 2:10) {
  
  cl <- pam(data.std, k = i, stand = FALSE)
  
  sil.widths[i] <- cl$silinfo$avg.width
  
}
par(mar=c(4,4,3,1))

plot(sil.widths, type='b', xlab='Number of Clusters', ylab='Average Silhouette Width', las=1, lwd=2, col='RoyalBlue', cex=1.25, main='Finding the "Right" Number of Clusters')

grid()

# another silhouette width plot
library(factoextra)
fviz_nbclust(data.std, pam, method = "wss") #+
#geom_vline(xintercept = 2, linetype = 2)



fviz_nbclust(data.std, pam, method = "silhouette")

fviz_nbclust(data.std, hcut, method = "silhouette",
             hc_method = "complete")

# More plotting k-medoids clusters

data.res.2 <- pam(scale(datacomplete2[,-1]), 2)
data.res.2$medoids
clusplot(data.res.2, main = "Cluster plot, k = 2", 
         color = TRUE)
library(factoextra)
fviz_cluster(data.res.2, data = datacomplete2)

data.res.3 <- pam(scale(datacomplete2[,-1]), 3)
data.res.3$medoids
clusplot(data.res.3, main = "Cluster plot, k = 3", 
         color = TRUE)
library(factoextra)
fviz_cluster(data.res.3, data = datacomplete2)

data.res.4 <- pam(scale(datacomplete2[,-1]), 4)
data.res.4$medoids
clusplot(data.res.4, main = "Cluster plot, k = 4", 
         color = TRUE)
library(factoextra)
fviz_cluster(data.res.4, data = datacomplete2)

data.res.5 <- pam(scale(datacomplete2[,-1]), 5)
data.res.5$medoids
clusplot(data.res.5, main = "Cluster plot, k = 5", 
         color = TRUE)
library(factoextra)
fviz_cluster(data.res.5, data = datacomplete2)

# Explore scatterplots with cluster groups

library(cluster)
library(ape)
library(RColorBrewer)

# nice colors for later

col.set <- brewer.pal(9, 'Set1')

# remove texture class and silt columns

datacomplete3 <- datacomplete[, c(-2, -4)]
datacomplete4 <- datacomplete[, c(-2)]

# check structure

str(datacomplete3)

# k medoid, k=2

par(mfrow=c(2,3), mar=c(1,1,1,1))

for(i in 2:7) {
  cl <- clara(datacomplete3, k = 2, stand = TRUE)
  plot(datacomplete3, col = col.set[cl$clustering])
  grid()
  points(cl$medoids, col = col.set, pch = 0, cex = 2, lwd=2)
  #  box()
  }

#Covariates on this k=2 plot with the clearest vertical separation of clusters along the value range (in respect to db_satiated) are oc (at ~ 2%) and clay_tot (at ~8 percent)

# k medoid, k=3

par(mfrow=c(2,3), mar=c(1,1,1,1))

for(i in 2:7) {
  cl <- clara(datacomplete3, k = 5, stand = TRUE)
  plot(datacomplete3, col = col.set[cl$clustering])
  grid()
  points(cl$medoids, col = col.set, pch = 0, cex = 2, lwd=2)
  #  box()
}

#At k=3, the 3rd cluster is comingled with the 2nd for most covariates except hzn_bot, suggesting that depth is the largest factor in this 3rd cluster.  The cluster depth change point is at ~ 100cm.

# k medoids for k=4:6 were evaluated, however the only non-comingled groups plot on the hzn_bot ~ db_satiated scatterplot, but do not change at a break on the hzn_bot axis suggesting they are clusters of bulk densities that may be explained by another covariate not accounted for in the scatterplot matrix.

# subset data by horizon depth, break at 100cm

data.upper <- subset(datacomplete, hzn_bot <100)
data.lower <- subset(datacomplete, hzn_bot >=100)

# tacit knowledge suggests that bulkdensity for silty textures may be very dependent upon horizon depth.  Very fluid (low bulk density) horizons are generally found higher in the soil profile
# evaluate silt textured horizons

silty <- c("si","sic","sicl","sil")
data.silty <- datacomplete[datacomplete$texture %in% silty, ]
round(cor(data.silty[, -2]), 2)
spm(data.silty[, -2])

#The corr coefficient betwee db_satiated ~ hzn_bot is 0.40.  The correlation coefficient between db_satiated and clay_tot is 0.51 and the plot suggests there is a change point at around ~15%.  

#silty.lowclay <- c("si","sil")
#silty.highclay <- c("sic","sicl")
#data.silty.lowclay <- datacomplete[datacomplete$texture %in% silty]
#data.silty.highclay <- datacomplete[datacomplete$texture %in% silty.highclay, ]

data.silty.lowclay <- subset(data.silty, clay_tot <15)
data.silty.highclay <- subset(data.silty, clay_tot >=15)

# generate correlation matrix of silty subset data
round(cor(data.silty.lowclay[, -2]), 2)
round(cor(data.silty.highclay[, -2]), 2)

# Add new grouped-texture variables to account for low sample size in lvfs, vfs, and cosl textures

lfs.lvfs <- c("lfs","lvfs")
fs.vfs <- c("fs", "vfs")
sl.cosl <- c("sl", "cosl")

library(dplyr)
datamutant <- mutate(datacomplete, texgrp = ifelse(texture %in% silty & clay_tot <15, "silty.lowclay",
                              ifelse(texture %in% silty & clay_tot >=15, "silty.highclay",
                              ifelse(texture %in% lfs.lvfs, "lfs.lvfs",
                              ifelse(texture %in% fs.vfs, "fs.vfs",
                              ifelse(texture %in% sl.cosl, "sl.cosl",
                              as.character(texture))))))) 

datamutant.summary <- ddply(datamutant, ~texgrp, summarise, 
                            n=n(),
                            min=min(db_satiated), 
                            min2sigma=round(((mean(db_satiated))-(2*(sd(db_satiated)))), 2),
                            sd=sd(db_satiated, 2),
                            mean=round(mean(db_satiated), 2),
                            median=median(db_satiated),
                            max2sigma=round(((mean(db_satiated))+(2*(sd(db_satiated)))), 2),
                            max=max(db_satiated))
datamutant.summary

# plot histograms to analyse ddistribution by new texture groups

cdat <- ddply(datamutant, "texgrp", summarise, db_satiated.mean=mean(db_satiated))
ggplot(datamutant, aes(x=db_satiated)) + 
  geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
                 binwidth=.05,
                 colour="black", fill="white") +
  geom_density(alpha=.2, fill="#FF6666") +   # Overlay with transparent density plot
  facet_wrap(~ texgrp) +
  geom_vline(data=cdat, aes(xintercept=db_satiated.mean,  colour=texgrp),
             linetype="dashed", size=1)

#ANOVA and Tukey Honest Significant Differences will be used to evaluate potential groupings of texture classes 

amod <- aov(db_satiated ~ texgrp, data=datamutant)
amod
summary(amod)
print(model.tables(amod, "effects", se = TRUE))
tukey <- TukeyHSD(amod, "texgrp")
hsd.table <- as.data.frame(tukey$texgrp)
write.csv(hsd.table, file="hsdtable.csv", row.names = TRUE)

# standard error table
test0 <- lm(db_satiated ~ texgrp, data=datamutant, contrasts = list(texgrp = contr.treatment))
anova(test0)
par(mfrow=c(2,2))
plot(test0)
summary(test0)
contr.treatment(unique(datamutant$texgrp)) # for reference

# Create new texture groups based on ANOVA
l.silty.highclay <- c("l", "silty.highclay")
lfs.lvfs.lcos.fs.vfs.ls.cos <- c("lfs.lvfs", "lcos", "fs.vfs", "ls", "cos")
vfsl.silty.lowclay.sl.cosl.fsl <- c("vfsl", "silty.lowclay", "sl.cosl", "fsl")

datamutant2 <- mutate(datamutant, texgrp2 = 
                  ifelse(texgrp %in% l.silty.highclay, "l.silty.highclay",
                  ifelse(texgrp %in% lfs.lvfs.lcos.fs.vfs.ls.cos, "lfs.lvfs.lcos.fs.vfs.ls.cos",
                  ifelse(texgrp %in% vfsl.silty.lowclay.sl.cosl.fsl, "vfsl.silty.lowclay.sl.cosl.fsl",
                  as.character(texgrp))))) 

datamutant2.summary <- ddply(datamutant2, ~texgrp2, summarise, 
                            n=n(),
                            min=min(db_satiated),
                            fifth=quantile(db_satiated, .05),
                            min2sigma=round(((mean(db_satiated))-(2*(sd(db_satiated)))), 2),
                            sd=sd(db_satiated, 2),
                            mean=round(mean(db_satiated), 2),
                            median=median(db_satiated),
                            ninetyfifth=quantile(db_satiated, .95),
                            max2sigma=round(((mean(db_satiated))+(2*(sd(db_satiated)))), 2),
                            max=max(db_satiated))

# plot histograms to analyse ddistribution by new texture groups

cdat2 <- ddply(datamutant2, "texgrp2", summarise, db_satiated.mean=mean(db_satiated))
ggplot(datamutant2, aes(x=db_satiated)) + 
  geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
                 binwidth=.05,
                 colour="black", fill="white") +
  geom_density(alpha=.2, fill="#FF6666") +   # Overlay with transparent density plot
  facet_wrap(~ texgrp2) +
  geom_vline(data=cdat2, aes(xintercept=db_satiated.mean,  colour=texgrp2),
             linetype="dashed", size=1)

#subset data by hzn_bot groups for determining RV values by depth with breaks at 50cm, 100cm, and 200cm

data.hzn_bot50 <- subset(datamutant, hzn_bot <50)
data.hzn_bot100 <- subset(datamutant, hzn_bot >=50 & hzn_bot<100)
data.hzn_bot200 <- subset(datamutant, hzn_bot >=100 & hzn_bot<200)

data.hzn_bot50.sum <- ddply(data.hzn_bot50, ~texgrp, summarise, 
                            n50=n(),
                            sd50=sd(db_satiated, 2),
                            mean50=round(mean(db_satiated), 2),
                            median50=median(db_satiated))
data.hzn_bot50.sum[, 'texgrp'] <- as.factor(data.hzn_bot50.sum[, 'texgrp'])

data.hzn_bot100.sum <- ddply(data.hzn_bot100, ~texgrp, summarise, 
                            n100=n(),
                            sd100=sd(db_satiated, 2),
                            mean100=round(mean(db_satiated), 2),
                            median100=median(db_satiated))
data.hzn_bot100.sum[, 'texgrp'] <- as.factor(data.hzn_bot100.sum[, 'texgrp'])

data.hzn_bot200.sum <- ddply(data.hzn_bot200, ~texgrp, summarise, 
                             n200=n(),
                             sd200=sd(db_satiated, 2),
                             mean200=round(mean(db_satiated), 2),
                             median200=median(db_satiated))
data.hzn_bot200.sum[, 'texgrp'] <- as.factor(data.hzn_bot200.sum[, 'texgrp'])

data.hzn_botALL.sum <- merge(data.hzn_bot50.sum, data.hzn_bot100.sum, by="texgrp")
data.hzn_botALL.sum <- merge(data.hzn_botALL.sum, data.hzn_bot200.sum, by="texgrp")

# add a depth factor to data for 2x2 ANOVA
datamutant3 <- mutate(datamutant2, depth_cl = 
                        ifelse(hzn_bot < 50, "0to<50cm",
                        ifelse(hzn_bot >=50 & hzn_bot<100, "50to<100cm",
                        ifelse(hzn_bot >=100, "100to200+cm",
                        hzn_bot)))) 

amod2 <- aov(db_satiated ~ texgrp2 * depth_cl, data=datamutant3)
amod2
summary(amod2)
print(model.tables(amod2, "means", se = TRUE))
tukey2 <- TukeyHSD(amod2, "depth_cl")
tukey2.1 <- TukeyHSD(amod2, "texgrp2:depth_cl")
tukey2
hsd.table2.1 <- as.data.frame(tukey2.1$`texgrp2:depth_cl`)
write.csv(hsd.table2.1, file="hsdtable2.1.csv", row.names = TRUE)

# P values suggest statistically insignificant pairings between the 50-100cm and 100-200+cm groups, and that they can be combined

datamutant4 <- mutate(datamutant3, depth_cl2 = 
                        ifelse(hzn_bot < 50, "0to<50cm",
                               ifelse(hzn_bot >=50, "50to200+cm",
                                      hzn_bot)))

amod3 <- aov(db_satiated ~ texgrp2 * depth_cl2, data=datamutant4)
#amod3 <- anova(lm(db_satiated ~ texgrp2 * depth_cl2, data=datamutant4))
summary(amod3)

# Note: Depth group p value was improved

# The following means can be used according to depth group and texture group

tukey3 <- TukeyHSD(amod3, "texgrp2")
tukey3
tukey4 <- TukeyHSD(amod3, "texgrp2:depth_cl2")
tukey4
hsd.table4 <- as.data.frame(tukey4$`texgrp2:depth_cl2`)
write.csv(hsd.table4, file="hsdtable4.csv", row.names = TRUE)

# The s and lfs.lvfs.lcos.fs.vfs.ls.cos groups have P values that do not support assigning db_satiated values by depth group.

print(model.tables(amod3, "means", se = TRUE))

# Assemble median Db values by texture groups and depth groups

datamutant.0_50 <- ddply(datamutant4[datamutant4$depth_cl2 == '0to<50cm', ], ~texgrp2, summarise, 
                             n.0_50cm=n(),
                             median.0_50cm=round(median(db_satiated), 2))
datamutant.50plus <- ddply(datamutant4[datamutant4$depth_cl2 == '50to200+cm', ], ~texgrp2, summarise, 
                         n.50pluscm=n(),
                         median.50pluscm=round(median(db_satiated), 2))
datamutant.final <- merge(x = datamutant.0_50, y = datamutant.50plus, by = "texgrp2")

# Attempting to tabulate Standard Error

test1 <- lm(db_satiated ~ texgrp2 * depth_cl2, data=datamutant4, contrasts = list(texgrp2 = contr.treatment, depth_cl2 = contr.treatment))
anova(test1)
par(mfrow=c(2,2))
plot(test1)

summary(test1)

# the following constrast matrices show which texture and depth groups correspond to the left-most column in the Standard Error table

contr.treatment(unique(datamutant4$texgrp2))
contr.treatment(unique(datamutant4$depth_cl2))

# Summarize Organic matter content, estimated from measured OC

datamutant5 <- mutate(datamutant4, om = oc* 1.724)  # estimate OM using OC*Van bemmelen factor

datamutant.OM.0_50 <- ddply(datamutant5[datamutant5$depth_cl2 == '0to<50cm', ], ~texgrp2, summarise, 
                         n.OM.0_50cm=n(),
                         fifth.OM.0_50cm=round(quantile(om, 0.05), 1),
                         median.OM.0_50cm=round(median(om), 1),
                         ninetyfifth.OM.0_50cm=round(quantile(om, 0.95), 1))
datamutant.OM.50plus <- ddply(datamutant5[datamutant5$depth_cl2 == '50to200+cm', ], ~texgrp2, 
                              summarise, 
                           n.OM.50pluscm=n(),
                           fifth.OM.50pluscm=round(quantile(om, 0.05), 1),
                           median.OM.50pluscm=round(median(om), 1),
                           ninetyfifth.OM.50pluscm=round(quantile(om, 0.95), 1))
datamutant.OM.final <- merge(x = datamutant.OM.0_50, y = datamutant.OM.50plus, by = "texgrp2")

datamutant.OM.nodepth <- ddply(datamutant5, ~texgrp2, summarise, 
                            n.OM.nodepth=n(),
                            fifth.OM.nodepth=round(quantile(om, 0.05), 1),
                            median.OM.nodepth=round(median(om), 1),
                            ninetyfifth.OM.nodepth=round(quantile(om, 0.95), 1))

# ANOVA / Tukey HSD on OM data

amod4 <- aov(om ~ texgrp2 * depth_cl2
             , data=datamutant5)
summary(amod4)
#tukey5 <- TukeyHSD(amod4, "texgrp")
tukey5 <- TukeyHSD(amod4, "texgrp2:depth_cl2")
tukey5
#hsd.table5 <- as.data.frame(tukey5$texgrp)
hsd.table5 <- as.data.frame(tukey5$`texgrp2:depth_cl2`)
write.csv(hsd.table5, file="hsdtable5.csv", row.names = TRUE)

# Tukey HSD suggests that depth groups should only be used for the vfsl.silty.lowclay.sl.cosl.fsl texture group

test2 <- lm(om ~ texgrp2 * depth_cl2, data=datamutant5, contrasts = list(texgrp2 = contr.treatment, depth_cl2 = contr.treatment))
#test2 <- lm(om ~ texgrp2, data=datamutant5, contrasts = list(texgrp2 = contr.treatment))
anova(test2)
par(mfrow=c(2,2))
plot(test2)

summary(test2)
contr.treatment(unique(datamutant4$texgrp2)) # for reference
contr.treatment(unique(datamutant4$depth_cl2)) # for reference
