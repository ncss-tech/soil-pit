library(sp)
library(maps)
library (ggplot2)
library (chron)
library(plyr)
library(scales)
library(zoo)
library(lattice)
library(RColorBrewer)
library(reshape2)
library(latticeExtra)
library(rgl)
library(scatterplot3d)
library(hexbin)
library(car)
library(weatherData)
library(rnoaa)
library(prism)
#library(gclus)


map('county', 'ohio') # plot county boundaries for all of Ohio
map('county', 'ohio,madison', add=T, fill = T, col="purple") #add Madison County, Ohio in purple to map
map.text("county", "ohio,Madison", add=T) #add text to madison

#Kokomo <- Sys.glob("C:/workspace/merge71/*.csv") #finds all csv files in folder
#for (Ko in Kokomo) {Kokomo71 <- read.csv(Ko, header = TRUE, sep = ",")} #iterate across all files?
Kokomo71=ldply(list.files(path="C:/workspace/merge71/",pattern="csv",full.names=TRUE),function(filename) {
  dum=read.csv(filename)
  dum$filename=filename
  return(dum)
})

Kokomo71$date <- as.Date(Kokomo71$date, '%m/%d/%Y')

ggplot(data=Kokomo71, aes (date, feet)) +geom_line()+ ylim(10, -5) #plot line


#ggplot(Kokomo71, aes(x=date, y=feet))+geom_line(aes(color=date)) #plot point
#ggplot(Kokomo71, aes(x=time, y=feet))+geom_line(aes(color=time)) #plot discrepancy in time 12:00:01 color

m <- mean(Kokomo71$feet) #mean feet
m
min <-min(Kokomo71$feet)#min feet
min
max<-max(Kokomo71$feet)#max feet
max
summary(Kokomo71$feet)


#Plot Yearly - Depths, Months, Years

#Plot 7 Day Hourly 

#Plot 30 day Daily Table (Spring)

#Plot mean of hourly values

#Plot mean by month/year

#Plot totals by month/year

#Plot Data Gaps - date