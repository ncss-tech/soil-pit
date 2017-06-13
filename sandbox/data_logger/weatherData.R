library(weatherData)
library(lubridate)
library(maps) #create maps
library(plyr) #splitting, applying, & combining data
library(ggplot2) #plot
library(lattice) #xy plot

#KUYF - Madison County, Ohio airport code
#TZR - Bolton Field, Colombus, Ohio airport code
#KI69 - Clermont County, Batavia, Ohio


#data_okay <- checkDataAvailability("I14", "2016-03-21" )

#data_okay2 <- checkDataAvailabilityForDateRange("KUYF", "2006-04-17", "2016-10-18")

#getWeatherForDate("KUYF", "2014-05-05")

## Need to loop through individual years to get full historical record 
for (yr in 1950:2017) { 
  start <- paste(yr,"-01-01",sep="")
  end <- paste(yr,"-12-31",sep="") 
  precip_yr <- paste("precip_",yr, sep="") 
  yr_data <- getWeatherForDate("KI69", start_date=start, ,end_date=end, opt_custom_columns=T, custom_columns=c(20)) 
  yr_data$Date <- ymd(yr_data$Date) 
  # make csv file name for each year of data downloaded 
  my_dir <- "E:/temp/weatherData/KI69" 
  link <- paste(my_dir,precip_yr,".csv",sep="")
  write.csv(yr_data, link, quote=FALSE, row.names = F) }

#alter path as needed
precip=ldply(list.files(path="E:/temp/weatherData/KI69",pattern="csv",full.names=TRUE),function(filename) {
  dum=read.csv(filename)
  dum$filename=filename
  return(dum)
})

#read the date from the table
precip$date <- as.Date (precip$date, '%m/%d/%Y')

#ars <- getSummarizedWeather("TZR", "2006-04-17", "2016-10-18", opt_temperature_columns = FALSE, opt_all_columns = TRUE)

precip$date<-as.POSIXlt(precip$date,format="%m/%d/%y %H:%M:%S")
precip <- within(precip, {
  day =   as.character(format(precip$date, "%m/%d/%y"))
  Jday =  as.integer(format(precip$date, "%j"))
  year =  as.integer(format(precip$date, "%Y"))
  month = as.integer(format(precip$date, "%m"))
  week =  as.integer(format(precip$date, "%W"))
})

#subset data Events & PrecipitationIn
precip_s<- subset(precip, Events = PrecipitationIn)
#ars_t<- subset(ars1, PrecipitationIn %in% Events)
#ars_t<- subset(ars1, PrecipitationIn < Events)
#ars_u<- subset(ars1, Events = PrecipitationIn )
#ars_v<- subset(ars1, PrecipitationIn = %)

#plot
ggplot(data = precip_s, aes(week, PrecipitationIn)) +geom_point(colour="purple")

ggplot(data = precip_s, aes(PrecipitationIn, year)) +geom_point(colour="purple")

ggplot(data = precip_s, aes(Jday, PrecipitationIn)) +geom_line(colour="purple")


ggplot(data = precip, aes(Jday, PrecipitationIn, group = year)) +
  geom_line(aes(colour= factor(year)))+
  ylim(0, 3) +
  ggtitle("Daily")+
  theme(plot.title = element_text(lineheight=.8, face="bold"))

#plot 
ggplot(data = precip, aes(month, PrecipitationIn)) +
  geom_point(colour="purple") +
  geom_smooth(colour="green") + 
  ylim(0, 3) +
  facet_wrap(~ year)+
  ggtitle("Averages of Months and Years")+
  theme(plot.title = element_text(lineheight=.8, face="bold"))