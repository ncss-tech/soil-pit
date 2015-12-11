
#depth charts using aqp
#load packages
library(soilDB)
library(sharpshootR)
library(lattice)
library(plyr)
library(reshape)
library(aqp)


#load data and labels

#data
dsp <- read.csv("~/DSP/DSP_data/dsp_data.csv")

#labels
dsp_labels <- read.csv("~/DSP/DSP_data/dsp_label.csv")

#see dsp proct names
factor(dsp$Name)

PROJECT<-"ID_Threebear"

out.loc <- paste0("~/DSP/DSP_data/output/", PROJECT, "/")

pr <- which(dsp$Name==PROJECT)
dsp_pr <- dsp[pr,]

#prep bulk density
# row count for each type of bulk density
apply(dsp_pr[, grep("^BD", names(dsp_pr))], 2, function(x) length(which(!is.na(x))))

#name of new combined bulk density column
bd <- "BulkDensity"

#Order of bulk density selection - change order if desired
bd_1 <- "BD_core_fld"
bd_2 <- "BD_clod_13"
bd_3 <- "BD_compcav"
bd_4 <- "BD_recon13"
bd_5 <- "BD_other"

#create new data element that combines all bulk density methods'
dsp_pr$bd <- as.numeric(
  ifelse(!is.na(dsp_pr[,bd_1]), dsp_pr[,bd_1], 
         ifelse(!is.na(dsp_pr[,bd_2]), dsp_pr[,bd_2],
                ifelse(!is.na(dsp_pr[,bd_3]), dsp_pr[,bd_3],
                       ifelse(!is.na(dsp_pr[,bd_4]), dsp_pr[,bd_4],
                              dsp_pr[,bd_5])
                ))))


#rename with assigned name from previous section
names(dsp_pr)[names(dsp_pr)=="bd"] <- bd

#new field with source of bd data
dsp_pr$bd_source <-  ifelse(!is.na(dsp_pr[,bd_1]), bd_1, 
                            ifelse(!is.na(dsp_pr[,bd_2]), bd_2,
                                   ifelse(!is.na(dsp_pr[,bd_3]), bd_3,
                                          ifelse(!is.na(dsp_pr[,bd_4]), bd_4,
                                                 bd_5))))

table(dsp_pr$bd_source)
summary(dsp_pr$BulkDensity)

#change na's to zero for Calcium carbonate
dsp_pr$CaCarb[is.na(dsp_pr$CaCarb)]<- 0
dsp_pr$CaCarb[dsp_pr$CaCarb<0] <- 0

summary(dsp_pr$CaCarb)

#Alter this statement to select the project of interest "alter project code inside quotations"
PROJECT<-"ID_Threebear"

out.loc <- paste0("~/DSP/DSP_data/output/", PROJECT, "/")
```



#label for comparison made - usually management system or state phase or condition
x_label <- "Management System"

#stratify data by spatial collection distribution (use unique plot id)
PLOT<-"Plot.ID"

#Plot numbers - plot numbers, are not unique across COND; but are shorter labels
PLOT_NO <- "Plot"



#description of each comparable layer (comp_layer) - all layers/samples will be labeled based on this
comp_1 <- "O and A horizons"
comp_2 <- "other"
comp_3 <- "Parent Material 1 - E and B"
comp_4 <- "Parent Material 2 - E and B"

#if needed edit comparable layer and upload data again
#### Properties



# Analysis


### Data Prep

table(dsp_pr$bd_source)
summary(dsp_pr$BulkDensity)

#change na's to zero for Calcium carbonate
dsp$CaCarb[is.na(dsp_pr$CaCarb)]<- 0

summary(dsp_pr$CaCarb)

# calculate SOC - soil organic carbon
SOC_calc <- dsp_pr$Tot_C - 0.11*dsp_pr$CaCarb


dsp_pr$SOC <- as.numeric(
  ifelse(!is.na(dsp_pr$Est_totOC), dsp_pr$Est_totOC,   
         ifelse(!is.na(dsp_pr$Tot_C), dsp_pr$Tot_C,                       
                ifelse(!is.na(dsp_pr$Total.C), dsp_pr$Total.C, 
                       NA ))))

summary(dsp_pr$SOC)

##comparable layer labels
comp_label <- data.frame(
  Comp_layer =c(1,2,3,4),
  comp_label = c(comp_1, comp_2, comp_3, comp_4))


# clean out columns for properties that were not measured
dsp_pro <- Filter( f=function(x) !all(is.na(x)), x=dsp_pr)

#join comparable layer labels, the sort by comparable layer (1,2 etc.)
require(plyr)
dsp_proj <- join(dsp_pro, comp_label, by="Comp_layer")

dsp_proj$comp_label <- with(dsp_proj, reorder(factor(dsp_proj$comp_label), dsp_proj$Comp_layer))

#reset facotrs to only levels found in this project
dsp_proj[,"Name"] <- factor(dsp_proj[,"Name"])
dsp_proj[,COMPARE] <- factor(dsp_proj[,COMPARE])
dsp_proj[,PLOT] <- factor(dsp_proj[,PLOT])
dsp_proj[,PLOT_NO] <- factor(dsp_proj[,PLOT_NO])
dsp_proj[,"Soil"] <- factor(dsp_proj[,"Soil"])
dsp_proj[,"Region.strata"] <- factor(dsp_proj[,"Region.strata"])


# honestly these can be done on-demand as they are needed for graphing/analysis
#subset by horizon master (A & B) and surface
dsp_1 <- dsp_proj[which(dsp_proj$Hor_sequ==1),]
dsp_A <-  dsp_proj[which(grepl("^A", dsp_proj$hor_desg)),]
dsp_B <-  dsp_proj[which(grepl("^B", dsp_proj$hor_desg)),]

# subset by comparable layer
dsp_c1 <- dsp_proj[dsp_proj$Comp_layer==1,]
dsp_c2 <- dsp_proj[dsp_proj$Comp_layer==2,]
dsp_c3 <- dsp_proj[dsp_proj$Comp_layer==3,]
dsp_c4 <- dsp_proj[dsp_proj$Comp_layer==4,]



#see levels within project
dsp_pr <- droplevels(dsp_pr)
factor(dsp_pr$COND)

levels(dsp_pr$COND)

#ordination evaluation

# 
# vars <- c('SOC', 'BulkDensity' , 'ph_h20', 'Clay', 'CEC_sumcation')
# 
# pedons
# pedons.df <- as()



# choose abbreviation for depth comparison
# would be cool if eventually this automatically assigned all levels of COND to a seperate set 
# need to think about that

MF <- dsp_pr[dsp_pr$COND=="MF" ,]
CP <- dsp_pr[dsp_pr$COND=="CP",]


# convert to SoilProfileCollection objects
#promote columns to site information

depths(MF) <- Pedon_ID  ~ hor_top + hor_bottom
site(MF) <- ~ Name + DSP.Project + Comparison + COND + Plot.ID + Crop + AgronFeat + Soil + UserPedonID

depths(CP) <- Pedon_ID  ~ hor_top + hor_bottom  
site(CP) <- ~ Name + DSP.Project + Comparison + COND + Plot.ID + Crop + AgronFeat + Soil + UserPedonID

plot(MF, name = 'hor_desg')
plot(CP, name = 'hor_desg')

par(mfrow= c(2,1))
plot(MF, name='hor_desg', color='BulkDensity')
plot(CP, name='hor_desg', color='BulkDensity')

par(mar=c(0,0,3,0)) # tighter figure margins
par(mfrow= c(2,2))
plot(MF, name='hor_desg', color='Clay')
plot(MF, name='hor_desg', color='SOC')
plot(MF, name='hor_desg', color='BulkDensity')
plot(MF, name='hor_desg', color='CEC_sumcation')

par(mfrow= c(2,2))
plot(CP, name='hor_desg', color='Clay' )
plot(CP, name='hor_desg', color='SOC')
plot(CP, name='hor_desg', color='BulkDensity')
plot(CP, name='hor_desg', color='CEC_sumcation')

par(mar=c(0,0,3,0)) # tighter figure margins
par(mfrow= c(1,1))
plot(CP, name='hor_desg', color='Clay' )
plot(CP, name='hor_desg', color='SOC')
plot(CP, name='hor_desg', color='BulkDensity')
plot(CP, name='hor_desg', color='CEC_sumcation')


par(mfrow= c(1,1))
plot(MF, name='hor_desg', color='Clay')
plot(MF, name='hor_desg', color='SOC')
plot(MF, name='hor_desg', color='BulkDensity')
plot(MF, name='hor_desg', color='CEC_sumcation')


par(mfrow= c(2,1))
plot(MF, name='hor_desg', color='BulkDensity')
plot(CP, name='hor_desg', color='BulkDensity')


#create slabs - prop by depth increments
mf.a <- slab(MF,  fm = ~ AggStab + SOC+ BulkDensity + ph_h20 + Clay + CEC_sumcation)
cp.a <- slab(CP,  fm = ~ AggStab + SOC+ BulkDensity + ph_h20 + Clay + CEC_sumcation)



cbind(CT=levels(mf.a$variable), NT=levels(cp.a$variable))

g <- make.groups(ClearcutPlanted=cp.a, MatureForest=mf.a)

dsp_labels$variable <- dsp_labels$Anal

g_label <- join(g, dsp_labels, by = "variable", type = "left", match="all")

# Plot by depth
## plot asthetics
tps <- list(superpose.line=list(col=c('RoyalBlue', 'DarkRed', 'DarkGreen'), lwd=2))



#reset page ask
 devAskNewPage(ask=NULL)

## to create a pdf with all graphs
#pdf(file= paste0(out.loc, "/", PROJECT, "_depth_graph.pdf"))
xyplot(top ~ p.q50| Label, groups=which, data=g_label, ylab='Depth',
    xlab='median bounded by 25th and 75th percentiles',
       lower=g$p.q25, upper=g$p.q75, ylim=c(40,-1),
       panel=panel.depth_function, alpha=0.25, sync.colors=TRUE,
       prepanel=prepanel.depth_function,
             strip=strip.custom(bg=grey(0.85)),
       cf=g$contributing_fraction, cf.interval=10,
       layout=c(3,1), scales=list(x=list(alternating=1, relation='free')),
             par.settings=tps,
             auto.key=list(columns=2, lines=TRUE, points=FALSE)
             )
#dev.off()

#clustering and similarity analysis
