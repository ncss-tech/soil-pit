#required packages - the first time you use this uncomment next line (remove the # and install these packages)
#install.packages(c("fastmatch", "ggplot2", "plyr","Rcpp", "RColorBrewer", "lme4", "lattice", "maps", "aqp", "soilDB"))
require(fastmatch)
require(ggplot2)
require(Rcpp)
require(plyr)
require(RColorBrewer)
require(lme4)
library(lattice)
library(maps)
require(aqp)
library(soilDB)


#Inputs - need to be modified with updated info


#file locations - alter path inside quotations, note that the backslash is used
## input files - Excel spreadsheets can be saved as individual csv files - alternatively use the 'load data' GUI in R or Rstudio
dsp <- read.csv("~/DSP/DSP_data/dsp_data.csv")
dsp_labels <- read.csv("~/DSP/DSP_data/dsp_label.csv")

#for SD - avg horizon cores over layer id (multiple samples taken

##location (folder) for output files (change to whatever you like)
###- after running analysis below check this folder for results
out.loc <- "~/DSP/DSP_data/output/"

#check DSP project analysis names
table(dsp$Name)
#project of interest "alter project code inside quotations"
PROJECT<-"NE_Kennebeck"

#Fields used for comparison and data analysis

##test - typically test for mgmt or condition effect (typically MGMT)
COMPARE<-"COND"

##label for comparison made - usually management system or state phase or condition
x_label <- "Management System"

##stratify data by spatial collection distribution (use unique plot id)
PLOT<-"Plot.ID"

### Plot numbers - plot numbers, are not unique across COND
PLOT_NO <- "Plot"

#It is helpful to group horizons into similar layers for analysis. 
#Look at the dsp_data file, you may want relabel the comp_layer for your project.
#after you've grouped horizons appropriately, save as a csv file and reload the data

dsp <- read.csv("~/DSP/DSP_data/dsp_data.csv")

#description of each comparable layer (comp_layer) - all samples will be labeled based on this
comp_1 <- "A and Ap horizons"
comp_2 <- "Not A horizons"
comp_3 <- ""
comp_4 <- ""

#properties of interest (use anal code from data dictionary, between " ")
A<-"Tot_C"
B<-"Clay"
C<-"BD_core_fld"
D<-"Bgluc"

#Analysis
## this doesn't require further entry to run
################################################

#change na's to zero for Calcium carbonate
dsp$CaCarb[is.na(dsp$CaCarb)]<- 0

summary(dsp$CaCarb)

##comparable layer labels
comp_label <- data.frame(
  Comp_layer =c(1,2,3,4),
  comp_label = c(comp_1, comp_2, comp_3, comp_4))



# select project of interest
dsp_pr <- subset(dsp, Name==PROJECT)


#join comparable layer labels, the sort by comparable layer (1,2 etc.)
require(plyr)
dsp_proj <- join(dsp_pr, comp_label, by="Comp_layer")

dsp_proj$comp_label <- with(dsp_proj, reorder(factor(dsp_proj$comp_label), dsp_proj$Comp_layer))

#reset facotrs to only levels found in this project
paste0("dsp_proj$", COMPARE)
dsp_proj[,"Name"] <- factor(dsp_proj[,"Name"])
dsp_proj[,COMPARE] <- factor(dsp_proj[,COMPARE])
dsp_proj[,PLOT] <- factor(dsp_proj[,PLOT])
dsp_proj[,PLOT_NO] <- factor(dsp_proj[,PLOT_NO])
dsp_proj[,"Soil"] <- factor(dsp_proj[,"Soil"])
dsp_proj[,"Region.strata"] <- factor(dsp_proj[,"Region.strata"])

#subset by horizon master (A & B) and surface
dsp_1 <- subset(dsp_proj, dsp_proj$Hor_sequ==1)
dsp_A <- subset(dsp_proj, grepl("A", dsp_proj$Hor_desg))
dsp_B<- subset(dsp_proj, grepl("B", dsp_proj$Hor_desg))

# subset by comparable layer
dsp_c1 <- subset(dsp_proj, dsp_proj$Comp_layer==1)
dsp_c2 <- subset(dsp_proj, dsp_proj$Comp_layer==2)
dsp_c3 <- subset(dsp_proj, dsp_proj$Comp_layer==3) 
dsp_c4 <- subset(dsp_proj, dsp_proj$Comp_layer==4)
#############

##SUMMARY PLOTS
#########define funtion to create summary plots
dsp1_box<- function(df=dsp_proj, compare=COMPARE, p=PLOT, n=PLOT_NO, xlab=x_label, labels=dsp_labels, start_column){
  require(RColorBrewer)
  require(ggplot2)
  dfx <- factor(df[,compare])
  ln <- length(names(df))
  proj <- as.character(df[1,"DSP.Project"])
  y <- df[,start_column]
  c<-factor(df[,n])
  nc<-nlevels(c)
  
  namey <- as.character(labels[grepl(names(df)[start_column], labels[,"Anal"]), "Label"])
  
  
  Q <- qplot(x=dfx, y=y, data=df, color=c, main=proj, xlab = x_label,
             ylab = namey, geom="boxplot")
  
  myColors <- if (nc<3) c("blue", "red") else (brewer.pal(nc,"Set1"))
  names(myColors) <- levels(c)
  colScale <- scale_colour_manual(name = "PLOT",values = myColors)
  Qi <- Q +colScale
  Qi
}

#test
dsp1_box(dsp_1, COMPARE, PLOT, PLOT_NO, x_label, labels=dsp_labels, 29)

#loop function over relevent columns for each subset
#### Surface horizon
filename <-paste0(out.loc,"Surface_", PROJECT,"_more.pdf")
pdf(filename)
ln <- length(names(dsp_1))
for(i in 29:ln){
  print(dsp1_box(dsp_1, COMPARE, PLOT, PLOT_NO, x_label, labels=dsp_labels, start_column=i) )
}
dev.off()


#individual plots for prop of interest
require(fastmatch)
propA_surf_box<- dsp1_box(dsp_1, COMPARE, PLOT, PLOT_NO, x_label, dsp_labels, start_column=fmatch(A,names(dsp_1)))
propB_surf_box<- dsp1_box(dsp_1, COMPARE, PLOT, PLOT_NO, x_label, dsp_labels, start_column=fmatch(B,names(dsp_1)))
propC_surf_box<- dsp1_box(dsp_1, COMPARE, PLOT, PLOT_NO, x_label, dsp_labels, start_column=fmatch(C,names(dsp_1)))
propD_surf_box<- dsp1_box(dsp_1, COMPARE, PLOT, PLOT_NO, x_label, dsp_labels, start_column=fmatch(D,names(dsp_1)))

print(propA_surf_box)
print(propB_surf_box)
print(propC_surf_box)
print(propD_surf_box)

## function to create boxplots by subset
#########################
#########################
# for sd initial
# all horizons
filename <-paste0(out.loc,"comparable", PROJECT,"_new.pdf")
pdf(filename)
for(i in 29:ln){
  ln <- length(names(dsp_proj))-3
  y <- names(dsp_proj)[i]
  namey <- as.character(dsp_labels[grepl(y, dsp_labels$Anal), "Label"])
    proj <- as.character(dsp_proj[1,"Anal"])
  #col_b <- c("#FEE08B", "#FDAE61","#F46D43" , "#D73027", "#A50026", "#D9EF8B", "#A6D96A", "#66BD63",
             #"#1A9850", "#006837", "#C6DBEF", "#9ECAE1", "#6BAED6", "#3182BD", "#08519C")
  #col_S <- scale_fill_manual(values = col_b)
  
    Qcomp <- ggplot(data=dsp_proj, aes_string(x="MGMT", y=names(dsp_proj)[i])) + ylab(namey) + xlab(" All Horizons") + ggtitle(paste0(proj, " All Horizons"))+
      geom_boxplot() 
Qcomp
    Qc<- Qcomp +geom_jitter(aes_string(x="MGMT", y=y, colour= "PedonID"), show_guide=F)
    Qf <- Qc + facet_wrap(~comp_label)
    Q <- Qf 
  print(Q)
}
dev.off()


###########
#aggregate over plots
numcomp <- sapply(dsp_proj, is.numeric)
datacomp<-data.frame(dsp_proj[,numcomp])

mean_ped_comp <-aggregate(x = datacomp, by = list(comp_layer = dsp_proj$Comp_layer, COND = dsp_proj[,COMPARE], plot_id = dsp_proj[,PLOT], Pedon_ID = dsp_proj$PedonID), mean, na.rm=T)
sd_ped_comp <-aggregate(x = datacomp, by = list(comp_layer = dsp_proj$Comp_layer, COND = dsp_proj[,COMPARE],plot_id = dsp_proj[,PLOT], Pedon_ID = dsp_proj$PedonID), sd, na.rm=T)
mean_ped_comp$stat <- "pedmean"
sd_ped_comp$stat <- "pedsd"

dsp_ped_comp <- rbind( mean_ped_comp, sd_ped_comp[-1,])

colout <- "Hor_sequ"

dsp_ped_compl <- join(dsp_ped_comp, comp_label, by="Comp_layer")
up <- data.frame( UserPedonID = dsp_proj$UserPedonID, Pedon_ID= dsp_proj$PedonID)
dsp_ped_compu <- join(dsp_ped_compl, up, by="Pedon_ID")

write.csv(dsp_ped_compl[,!(names(dsp_ped_compl) %in% colout)], file = paste0(out.loc,PROJECT, "_comp-layer_byPED.csv"), row.names=F)


numcompl <- sapply(dsp_ped_compu, is.numeric)

mean_plot_comp <- aggregate(x = mean_ped_comp[,numcompl], by = list(comp_layer = mean_ped_comp$comp_layer, COND = mean_ped_comp$COND, plot_id = mean_ped_comp$plot_id), mean, na.rm=T)
sd_plot_comp <-aggregate(x = sd_ped_comp[,numcompl], by = list(comp_layer = sd_ped_comp$comp_layer, COND = sd_ped_comp$COND,plot_id = sd_ped_comp$plot_id), sd, na.rm=T)
mean_plot_comp$stat <- "plotmean"
sd_plot_comp$stat <- "plotsd" 


dsp_plot_comp <- rbind( mean_plot_comp, sd_plot_comp[-1,])

colout <- c("Plot", "Pedon", "Hor_sequ")

dsp_plot_compl <- join(dsp_plot_comp, comp_label, by="Comp_layer")



write.csv(dsp_plot_compl[,!(names(dsp_plot_compl) %in% colout)], file = paste0(out.loc,PROJECT, "_comp-layer_byPLOT.csv"), row.names=F)

##ped averages
# for sd initial
filename <-paste0(out.loc,"comp_ped_new", PROJECT,"new.pdf")
pdf(filename)
for(i in 12:ln){
  m <- subset(dsp_ped_compl, stat=="pedmean")
  ln <- length(names(m))-3
    y <- names(m)[i]
    namey <- as.character(dsp_labels[grepl(y, dsp_labels$Anal), "Label"])
    proj <- as.character(dsp_proj[1,"Name"])

  Qcomp <- ggplot(data=m, aes_string(x="COND", y=y)) + ylab(namey)+ 
    xlab(" All Horizons") + ggtitle(paste0(proj, " by Pedon"))+ geom_boxplot() 
Qcomp
    Qc<- Qcomp +geom_jitter(aes_string(x="COND", y=y, colour="Pedon_ID"), show_guide=F) 
    Qf <- Qc + facet_wrap(~comp_label)
    Q <- Qf 
  print(Q)
}
dev.off()

#exploratory plots
A<-"Tot_C"
B<-"Clay"
C<-"BD_core"
D<-"Bgluc"

# #density plot of mgmt systems
filename <-paste0(out.loc,"DensityPlots_", PROJECT,"_more.pdf")
pdf(filename)
# #################could loop across columns
  qplot(Tot_C, data=dsp_1, geom="density", fill=MGMT, alpha=I(.25))
  qplot(Clay, data=dsp_1, geom="density", fill=MGMT, alpha=I(.25))
  qplot(BD_core, data=dsp_1, geom="density", fill=MGMT, alpha=I(.25))
  qplot(Bgluc, data=dsp_1, geom="density", fill=MGMT, alpha=I(.25))
  qplot(AggStab, data=dsp_1, geom="density", fill=MGMT, alpha=I(.25))
qplot(Pom_C, data=dsp_1, geom="density", fill=MGMT, alpha=I(.25))

# #density plot by comparable layer
qplot(Tot_C, data=dsp_proj, geom="density", fill=comp_label, alpha=I(.5))
qplot(Bgluc, data=dsp_proj, geom="density", fill=comp_label, alpha=I(.5))
qplot(BD_core, data=dsp_proj, geom="density", fill=comp_label, alpha=I(.5))
qplot(AggStab, data=dsp_proj, geom="density", fill=comp_label, alpha=I(.5))
qplot(Pom_C, data=dsp_proj, geom="density", fill=comp_label, alpha=I(.5))
qplot(Clay, data=dsp_proj, geom="density", fill=comp_label, alpha=I(.5))

#density plot by Soil
qplot(Tot_C, data=dsp_1, geom="density", fill=Soil, alpha=I(.25), facets = . ~ MGMT)
qplot(Clay, data=dsp_1, geom="density", fill=Soil, alpha=I(.25), facets = . ~ MGMT)
qplot(BD_core, data=dsp_1, geom="density", fill=Soil, alpha=I(.25), facets = . ~ MGMT)
qplot(Bgluc, data=dsp_1, geom="density", fill=Soil, alpha=I(.25), facets = . ~ MGMT)
qplot(AggStab, data=dsp_1, geom="density", fill=Soil, alpha=I(.25), facets = . ~ MGMT)
qplot(Pom_C, data=dsp_1, geom="density", fill=Soil, alpha=I(.25), facets = . ~ MGMT)

# #################management by soil
qplot(Tot_C, data=dsp_proj, geom="density", fill=MGMT, alpha=I(.25), facets = comp_label ~ Soil)
qplot(Clay, data=dsp_proj, geom="density", fill=MGMT, alpha=I(.25), facets = comp_label ~ Soil)
qplot(BD_core, data=dsp_proj, geom="density", fill=MGMT, alpha=I(.25), facets = comp_label ~ Soil)
qplot(Bgluc, data=dsp_proj, geom="density", fill=MGMT, alpha=I(.25), facets = comp_label ~ Soil)
qplot(AggStab, data=dsp_proj, geom="density", fill=MGMT, alpha=I(.25), facets = .~ Soil)
qplot(Pom_C, data=dsp_proj, geom="density", fill=MGMT, alpha=I(.25), facets = . ~ Soil)


dev.off()


######DATA ANAL###

##ANal for surface horizon

#flag numberic data columns into seperate dataframe
nums <- sapply(dsp_1, is.numeric)
data1<-data.frame(dsp_1[,nums])

#overall by plot -  mean, sd, max and min
min_plot_1 <- aggregate(x=data1, by = list(COND = dsp_1[,COMPARE],plot_id = dsp_1[,PLOT]), min, na.rm=T)
max_plot_1 <- aggregate(x = data1, by = list(COND = dsp_1[,COMPARE],plot_id = dsp_1[,PLOT]), max, na.rm=T)
mean_plot_1 <-aggregate(x = data1, by = list(COND = dsp_1[,COMPARE],plot_id = dsp_1[,PLOT]), mean, na.rm=T)
sd_plot_1 <-aggregate(x = data1, by = list(COND = dsp_1[,COMPARE],plot_id = dsp_1[,PLOT]), sd, na.rm=T)

#add label column - within plot variables
min_plot_1$stat <- "pedmin"
max_plot_1$stat <- "pedmax"
mean_plot_1$stat <- "plotmean"
sd_plot_1$stat <- "plotsd"

dsp_plot_surf <- rbind(min_plot_1, max_plot_1[-1,], mean_plot_1[-1,], sd_plot_1[-1,])

#get rid of columns that no longer make sense
colout <- c("Plot", "Pedon", "pedonID", "Hor_sequ")

#write table to a csv, that can be opened by excel, in designated output folder
write.csv(dsp_plot_surf[,!(names(dsp_plot_surf) %in% colout)], file = paste0(out.loc,PROJECT, "_surface_byPLOT.csv"), row.names=F)


#summary for cond (mgmt systems or state phases)

# get numeric columns for plot data
numstat <- sapply(dsp_plot_surf, is.numeric)

#Get min for the lowest pedon value (min_indivped) and the lowest plot avg (min_plot_avg)
min_cond_1 <- aggregate(x=min_plot_1[,numstat], by = list(COND = min_plot_1$COND), min, na.rm=T)
min_plotavg_1 <- aggregate(x=mean_plot_1[,numstat], by = list(COND = mean_plot_1$COND), min, na.rm=T)
min_cond_1$stat <- "min_indivped"
min_plotavg_1$stat<- "min_plotavg"

max_cond_1 <-  aggregate(x=max_plot_1[,numstat], by = list(COND = max_plot_1$COND), max, na.rm=T)
max_plotavg_1 <- aggregate(x=mean_plot_1[,numstat], by = list(COND = mean_plot_1$COND), max, na.rm=T)
max_cond_1$stat <- "max_indivped"
max_plotavg_1$stat<- "max_plotavg"

mean_cond_1 <-  aggregate(x=mean_plot_1[,numstat], by = list(COND = mean_plot_1$COND), mean, na.rm=T)
mean_cond_1$stat <- "cond_mean"

sd_plot_mean1 <-  aggregate(x=sd_plot_1[,numstat], by = list(COND = sd_plot_1$COND), mean, na.rm=T)
sd_plot_min1 <-  aggregate(x=sd_plot_1[,numstat], by = list(COND = sd_plot_1$COND), min, na.rm=T)
sd_plot_max1 <- aggregate(x=sd_plot_1[,numstat], by = list(COND = sd_plot_1$COND), max, na.rm=T)
sd_plot_mean1$stat <- "sd_plot_mean"
sd_plot_min1$stat <- "sd_plot_min"
sd_plot_max1$stat <- "sd_plot_max"

sd_cond_1 <-  aggregate(x=mean_plot_1[,numstat], by = list(COND = mean_plot_1$COND), sd, na.rm=T)
sd_cond_1$stat <- "cond_sd"

dsp_cond_surf <-  rbind(min_cond_1, min_plotavg_1[-1,], max_cond_1[-1,], max_plotavg_1[-1,], mean_cond_1[-1,],
                        sd_plot_mean1[-1,], sd_plot_min1[-1,], sd_plot_max1[-1,], sd_cond_1[-1,])


#write table to a csv, that can be opened by excel, in designated output folder
write.csv(dsp_cond_surf[,!(names(dsp_cond_surf) %in% colout)], file = paste0(out.loc,PROJECT, "_surface_byCOND.csv"), row.names=F)


##ANal by Comparable Layers

#flag numberic data columns into seperate dataframe
numcomp <- sapply(dsp_proj, is.numeric)
datacomp<-data.frame(dsp_proj[,numcomp])

#overall by plot -  mean, sd, max and min

min_plot_comp <- aggregate(x = datacomp, by = list(comp_layer = dsp_proj$Comp_layer, COND = dsp_proj[,COMPARE],plot_id = dsp_proj[,PLOT]), min, na.rm=T)
max_plot_comp <- aggregate(x = datacomp, by = list(comp_layer = dsp_proj$Comp_layer, COND = dsp_proj[,COMPARE],plot_id = dsp_proj[,PLOT]), max, na.rm=T)
mean_plot_comp <-aggregate(x = datacomp, by = list(comp_layer = dsp_proj$Comp_layer, COND = dsp_proj[,COMPARE],plot_id = dsp_proj[,PLOT]), mean, na.rm=T)
sd_plot_comp <-aggregate(x = datacomp, by = list(comp_layer = dsp_proj$Comp_layer, COND = dsp_proj[,COMPARE],plot_id = dsp_proj[,PLOT]), sd, na.rm=T)

#add label column - within plot variables
min_plot_comp$stat <- "pedmin"
max_plot_comp$stat <- "pedmax"
mean_plot_comp$stat <- "plotmean"
sd_plot_comp$stat <- "plotsd"

dsp_plot_comp <- rbind(min_plot_comp, max_plot_comp[-1,], mean_plot_comp[-1,], sd_plot_comp[-1,])

#get rid of columns that no longer make sense
colout <- c("Plot", "Pedon", "pedonID", "Hor_sequ")

#put comparable layer labels back on
dsp_plot_compl <- join(dsp_plot_comp, comp_label, by="Comp_layer")

#write table to a csv, that can be opened by excel, in designated output folder
write.csv(dsp_plot_compl[,!(names(dsp_plot_compl) %in% colout)], file = paste0(out.loc,PROJECT, "_comp-layer_byPLOT.csv"), row.names=F)


#summary for cond (mgmt systems or state phases)
# get numeric columns for plot data

numcompl <- sapply(dsp_plot_compl, is.numeric)

#Get min for the lowest pedon value (min_indivped) and the lowest plot avg (min_plot_avg)
min_cond_comp <- aggregate(x=min_plot_comp[,numcompl], by = list(comp_layer = min_plot_comp$comp_layer, COND = min_plot_comp$COND), min, na.rm=T)
min_plotavg_comp <- aggregate(x=mean_plot_comp[,numcompl], by = list(comp_layer = min_plot_comp$comp_layer, COND = mean_plot_comp$COND), min, na.rm=T)
min_cond_comp$stat <- "min_indivped"
min_plotavg_comp$stat<- "min_plotavg"

max_cond_comp <-  aggregate(x=max_plot_comp[,numcompl], by = list(comp_layer = min_plot_comp$comp_layer, COND = max_plot_comp$COND), max, na.rm=T)
max_plotavg_comp <- aggregate(x=mean_plot_comp[,numcompl], by = list(comp_layer = min_plot_comp$comp_layer, COND = mean_plot_comp$COND), max, na.rm=T)
max_cond_comp$stat <- "max_indivped"
max_plotavg_comp$stat<- "max_plotavg"

mean_cond_comp <-  aggregate(x=mean_plot_comp[,numcompl], by = list(comp_layer = min_plot_comp$comp_layer, COND = mean_plot_comp$COND), mean, na.rm=T)
mean_cond_comp$stat <- "cond_mean"

sd_plot_meancomp <-  aggregate(x=sd_plot_comp[,numcompl], by = list(comp_layer = min_plot_comp$comp_layer, COND = sd_plot_comp$COND), mean, na.rm=T)
sd_plot_mincomp <-  aggregate(x=sd_plot_comp[,numcompl], by = list(comp_layer = min_plot_comp$comp_layer, COND = sd_plot_comp$COND), min, na.rm=T)
sd_plot_maxcomp <- aggregate(x=sd_plot_comp[,numcompl], by = list(comp_layer = min_plot_comp$comp_layer, COND = sd_plot_comp$COND), max, na.rm=T)
sd_plot_meancomp$stat <- "sd_plot_mean"
sd_plot_mincomp$stat <- "sd_plot_min"
sd_plot_maxcomp$stat <- "sd_plot_max"

sd_cond_comp <-  aggregate(x=mean_plot_comp[,numcompl], by = list(comp_layer = min_plot_comp$comp_layer, COND = mean_plot_comp$COND), sd, na.rm=T)
sd_cond_comp$stat <- "cond_sd"

dsp_cond_comp <-  rbind(min_cond_comp, min_plotavg_comp[-1,], max_cond_comp[-1,], max_plotavg_comp[-1,], mean_cond_comp[-1,],
                        sd_plot_meancomp[-1,], sd_plot_mincomp[-1,], sd_plot_maxcomp[-1,], sd_cond_comp[-1,])

dsp_cond_compl <- join(dsp_plot_comp, comp_label, by="Comp_layer")

colout <- c("Plot", "Pedon", "pedonID", "Hor_sequ")

#write table to a csv, that can be opened by excel, in designated output folder
write.csv(dsp_cond_compl[,!(names(dsp_cond_compl) %in% colout)], file = paste0(out.loc,PROJECT, "_comp-layer_byCOND.csv"), row.names=F)

# dcc<- dsp_cond_compl[,!(names(dsp_cond_compl) %in% colout)]
# write.csv(dcc, file= "~/DSP/DSP_example/dcc.csv")

#### test for the effect of conditions on soil properties
require(lme4)


#function to test COMPARE condition - uses mixed model to fit two models one with and without COMPARE
#then uses anova to test for difference between models
cond_test <- function(df=dsp_1, COMPARE=COMPARE, PLOT=PLOT, LABELS=dsp_labels, start_col=29){
  require(lme4)
  C <- factor(df[,COMPARE])
  P <- factor(df[,PLOT])
	
  prop <- as.character(LABELS[grepl(names(df)[start_col], LABELS[,"Anal"]), "Label"])
  xx <- df[,start_col]
  
  fit_cond_i <- lmer(xx ~  C + (1|P) , data=df, REML= F)
  fit_r_i <- lmer(df[,start_col] ~ (1|P), data=df, REML=F)
  a_i <- anova(fit_r_i, fit_cond_i)
  p <- as.numeric(a_i[2,8])
  pl_i <- cbind(prop, p)
  pl_i
}


#test function
cond_test(df=dsp_proj, COMPARE=COMPARE, PLOT=PLOT, LABELS=dsp_labels, start_col=32)

#This creates a csv file with an F test for the statistical difference between levels of COMPARE (mgmt system or condition)



for(i in 29:ln){
  ln <- length(names(dsp_1))-1
    
  pl_i <- tryCatch(cond_test(df=dsp_1, COMPARE=COMPARE, PLOT=PLOT, LABELS=dsp_labels, start_col=i), error=function(e) NULL) 
    if (i ==29)
  {
    write.table(pl_i, file = paste0(out.loc, PROJECT,"_surface_ftest.csv"), sep = ",", col.names = c("Property", "p value"), row.names=F )
  } else
  {
    write.table(pl_i, file = paste0(out.loc, PROJECT,"_surface_ftest.csv"), sep = ",", append = T, row.names = F, col.names=F);
  }
}

# do by COND for each comparable layer
# #Comparable layers
#uncomment c3 and c4 if there are more than 2 comparable layers


for(i in 25:ln){
  ln <- length(names(dsp_c1))-1
  
  #comparable layer 1 and 2
  
  t1 <- tryCatch(cond_test(df=dsp_c1, COMPARE=COMPARE, PLOT=PLOT, labels=dsp_labels, start_col=i), error=function(e) NULL) 
  t2 <- tryCatch(cond_test(df=dsp_c2, COMPARE=COMPARE, PLOT=PLOT, labels=dsp_labels, start_col=i), error=function(e) NULL)
  
  
  pl_c1 <- if (!is.null(t1))
  {cbind(as.character(comp_1),t1)
  } else
  { cbind(as.character(comp_1),as.character(dsp_labels[i,"Label"]),"NULL") }
  pl_c2 <- if (!is.null(t2)){
    cbind(as.character(comp_2),t2)
  } else
  {cbind(as.character(comp_2), as.character(dsp_labels[i, "Label"]), "NULL")}
  
  d1<- data.frame(pl_c1)
  names(d1) <-  c("Comparable Layer", "Property", "p-value")
  d2<- data.frame(pl_c2)
  names(d2) <-  c("Comparable Layer", "Property", "p-value") 
  
  pl_i <- rbind.fill(d1, d2)  
#   
#   
#   #comparable layer 3 and 4 - you can uncomment to include
#   # if one of these is blank - it will create many extra rows in the final tabel (with blanks for comparable layer)
#   #    t3 <- fs_cond_test(df=test_proj_c3, COMPARE=COMPARE, PLOT=PLOT, dsp_labels=dsp_labels, start_col=i)
#   #    t4 <- fs_cond_test(df=test_proj_c4, COMPARE=COMPARE, PLOT=PLOT, dsp_labels=dsp_labels, start_col=i)
#   #   
#   #    pl_c3 <- if (!is.null(t3)){
#   #       cbind(as.character(comp_label[1,3]),t3)
#   #       } else
#   #         {cbind(as.character(comp_3),as.character(dsp_labels[i, "Label"]),"NULL" ) }
#   #    pl_c4 <- if (!is.null(t4)){
#   #      cbind(as.character(comp_4),t4)
#   #    } else
#   #         {cbind(as.character(comp_4), as.character(dsp_labels[i, "Label"]), "NULL")}
#   #   
#   #       d3<- data.frame(pl_c3)
#   #       names(d3) <-  c("Comparable Layer", "Property", "p-value")
#   #       d4<- data.frame(pl_c4)
#   #       names(d4) <-  c("Comparable Layer", "Property", "p-value")  
#   #   
#   #   
#   #    pl_i <- rbind.fill(d1, d2, d3, d4)  
#   
#   
  if (i ==29)
  {
    write.table(pl_i, file = paste0(out.loc, PROJECT,"_comp_ftest.csv"), sep = ",", col.names = c("Comparable Layer", "Property", "p value"), row.names=F)
  } else
  {
    write.table(pl_i, file = paste0(out.loc, PROJECT,"_comp_ftest.csv"), sep = ",", append = T, row.names = F, col.names=F)
  }
}
# 
# 
#
# 
# # get covariance estimates

get_cov <- function(df=dsp_1, PL=PLOT, start_col=29, labels=dsp_labels){
  prop1<- as.character(labels[grepl(names(df)[start_col], labels[,"Anal"]), "Label"])
  P <- factor(df[,PL])
  fit_cov <- lmer(df[,start_col] ~ (1|P), data=df, REML=T)
  cov <- as.data.frame(VarCorr(fit_cov))
  COV1 <- cbind(prop1, ex$vcov[1],ex$vcov[2])
  COV1
  
}


#test_covariance output
covs <- get_cov()
covs_i <- by(data=dsp_1, factor(dsp_1[,COMPARE]), get_cov, start_col=39)
v1 <- data.frame(cbind(names(covs_i)[[1]],covs_i[[1]]))
v2 <- cbind(names(covs_i)[[2]],covs_i[[2]])
tab_i <- rbind(v1,v2)
#
#

covs_by <- function(sc=30){
  cb <-  by(data=test_1, factor(test_1$COMPARE), get_cov, start_col=sc)
  # trying to make more general
  # cb<- by(data=d, factor(print(ind)), get_cov, df=d, start_col=sc)
  cb
}

# try_cb <- tryCatch(covs_by(sc=31), error = fuction(e) e, NULL)
#
# fw_covs <- failwith(NULL, covs_by)        
#
# if(inherits(try_cb, "error"){
#                    message("Caught error:", try_cb$message)           
#                      ## error reading..
#                    } else{
#                      covs_i
#                    }
#  
#
# start_col <- 31
# prop<- as.character(labels[start_col, "Label"])
# prop


for(i in 25:ln){
  ln <- length(names(test_1))-3
  t <- aggregate(test_1[,i]~test_1$COMPARE, data=test_1, mean)
  
  if ((t[1,2]==0) & (t[2,2]==0)){
    
    v1 <- cbind(paste(t[1,1]),as.character(dsp_labels[i,"Label"]),"NULL", "NULL")
    v2 <- cbind(paste(t[2,1]),as.character(dsp_labels[i,"Label"]),"NULL", "NULL")
    
  } else
    if(t[1,2]==0){
      
      v1 <- cbind(paste(t[1,1]),as.character(dsp_labels[i,"Label"]),"NULL", "NULL")
      
      covs_i <- get_cov(start_col=i)
      v2 <- cbind(paste(t[2,1]),covs_i)
      
    } else
      if(t[2,2]==0){
        covs_i <- get_cov(start_col=i)
        v1 <- cbind(paste(t[1,1]), covs_i)
        v2 <- cbind(paste(t[2,1]),as.character(dsp_labels[i,"Label"]),"NULL", "NULL")
        
      } else {
        covs_i <- covs_by(sc=i)
        v1 <- cbind(names(covs_i)[[1]],covs_i[[1]])
        v2 <- cbind(names(covs_i)[[2]],covs_i[[2]])
        
      }
  
  
  tab_i <- rbind(v1,v2)
  
  ## handling for more than two conditions needs to be added
  
  if (i==29)
  {
    write.table(tab_i, file = paste0(out.loc, PROJECT,"_surface_covariance.csv"), sep = ",", col.names = c(COMPARE, "Property", "Plot var", "Residual var"), row.names=F )
  } else
  {
    write.table(tab_i, file = paste0(out.loc, PROJECT,"_surface_covariance.csv"), sep = ",", append = T, row.names = F, col.names=F)
  }
  
}

# #############old stuff
#  
#    v1 <-  
#    if (!is.null(covs_i[[1]]))
#      {cbind(names(covs_i)[[1]],covs_i[[1]])
#       } else
#         {cbind(names(covs_i)[[1]],as.character(dsp_labels[i,"Label"]),"NULL", "NULL") }
#   
#     v2 <-  
#    if (!is.null(covs_i[[2]]))
#      {cbind(names(covs_i)[[2]],covs_i[[2]])
#       } else
#         { cbind(names(covs_i)[[2]],as.character(dsp_labels[i,"Label"]),"NULL", "NULL") }

###test - use this cntrl-shift-C to uncomment following lines

#change s if something other than comparable layer is used for subsetting
# 
# dsp_comp_box<- function(df=dsp_proj, start_col=25, compare=COMPARE, p=PLOT, n=PLOT_NO, s="comp_label",xlab=x_label, labels=dsp_labels){
#   
#   require(RColorBrewer)
#   require(ggplot2)
#   
#   ln <- length(names(df))
#   dfy <- df[,start_col]
#   dfx <- factor(df[,compare])
#   
#   y2 <- names(df)[start_col]
#   x2 <- COMPARE
#   
#   c<-factor(df[,p])
#   nc<-nlevels(c)
#   num <- max(df[,PLOT_NO])
#   
#   proj <- as.character(df[1,"Name"])
#   # namey <- as.character(labels[start_col, "Label"])
#   namey <- as.character(labels[grepl(names(df)[start_col], labels[,"Anal"]), "Label"])
#   
#   #   #ggplot should work with strings, but that does not seem to be working, so these are leftover dummie variables
#   #   dfxx <- paste(compare)
#   
#   #   cc <- paste(p)
#   #   ncc <- nlevels(paste0("df$",p))   
#   
#   
#   all_col <- brewer.pal(11, "RdYlGn")
#   col1 <- all_col[1:num]
#   col2 <- all_col[(11-num):11] 
#   extra_col <- brewer.pal((num+1), "Blues")
#   
#   col3 <- extra_col[num:(num+1)]
#   
#   cols <- c(col1,col2,col3)
#   
#   myColors <- brewer.pal(nc,"Spectral")
#   names(myColors) <- levels(c)
#   colScale <- scale_colour_manual(name =p,values = myColors)
#   
#   col_b <- c("#FEE08B", "#FDAE61","#F46D43" , "#D73027", "#A50026", "#D9EF8B", "#A6D96A", "#66BD63",
#              "#1A9850", "#006837", "#C6DBEF", "#9ECAE1", "#6BAED6", "#3182BD", "#08519C")
#   col_S <- scale_fill_manual(values = col_b)
#   
#   Qbox <- ggplot(data=df, aes_string(x=x2, y=y2)) + ylab(namey) + xlab(x_label) + ggtitle(proj)+
#     geom_boxplot(outlier.size=0,  alpha=0.95) +
#     geom_boxplot(aes_string(fill = p), alpha= 0.5, outlier.size =0)
#   
#   Qc<- Qbox +  geom_jitter(aes_string(x=x2, y=y2, colour= p), show_guide=F) + scale_colour_manual(values = col_b)
#   Qf <- Qc + facet_wrap(as.formula(paste0("~", s)))
#   Qcf <- Qf + col_S
#   
#   print(Qcf)
#   
#   
# }
# #test
# #dsp_comp_box<- function(df=dsp_proj, compare=COMPARE, p=PLOT, n=PLOT_NO, s=label, xlab=x_label, lookup=dsp_labels, start_column=25){
# 
# dsp_comp_box(df=dsp_proj, start_col=30, compare=COMPARE, p=PLOT, n=PLOT_NO, s="comp_label", xlab=x_label, labels=dsp_labels)
# 
# #loop function over relevent columns for each subset
# #### Comparable Layer
# #### or all layers
# filename <-paste0(out.loc,"avg_", PROJECT,".pdf")
# pdf(filename)
# for(i in 25:ln){
#   ln <- length(names(dsp_proj))-3
#   dsp_comp_box(df=dsp_proj, start_col=i, compare=COMPARE, p=PLOT, n=PLOT_NO, s="comp_label", xlab=x_label, labels=dsp_labels)
# }
# dev.off()
# 
# file <-paste0(out.loc,"avg_interest_", PROJECT,".pdf")
# pdf(file)
# propA_surf_box<- dsp_comp_box(dsp_proj, compare=COMPARE, p=PLOT, n=PLOT_NO, s="comp_label", xlab=x_label, labels=dsp_labels, start_col=fmatch(A,names(dsp_proj)))
# propB_surf_box<- dsp_comp_box(dsp_proj, compare=COMPARE, p=PLOT, n=PLOT_NO, s="comp_label", xlab=x_label, labels=dsp_labels, start_col=fmatch(B,names(dsp_proj)))
# propC_surf_box<- dsp_comp_box(dsp_proj, compare=COMPARE, p=PLOT, n=PLOT_NO, s="comp_label", xlab=x_label, labels=dsp_labels, start_col=fmatch(C,names(dsp_proj)))
# propD_surf_box<- dsp_comp_box(dsp_proj, compare=COMPARE, p=PLOT, n=PLOT_NO, s="comp_label", xlab=x_label, labels=dsp_labels, start_col=fmatch(D,names(dsp_proj)))
# dev.off()
# 

save.image( file=�dsp_anal.RData�)