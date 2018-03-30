# Author:Jacob Isleib
# Data exploration of artifacts and trace elements in pedon data from NYC and Hudson Co NJ

setwd("C:/workspace/artifact_analysis")

# Import table queried from KSSL MSAccess database with select measured soil physical and chemical data (including major and trace element geochemistry data).

ksslraw <- read.csv("ALL_geochemistry.csv", header=TRUE)

# remove any duplicate rows of data
ksslraw.uniq <- unique(ksslraw)
#subset raw KSSL export to rows that have Pb geochemistry data (i.e. measured trace metals) and total sand content (to remove data measured on pure artifacts; this also removes O horizon data, which should not affect the analysis)
ksslgeochem <- ksslraw.uniq[complete.cases(ksslraw.uniq$pb_trelm, ksslraw.uniq$sand_tot_psa),]
write.csv(ksslgeochem, file="ksslgeochem.csv", col.names = TRUE)

# generate concatenated list of pedon lab numbers for querying in NASIS

ksslgeochemuniq <- unique(ksslgeochem$pedlabsampnum1)
dput(ksslgeochemuniq, file="NASIS_ALL.txt")

# The txt file create contains a comma-delimited list of lab pedon numbers for use in a NASIS query
# after querying the KSSL pedons with geochemistry data in NASIS, export the pedon horizon human artifacts 
#don't worry about duplicate phorizon data yet

phhuarts <- read.csv("phhuarts.csv", header = TRUE)

# ..and pedon sample tables

phsample <- read.csv("phsample.csv", header = TRUE)

# new data frame of only phorizon.rec.id and lab.sample..
phsample1 <- phsample[, c(13,15)]
# QC data
phsample1[phsample1==""] <- NA
# remove incomplete data
phsample1 <- phsample1[complete.cases(phsample1$Lab.Sample..), ]
phsample1 <- phsample1[order(phsample1$Phorizon.Rec.ID),]
# optional QC
#write.csv(phsample1, file = "phsample1.csv", col.names = TRUE)

#merge the phsample numbers with the phhuarts data
library(dplyr)
merge <- merge(x = phhuarts, y= phsample1, by="Phorizon.Rec.ID")#, all.x = TRUE)

#remove duplicate values with same vol.., Low, and High, Kind, and lab sample number
phhuarts.uniq <- merge %>% distinct(Top.Depth..RV., Vol.., Low, High, Kind, Lab.Sample..)

phhuarts1 <- phhuarts.uniq[, c(2,6)]
phhuarts1[phhuarts1==""] <- NA

library(plyr)
phhuartsagg <- ddply(phhuarts1, ~Lab.Sample.., summarise, totartvol=sum(Vol..))
# optional QC
#write.csv(phhuartsagg, file = "phhuartsagg.csv", col.names = TRUE)

#Quality control: find na cases of lab sample numbers
qc1 <- nasismerge[!complete.cases(nasismerge$Lab.Sample..), ]
qc1uniq <- unique(qc1$User.Site.ID)
dput(qc1uniq, file="qc1uniq.txt")
#Review of na values confirms that these are partially sampled pedons.  NA rows can be dropped as there's no geochemistry data to join them to

nasismergecomplete <- phhuartsagg[complete.cases(phhuartsagg$Lab.Sample..), ]
#column names housekeeping
colnames(nasismergecomplete)[1] <- "labsampnum1"
write.csv(nasismergecomplete, file = "nasismergecomplete.csv", col.names = TRUE)

#inner join between KSSL data with geochem and artifact data
geochemart <- merge(x=ksslgeochem, y=nasismergecomplete, by="labsampnum1")
which( colnames(geochemart)=="labsampnum1" )
#1
which( colnames(geochemart)=="totartvol" )
#130
#select key trace elements
geochemart2 <- geochemart[, c(107, 110:112, 114, 119, 121, 130)]

#scale data, since trace element values range orders of magnitube between elements
geochemart2.complete <- geochemart2[complete.cases(geochemart2),]
geochemart2.scaled <- geochemart2.complete
geochemart2.scaled[, 1:7] <- scale(geochemart2.scaled[, 1:7])

#reshape data to create 1 scatterplot with all trace elements
library(reshape2)
geochemartmelt <- melt(geochemart2.scaled, id.var= 'totartvol')
library(ggplot2)

# plot all scaled data, no groups
ggplot(geochemartmelt, aes(x=totartvol, y=value)) + 
  labs( y ="value (scaled)", title= "PHorizon: Scaled trace element values ~ Total Human Artifacts", caption = paste("n=", length(geochemartmelt$value))) + 
  geom_point() + 
  geom_smooth() + 
  xlab('totartvol')


# plot all scaled data, with trace element groups
ggplot(geochemartmelt, aes(x=totartvol, y=value, colour=variable)) + 
  labs( y ="value (scaled)", title= "PHorizon: Scaled trace element values ~ Total Human Artifacts", caption = paste("n=", length(geochemartmelt$value))) + 
  geom_point() + 
  geom_smooth() + 
  xlab('totartvol')

library(Hmisc)

#evaluate correlation coefficient for all scaled data
rcorr(as.matrix(geochemartmelt[,-2]))

# This is a relatively low correlation coefficient (Pearson's r), suggesting that grouping all selected trace elements values together may not be the best way to explore the relationship between artifacts and trace elements.

# correlation matrix of original (non-scaled, non-reshaped) to explore relationships between individual elements and artifacts
rcorr(as.matrix(geochemart2.complete))

# correlation matrix plot for visualization
geochemcor <- cor(geochemart2.complete)
round(geochemcor, 2)
library(corrplot)
corrplot(geochemcor, type = "upper", order = "hclust", 
         tl.col = "black")#, tl.srt = 45)

# None of the correlation coefficients are very strong (i.e., >=0.7); the highest are Nickel (Ni), Lead (Pb), and Arsenic (As) which are higher than the r value of the group scaled data (0.25 from Table 1 above).

# scatterplot matrix
library(car)
scatterplotMatrix(geochemart2)

# principle components analysis
pca <- prcomp(geochemartmelt[, -2], scale= TRUE)
print(pca)

#examine individual scatterplots
#note that the sample size is relatively small, n=91 horizons
#elements are list in order of correlation coefficients (descending)

library(lattice)

###Nickel
xyplot(ni_trelm ~ totartvol, data=geochemart2, type = c("p","smooth"), main = paste("PHorizon: Nickel ~ Total Human Artifacts, n=", length(geochemart2.complete$ni_trelm)))

#The Loess smooth line for Ni ~ artifacts appears to "elbow" between 15 and 20 percent artifacts

### Lead
xyplot(pb_trelm ~ totartvol, data=geochemart2, type = c("p","smooth"), main = paste("PHorizon: Lead ~ Total Human Artifacts, n=", length(geochemart2.complete$pb_trelm)))

#The Loess smooth line for Pb ~ artifacts appears to "elbow" somewhere between 15-30 percent artifacts.

### Arsenic
xyplot(as_trelm ~ totartvol, data=geochemart2, type = c("p","smooth"), main = paste("PHorizon: Arsenic ~ Total Human Artifacts, n=", length(geochemart2.complete$as_trelm)))

#The Loess smooth line for As ~ artifacts appears to "elbow" at around 30 percent artifacts.

###Cobalt
xyplot(co_trelm ~ totartvol, data=geochemart2.complete, type = c("p","smooth"), main = paste("PHorizon: Cobalt ~ Total Human Artifacts, n=", length(geochemart2.complete$co_trelm)))

#The Loess smooth line for Co ~ artifacts appears to "elbow" at around 30 percent artifacts, although the change in slope appears slight 