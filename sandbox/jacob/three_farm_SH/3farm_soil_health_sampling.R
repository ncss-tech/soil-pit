<<<<<<< HEAD
# Author: Jacob Isleib
# 3 Farm Soil Health Sampling 2015-2016 Data Exploration

setwd("S:/NRCS/Technical_Soil_Services/Soil Health Initiative/3 Farm Sampling Plan FY15")
getwd()
soil <- read.csv('soil_testing.csv')
soil2 <- soil[,c(1:26, 29)]

soil2$field_type.haycorn <- ifelse(soil2$field_type =='corn field', 'corn & hay',
                            ifelse(soil2$field_type =='hay field', 'corn & hay',
                                   ifelse(soil2$field_type =='woodlot', 'woodlot', 'NA'
                                   )))

soil2$field_type.haywood <- ifelse(soil2$field_type =='corn field', 'corn field',
                                   ifelse(soil2$field_type =='hay field', 'hay & woodlot',
                                          ifelse(soil2$field_type =='woodlot', 'hay & woodlot', 'NA'
                                          )))
library(sp)
soil2.sp <- soil
attach(soil2.sp)
library(leaflet)
pal <- colorFactor(c("green", "navy", "red"), domain = c("corn field", "hay field", "woodlot"))

m <- leaflet(soil2.sp) %>% setView(lng = -71.90, lat = 41.9669, zoom = 12)
m %>% addProviderTiles(providers$Esri.WorldImagery) %>% 
  addCircleMarkers(
#    radius = ~ifelse(type == "field_type", 6, 10),
    color = ~pal(field_type),
    stroke = FALSE, fillOpacity = 0.5
  ) %>%
  addLegend("bottomright", pal = pal, values = ~field_type,
            title = "Field type",
#            labFormat = labelFormat(prefix = "$"),
            opacity = 1
  )

soil.num <- soil[, c(8:26)]
soil.num[(2:19)] <- lapply(soil.num[(2:19)], as.numeric)
soil.num2 <- soil.num[complete.cases(soil.num),]

corr.matrix <- as.data.frame(cor(soil.num))
library(corrplot)
corrplot(cor(soil.num2), type = "upper")

plant <- read.csv('plant_data.csv', na.strings = c('', 'na'))
plant.corn <- plant[which(plant$field_type=='corn field'), c(1:9, 19:20)]
plant.corn <- plant.corn[complete.cases(plant.corn), ]
library(plyr)
plant.corn.sum <- ddply(plant.corn, ~site_id, summarise, num_plant.mean=mean(Number.of.Plants...50.ft2), 
                        plants_per_acre.mean = mean(Plants...Acre))

soil.corn.merge <- merge(x=soil, y=plant.corn.sum, by="site_id", all.y = TRUE)
soil.corn.merge2 <- soil.corn.merge[, c(8:26, 34:35)]
scatterplotMatrix(soil.corn.merge2)

soil.corn.corrmatrix <- as.data.frame(cor(soil.corn.merge2))
soil.corn.corrmatrix

### Select covariates with Pearson's coef > 0.70

library(reshape2)
soil.corn.corrmatrix.melt <- subset(melt(cor(soil.corn.merge2)), value > .70)
soil.corn.corrmatrix.melt[(1:2)] <- lapply(soil.corn.corrmatrix.melt[(1:2)], as.character)
select <- !(soil.corn.corrmatrix.melt$Var1 == soil.corn.corrmatrix.melt$Var2)
soil.corn.corrmatrix.melt <- soil.corn.corrmatrix.melt[select, ]
soil.corn.corrmatrix.melt[rev(order(soil.corn.corrmatrix.melt$value)),]

corr.columns <- as.character(soil.corn.corrmatrix.melt$Var1)
corr.columns <- unique(corr.columns)

soil.corn.merge2.select <- soil.corn.merge2[, corr.columns]

### Evaluate relationships using scatterplot matrix

library(car)
library(ggplot2)
scatterplotMatrix(soil.corn.merge2.select)

#soil.corn.merge2.select <- soil.corn.merge2[ setdiff(names(soil.corn.merge2), corr.columns)]

corrplot(cor(soil.corn.merge2), type = "upper")

### Evaluate ranges of soil textures between samples

library(soiltexture)
colnames(soil2)[24] <- "SAND"
colnames(soil2)[25] <- "SILT"
colnames(soil2)[26] <- "CLAY"

geo <- TT.geo.get()

kde.res1 <- TT.kde2d(
  geo = geo,
  tri.data = soil2
)

soil2.hay <- soil2[which(field_type == "hay field"), ]
soil2.corn <- soil2[which(field_type == "corn field"), ]
soil2.woodlot <- soil2[which(field_type == "woodlot"), ]

plot.new()

geo <- TT.plot(class.sys   = "USDA.TT",
               tri.data    = soil2.hay,
               main        = "Range of Particle Size Data for all samples",
               col = "blue",
               cex = .7,
               cex.axis=.5,
               cex.lab=.6,
               lwd=.5,
               lwd.axis=0.5,
               lwd.lab=0.3)

TT.points(tri.data = soil2.corn,
          geo = geo,
          col = "red",
          cex = .1,
          pch = 3)

TT.points(tri.data = soil2.woodlot,
          geo = geo,
          #          dat.css.ps.lim  = c(0,2,63,2000),
          #          css.transf      = TRUE,
          col = "green",
          cex = .2,
          pch = 2)


### Evaluate range of CASH indicators between field types

soil2$all_fields <- "all field types"

library(dplyr)
sample.size <- ddply(soil2, ~field_type, summarise, n = n())
sample.size

attach(soil2)
### Surface Hardness
bartlett.test(Surface.Hardness ~ field_type, data = soil2)
### p-value > 0.05; the variance is the same for all treatment groups.  Use one-way ANOVA to evaluate difference between means of the groups.
aov.surf <- aov(Surface.Hardness ~ field_type, data = soil2)
aov.surf
summary(aov.surf)
print(model.tables(aov.surf, "effects", se = TRUE))
### ANOVA p-value < 0.05; Means are different between groups.

### Analyze means
tapply(X = Surface.Hardness, INDEX = list(field_type), FUN = mean)
### Pairwise comparisons of treatment groups
pairwise.t.test(Surface.Hardness, field_type, p.adj = "holm")
### Corn field and hay field treatments are not significantly different.  Woodlot treatments are different from both others.
var.test(Surface.Hardness ~ field_type.haycorn, soil2, alternative = "two.sided")
# F test suggests variance is not difference between new groups.
summary(aov(Surface.Hardness ~ field_type.haycorn, data = soil2))
# ANOVA of new groups suggests means are different.
boxplot( Surface.Hardness ~ field_type.haycorn, data = soil2, main = "Surface Hardness by Field type", xlab = "Field type", ylab = "Surface Hardness (psi)")

### Subsurface Hardness
bartlett.test(Subsurface.Hardness ~ field_type, data = soil2)
### Bartlett p-value < 0.05; variance appears different between field type groups; used Welch's test to assess means
oneway.test(Subsurface.Hardness ~ field_type, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA p-value < 0.05; Means are different between groups using parametric test.  Use Kruskal-Wallis test for non-parametric version.
kruskal.test(Subsurface.Hardness ~ field_type, soil2, na.action=na.omit)
### Kruskal-Wallis test also indicates difference between means.

### Analyze means
tapply(X = Subsurface.Hardness, INDEX = list(field_type), FUN = mean)
### Pairwise comparisons of treatment groups
pairwise.t.test(Subsurface.Hardness, field_type, p.adj = "holm")
### All treatments are significantly different
boxplot( Subsurface.Hardness ~ field_type, data = soil2, main = "Subsurface Hardness by Field type", xlab = "Field type", ylab = "Subsurface Hardness (psi)")

### Aggregate Stability
bartlett.test(Aggregate.Stability ~ field_type, data = soil2)
### p-value < 0.05; variance appears different between field type groups
oneway.test(Aggregate.Stability ~ field_type, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA p-value < 0.05; Means are different between groups using parametric test.  Use Kruskal-Wallis test for non-parametric version.
kruskal.test(Aggregate.Stability ~ field_type, soil2, na.action=na.omit)
### Kruskal-Wallis test also indicates difference between means.

### Analyze means
tapply(X = Aggregate.Stability, INDEX = list(field_type), FUN = mean)
### Pairwise comparisons of treatment groups
pairwise.t.test(Aggregate.Stability, field_type, p.adj = "holm")
### Hay field and woodlot treatments are not significantly different.  Corn field treatments are different from both others.
var.test(Aggregate.Stability ~ field_type.haywood, soil2, alternative = "two.sided")
### F test suggests variance is different between new groups.
oneway.test(Aggregate.Stability ~ field_type.haywood, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA suggests means are different between new groups.
boxplot( Aggregate.Stability ~ field_type.haywood, data = soil2, main = "Aggregate Stability by Field type", xlab = "Field type", ylab = "Aggregate Stability (%)")

### Organic Matter
bartlett.test(Organic.Matter ~ field_type, data = soil2)
### p-value < 0.05; variance appears different between field type groups
oneway.test(Organic.Matter ~ field_type, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA p-value < 0.05; Means are different between groups using parametric test.  Use Kruskal-Wallis test for non-parametric version.
kruskal.test(Organic.Matter ~ field_type, soil2, na.action=na.omit)
### Kruskal-Wallis test also indicates difference between means.

### Analyze means
tapply(X = Organic.Matter, INDEX = list(field_type), FUN = mean)
### Pairwise comparisons of treatment groups
pairwise.t.test(Organic.Matter, field_type, p.adj = "holm")
### Corn field and hay field treatments are not significantly different.  woodlot treatments are different from both others.
var.test(Organic.Matter ~ field_type.haycorn, soil2, alternative = "two.sided")
### F test suggests variance is not different between new groups.
summary(aov(Organic.Matter ~ field_type.haycorn, data = soil2))
# ANOVA of new groups suggests means are different.
boxplot( Organic.Matter ~ field_type.haycorn, data = soil2, main = "Organic Matter Content by Field type", xlab = "Field type", ylab = "Organic Matter (%)")

### Active carbon
bartlett.test(Active.Carbon ~ field_type, data = soil2)
### p-value > 0.05; the variance is the same for all treatment groups.  Use one-way ANOVA to evaluate difference between means of the groups.
aov.actC <- aov(Active.Carbon ~ field_type, data = soil2)
aov.actC
summary(aov.actC)
print(model.tables(aov.actC, "effects", se = TRUE))
### Cannot reject null hypothesis that there is no difference between the means.
boxplot( Active.Carbon ~ all_fields, data = soil2, main = "Active Carbon by Field type", xlab = "Field type", ylab = "Active Carbon (ppm)")

### ACE Soil Protein Index
bartlett.test(ACE.Soil.Protein.Index ~ field_type, data = soil2)
### p-value < 0.05; variance appears different between field type groups
oneway.test(ACE.Soil.Protein.Index ~ field_type, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA p-value < 0.05; Means are different between groups using parametric test.  Use Kruskal-Wallis test for non-parametric version.
kruskal.test(ACE.Soil.Protein.Index ~ field_type, soil2, na.action=na.omit)
### Kruskal-Wallis test also indicates difference between means.

### Analyze means
tapply(X = ACE.Soil.Protein.Index, INDEX = list(field_type), FUN = mean)
### Pairwise comparisons of treatment groups
pairwise.t.test(ACE.Soil.Protein.Index, field_type, p.adj = "holm")
### Corn field and hay field treatments are not significantly different.  woodlot treatments are different from both others.
var.test(ACE.Soil.Protein.Index ~ field_type.haycorn, soil2, alternative = "two.sided")
### F test suggests variance is different between new groups.
oneway.test(ACE.Soil.Protein.Index ~ field_type.haycorn, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA suggests means are different between new groups.
boxplot( ACE.Soil.Protein.Index ~ field_type.haycorn, data = soil2, main = "ACE Soil Protein Index by Field type", xlab = "Field type", ylab = "ACE Soil Protein Index (mg/g-soil)")

### Microbial Respiration
bartlett.test(Respiration ~ field_type, data = soil2)
### p-value > 0.05; the variance is the same for all treatment groups.  Use one-way ANOVA to evaluate difference between means of the groups.
aov.resp <- aov(Respiration ~ field_type, data = soil2)
aov.resp
summary(aov.resp)
print(model.tables(aov.resp, "effects", se = TRUE))
### ANOVA p-value < 0.05; Means are different between groups.

### Analyze means
tapply(X = Respiration, INDEX = list(field_type), FUN = mean)
### Pairwise comparisons of treatment groups
pairwise.t.test(Respiration, field_type, p.adj = "holm")
### Hay field and woodlot treatments are not significantly different.  Corn field treatments are different from both others.
var.test(Respiration ~ field_type.haywood, soil2, alternative = "two.sided")
### F test suggests variance is different between new groups.
oneway.test(Respiration ~ field_type.haywood, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA suggests means are different between new groups.

boxplot( Respiration ~ field_type.haywood, data = soil2, main = "Microbial respiration by Field type, 4-day incubation", xlab = "Field type", ylab = "Microbial respiration (mg)")
=======
# Author: Jacob Isleib
# 3 Farm Soil Health Sampling 2015-2016 Data Exploration

setwd("S:/NRCS/Technical_Soil_Services/Soil Health Initiative/3 Farm Sampling Plan FY15")
getwd()
soil <- read.csv('soil_testing.csv')
soil2 <- soil[,c(1:26, 29)]

soil2$field_type.haycorn <- ifelse(soil2$field_type =='corn field', 'corn & hay',
                            ifelse(soil2$field_type =='hay field', 'corn & hay',
                                   ifelse(soil2$field_type =='woodlot', 'woodlot', 'NA'
                                   )))

soil2$field_type.haywood <- ifelse(soil2$field_type =='corn field', 'corn field',
                                   ifelse(soil2$field_type =='hay field', 'hay & woodlot',
                                          ifelse(soil2$field_type =='woodlot', 'hay & woodlot', 'NA'
                                          )))
library(sp)
soil2.sp <- soil
attach(soil2.sp)
library(leaflet)
pal <- colorFactor(c("green", "navy", "red"), domain = c("corn field", "hay field", "woodlot"))

m <- leaflet(soil2.sp) %>% setView(lng = -71.90, lat = 41.9669, zoom = 12)
m %>% addProviderTiles(providers$Esri.WorldImagery) %>% 
  addCircleMarkers(
#    radius = ~ifelse(type == "field_type", 6, 10),
    color = ~pal(field_type),
    stroke = FALSE, fillOpacity = 0.5
  ) %>%
  addLegend("bottomright", pal = pal, values = ~field_type,
            title = "Field type",
#            labFormat = labelFormat(prefix = "$"),
            opacity = 1
  )

soil.num <- soil[, c(8:26)]
soil.num[(2:19)] <- lapply(soil.num[(2:19)], as.numeric)
soil.num2 <- soil.num[complete.cases(soil.num),]

corr.matrix <- as.data.frame(cor(soil.num))
library(corrplot)
corrplot(cor(soil.num2), type = "upper")

plant <- read.csv('plant_data.csv', na.strings = c('', 'na'))
plant.corn <- plant[which(plant$field_type=='corn field'), c(1:9, 19:20)]
plant.corn <- plant.corn[complete.cases(plant.corn), ]
library(plyr)
plant.corn.sum <- ddply(plant.corn, ~site_id, summarise, num_plant.mean=mean(Number.of.Plants...50.ft2), 
                        plants_per_acre.mean = mean(Plants...Acre))

soil.corn.merge <- merge(x=soil, y=plant.corn.sum, by="site_id", all.y = TRUE)
soil.corn.merge2 <- soil.corn.merge[, c(8:26, 34:35)]
scatterplotMatrix(soil.corn.merge2)

soil.corn.corrmatrix <- as.data.frame(cor(soil.corn.merge2))
soil.corn.corrmatrix

### Select covariates with Pearson's coef > 0.70

library(reshape2)
soil.corn.corrmatrix.melt <- subset(melt(cor(soil.corn.merge2)), value > .70)
soil.corn.corrmatrix.melt[(1:2)] <- lapply(soil.corn.corrmatrix.melt[(1:2)], as.character)
select <- !(soil.corn.corrmatrix.melt$Var1 == soil.corn.corrmatrix.melt$Var2)
soil.corn.corrmatrix.melt <- soil.corn.corrmatrix.melt[select, ]
soil.corn.corrmatrix.melt[rev(order(soil.corn.corrmatrix.melt$value)),]

corr.columns <- as.character(soil.corn.corrmatrix.melt$Var1)
corr.columns <- unique(corr.columns)

soil.corn.merge2.select <- soil.corn.merge2[, corr.columns]

### Evaluate relationships using scatterplot matrix

library(car)
library(ggplot2)
scatterplotMatrix(soil.corn.merge2.select)

#soil.corn.merge2.select <- soil.corn.merge2[ setdiff(names(soil.corn.merge2), corr.columns)]

corrplot(cor(soil.corn.merge2), type = "upper")

### Evaluate ranges of soil textures between samples

library(soiltexture)
colnames(soil2)[24] <- "SAND"
colnames(soil2)[25] <- "SILT"
colnames(soil2)[26] <- "CLAY"

geo <- TT.geo.get()

kde.res1 <- TT.kde2d(
  geo = geo,
  tri.data = soil2
)

soil2.hay <- soil2[which(field_type == "hay field"), ]
soil2.corn <- soil2[which(field_type == "corn field"), ]
soil2.woodlot <- soil2[which(field_type == "woodlot"), ]

plot.new()

geo <- TT.plot(class.sys   = "USDA.TT",
               tri.data    = soil2.hay,
               main        = "Range of Particle Size Data for all samples",
               col = "blue",
               cex = .7,
               cex.axis=.5,
               cex.lab=.6,
               lwd=.5,
               lwd.axis=0.5,
               lwd.lab=0.3)

TT.points(tri.data = soil2.corn,
          geo = geo,
          col = "red",
          cex = .1,
          pch = 3)

TT.points(tri.data = soil2.woodlot,
          geo = geo,
          #          dat.css.ps.lim  = c(0,2,63,2000),
          #          css.transf      = TRUE,
          col = "green",
          cex = .2,
          pch = 2)


### Evaluate range of CASH indicators between field types

soil2$all_fields <- "all field types"

library(dplyr)
sample.size <- ddply(soil2, ~field_type, summarise, n = n())
sample.size

attach(soil2)
### Surface Hardness
bartlett.test(Surface.Hardness ~ field_type, data = soil2)
### p-value > 0.05; the variance is the same for all treatment groups.  Use one-way ANOVA to evaluate difference between means of the groups.
aov.surf <- aov(Surface.Hardness ~ field_type, data = soil2)
aov.surf
summary(aov.surf)
print(model.tables(aov.surf, "effects", se = TRUE))
### ANOVA p-value < 0.05; Means are different between groups.

### Analyze means
tapply(X = Surface.Hardness, INDEX = list(field_type), FUN = mean)
### Pairwise comparisons of treatment groups
pairwise.t.test(Surface.Hardness, field_type, p.adj = "holm")
### Corn field and hay field treatments are not significantly different.  Woodlot treatments are different from both others.
var.test(Surface.Hardness ~ field_type.haycorn, soil2, alternative = "two.sided")
# F test suggests variance is not difference between new groups.
summary(aov(Surface.Hardness ~ field_type.haycorn, data = soil2))
# ANOVA of new groups suggests means are different.
boxplot( Surface.Hardness ~ field_type.haycorn, data = soil2, main = "Surface Hardness by Field type", xlab = "Field type", ylab = "Surface Hardness (psi)")

### Subsurface Hardness
bartlett.test(Subsurface.Hardness ~ field_type, data = soil2)
### Bartlett p-value < 0.05; variance appears different between field type groups; used Welch's test to assess means
oneway.test(Subsurface.Hardness ~ field_type, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA p-value < 0.05; Means are different between groups using parametric test.  Use Kruskal-Wallis test for non-parametric version.
kruskal.test(Subsurface.Hardness ~ field_type, soil2, na.action=na.omit)
### Kruskal-Wallis test also indicates difference between means.

### Analyze means
tapply(X = Subsurface.Hardness, INDEX = list(field_type), FUN = mean)
### Pairwise comparisons of treatment groups
pairwise.t.test(Subsurface.Hardness, field_type, p.adj = "holm")
### All treatments are significantly different
boxplot( Subsurface.Hardness ~ field_type, data = soil2, main = "Subsurface Hardness by Field type", xlab = "Field type", ylab = "Subsurface Hardness (psi)")

### Aggregate Stability
bartlett.test(Aggregate.Stability ~ field_type, data = soil2)
### p-value < 0.05; variance appears different between field type groups
oneway.test(Aggregate.Stability ~ field_type, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA p-value < 0.05; Means are different between groups using parametric test.  Use Kruskal-Wallis test for non-parametric version.
kruskal.test(Aggregate.Stability ~ field_type, soil2, na.action=na.omit)
### Kruskal-Wallis test also indicates difference between means.

### Analyze means
tapply(X = Aggregate.Stability, INDEX = list(field_type), FUN = mean)
### Pairwise comparisons of treatment groups
pairwise.t.test(Aggregate.Stability, field_type, p.adj = "holm")
### Hay field and woodlot treatments are not significantly different.  Corn field treatments are different from both others.
var.test(Aggregate.Stability ~ field_type.haywood, soil2, alternative = "two.sided")
### F test suggests variance is different between new groups.
oneway.test(Aggregate.Stability ~ field_type.haywood, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA suggests means are different between new groups.
boxplot( Aggregate.Stability ~ field_type.haywood, data = soil2, main = "Aggregate Stability by Field type", xlab = "Field type", ylab = "Aggregate Stability (%)")

### Organic Matter
bartlett.test(Organic.Matter ~ field_type, data = soil2)
### p-value < 0.05; variance appears different between field type groups
oneway.test(Organic.Matter ~ field_type, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA p-value < 0.05; Means are different between groups using parametric test.  Use Kruskal-Wallis test for non-parametric version.
kruskal.test(Organic.Matter ~ field_type, soil2, na.action=na.omit)
### Kruskal-Wallis test also indicates difference between means.

### Analyze means
tapply(X = Organic.Matter, INDEX = list(field_type), FUN = mean)
### Pairwise comparisons of treatment groups
pairwise.t.test(Organic.Matter, field_type, p.adj = "holm")
### Corn field and hay field treatments are not significantly different.  woodlot treatments are different from both others.
var.test(Organic.Matter ~ field_type.haycorn, soil2, alternative = "two.sided")
### F test suggests variance is not different between new groups.
summary(aov(Organic.Matter ~ field_type.haycorn, data = soil2))
# ANOVA of new groups suggests means are different.
boxplot( Organic.Matter ~ field_type.haycorn, data = soil2, main = "Organic Matter Content by Field type", xlab = "Field type", ylab = "Organic Matter (%)")

### Active carbon
bartlett.test(Active.Carbon ~ field_type, data = soil2)
### p-value > 0.05; the variance is the same for all treatment groups.  Use one-way ANOVA to evaluate difference between means of the groups.
aov.actC <- aov(Active.Carbon ~ field_type, data = soil2)
aov.actC
summary(aov.actC)
print(model.tables(aov.actC, "effects", se = TRUE))
### Cannot reject null hypothesis that there is no difference between the means.
boxplot( Active.Carbon ~ all_fields, data = soil2, main = "Active Carbon by Field type", xlab = "Field type", ylab = "Active Carbon (ppm)")

### ACE Soil Protein Index
bartlett.test(ACE.Soil.Protein.Index ~ field_type, data = soil2)
### p-value < 0.05; variance appears different between field type groups
oneway.test(ACE.Soil.Protein.Index ~ field_type, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA p-value < 0.05; Means are different between groups using parametric test.  Use Kruskal-Wallis test for non-parametric version.
kruskal.test(ACE.Soil.Protein.Index ~ field_type, soil2, na.action=na.omit)
### Kruskal-Wallis test also indicates difference between means.

### Analyze means
tapply(X = ACE.Soil.Protein.Index, INDEX = list(field_type), FUN = mean)
### Pairwise comparisons of treatment groups
pairwise.t.test(ACE.Soil.Protein.Index, field_type, p.adj = "holm")
### Corn field and hay field treatments are not significantly different.  woodlot treatments are different from both others.
var.test(ACE.Soil.Protein.Index ~ field_type.haycorn, soil2, alternative = "two.sided")
### F test suggests variance is different between new groups.
oneway.test(ACE.Soil.Protein.Index ~ field_type.haycorn, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA suggests means are different between new groups.
boxplot( ACE.Soil.Protein.Index ~ field_type.haycorn, data = soil2, main = "ACE Soil Protein Index by Field type", xlab = "Field type", ylab = "ACE Soil Protein Index (mg/g-soil)")

### Microbial Respiration
bartlett.test(Respiration ~ field_type, data = soil2)
### p-value > 0.05; the variance is the same for all treatment groups.  Use one-way ANOVA to evaluate difference between means of the groups.
aov.resp <- aov(Respiration ~ field_type, data = soil2)
aov.resp
summary(aov.resp)
print(model.tables(aov.resp, "effects", se = TRUE))
### ANOVA p-value < 0.05; Means are different between groups.

### Analyze means
tapply(X = Respiration, INDEX = list(field_type), FUN = mean)
### Pairwise comparisons of treatment groups
pairwise.t.test(Respiration, field_type, p.adj = "holm")
### Hay field and woodlot treatments are not significantly different.  Corn field treatments are different from both others.
var.test(Respiration ~ field_type.haywood, soil2, alternative = "two.sided")
### F test suggests variance is different between new groups.
oneway.test(Respiration ~ field_type.haywood, data=soil2, na.action=na.omit, var.equal=FALSE)
### Welch ANOVA suggests means are different between new groups.

boxplot( Respiration ~ field_type.haywood, data = soil2, main = "Microbial respiration by Field type, 4-day incubation", xlab = "Field type", ylab = "Microbial respiration (mg)")
>>>>>>> origin/master
