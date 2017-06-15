library(rnoaa)
library(dplyr)
library(ggmap)
library(ggplot2)
library(maps)

options(noaakey = "GzYofYCBrXwSICBKNfKSOIPjfhSCyPeV")

#Get Table of all datasets
res <- ncdc_datasets()
res$data
#Daily Smmaries - GHCND
#Normals/Annual/Seasonal - NORMAL_ANN
#Normals Daily - NORMAL_DLY
#Normals Hourly - NORMAL_HLY
#Normals Monthly - NORMAL_MLY
#Precipitation Hourly - PRECIP_HLY

#ncdc_stations(datasetid = '', locationid = '', stationid = '')

#Find Stations within County using State and County FIPS 
ncdc_stations(datasetid = 'GHCND', locationid="FIPS:39097")

ncdc_stations(datasetid = 'GHCND', locationid = 'FIPS:39097', stationid = 'GHCND:USC00334681')
ncdc_stations(datasetid = 'PRECIP_HLY', locationid = 'FIPS:39097', stationid = 'GHCND:USC00334681')

out <- ncdc(datasetid = 'NORMAL_DLY', datatypeid= 'dly-tmax-normal', startdate= '2010-01-01', enddate = '2010-12-10')
outp <- ncdc(datasetid = 'PRECIP_HLY', datatypeid= 'PRCP', startdate= '2010-01-01', enddate = '2010-12-10')
outg <- ncdc(datasetid = 'GHCND', datatypeid= 'PRCP', startdate= '2010-01-01', enddate = '2010-12-10', limit = 500)

# dowload station data (there is a lot of data so it takes a while for this) will look at creating Regional subsets later
station_data<-ghcnd_stations()

#filger precip data
station_data %>% filter (element == "PRCP")

#subset precip data
prcp <- subset(station_data, element == "PRCP")

prcp(cbind(latitude, longitude))

map <- get_map(location = 'US', zoom = 4)

mapPoints <-ggmap(map)+ 
  geom_point(aes(x= longitude, y = latitude))



# rename column to "id" so rnoaa understands
s_ids<-plyr::rename(s, c("site_id"="id"))

# Find nearby NOAA weather station
nearest_station<-as.data.frame(meteo_nearby_stations(lat_lon_df=s_ids, lat_colname= "y", lon_colname="x", limit=1, station_data= station_data))

# Use the station ID from the nearest_station get daily climate data from NOAA database by climate Station ID
stations<-meteo_pull_monitors(nearest_station[1])

# Filter the dates of interest
station_filter<-stations %>% filter(date> "2004-09-26") %>% filter(date< "2011-06-18")

