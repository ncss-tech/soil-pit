library(aqp)
library(ggplot2)
library(plyr)

surf <- read.csv("~/Projects_15/POXnBgluc/Q_sh_surface-complete.csv")
str(surf)
ped <- read.csv("~/Projects_15/POXnBgluc/Q_SH_pedon_tax.csv")


levels(surf$analyte_abbrev)

#dataset for ??-Glucosidase
B <- surf[which(surf$analyte_abbrev=="PNitrophen"),]
BG <- join(G, ped, by="lims_pedon_id", type= "left", match="first")

summary(as.numeric(BG$analyte_val))

BG$Bgluc <- BG$analyte_val

summary(BG$Bgluc)
boxplot(BG$Bgluc)

boxplot(BG$Bgluc,data=BG, main="All Surface Samples", ylab="??-Glucosidase") 





dsp_BG <- surf[!is.na(surf$POX_C),]
summary(dsp_BG$POX_C)
dsp_BG <- droplevels(dsp_BG)

levels(dsp_BG$Soil)

B <- qplot(Soil, POX_C, data=dsp_BG, color=COND, geom="boxplot")+ ggtitle("All Soils and Conditions")
B
