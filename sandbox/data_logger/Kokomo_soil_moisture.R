library(ggplot2)
library(plyr)




Kokomo_sm=ldply(list.files(path="E:/Documents/GIS/Trainings/Stat_for_Soil_Survey/final_Project/nasis",pattern="csv",full.names=TRUE),function(filename) {
  dum=read.csv(filename)
  dum$filename=filename
  return(dum)
})

Kokomosm0 <- subset(Kokomo_sm, Moisture.Status == "wet")
#Kokomosm1 <- subset(Kokomo_sm, DMU.Description == "MLRA 111A Kokomo sicl, 0 to 2%" & Moisture.Status == "wet")

K <- cbind(Kokomosm0, Low, RV, High)

Kokomosm2 <- aggregate(Month ~ High & Low + RV, data = Kokomosm0)

ggplot(data=Kokomosm0, aes(Month, High))+geom_point(colour='red') +ylim (0,175)
ggplot(data=Kokomosm0, aes(Month, Low))+geom_point(colour='purple') +ylim (0,175)
ggplot(data=Kokomosm0, aes(Month, RV))+geom_point(colour='green') +ylim (0,175)

ggplot(data=K, aes(Month)+geom_point(colour=K) +ylim (0,175))

ggplot(data=Kokomosm0, aes(Month, RV))+geom_point()+facet_grid(c(Low, RV, High))


#plots all 3 values overlayed
ggplot(data=Kokomosm0, (aes(Month, High))+ geom_point(colour='red')

ggplot()+geom_line(data=Kokomosm0, aes(Month, Low), colour='red')+
  geom_line(data=Kokomosm0, aes(Month, RV), colour='purple')+
  geom_point(data=Kokomosm0, aes(Month, High), colour='green') +
  ylim (175, 0)


ggplot()+geom_point(data=Kokomosm0, aes(Month, Low), colour='red')+
  geom_point(data=Kokomosm0, aes(Month, RV), colour='purple')+
  geom_point(data=Kokomosm0, aes(Month, High), colour='green')+
  ylim (0, 175)

ggplot()+geom_jitter(data=Kokomosm0, aes(Month, Low), colour='red', outlier.shape = 2)+
  geom_jitter(data=Kokomosm0, aes(Month, RV), colour='purple', outlier.shape = 2)+
  geom_jitter(data=Kokomosm0, aes(Month, High), colour='green', outlier.shape = 2)+
  ylim (200, 0)+
  ggtitle("Soil Moisture Months from NASIS")+
  theme(plot.title = element_text(lineheight=.8, face="bold"))

ggplot()+geom_violin(data=Kokomosm0, aes(Month, Low), colour='red', outlier.shape = 2)+
  geom_violin(data=Kokomosm0, aes(Month, RV), colour='purple', outlier.shape = 2)+
  geom_violin(data=Kokomosm0, aes(Month, High), colour='green', outlier.shape = 2)+ 
  ylim (200, 0)+ facet_wrap(Low)+
  ggtitle("Soil Moisture Months from NASIS")+
  theme(plot.title = element_text(lineheight=.8, face="bold"))

ggplot()+geom_point(data=Kokomosm0, aes(Month, High), colour='red')+facet_wrap(~High)+
  geom_point(data=Kokomosm0, aes(Month, RV), colour='purple')+ facet_wrap(~High)+
  geom_point(data=Kokomosm0, aes(Month, Low), colour='green')+ facet_wrap(~High)+
  ylim (200, 0)+ 
  ylab("Low, RV, High")+
  ggtitle("Soil Moisture Months from NASIS")+
  theme(plot.title = element_text(lineheight=.8, face="bold"))




ggplot()+geom_point(data=Kokomosm0, aes(Month, Low), colour='red')