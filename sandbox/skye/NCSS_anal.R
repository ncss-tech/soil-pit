rm(list = ls() ) #clear environment

#load packages
library(soilDB)
library(plyr)
library(reshape2)
library(ggplot2)
library(ggthemes)



#Queried from the NCSS database downloaded as a ACCESS DB
#calculate SOC, combine BD methods and pull some taxonomy and texture in
# > str(ncss)
# 'data.frame':	312022 obs. of  26 variables:
#   $ samp_taxorder     : Factor w/ 13 levels "","ALFISOLS",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ samp_taxsuborder  : Factor w/ 78 levels "","ALBOLLS","ANDEPTS",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ samp_taxmoistscl  : Factor w/ 9 levels "","AERIC","AQUIC",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ samp_taxtempregime: Factor w/ 14 levels "","CRYIC","FRIGID",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ upedonid          : chr  "" "" "" "" ...
# $ pedlabsampnum     : chr  "" "" "" "" ...
# $ pedon_key         : int  NA 34643 34643 34644 34644 34644 34644 34644 34644 34644 ...
# $ labsampnum        : chr  "08N01412" "06N04863" "06N04864" "06N04865" ...
# $ layer_sequence    : int  1 144 145 146 147 148 149 150 151 152 ...
# $ hzn_master        : chr  "" "A" "B" "A" ...
# $ hzn_desgn         : chr  "" "Ap" "Bs" "Ap" ...
# $ hzn_top           : num  0 0 22 0 8 53 130 132 178 203 ...
# $ hzn_bot           : num  NA 22 41 8 53 130 132 178 203 254 ...
# $ c_tot             : num  5.15 1.67 0.67 1 0 ...
# $ oc                : num  NA NA NA NA NA NA NA NA NA NA ...
# $ carb              : num  NA NA NA NA NA NA NA NA NA NA ...
# $ BD                : num  NA NA NA NA NA NA NA NA NA NA ...
# $ model_desg        : chr  "" "Ap" "Bhs" "Ap" ...
# $ hor_thick         : num  NA 22 19 8 45 77 2 46 25 51 ...
# $ hzn_avg           : num  NA 11 9.5 4 22.5 38.5 1 23 12.5 25.5 ...
# $ SOC               : num  5.15 1.67 0.67 1 0 ...
# $ vfg2              : int  2 0 0 0 0 0 0 0 0 0 ...
# $ tex_psda          : chr  "sicl" "lcos" "lcos" "cos" ...
# $ clay_tot_psa      : num  33 7.5 8.7 2.9 0 ...
# $ silt_tot_psa      : num  58 5.8 6.5 5.6 0.8 ...
# $ sand_tot_psa      : num  9 86.7 84.8 91.5 99.2 ...

ncss <- read.csv("F:/NCSS_Soil_Characterization_Database/q_soc_BD_PSDA.csv")
summary(ncss)
names(ncss)

ncss$samp_taxorder <- factor(toupper(ncss$samp_taxorder))
ncss$samp_taxsuborder <- factor(toupper(ncss$samp_taxsuborder))
ncss$samp_taxmoistscl <- factor(toupper(ncss$samp_taxmoistscl))
ncss$samp_taxtempregime <- factor(toupper(ncss$samp_taxtempregime))

ncss$SOC <- ifelse(ncss$SOC<0, 0, ncss$SOC)


ggplot(ncss[ncss$SOC >=0 & ncss$clay_tot_psa >0,  ], aes(clay_tot_psa, SOC)) + geom_point()

ggplot(ncss[ncss$SOC >=0 & ncss$SOC <=20 & ncss$clay_tot_psa >0,  ], aes(clay_tot_psa, SOC)) + 
  geom_point(aes(color=samp_taxorder))

#subset to data with taxonomic infor
t <- ncss[!is.na(ncss$samp_taxorder) & ncss$samp_taxorder != "",]

#subset data to only that with non organic horizons

m <- t[grep("O", t$hzn_master, ignore.case=T, invert=T),]
m <- m[m$SOC >=0 & m$SOC <=20 & m$clay_tot_psa >0,  ]

ggplot(m, aes(clay_tot_psa, SOC)) + geom_point()

ggplot(m, aes(clay_tot_psa, SOC)) + geom_point(aes(color = samp_taxmoistscl)) + facet_wrap(~samp_taxorder)

ggplot(m, aes(clay_tot_psa, SOC)) + geom_point(aes(color = samp_taxtempregime)) + facet_wrap(~samp_taxorder)

ggplot(m, aes(clay_tot_psa, SOC)) + geom_point(aes(color = samp_taxtempregime)) + facet_wrap(~samp_taxmoistscl)

#just in surface horizons
sm <- m[m$hzn_top ==0,]

ggplot(sm, aes(clay_tot_psa, SOC)) + geom_point()

ggplot(sm[!is.na(sm$samp_taxorder),], aes(clay_tot_psa, SOC)) + geom_point(aes(color = samp_taxmoistscl)) + facet_wrap(~samp_taxorder)

ggplot(sm, aes(clay_tot_psa, SOC)) + geom_point(aes(color = samp_taxtempregime)) + facet_wrap(~samp_taxorder)

ggplot(sm, aes(clay_tot_psa, SOC)) + geom_point(aes(color = samp_taxtempregime)) + facet_wrap(~samp_taxmoistscl)


sc <- ggplot(sm[!is.na(sm$samp_taxorder) & !is.na(sm$samp_taxmoistscl) & sm$samp_taxmoistscl != "",]
             , aes(clay_tot_psa, SOC)) + 
  geom_point(aes(color = samp_taxmoistscl)) + facet_wrap(~samp_taxorder)

sc1 <- sc +scale_fill_few()  + labs(color ="Moisture Regime", x="Clay %", y = "Soil Organic Carbon %") + 
  ggtitle("Mineral Surface Horizons")+
  theme(axis.text.y=element_text(size=8), axis.text.x=element_text(size=8)
        ,legend.text=element_text(size=8), strip.text = element_text(size=8) ) 

sc1



ggsave('Surface - SOC by Clay.png', plot = sc1, device = "png", path = "F:/NCSS_Soil_Characterization_Database", scale = 1, width = 6,   
       height = 3, units = "in", dpi = 600, limitsize = TRUE)


h <- t[t$hzn_master %in% c("A", "E", "B", "C"),]
h$hzn_master <- droplevels(factor(h$hzn_master))
levels(h$hzn_master)

h$hzn_master <- factor(h$hzn_master, levels(h$hzn_master)[c(1, 4, 2,3)])


SM <- ggplot(h, aes(hzn_master, SOC )) + geom_boxplot(aes(color = hzn_master))
SM

lSM <- ggplot(h, aes(hzn_master, log(SOC+.1) )) + geom_boxplot(aes(color = hzn_master), show.legend = F)
lSM

lSM1 <- lSM +scale_fill_few()  + labs(x ="Master Horizon", y = "ln (Soil Organic Carbon %)") + 
    theme(axis.text.y=element_text(size=8), axis.text.x=element_text(size=8)
        ,legend.text=element_text(size=8)) + scale_y_continuous(limits = c(-5,5))

lSM1

ggsave('Surface - SOC by Master.png', plot = lSM1, device = "png", path = "F:/NCSS_Soil_Characterization_Database", scale = 1, width = 6,   
       height = 3, units = "in", dpi = 600, limitsize = TRUE)


#Create function to build two-way contigency plot (area proportional to two variables)

ggMMplot <- function(var1, var2){
  require(ggplot2)
  levVar1 <- length(levels(var1))
  levVar2 <- length(levels(var2))
  
  jointTable <- prop.table(table(var1, var2))
  plotData <- as.data.frame(jointTable)
  plotData$marginVar1 <- prop.table(table(var1))
  plotData$var2Height <- plotData$Freq / plotData$marginVar1
  plotData$var1Center <- c(0, cumsum(plotData$marginVar1)[1:levVar1 -1]) +
    plotData$marginVar1 / 2
  
  ggplot(plotData, aes(var1Center, var2Height)) +
    geom_bar(stat = "identity", aes(width = marginVar1, fill = var2), col = "Black") +
    geom_text(aes(label = as.character(var1), x = var1Center, y = .95), angle = 90,
                   size= 2)
}


h <- t[t$hzn_master %in% c("A", "E", "B", "C", "O"),]
#h <- h[h$saRmp_taxorder != "", ]
h$hzn_master <- droplevels(factor(h$hzn_master))
levels(h$hzn_master)

h$hzn_master <- factor(h$hzn_master, levels(h$hzn_master)[c(5, 1, 4, 2, 3)])

# levels(h$samp_taxorder)
# h$samp_taxorder <- factor(h$samp_taxorder, levels(h$samp_taxorder)[c(5, 1, 4, 2, 3)])


ml <- ggMMplot(as.factor(h$samp_taxorder),as.factor(h$hzn_master))
ml
               
mml <-  ml + labs(x ="Soil Order", y = "Master Horizon", fill = "Master Horizon") + 
  theme(axis.text.y=element_text(size=8),legend.text=element_text(size=8)) + scale_y_reverse() 
 
mml


ggsave('Order_Master.png', plot = mml, device = "png", path = "F:/NCSS_Soil_Characterization_Database", 
       scale = 1, width = 12, height = 3, units = "in", dpi = 600, limitsize = TRUE)



####################################################
# Depth Plots for SOC concentration and Density
#using aqp
####################################################
library(aqp)
library(lattice)

h$Order <- h$samp_taxorder
h$clay <- h$clay_tot_psa
x <- h[h$samp_taxorder %in% c("ENTISOLS", "INCEPTISOLS", "ALFISOLS", "ULTISOLS"),]
x$Order <- droplevels(x$Order)

# promote to SPC
depths(x) <- pedlabsampnum ~ hzn_top + hzn_bot
# move some site-level data to site slot
site(x) <- ~  upedonid + Order

# depth-wise quantiles, by Soil Order
a <- slab(x,  Order ~ SOC + clay)

levels(a$Order)


# custom colors
tps <- list(superpose.line=list(col=c('DarkRed',  "RoyalBlue"), lwd=2))


p.SOC <- xyplot(top ~ p.q50, groups=Order, data=a, ylab='Depth (cm)',
                xlab='median bounded by 25th and 75th percentiles',
                lower=a$p.q25, upper=a$p.q75, ylim=c(40,-1),
                panel=panel.depth_function, alpha=0.25, sync.colors=TRUE,
                prepanel=prepanel.depth_function,
                strip=strip.custom(bg=grey(0.85)),
                scales=list(x=list(alternating=1)),
                par.settings=tps, subset=variable == 'SOC',
                auto.key=list(columns=2, lines=TRUE, points=FALSE)
)

p.Clay <- xyplot(top ~ p.q50, groups=Order, data=a, ylab='Depth (cm)',
               xlab='median bounded by 25th and 75th percentiles',
               lower=a$p.q25, upper=a$p.q75, ylim=c(40,-1),
               panel=panel.depth_function, alpha=0.25, sync.colors=TRUE,
               prepanel=prepanel.depth_function,
               strip=strip.custom(bg=grey(0.85)),
               scales=list(x=list(alternating=1)),
               par.settings=tps, subset=variable == 'clay',
               auto.key=list(columns=2, lines=TRUE, points=FALSE)
)
png(file = 'F:/NCSS_Soil_Characterization_Database/Order_depth-SOC.png', width = 4, height = 4, units = 'in', res = 600)
print(p.SOC) # Make plot
dev.off()

png(file = 'F:/NCSS_Soil_Characterization_Database/Order_depth-Clay.png', width = 4, height = 4, units = 'in', res = 600)
print(p.Clay) # Make plot
dev.off()


