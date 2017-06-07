#read and manipulate permutation tables
rm(list=ls())

#install.packages("tidyverse", "stringr)
library(tidyverse)
library(stringr)

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


rs <- samp %>%
  filter (!is.na(Measure_BD), !is.na(OM)) %>%
    mutate(LUGR = paste0(LU, MOGr), Master = str_sub(Model_desg, 1,1), Type = ifelse(Master == "O", "organic", "mineral")) %>%
  select(rcasiteid, upedonid, TOP, BOT, LU, LUGR, hzname, Model_desg, Master, Type, Texture, fragvolc, BDmethod, BD = Measure_BD, c_tot_ncs, caco3, SOC, OM)

sp <-   ggplot(rs, aes(OM,1/BD)) + geom_point(aes(color = Model_desg), size = 3, shape=2)

bdp <- ggplot(rs, aes(OM,BD)) + geom_point(aes(color = Model_desg), size = 3, shape = 1)

ggsave('1BD_and_OM.png', plot = sp, device = 'png', scale = 1, width = 6,   
       height = 3, units = "in", dpi = 300, limitsize = TRUE)

ggsave('BD_and_OM.png', plot = bdp, device = "png", scale = 1, width = 6,   
       height = 3, units = "in", dpi = 300, limitsize = TRUE)


op <- rs %>%
  filter(Type == "organic")%>%
  ggplot(aes(OM,1/BD)) + geom_point(aes(color = Model_desg), size = 3, shape=2) + 
  ggtitle("Only Organic Master Horizon")

p <-   rs %>%
  filter(Type == "organic")%>%
  ggplot(aes(OM,BD)) + geom_point(aes(color = Model_desg), size = 3, shape=2) + 
  ggtitle("Only Organic Master Horizon")
  

ggsave('Organic_1BD_and_OM.png', plot = op, device = 'png', scale = 1, width = 6,   
       height = 3, units = "in", dpi = 300, limitsize = TRUE)

ggsave('Organic_BD_and_OM.png', plot = p, device = "png", scale = 1, width = 6,   
       height = 3, units = "in", dpi = 300, limitsize = TRUE)


mp <- rs %>%
  ggplot(aes(OM,1/BD)) + geom_point(aes(shape = Type, color = Master), size = 3) + 
  ggtitle("ALL Horizons by type and Master")

mpp <-   rs %>%
  ggplot(aes(OM,BD)) + geom_point(aes(shape = Type, color = Master), size = 3) + 
  ggtitle("ALL Horizons by type and Master")


ggsave('byType&Master_1BD.png', plot = mp, device = 'png', scale = 1, width = 6,   
       height = 3, units = "in")

ggsave('byType&Master_BD.png', plot = mpp, device = "png", scale = 1, width = 6,   
       height = 3, units = "in", dpi = 300, limitsize = TRUE)

tp <- rs %>%
  filter(TOP <= 10) %>%
  
  ggplot(aes(OM,1/BD)) + geom_point(aes(shape = Type, color = Master), size = 3) + 
  ggtitle("Horizons within 10cm of surface - by type and Master")

tpp <-   rs %>%
  filter(TOP <= 10) %>%
  ggplot(aes(OM,BD)) + geom_point(aes(shape = Type, color = Master), size = 3) + 
  ggtitle("Horizons within 10cm  of surface- by type and Master")


ggsave('TOPbyType&Master_1BD.png', plot = tp, device = 'png', scale = 1, width = 6,   
       height = 3, units = "in")

ggsave('TOPType&Master_BD.png', plot = tpp, device = "png", scale = 1, width = 6,   
       height = 3, units = "in", dpi = 300, limitsize = TRUE)


lp <- rs %>%
  filter(TOP <= 10 & (LU=='W'|LU=='C')) %>%
  
  ggplot(aes(OM,1/BD)) + geom_point(aes(shape = Type, color = LU), size = 3) + 
  ggtitle("Horizons within 10cm of surface for Cropland and Wetlands \n by Horizon Type")+
  theme(plot.title = element_text(hjust = 0.5))

lp 

levels(rs$LU)
rs$LU <- factor(rs$LU, levels=c('C', 'F', 'P', 'R', 'W', 'X'), labels=c('Cropland', 'Forestland', 'Pastureland', 'Rangeland', 'Wetland', 'CRP'))

lpp <-   rs %>%
  filter(TOP <= 10) %>%
  ggplot(aes(OM,1/BD)) + geom_point(aes(shape = Type, color = Master), size = 3) + 
  ggtitle("Horizons within 10cm  of surface- by type and Master")+
  facet_wrap(~LU) + scale_x_continuous(limits=c(0,100))


lpp

ggsave('TOPC&WbyType&LUr_1BD.png', plot = lp, device = 'png', scale = 1, width = 6,   
       height = 3, units = "in")

ggsave('TOPType&Master_byLU.png', plot = lpp, device = "png", scale = 1, width = 6,   
       height = 3, units = "in", dpi = 300, limitsize = TRUE)



pdf(file = "OM&BD_graphs.pdf")
sp
bdp
op
p
mp
mpp
tp
tpp
dev.off()


#repeat for KSSL 
#from 2013 output of NCSS data

ncss <- read.csv('C:/Users/skye.wills/ownCloud/RaCA_data/BD_model/NCSS_SOC_abovebelow.csv')

#limit to sample values
ncss <- ncss[,3:19]

# calculate SOC and OM for each sample (forumlas from the NSSH 618.43)


ncss$soc <- ifelse(ncss$SOC<0, 0, ncss$SOC)

ncss$OM <- ncss$SOC*1.724


ns <- ncss %>%
  filter (!is.na(BD), !is.na(OM)) %>%
  mutate( Master = str_sub(Model_desg, 1,1), Type = ifelse(Master == "O", "organic", "mineral")) 

nsp <-   ggplot(ns, aes(OM,1/BD)) + geom_point(aes(color = Model_desg), size = 3, shape=2)

nbdp <- ggplot(ns, aes(OM,BD)) + geom_point(aes(color = Model_desg), size = 3, shape = 1)


nop <- ns %>%
  filter(Type == "organic")%>%
  ggplot(aes(OM,1/BD)) + geom_point(aes(color = Model_desg), size = 3, shape=2) + 
  ggtitle("Only Organic Master Horizon")

np <-   ns %>%
  filter(Type == "organic")%>%
  ggplot(aes(OM,BD)) + geom_point(aes(color = Model_desg), size = 3, shape=2) + 
  ggtitle("Only Organic Master Horizon")


ggsave('NCSS_Organic_1BD_and_OM.png', plot = nop, device = 'png', scale = 1, width = 6,   
       height = 3, units = "in", dpi = 300, limitsize = TRUE)

ggsave('NCSS_Organic_BD_and_OM.png', plot = np, device = "png", scale = 1, width = 6,   
       height = 3, units = "in", dpi = 300, limitsize = TRUE)


nmp <- ns %>%
  ggplot(aes(OM,1/BD)) + geom_point(aes(shape = Type, color = Master), size = 3) + 
  ggtitle("ALL Horizons by type and Master")

nmpp <-   ns %>%
  ggplot(aes(OM,BD)) + geom_point(aes(shape = Type, color = Master), size = 3) + 
  ggtitle("ALL Horizons by type and Master")


ggsave('NCSS_byType&Master_1BD.png', plot = nmp, device = 'png', scale = 1, width = 6,   
       height = 3, units = "in")

ggsave('NCSS_byType&Master_BD.png', plot = nmpp, device = "png", scale = 1, width = 6,   
       height = 3, units = "in", dpi = 300, limitsize = TRUE)

ntp <- ns %>%
  filter(top <= 10) %>%
  
  ggplot(aes(OM,1/BD)) + geom_point(aes(shape = Type, color = Master), size = 3) + 
  ggtitle("Horizons within 10cm of surface - by type and Master")

ntpp <-   ns %>%
  filter(top <= 10) %>%
  ggplot(aes(OM,BD)) + geom_point(aes(shape = Type, color = Master), size = 3) + 
  ggtitle("Horizons within 10cm  of surface- by type and Master")


ggsave('NCSS_TOPbyType&Master_1BD.png', plot = ntp, device = 'png', scale = 1, width = 6,   
       height = 3, units = "in")

ggsave('NCSS_TOPType&Master_BD.png', plot = ntpp, device = "png", scale = 1, width = 6,   
       height = 3, units = "in", dpi = 300, limitsize = TRUE)


lp <- rs %>%
  filter(TOP <= 10 & (LU=='W'|LU=='C')) %>%
  
  ggplot(aes(OM,1/BD)) + geom_point(aes(shape = Type, color = LU), size = 3) + 
  ggtitle("Horizons within 10cm of surface for Cropland and Wetlands \n by Horizon Type")+
  theme(plot.title = element_text(hjust = 0.5))


#NCSS dataset does not have a land use/cover assigned (earth cover kind)
# lp 
# 
# levels(rs$LU)
# rs$LU <- factor(rs$LU, levels=c('C', 'F', 'P', 'R', 'W', 'X'), labels=c('Cropland', 'Forestland', 'Pastureland', 'Rangeland', 'Wetland', 'CRP'))
# 
# lpp <-   rs %>%
#   filter(TOP <= 10) %>%
#   ggplot(aes(OM,1/BD)) + geom_point(aes(shape = Type, color = Master), size = 3) + 
#   ggtitle("Horizons within 10cm  of surface- by type and Master")+
#   facet_wrap(~LU) + scale_x_continuous(limits=c(0,100))
# lpp
# 
# ggsave('TOPC&WbyType&LUr_1BD.png', plot = lp, device = 'png', scale = 1, width = 6,   
#        height = 3, units = "in")
# 
# ggsave('TOPType&Master_byLU.png', plot = lpp, device = "png", scale = 1, width = 6,   
#       height = 3, units = "in", dpi = 300, limitsize = TRUE)



pdf(file = "NCSS_OM&BD_graphs.pdf")
nsp
nbdp
nop
np
nmp
nmpp
ntp
ntpp
dev.off()

write.csv(ns, "KSSL_data.csv")
