#read and manipulate permutation tables
rm(list=ls())

#install.packages("tidyverse", "stringr", "hexbin", "ggjoy", "ggbeeswarm", "viridis", "gridExtra", "cetcolor")
library(tidyverse)
library(stringr)
library(hexbin)
library(ggjoy)
library(ggbeeswarm)
library(viridis)
library(gridExtra)
library(cetcolor)

#reset this to save where you put this data - auto download isn't working
#https://www.cloudvault.usda.gov/index.php/s/YXoJolPAXLNoY1S


setwd("C:/Users/skye.wills/ownCloud/RaCA_BD-OM/")
#setwd("C:/Users/skyew/ownCloud/RaCA_BD-OM")

#import RaCA_download data
samp <- read.csv('C:/Users/skye.wills/ownCloud/RaCA_data/RaCA_samples.csv')

# calculate SOC and OM for each sample (forumlas from the NSSH 618.43)

samp$CALC_SOC <- ifelse(!is.na(samp$caco3),
                        ifelse(samp$caco3>0,samp$c_tot_ncs-(samp$caco3*0.12),samp$c_tot_ncs), samp$c_tot_ncs)

samp$SOC <- ifelse(samp$CALC_SOC<0, 0, samp$CALC_SOC)

samp$OM <- samp$SOC*1.724

samp$OM <- ifelse(samp$OM>100, 100, samp$OM)

#with old colors

rs <- samp %>%
  filter (!is.na(Measure_BD), !is.na(OM)) %>%
    mutate(LUGR = paste0(LU, MOGr), Master = str_sub(Model_desg, 1,1), Type = ifelse(Master == "O", "organic", "mineral")) %>%
  select(rcasiteid, upedonid, TOP, BOT, LU, LUGR, hzname, Model_desg, Master, Type, Texture, fragvolc, BDmethod, BD = Measure_BD, c_tot_ncs, caco3, SOC, OM)


ggplot(rs, aes(y = BD, x = Master)) + geom_jitter(aes(color = SOC)) +
  scale_colour_gradient2(low = "green", mid = "grey", high = "blue", midpoint = 20)

rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
           ggplot(aes(y = BD, x = Master)) + geom_jitter(aes(color = SOC)) +
           scale_colour_gradient2(low = "green", mid = "grey", high = "blue", midpoint = 10)

rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(y = BD, x = Master)) + geom_jitter(aes(colour = SOC)) +
  scale_colour_viridis(option = "magma",begin = 0, end = 1, direction = -1 )


rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(y = BD, x = SOC)) + geom_hex()+
  scale_colour_gradient2(low = "green", mid = "grey", high = "blue", midpoint = 500)


rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(x=BD, y=Master, fill = Master, height = ..density..)) +  
    geom_joy(scale = 1, stat = "density", alpha = 0.5)  + theme_joy()
  
#joy plot
rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(x=BD, y=Master, fill = Master, height = ..density..)) +  
  geom_joy(scale = 1, stat = "density", alpha = 0.5)  + theme_joy()

#joy plot with continuous fill
rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(x=BD, y = Master, fill = ..x..)) +  
  geom_joy_gradient()  + scale_fill_viridis(name = "BD", option="magma")+ theme_joy() +
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Master Horizon",caption="@wills_skye", title="Joyplot")

#bee swarm
rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(x=BD, y = Master, color = BD)) +  
  geom_quasirandom(alpha=0.82, groupOnX=FALSE) + scale_color_viridis(name = "BD")+ theme_joy() +
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Master Horizon",caption="@wills_skye", title="Beeswarm Plot")


#Joyswarms
rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(x=BD, y = Master, color = BD, fill = ..x..)) + 
  scale_color_viridis()+ 
  geom_joy(alpha = 0.75, fill = "lightgray") +
  geom_quasirandom(alpha=0.82, groupOnX=FALSE) +
        scale_fill_viridis() + theme_joy()+ 
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Master Horizon",caption="@wills_skye", title="JoySwarm Plot")


#Joyswarms
rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(x=BD, y = Master, color = BD, fill = ..x..)) + 
  scale_color_viridis()+ 
  geom_joy(scale = 0.75, alpha = 0.75, fill = "lightgray") +
  geom_quasirandom(alpha=0.82, groupOnX=FALSE) +
  scale_fill_viridis() + theme_joy()+ 
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Master Horizon",caption="@wills_skye", title="JoySwarm Plot")


######################
#with new colors
#######################
install.packages('cetcolor')
library(cetcolor)
display_cet_attribute(attribute = "linear")
display_cet_attribute(attribute = "diverging")
?cet_color_maps

#use grid arrange to view multiple plots at once

grid.arrange(
ggplot(rs, aes(y = BD, x = Master)) + geom_jitter(aes(color = SOC), alpha = .5) +
  scale_color_gradientn(colours = cet_pal(5, name = "inferno"))

,
ggplot(rs, aes(y = BD, x = Master)) + geom_jitter(aes(color = SOC), alpha = .5) +
  scale_color_gradientn(colours = cet_pal(10, name = "cyclic_mrybm_35-75_c68_n256"))
,
rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(y = BD, x = Master)) + geom_jitter(aes(color = SOC)) +
  scale_color_gradientn(colors = cet_pal(5, name = "inferno"))

,
rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(y = BD, x = Master)) + geom_jitter(aes(color = SOC)) +
  scale_colour_gradientn(colours = cet_pal(10, name = "diverging-rainbow_bgymr_45-85_c67_n256"))
,
ncol = 2, nrow=2)


#########

#joy plot with continuous fill
rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(x=BD, y = Master, fill = ..x..)) +  
  geom_joy_gradient()  + 
  scale_fill_gradientn(colours = cet_pal(5, name = "fire"), name = "BD")+
  theme_joy() +
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Master Horizon",caption="@wills_skye", title="Joyplot w CET fire color")

#bee swarm
rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(x=BD, y = Master, color = BD)) +  
  geom_quasirandom(alpha=0.82, groupOnX=FALSE) + 
  scale_color_gradientn(colours = cet_pal(10, name = "cyclic_mrybm_35-75_c68_n256"), name = "BD")+
  theme_joy() +
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Master Horizon",caption="@wills_skye", title="Beeswarm Plot w rainbow CET color")


rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(x=BD, y = Master, color = BD, fill = ..x..)) + 
  scale_color_gradientn(colours = cet_pal(10, name = "diverging-isoluminant_cjm_75_c23_n256"), name = "BD")+
  geom_quasirandom(alpha=0.82, groupOnX=FALSE) +
  scale_fill_gradientn(colours = cet_pal(10, name = "diverging-isoluminant_cjm_75_c23_n256"), name = "BD")+
  theme_joy()+ 
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Master Horizon",caption="@wills_skye", title="BeeSwarm Plot w/ isolum CET color")

rs %>%
  filter(Master %in% c('A','E','B','C')) %>%
  ggplot(aes(x=BD, y = Master, color = BD, fill = ..x..)) + 
  scale_color_gradientn(colours = cet_pal(5, name = "kgy"), name = "BD")+
  geom_quasirandom(alpha=0.82, groupOnX=FALSE) +
  scale_fill_gradientn(colours = cet_pal(5, name = "kgy"), name = "BD")+
  theme_joy()+ 
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Master Horizon",caption="@wills_skye", title="BeeSwarm Plot w/ KGY CET color")



