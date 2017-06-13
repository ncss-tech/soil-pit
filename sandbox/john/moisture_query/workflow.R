library(soilDB)
library(ggplot2)
library(lubridate)
library(rnoaa)
library(dplyr)
library(RODBC)

# Load Monitoring Data into R

monitor_data<-read.csv("//AIOININ23FP1/ININ2/Home/NRCS/john.hammerly/Desktop/000009BEC048_20110617_0923.csv", header=FALSE, skip=8, col.names=c("date","time","depth","units"), as.is=TRUE)

# Summarize into daily readings

monitor_data_daily<- aggregate(cbind(depth)~date,data=monitor_data,FUN=mean)

# Convert depths to positve centimeters and round to nearest whole number

monitor_data_daily_convert<-data.frame(monitor_data_daily$date, round(monitor_data_daily$depth*-1*2.54))

# Specify column names

names(monitor_data_daily_convert)<-list("date","depth")

# Open connection to Pedon PC access database (must have 32bit R running)

PedonPC<-odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=C:/pedon/pedon.accdb")

# Need to create a site at some point

# Save Monitoring Data to Pedon PC first in the dates in the obsdate column in the siteobs table  (Need to figure out date formatting for this part to work)

sqlSave(PedonPC, monitor_data_daily_convert$date, tablename=siteobs)  # Still need modifications for this part to work.
sqlSave(PedonPC, monitor_data_daily_convert$depth, tablename=sitesoilmoist)  # before this we need to get the columns right soimoistdept, soimoistdepb, soilmoistsensordepth, obssoimoiststat.  Record IDs must match the observation dates

# Open NASIS and upload Pedons from Pedon PC

# Load the site(s) of interest in NASIS seleceted set before using these functions

# get data from NASIS
s<-get_site_soilmoist_from_NASIS_db()


# Plot all data
ggplot(s, aes(x= as.Date(obs_date),y= t_sm_d)) +
  geom_line(cex=1)+scale_y_reverse()+scale_x_date()


# aggregate by month
s_by_month<- aggregate(cbind(t_sm_d)~month(obs_date),data=s,FUN=mean)


# Plot Results
ggplot(s_by_month, aes(x= `month(obs_date)`,y= t_sm_d)) +
  geom_line(cex=1) +
  scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month") +
  ylim(200, 0)

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

# Normal Years must meet 2 conditions:
 
# Annual precipitation must be within (+/-) 1 standard deviation of the long term (30 years or more) of the mean annual precipitation
# Mean monthly precipitation must be within (+/-) 1 standard deviation of long term monthly precipitation of 8 of the 12 months
 
# Get standard deviation
 sd(filter_annual_precip$prcp)

# Get mean
  mean(filter_annual_precip$prcp)

# Find min and max precip using mean and standard deviation
min_normal_precip<-mean(filter_annual_precip$prcp)-sd(filter_annual_precip$prcp)
max_normal_precip<-mean(filter_annual_precip$prcp)+sd(filter_annual_precip$prcp)

# Calculate mean long term monthly precipitation

# Sum the monthly data
stations_by_month_and_year<-aggregate(cbind(prcp)~month(date)+year(date),data=stations,FUN=sum)

#find means by month
month_means<-aggregate(stations_by_month_and_year, by=list(stations_by_month_and_year$`month(date`), mean)

  # Sum annual rainfall
 station_annual_precip<-aggregate(cbind(prcp)~year(date),data=stations,FUN=sum)
 
 # Filter data for 30 year climate normal years 1981-2010
 filter_annual_precip<-station_annual_precip %>% filter(`year(date)`>1980) %>% filter(`year(date)`<2011)
 
 # Summary statistics for the dataset
 summary(filter_annual_precip)
 
 # Find normal years using 1st and 3rd quartiles as range
normal_years<-station_annual_precip %>%
  filter(prcp>quantile(filter_annual_precip$prcp, 0.25)) %>%
  filter(prcp<quantile(filter_annual_precip$prcp, 0.75)) %>%
  filter(`year(date)`>2003) %>% filter(`year(date)`<2012)

 #Use only normal years
s_normal_years<-s %>%
  filter(obs_date>as.Date("12-31-2003",format='%m-%d-%Y') & obs_date<as.Date("01-01-2005", format='%m-%d-%Y')|
           obs_date>as.Date("12-31-2005",format='%m-%d-%Y') & obs_date<as.Date("01-01-2007", format='%m-%d-%Y')|
           obs_date>as.Date("12-31-2008",format='%m-%d-%Y') & obs_date<as.Date("01-01-2010", format='%m-%d-%Y')|
           obs_date>as.Date("12-31-2010",format='%m-%d-%Y') & obs_date<as.Date("01-01-2012", format='%m-%d-%Y'))

 # Aggregate normal years by month
s_normals_by_month<- aggregate(cbind(t_sm_d)~month(obs_date),data=s_normal_years,FUN=mean)

# Plot Results
ggplot(s_normals_by_month, aes(x= `month(obs_date)`,y= t_sm_d))+geom_line(cex=1)+scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month")+ylim(200, 0)

# Select normal rainfall data
normal_station_filter<-station_filter %>%
  filter(date>as.Date("12-31-2003",format='%m-%d-%Y') & date<as.Date("01-01-2005", format='%m-%d-%Y')|
           date>as.Date("12-31-2005",format='%m-%d-%Y') & date<as.Date("01-01-2007", format='%m-%d-%Y')|
           date>as.Date("12-31-2008",format='%m-%d-%Y') & date<as.Date("01-01-2010", format='%m-%d-%Y')|
           date>as.Date("12-31-2010",format='%m-%d-%Y') & date<as.Date("01-01-2012", format='%m-%d-%Y'))

# Aggregate normal rainfall
normal_station_filter_by_month<-aggregate(cbind(prcp)~month(date),data=normal_station_filter,FUN=sum)

# Plot rainfall and water table by month
ggplot() +
  geom_line(data= s_normals_by_month, aes(x= `month(obs_date)`,y=-1*(t_sm_d)),cex=1) +
  geom_line(data= normal_station_filter_by_month, aes(x= `month(date)`,y= prcp/100), color='blue') +
  scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month") +
  ylim(-210, 40) +
  geom_hline(aes(yintercept=0))

# Filter moisture observations within 1st and 3rd quartile
normal_s<-s %>%
  filter(t_sm_d>quantile(s$t_sm_d, 0.25)) %>%
  filter(t_sm_d<quantile(s$t_sm_d, 0.75))

# Filter normal precip
filter_normal_annual_precip<-filter_annual_precip %>% filter(prcp>min_normal_precip) %>% filter(prcp<max_normal_precip)
