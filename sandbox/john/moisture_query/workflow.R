library(soilDB)
library(ggplot2)
library(lubridate)
library(rnoaa)
library(dplyr)

# Load the site(s) of interest in NASIS seleceted set before using these functions

# get data from NASIS
s<-get_site_soilmoist_from_NASIS_db()


# Plot all data
ggplot(s, aes(x= as.Date(obs_date),y= t_sm_d))+geom_line(cex=1)+scale_y_reverse()+scale_x_date()


# aggregate by month
s_by_month<- aggregate(cbind(t_sm_d)~month(obs_date),data=s,FUN=mean)


# Plot Results
ggplot(s_by_month, aes(x= `month(obs_date)`,y= t_sm_d))+geom_line(cex=1)+scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month")+ylim(200, 0)

# dowload station data (there is a lot of data so it takes a while for this) will look at creating Regional subsets later
station_data<-ghcnd_stations()

# rename column to "id" so rnoaa understands
s_ids<-plyr::rename(s, c("site_id"="id"))

# Find nearby NOAA weather station
nearest_station<-as.data.frame(meteo_nearby_stations(lat_lon_df=s_ids, lat_colname= "y", lon_colname="x", limit=1, station_data= station_data))

# Use the station ID from the nearest_station get daily climate data from NOAA database by climate Station ID
stations<-meteo_pull_monitors(nearest_station[1])

# Filter the dates of interest
station_filter<-stations %>% filter(date> "2004-09-26") %>% filter(date< "2011-06-18")

# Plot daily rainfall and soil moisture data
 ggplot() +
  geom_line(data= s, aes(x= as.Date(obs_date),y=-1*(t_sm_d))) +
  geom_line(data= station_filter, aes(x= as.Date(date),y= prcp/100), color='blue') +
  ylim(-210, 10)

 # Sum annual rainfall
 
 
 # Sum annual rainfall for climate normal years 1981-2010