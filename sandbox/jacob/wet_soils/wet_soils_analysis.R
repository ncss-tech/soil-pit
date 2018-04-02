# Author: Jacob Isleib
# Soil taxonomy "wet" soil order data analysis

setwd("C:/workspace/sandbox/jacob/wet_soils")
.pardefault <- par()

#check for SAS pedons to be added; these are known sampled SAS pedons originating from Stolt lab
sas.pedons <- as.factor(c('07N0032', '07N0034', '07N0038', '07N0039', '07N0040', 'GR04', 'GR05', 'GR09', 'GR12', 'URI0001', 'URI0002', 'URI0003', 'URI0004', 'URI0005', 'URI0006', 'URI0007', 'URI0008', 'URI0404NP', 'URI0603GB', 'URI0604GB', 'URI0605GB', 'URI0606WH', 'URI0607GB', 'URI0607WH', 'URI0608GB', 'URI0608WH', 'URI0609WH', 'URI0705PJ', 'URI0706PJ', 'URI0707PJ', 'URI0708PJ', 'URI0710PJ', 'URI0711PJ', 'URI0712PJ', 'URI0713PJ', 'URI0714PJ', 'URI0801NP', 'URI0802NP', 'URI0803NP', 'URI0804NP', 'URI0805NP', 'URI0806NP', 'URI0807NP', 'URI0808NP', 'URI0809NP', 'URI0810NP', 'URI0811QP', 'URI0812QP', 'URI0813QP', 'URI0901QP', 'URI0902QP', 'URI0903QP', 'URI0904QP', 'URI0905QP', 'URI0906QP', 'URI0907PJ', 'URI0908PJ', 'URI0909PJ', 'URI0911PJ', 'URI0912PJ', 'URI0913PJ', 'URI0916NP', 'URI0917NP', 'URI0918NP', 'URI0919NP', 'URI130901', 'URI130902', 'URI130903', 'URI130904', 'URI130905', 'URI130906'))
sas.pedons <- sort(sas.pedons)

############################
# Data wrangling
############################

# load csv export from KSSL MSAccess database
# had to manually fix horizon depth errors (NA hzn_bot depths)
ksslraw <- read.csv("access_export.csv", header=TRUE, na.strings ="")
#remove R horizons
ksslraw <- ksslraw[ksslraw$hzn_master != "R", ]
ksslraw <- unique(ksslraw)

library(plyr)

# Remove histosols (histosols would not key out into a wet soils order)

ksslraw["thickness"] <- (ksslraw$hzn_bot-ksslraw$hzn_top)
ksslraw.histqc <- ksslraw[which(ksslraw$hzn_bot<= 130), ]
ksslraw.histqc <- ksslraw.histqc[which(ksslraw.histqc$hzn_master=='O'),]
ksslraw.histqc.sum <- ddply(ksslraw.histqc, ~pedlabsampnum1, summarise, thickness.sum=sum(thickness))
ksslraw.histqc.sum.hist <- ksslraw.histqc.sum[which(ksslraw.histqc.sum$thickness.sum >=40),]
histosols <-  ksslraw.histqc.sum.hist$pedlabsampnum1
ksslraw <- ksslraw[!(ksslraw$pedlabsampnum1 %in% histosols), ]

#Check for inclusion of SAS pedons
sas.pedons.qc <- ksslraw[which(ksslraw$pedlabsampnum1 %in% sas.pedons),]
length(unique(sas.pedons.qc$pedlabsampnum1))

#######
# Color
#######

# export phorizon color data from NASIS using report 'Pedon Horizon Color and Lab Sample Number, comma delim v2'
phcolor <- read.csv("phcolor.csv", header=TRUE)
#change color percentage type from integer to double
phcolor$color_pct <- as.double(phcolor$color_pct)
# change blanks to NA
phcolor[phcolor==""] <- NA
# remove erroneous data with NA Hue
phcolor <- phcolor[complete.cases(phcolor$hue), ]
# change NA chroma to zero
phcolor$chroma[is.na(phcolor$chroma)] <- 0
unique(phcolor$colormoistst)
which(is.na(phcolor$colormoistst))
phcolor$colormoistst[is.na(phcolor$colormoistst)] <- "moist"
str(phcolor$colormoistst)
phcolor <- phcolor[which(phcolor$colormoistst=="moist"),]
#remove duplicate values with same Hue, Value, Chroma
phcolor <- unique(phcolor)
phcolor <- phcolor[!(phcolor$colorphysst %in% 'pyrophosphate extract'), ]

#check for lost SAS pedons
phcolor.sas.qc <- phcolor[(phcolor$lab_sample_num %in% sas.pedons.qc$labsampnum1), ]

#Qc color_pct
library(plyr)
library(dplyr)
phcolorpctna <- phcolor[which(is.na(phcolor$color_pct)),]
phcolorpctnotna <- phcolor[which(!is.na(phcolor$color_pct)),]

#QC 
phcolorpctnotnanot100 <- phcolorpctnotna[which(phcolorpctnotna$color_pct < 100),]
phcolorpctnotna100 <- phcolorpctnotna[which(phcolorpctnotna$color_pct == 100),]
phcolorpctnotna.sum <- ddply(phcolorpctnotna100, ~lab_sample_num, summarise, n=n())
max(phcolorpctnotna.sum$n)
#if this is >3, add QC below!

notna.n1 <- which(phcolorpctnotna.sum$n ==1)
lab_sample_num.notna.n1 <- as.character(phcolorpctnotna.sum$lab_sample_num[notna.n1])
lab_sample_num.notna.n1 <- as.factor(lab_sample_num.notna.n1)
phcolorpctnotna.n1 <- phcolorpctnotna[phcolorpctnotna$lab_sample_num %in% lab_sample_num.notna.n1,]

notna.n2 <- which(phcolorpctnotna.sum$n ==2)
lab_sample_num.notna.n2 <- as.character(phcolorpctnotna.sum$lab_sample_num[notna.n2])
lab_sample_num.notna.n2 <- as.factor(lab_sample_num.notna.n2)
phcolorpctnotna.n2 <- phcolorpctnotna[phcolorpctnotna$lab_sample_num %in% lab_sample_num.notna.n2,]
physst1 <- as.factor(c("interior", "broken face", "reduced"))
phcolorpctnotna.n2.fixed  <- phcolorpctnotna.n2[(phcolorpctnotna.n2$colorphysst %in% physst1), ]

notna.n3 <- which(phcolorpctnotna.sum$n ==3)
lab_sample_num.notna.n3 <- as.character(phcolorpctnotna.sum$lab_sample_num[notna.n3])
lab_sample_num.notna.n3 <- as.factor(lab_sample_num.notna.n3)
phcolorpctnotna.n3 <- phcolorpctnotna[phcolorpctnotna$lab_sample_num %in% lab_sample_num.notna.n3,]
phcolorpctnotna.n3.fixed  <- phcolorpctnotna.n3[(phcolorpctnotna.n3$colorphysst %in% physst1), ]

#put back together
phcolorpctnotna.fixed <- rbind(phcolorpctnotnanot100, phcolorpctnotna.n1, phcolorpctnotna.n2.fixed, phcolorpctnotna.n3.fixed)

length(unique(phcolorpctnotna.fixed$lab_sample_num)) == length(unique(phcolorpctnotna$lab_sample_num))
#If FALSE, QC for lost horizons

# summarize data by lab_sample_num to identify horizons with multiple colors and NA color percentage
phcolorpctnasum <- ddply(phcolorpctna, ~lab_sample_num, summarise, n=n())
                      #totcolor_pct=sum(color_pct))
max(phcolorpctnasum$n)
# max=5
# subset dataframe for each n
n1 <- which(phcolorpctnasum$n == 1)
lab_sample_num.n1 <- as.character(phcolorpctnasum$lab_sample_num[n1])
lab_sample_num.n1 <- as.factor(lab_sample_num.n1)
phcolorpctna.n1 <- phcolorpctna[phcolorpctna$lab_sample_num %in% lab_sample_num.n1,]
# change NA to 100 percent
phcolorpctna.n1$color_pct[is.na(phcolorpctna.n1$color_pct)] <- 100

n2 <- which(phcolorpctnasum$n == 2)
lab_sample_num.n2 <- as.character(phcolorpctnasum$lab_sample_num[n2])
lab_sample_num.n2 <- as.factor(lab_sample_num.n2)
phcolorpctna.n2 <- phcolorpctna[phcolorpctna$lab_sample_num %in% lab_sample_num.n2,]
#subset by physical state is NA, interior, or broken face
physst.qc <- unique(phcolorpctna.n2$colorphysst)
droplevels(physst.qc)
#physst2 <- as.factor(c(NA, "interior", "broken face"))
physst2 <- as.factor(c("exterior", "crushed"))
phcolorpctna.n2.2 <- phcolorpctna.n2[!(phcolorpctna.n2$colorphysst %in% physst2),]
#summarize to see how many color rows per subset lab_sample_num
phcolorpctna.n2.2sum <- ddply(phcolorpctna.n2.2, ~lab_sample_num, summarise, n=n())
#select lab_sample_num that now only have 1 color
n2.1 <- which(phcolorpctna.n2.2sum$n == 1)
lab_sample_num.n2.1 <- as.character(phcolorpctna.n2.2sum$lab_sample_num[n2.1])
lab_sample_num.n2.1 <- as.factor(lab_sample_num.n2.1)
phcolorpctna.n2.1 <- phcolorpctna.n2.2[phcolorpctna.n2.2$lab_sample_num %in% lab_sample_num.n2.1,]
# change NA to 100 percent
phcolorpctna.n2.1$color_pct[is.na(phcolorpctna.n2.1$color_pct)] <- 100
#select remaining lab_sample_num that still have n=2 colors
n2.2 <- which(phcolorpctna.n2.2sum$n == 2)
lab_sample_num.n2.2 <- as.character(phcolorpctna.n2.2sum$lab_sample_num[n2.2])
lab_sample_num.n2.2 <- as.factor(lab_sample_num.n2.2)
phcolorpctna.n2.2.2 <- phcolorpctna.n2.2[phcolorpctna.n2.2$lab_sample_num %in% lab_sample_num.n2.2,]
# change NA to 50 percent
phcolorpctna.n2.2.2$color_pct[is.na(phcolorpctna.n2.2.2$color_pct)] <- 50
# recombine data frames
phcolorpctna.n2rbind <- rbind(phcolorpctna.n2.1, phcolorpctna.n2.2.2)

#QC for lost horizons
length(unique(phcolorpctna.n2$lab_sample_num)) == length(unique(phcolorpctna.n2rbind$lab_sample_num))
n2qc1 <- unique(phcolorpctna.n2$lab_sample_num)
n2qc2 <- unique(phcolorpctna.n2rbind$lab_sample_num)

#if FALSE, check subsetting by physical state to see what samples were lost

n3 <- which(phcolorpctnasum$n == 3)
lab_sample_num.n3 <- as.character(phcolorpctnasum$lab_sample_num[n3])
phcolorpctna.n3 <- phcolorpctna[phcolorpctna$lab_sample_num %in% lab_sample_num.n3,]
phcolorpctna.n3$color_pct[is.na(phcolorpctna.n3$color_pct)] <- (100/3)

n4 <- which(phcolorpctnasum$n == 4)
lab_sample_num.n4 <- as.character(phcolorpctnasum$lab_sample_num[n4])
phcolorpctna.n4 <- phcolorpctna[phcolorpctna$lab_sample_num %in% lab_sample_num.n4,]
phcolorpctna.n4$color_pct[is.na(phcolorpctna.n4$color_pct)] <- 25

n5 <- which(phcolorpctnasum$n == 5)
lab_sample_num.n5 <- as.character(phcolorpctnasum$lab_sample_num[n5])
phcolorpctna.n5 <- phcolorpctna[phcolorpctna$lab_sample_num %in% lab_sample_num.n5,]
phcolorpctna.n5$color_pct[is.na(phcolorpctna.n5$color_pct)] <- 20

phcolorpctna.fixed <- rbind(phcolorpctna.n1, phcolorpctna.n2rbind, phcolorpctna.n3, phcolorpctna.n4, phcolorpctna.n5)

#QC for lost horizons
length(unique(phcolorpctna$lab_sample_num)) == length(unique(phcolorpctna.fixed$lab_sample_num))
#if FALSE, check to see what samples were lost

missing <- phcolorpctna[!(phcolorpctna$lab_sample_num %in% phcolorpctna.fixed$lab_sample_num),]

phcolor.fixed <- rbind(phcolorpctnotna.fixed, phcolorpctna.fixed)
colnames(phcolor.fixed)[7] <- "labsampnum1"

#check for lost SAS pedons
phcolor.fixed.sas.qc <- phcolor.fixed[(phcolor.fixed$labsampnum1 %in% sas.pedons.qc$labsampnum1), ]

###############
# Horizon Depth
###############

#horizon depth QC
ksslraw <- ksslraw[complete.cases(ksslraw$hzn_top),]
ksslraw.qc <- ksslraw[which(is.na(ksslraw$hzn_bot)),]
missinghzn_bot <- ksslraw.qc$pedlabsampnum1
missinghzn_bot <- factor(missinghzn_bot)
ksslraw.hzn_bot.na <- ksslraw[ksslraw$pedlabsampnum1 %in% missinghzn_bot, ]
#write.csv(ksslraw.hzn_bot.na, file="ksslraw.hzn_bot.na.csv")
olmaster <- c('L', 'O')
ksslraw.hzn_bot.notna <- ksslraw[!(ksslraw$pedlabsampnum1 %in% missinghzn_bot), ]
ksslraw.hzn_bot.na <- mutate(ksslraw.hzn_bot.na, hzn_bot = 
                               ifelse(user_site_id == 'S2012VT003012', hzn_top +5, 
                                      ifelse(is.na(hzn_bot) & (hzn_master %in% olmaster), 0, 
                                             ifelse(is.na(hzn_bot), hzn_top + 5, hzn_bot))))
#QC, result should be zero
which(is.na(ksslraw.hzn_bot.na$hzn_bot))
##
# STOP SCRIPT, manually fix horizon depth errors, save fixed csv as 
##
#ksslraw.hzn_bot.na <- read.csv("ksslraw.hzn_bot.na_FIXED.csv", header= TRUE, na.strings ="", row.names = 1, stringsAsFactors=FALSE)
ksslraw <- rbind(ksslraw.hzn_bot.na, ksslraw.hzn_bot.notna)
#check to see if NAs are all fixed
which(is.na(ksslraw$hzn_top))
which(is.na(ksslraw$hzn_bot))

# fix horizon depth errors involving O and L horizons
ksslraw.hznerror <- ksslraw[which(ksslraw$hzn_bot<ksslraw$hzn_top),]
hzerror.labsampnum1 <- ksslraw.hznerror$labsampnum1
ksslraw.hznerror.sum <- ddply(ksslraw.hznerror, ~pedlabsampnum1, summarise, hzn_top.max=max(hzn_top))
ksslraw <- merge(x=ksslraw, y=ksslraw.hznerror.sum, by="pedlabsampnum1", all.x = TRUE)
ksslraw$hzn_top.max[is.na(ksslraw$hzn_top.max)] <- 0
# change O and L horizons with negative depths to negative values
ksslraw <- mutate(ksslraw, hzn_top = ifelse(labsampnum1 %in% hzerror.labsampnum1, hzn_top*(-1), hzn_top))
ksslraw <- mutate(ksslraw, hzn_bot = ifelse(labsampnum1 %in% hzerror.labsampnum1, hzn_bot*(-1), hzn_bot))
# add total thickness of O and L above zero depth to updated depths
ksslraw$hzn_top <- (ksslraw$hzn_top + ksslraw$hzn_top.max)
ksslraw$hzn_bot <- (ksslraw$hzn_bot + ksslraw$hzn_top.max)
# QC check on corrected data
which(ksslraw$hzn_top > ksslraw$hzn_bot)
#check to see if hzn_bot is > hzn top
ksslraw.qc2 <- ksslraw[which(ksslraw$hzn_bot == ksslraw$hzn_top),]

# inner join fixed PHorizon Color data with KSSL MSAccess export
ksslidsthk <- ksslraw[, c(1, 3, 9:10)]
avgchroma <- merge(ksslidsthk, phcolor.fixed, by="labsampnum1")

# average chroma and hue in upper 50cm calc

hue <- c('5R', '7.5R', '10R', '2.5YR', '5YR', '7.5YR', '10YR', '2.5Y', '5Y', '10Y', '5GY', '10GY', '5G', '10G', '5BG', '10BG', '5B', '10B', '5PB', 'N')
hue_num <- c(9, 8, 7, 6, 5, 4, 3, 2, 1, 0,0,0,0,0,0,0,0,0,0,0)
hue_conv <- data.frame(hue, hue_num)

# select applicable columns and only rows with top_depth <50cm
avgchroma <- avgchroma[which(avgchroma$hzn_top<50), ]
avgchroma$hzn_bot[avgchroma$hzn_bot>50] <- 50
avgchroma$color_pct <- (avgchroma$color_pct/100)
avgchroma["thickness"] <- ((avgchroma$hzn_bot - avgchroma$hzn_top)*avgchroma$color_pct)
avgchroma <- merge(x=avgchroma, y=hue_conv, by = 'hue')
avgchroma <- avgchroma[, c(2:6, 1, 12, 7:11)]

avgchroma["chroma.mult"] <- (avgchroma$color_pct*avgchroma$chroma*avgchroma$thickness)
avgchroma["hue.mult"] <- (avgchroma$color_pct*avgchroma$hue_num*avgchroma$thickness)
avgchroma.sum <- ddply(avgchroma, ~labsampnum1, summarise, chroma.mult.sum=sum(chroma.mult),
                       hue.mult.sum=sum(hue.mult),
                       chroma.thickness.sum=sum(thickness))

#QC check; should result in zero
which(avgchroma.sum$thickness.sum<0)
kssl.sampnumkey <- ksslraw[, c(1, 3)]
kssl.sampnumkey <- unique(kssl.sampnumkey)
pedon.avgchroma <- merge(x=avgchroma.sum, y=kssl.sampnumkey, by = "labsampnum1")
pedon.avgchroma.sum <- ddply(pedon.avgchroma, ~pedlabsampnum1, summarise, wtavgchroma50cm = (sum(chroma.mult.sum))/(sum(chroma.thickness.sum)), 
                             wtavghue50cm = (sum(hue.mult.sum))/(sum(chroma.thickness.sum)))
# Round wt avg chroma and change data type to integer
pedon.avgchroma.sum[,'wtavgchroma50cm'] = (round(pedon.avgchroma.sum[, 'wtavgchroma50cm'], digits = 1))
pedon.avgchroma.sum[,'wtavghue50cm'] = (round(pedon.avgchroma.sum[, 'wtavghue50cm'], digits = 1))

# depth to "depleted matrix" (value >=4, chroma <=2)
deplmatrix <- merge(ksslidsthk, phcolor.fixed, by="labsampnum1")
deplmatrix <- deplmatrix[which(deplmatrix$color_pct >= 50 & deplmatrix$value >= 4 & deplmatrix$chroma<= 2), ]
deplmatrix.sum <- ddply(deplmatrix, ~pedlabsampnum1, summarise, min.hzn_top=min(hzn_top))
colnames(deplmatrix.sum)[2] <- "deplmtrx_top"

# average dith.fe in upper 50 cm
avgdithfe <- ksslraw[which(ksslraw$hzn_top<50), c(1, 9:10, 52)]
avgdithfe <- avgdithfe[complete.cases(avgdithfe$fe_dith),]
avgdithfe$hzn_bot[avgdithfe$hzn_bot>50] <- 50
avgdithfe["thickness"] <- (avgdithfe$hzn_bot - avgdithfe$hzn_top)
avgdithfe["mult"] <- (avgdithfe$fe_dith*avgdithfe$thickness)
avgdithfe.sum <- ddply(avgdithfe, ~pedlabsampnum1, summarise, avgdithfe50cm = (sum(mult)/sum(thickness)))
avgdithfe.sum[,'avgdithfe50cm'] = round(avgdithfe.sum[, 'avgdithfe50cm'], digits = 1)

# depth to gley hue
gleyhue <- as.factor(c("N", "10Y", "5GY", "10GY", "5G", "10G", "5BG", "10BG", "5B", "10B", "5PB"))
allgleyhue <- merge(ksslidsthk, phcolor.fixed, by="labsampnum1")
allgleyhue <- allgleyhue[allgleyhue$hue %in% gleyhue, c(1:3, 6)]
depthgleyhue.sum <- ddply(allgleyhue, ~pedlabsampnum1, summarise, depthgleyhue = min(hzn_top))

# clay difference calc
claytop <- ksslraw[complete.cases(ksslraw$clay_tot_psa), c(1,3,9,15)]
claytop.sum <- ddply(claytop, ~pedlabsampnum1, summarise, minhzn_top=min(hzn_top))
claytop <- merge(x = claytop, y = claytop.sum, by = "pedlabsampnum1", all.x = TRUE)
claytop <- claytop[claytop$hzn_top == claytop$minhzn_top, c(1,4)]
# aggregate data for pedons that have multiple horizons matching the min top depth
claytop.qc <- ddply(claytop, ~pedlabsampnum1, summarise, n=n(), top_clay_avg=mean(clay_tot_psa))

subsurfmasterhzn <- as.factor(c('^B', '^BC', '^CB', '^C', 'B', 'BC', 'CB', 'C'))
claybot <- ksslraw[(ksslraw$hzn_master %in% subsurfmasterhzn) & complete.cases(ksslraw$clay_tot_psa), c(1,3,9,15,61)]
claybot.sum <- ddply(claybot, ~pedlabsampnum1, summarise, minhzn_top=min(hzn_top))
claybot <- merge(x= claybot, y= claybot.sum, by = "pedlabsampnum1", all.x = TRUE)
claybot <- claybot[claybot$hzn_top == claybot$minhzn_top, c(1,4)]
# aggregate data for pedons that have multiple horizons matching the min top depth
claybot.qc <- ddply(claybot, ~pedlabsampnum1, summarise, n=n(), bot_clay_avg=mean(clay_tot_psa))

claydiff <- merge(claytop.qc[, c(1, 3)], claybot.qc[, c(1,3)], by = "pedlabsampnum1")
claydiff["clay_diff"] <- round((claydiff$bot_clay_avg - claydiff$top_clay_avg), digits = 1)
claydiff <- claydiff[, c(1,4)]

# carbon content at 30cm
oc_30cm <- ksslraw[ksslraw$hzn_top <= 30 & ksslraw$hzn_bot >= 30 & !(is.na(ksslraw$final_oc)), c(1, 73)]
# account for pedons with horizon breaks at 30cm, take highest oc value
oc_30cm.sum <- ddply(oc_30cm, ~pedlabsampnum1, summarise, oc30cm=max(final_oc))

# load drainage class
# Use 'MLRA12Office>>Pedon Lab sample number and drainage class' report on selected set in NASIS
drainagecl <- read.csv("drainagecl.csv", header=TRUE, na.strings = '')
drainagecl <- unique(drainagecl)
colnames(drainagecl)[1] <- "pedlabsampnum1"

drainagecl.sas <- drainagecl[(drainagecl$pedlabsampnum1 %in% sas.pedons),]
drainagecl.sas$drainage_cl[!(drainagecl.sas$drainage_cl == 'subaqueous')] <- 'subaqueous'
drainagecl.sas$drainage_cl[is.na(drainagecl.sas$drainage_cl)] <- 'subaqueous'
drainagecl.nonsas <- drainagecl[!(drainagecl$pedlabsampnum1 %in% sas.pedons),]
drainagecl <- rbind(drainagecl.sas, drainagecl.nonsas)

drainagecl.na <- drainagecl[is.na(drainagecl$drainage_cl), ]
drainagecl.notna <- drainagecl[!(is.na(drainagecl$drainage_cl)), ]

### Fix missing drainage classes
#load master list of taxon_name and drainage class, exported from NASIS using *all* pedons.sites
#use MLRA12_Office report 'Drainage class, master dataframe, ALL nasis sites and pedons'

library(data.table)
master.drainagecl <-read.csv("masterdrainagcl.csv", header=TRUE, na.strings ="")
master.drainagecl$taxon_name <- as.character(master.drainagecl$taxon_name)
master.drainagecl$taxon_name <- tolower(master.drainagecl$taxon_name)

#create first letter capitalize function
capwords <- function(s, strict = FALSE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
                           {s <- substring(s, 2); if(strict) tolower(s) else s},
                           sep = "", collapse = " " )
  sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}

master.drainagecl$taxon_name <- capwords(master.drainagecl$taxon_name)
master.drainagecl$taxon_name <- as.factor(master.drainagecl$taxon_name)
master.drainagecl <- master.drainagecl[complete.cases(master.drainagecl),]
master.drainagecl.sum <- group_by(master.drainagecl, taxon_name, drainage_cl) %>% count(taxon_name, drainage_cl)
master.drainagecl.sum2 <- ddply(master.drainagecl.sum, ~taxon_name, summarise, n=max(n))
master.drainagecl.sum3 <- inner_join(master.drainagecl.sum2, master.drainagecl.sum, by= c("taxon_name", "n"))
# subset for duplicated taxon_names
master.drainagecl.sum3.error <- master.drainagecl.sum3[duplicated(master.drainagecl.sum3$taxon_name),]

kssl_drainagecl_na <- ksslraw[(ksslraw$pedlabsampnum1 %in% drainagecl.na$pedlabsampnum1), c(1:2, 4:5)]
kssl_drainagecl_na <- unique(kssl_drainagecl_na)
kssl_drainagecl_na["taxon_name"] <- ifelse(is.na(kssl_drainagecl_na$correlated_taxon_name), as.character(kssl_drainagecl_na$sampled_taxon_name), as.character(kssl_drainagecl_na$correlated_taxon_name))
kssl_drainagecl_na$taxon_name <- as.factor(kssl_drainagecl_na$taxon_name)
kssl_drainagecl_na.merge <- merge(x= kssl_drainagecl_na, y= master.drainagecl.sum3, by="taxon_name", all.x = TRUE)
kssl_drainagecl_na.merge.error <- kssl_drainagecl_na.merge[duplicated(kssl_drainagecl_na.merge$pedlabsampnum1),]
kssl_drainagecl_na.merge.error2 <- kssl_drainagecl_na.merge[kssl_drainagecl_na.merge$pedlabsampnum1 %in% kssl_drainagecl_na.merge.error$pedlabsampnum1, ]
kssl_drainagecl_na.merge.error2 <- kssl_drainagecl_na.merge.error2[c(1, 3, 6, 7, 11, 13, 15), ]
kssl_drainagecl_na.merge.ok <- kssl_drainagecl_na.merge[!(kssl_drainagecl_na.merge$pedlabsampnum1 %in% kssl_drainagecl_na.merge.error$pedlabsampnum1), ]
kssl_drainagecl_na.merge <- rbind(kssl_drainagecl_na.merge.ok, kssl_drainagecl_na.merge.error2)
drainagecl.na2 <- kssl_drainagecl_na.merge[, c(2, 7)]
drainagecl.na2$drainage_cl <- droplevels(drainagecl.na2$drainage_cl)
drainagecl <- rbind(drainagecl.na2, drainagecl.notna)

# create data frame to summarize which SAS pedons are missing analysis variables
sas.pedon.avgchroma <- pedon.avgchroma.sum$pedlabsampnum1[pedon.avgchroma.sum$pedlabsampnum1 %in% sas.pedons]
avg_chroma <- sas.pedons %in% sas.pedon.avgchroma

sas.depthgleyhue <- depthgleyhue.sum$pedlabsampnum1[depthgleyhue.sum$pedlabsampnum1 %in% sas.pedons]
depth_gleyhue <- sas.pedons %in% sas.depthgleyhue

sas.claydiff <- claydiff$pedlabsampnum1[claydiff$pedlabsampnum1 %in% sas.pedons]
clay_diff <- sas.pedons %in% sas.claydiff

sas.oc_30cm <- oc_30cm$pedlabsampnum1[oc_30cm$pedlabsampnum1 %in% sas.pedons]
oc30cm  <- sas.pedons %in% sas.oc_30cm

sas.deplmatrix <- deplmatrix.sum$pedlabsampnum1[deplmatrix.sum$pedlabsampnum1 %in% sas.pedons]
depth_deplmatrix  <- sas.pedons %in% sas.deplmatrix

sas.variable.sum <- data.frame(avg_chroma, depth_gleyhue, clay_diff, oc30cm, depth_deplmatrix, row.names = sas.pedons)

# join back to merge dataset
wetsoildata <- merge(x= pedon.avgchroma.sum, y=avgdithfe.sum, by ="pedlabsampnum1", all = TRUE)
wetsoildata <- merge(x= wetsoildata, y=depthgleyhue.sum, by ="pedlabsampnum1", all = TRUE)
wetsoildata <- merge(x= wetsoildata, y=claydiff, by ="pedlabsampnum1", all = TRUE)
wetsoildata <- merge(x= wetsoildata, y=oc_30cm.sum, by ="pedlabsampnum1", all = TRUE)
wetsoildata <- merge(x= wetsoildata, y=deplmatrix.sum, by ="pedlabsampnum1", all = TRUE)
wetsoildata <- merge(x= wetsoildata, y=drainagecl, by = "pedlabsampnum1", all.x = TRUE)

wetsoildata1 <- wetsoildata[, c(1:3, 6:9)]
#wetsoildata1 <- wetsoildata1[complete.cases(wetsoildata1[, c(1:6)]),]
#wetsoildata1 <- wetsoildata1[complete.cases(wetsoildata1),]
wetsoildata1 <- na.omit(wetsoildata1)
#wetsoildata1 <- droplevels.data.frame(wetsoildata1)
wetsoildata1.sum <- ddply(wetsoildata1, ~drainage_cl, summarise, n=n())

#check number of SAS pedons
length(which(wetsoildata1$drainage_cl == 'subaqueous'))

############################
# Analysis
############################

library(ggplot2)
library(car)

datacomplete.cat <- wetsoildata1$drainage_cl
datacomplete.cont <- wetsoildata1[, c(2:6)]
datacomplete.cont <- na.omit(datacomplete.cont)
n_occur <- data.frame(table(datacomplete.cat))
str(datacomplete.cont)
str(datacomplete.cat)

datapca <- prcomp(datacomplete.cont, scale = TRUE)
print(datapca)
summary(datapca)
x <- predict(datapca, datacomplete.cont)
length(datacomplete.cat)
length(datacomplete.cont)

# Create correlation matrix
round(cor(datacomplete.cont), 2)

#scatterplot matrix
spm(datacomplete.cont)

# PCA biplot groups and labels by drainage class
library(devtools)
library(ggbiplot)

g1 <- ggbiplot(datapca, obs.scale = 1, var.scale = 1#, 
              #groups = datacomplete.cat, ellipse = TRUE, 
              )#labels = datacomplete.cat, circle = FALSE)
g1 <- g1 + scale_color_discrete(name = '')
g1 <- g1 + theme(legend.direction = 'horizontal', 
               legend.position = 'top')
print(g1)

g2 <- ggbiplot(datapca, obs.scale = 1, var.scale = 1, 
              groups = datacomplete.cat, ellipse = TRUE, 
              labels = datacomplete.cat, circle = FALSE)
g2 <- g2 + scale_color_discrete(name = '')
g2 <- g2 + theme(legend.direction = 'horizontal', 
               legend.position = 'top')
print(g2)

# Without the DCB Fe and the histosols pedons, the subaqueous drainage class isn't isolated off by itself (like the initial analysis) and the very poorly doesn't range so far along the y-axis (oc @30cm is correlated close to the PC2/y-axis).  I think this illustrates that data we fed the PCA does a pretty good job of approximating differences in the pedons based on wetness.  We see a consecutive trend along the x-axis of wetter drainage class with positive PC1 values.

# Perform hard clustering and evaluate silhouette widths to aid in determining appropriate number of clusters

library(cluster)
data.std <- data.frame(datacomplete.cont, scale(datacomplete.cont))
sil.widths <- vector(mode='numeric')

for(i in 2:10) {
  
  cl <- pam(data.std, k = i, stand = FALSE)
  
  sil.widths[i] <- cl$silinfo$avg.width
  
}
#par(mar=c(4,4,3,1))
par(mar=c(3,3,3,1))
plot(sil.widths, type='b', xlab='Number of Clusters', ylab='Average Silhouette Width', las=1, lwd=2, col='RoyalBlue', cex=1.25, main='Finding the "Right" Number of Clusters')

grid()

# other silhouette width plots
library(factoextra)
fviz_nbclust(data.std, pam, method = "wss") #+
#geom_vline(xintercept = 2, linetype = 2)

fviz_nbclust(data.std, pam, method = "silhouette")
fviz_nbclust(data.std, hcut, method = "silhouette",
             hc_method = "complete")

# The silhouette widths suggest that 2 clusters are the most meaningful.

# More plotting k-medoids clusters

data.res.2 <- pam(scale(datacomplete.cont), 2)
data.res.2$medoids
clusplot(data.res.2, main = "Cluster plot, k = 2", 
         color = TRUE)
library(factoextra)
fviz_cluster(data.res.2, data = datacomplete.cont)

data.res.3 <- pam(scale(datacomplete.cont), 3)
data.res.3$medoids
clusplot(data.res.3, main = "Cluster plot, k = 3", 
         color = TRUE)
library(factoextra)
fviz_cluster(data.res.3, data = datacomplete.cont)

data.res.4 <- pam(scale(datacomplete.cont), 4)
data.res.4$medoids
clusplot(data.res.4, main = "Cluster plot, k = 4", 
         color = TRUE)
library(factoextra)
fviz_cluster(data.res.4, data = datacomplete.cont)

library(RColorBrewer)
# nice colors for later
col.set <- brewer.pal(9, 'Set1')

# Combine K-medoids and category data and box plot
combinek2 <- data.frame(datacomplete.cat, data.res.2$clustering)
par(cex.axis=.5)
boxplot(data.res.2.clustering ~ datacomplete.cat, data=combinek2, axes = FALSE)
box()
axis(side = 1, at = combinek2$datacomplete.cat, labels= combinek2$datacomplete.cat)
axis(side = 2, at = c(1,2, -1))
title(ylab = "cluster", xlab="drainage class")

library(plyr)

ggplot(combinek2, aes(x=data.res.2.clustering)) +
  geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
                 binwidth=.05,
                 colour="black", fill="white") +
  geom_density(alpha=.2, fill="#FF6666") +   # Overlay with transparent density plot
  facet_wrap(~ datacomplete.cat) +
  scale_x_continuous(breaks=c(1,2))

# With 2 clusters, Poorly, Very Poorly (without histosols), and Subaqueous drainage class pedons have a strong membership in the same cluster (cluster 2).  The plot suggests that Poorly and Very Poorly pedons that were assigned to cluster 1  are outliers in the distribution.

# Combine K-medoids and category data and box plot
par(cex.axis=.5)
combinek3 <- data.frame(datacomplete.cat, data.res.3$clustering)
boxplot(data.res.3.clustering ~ datacomplete.cat, data=combinek3, axes = FALSE)
box()
axis(side = 1, at = combinek3$datacomplete.cat, labels= combinek3$datacomplete.cat)
axis(side = 2, at = c(1,2,3))
title(ylab = "cluster", xlab="drainage class")

ggplot(combinek3, aes(x=data.res.3.clustering)) +
  geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
                 binwidth=.05,
                 colour="black", fill="white") +
  geom_density(alpha=.2, fill="#FF6666") +   # Overlay with transparent density plot
  facet_wrap(~ datacomplete.cat)  +
  scale_x_continuous(breaks=c(1,2,3))

# Combine K-medoids and category data and box plot
par(cex.axis=.5)
combinek4 <- data.frame(datacomplete.cat, data.res.4$clustering)
boxplot(data.res.4.clustering ~ datacomplete.cat, data=combinek4, axes = FALSE)
box()
axis(side = 1, at = combinek4$datacomplete.cat, labels= combinek4$datacomplete.cat)
axis(side = 2, at = c(1,2,3,4))
title(ylab = "cluster", xlab="drainage class")

# With 3 clusters, distribution of drainage class by cluster number agrees with the silhouette width analysis suggesting that 3+ clusters lack cohesion 
