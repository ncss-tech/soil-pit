#Use ggjoy to look at SOC distribution in RaCA pedons



#add data if not currently available
raca.pedon.url <- 'https://www.cloudvault.usda.gov/index.php/s/XDYs3KCNG1GcoZE/download'
ifelse(!file.exists('RaCA_SOC_pedons.csv'), download.file(raca.pedon.url, destfile = 'RaCA_SOC_pedons.csv') , "File already downloaded")
SOCpedons <- read.csv("RaCA_SOC_pedons.csv")

#filter for only LU classes with spatial extent
O <- SOCpedons[SOCpedons$LU != "X", ]
O$LUGR <- as.factor(paste0(as.character(O$LU),substr(O$rcasiteid,2,5)))
levels(O$LU)
O$LU <- factor(O$LU, levels(O$LU)[c(5,2,3,4,1)])
levels(O$LU)
levels(O$LU)<- c('Wetland', 'Forestland', 'Pastureland',  "Rangeland",'Cropland')


#add packages
library(devtools)
install_github("clauswilke/ggjoy")

library(ggplot2)
library(ggjoy)

#example from ggjoy github
ggplot(diamonds, aes(x=price, y=cut, group=cut, height=..density..)) +
  geom_joy(scale=4) +
  scale_y_discrete(expand=c(0.01, 0)) +
  scale_x_continuous(expand=c(0, 0)) + theme_joy()

#SOC to 100cm by land use/cover class
ggplot(O, aes(x=SOCstock100, y=LU, group=LU, fill = LU, height=..density..)) +
  geom_joy(scale=3) +
  scale_y_discrete(expand=c(0.01, 0)) +
  scale_x_continuous(expand=c(0, 0)) + theme_joy() + scale_x_log10()+
  labs(y ="Land Use / Land Cover Class",  x =" SOC stock (Mg/ha)", fill = "Land Use/Cover")

#SOC to 100cm by Region (called MO)
ggplot(O, aes(x=SOCstock100, y=as.factor(MO), group=as.factor(MO), height=..density..)) +
  geom_joy(scale=3) +
  scale_y_discrete(expand=c(0.01, 0)) +
  scale_x_continuous(expand=c(0, 0)) + theme_joy() + scale_x_log10()+ 
  labs(y ="Regions",  x ="SOC stock (Mg/ha)")
