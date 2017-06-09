library(weatherData)

#KUYF - Madison County, Ohio airport code
#TZR - Bolton Field, Colombus, Ohio airport code


data_okay <- checkDataAvailability("I14", "2016-03-21" )

data_okay2 <- checkDataAvailabilityForDateRange("KUYF", "2006-04-17", "2016-10-18")

getWeatherForDate("KUYF", "2014-05-05")

ars <- getSummarizedWeather("TZR", "2006-04-17", "2016-10-18", opt_temperature_columns = FALSE, opt_all_columns = TRUE)

ars$Date<-as.POSIXlt(ars$Date,format="%m/%d/%y %H:%M:%S")
ars1 <- within(ars, {
  day =   as.character(format(ars$Date, "%m/%d/%y"))
  Jday =  as.integer(format(ars$Date, "%j"))
  year =  as.integer(format(ars$Date, "%Y"))
  month = as.integer(format(ars$Date, "%m"))
  week =  as.integer(format(ars$Date, "%W"))
})

#subset data Events & PrecipitationIn
ars_s<- subset(ars1, Events = PrecipitationIn)
#ars_t<- subset(ars1, PrecipitationIn %in% Events)
ars_t<- subset(ars1, PrecipitationIn < Events)
ars_u<- subset(ars1, Events = PrecipitationIn )
ars_v<- subset(ars1, PrecipitationIn = %)

ggplot(data = ars_t, aes(week, PrecipitationIn)) +geom_line(colour="purple")

ggplot(data = ars_t, aes(PrecipitationIn, week)) +geom_point(colour="purple")