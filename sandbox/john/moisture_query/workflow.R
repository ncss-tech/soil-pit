#
# Before Starting this workflow, a new empty pedon database is required in Pedon PC 6.3
#
# There are some assumptions in this workflow at this time which are as follows:
# 1. A site and pedon do not already exist in NASIS
# 2. The monitoring data is an accurate representation of a wet soil moisture condition
# 3. Data collection has completed and it is ready to archive in NASIS and analyzed in R
#

# Load required libraries
library(soilDB) #not required now but could be needed if GitHub function is added to the package later
library(ggplot2)
library(lubridate)
library(rnoaa)
library(dplyr)
library(RODBC)

# Load Monitoring Data into R, depending on your dataset, you may need to modify this next part according to your unique data.
monitor_data<-read.csv("C:/Users/john.hammerly/ownCloud/water_monitor_data/000009BEC048_20110617_0923.csv", header=FALSE, skip=8, col.names=c("date","time","depth","units"), as.is=TRUE)

# Summarize into means of readings for each day
monitor_data_daily<- aggregate(cbind(depth)~date,data=monitor_data,FUN=mean)

# Convert inch depths to positve centimeters and round to nearest whole number, convert dates in to date type, (depending on your data, this step may not be necessary)
monitor_data_daily_convert<-data.frame(as.Date(monitor_data_daily$date, format="%m/%d/%Y"), round(monitor_data_daily$depth*-1*2.54))

# Specify column names because the previous code messed them up
names(monitor_data_daily_convert)<-list("obsdate","depth")

# Replace any negative values with 0, this dataset contained values above the calibration point, which will cause an error in NASIS.
monitor_data_daily_convert$depth[monitor_data_daily_convert$depth<0]<-0

# Order dates chronologically, the sequence of the data is important since we need to strip out the dates later on in the sitesoimoist table
monitor_data_daily_convert<-monitor_data_daily_convert[order(monitor_data_daily_convert$obsdate),]

# Reassign row names, this allows for the correct calculation of the sequence column
row.names(monitor_data_daily_convert) <- 1:nrow(monitor_data_daily_convert)

# Create a sequence column, this will also be used to generate the primary key (record id)
monitor_data_daily_convert$seqnum<-seq.int(nrow(monitor_data_daily_convert))

# Create dataframe for sitesoilmoist table, the data in NASIS is in 2 tables - the siteobs table and the sitesoimoist table
sitesoilmoist_table<-monitor_data_daily_convert

# Create sitemiid, this is needed for proper loading into Pedon PC
sitesoilmoist_table$sitesmiid<-sitesoilmoist_table$seqnum

# Create topdepth, this is the depths recorded by the monitoring equipment
sitesoilmoist_table$soimoistdept<-sitesoilmoist_table$depth

# Create bottom depth, for this sensor, the bottom depth is the lowest the sensor will register a reading
sitesoilmoist_table$soimoistdepb<-210

#create sensor depth, this is also the lowest the sensor will register a reading
sitesoilmoist_table$soilmoistsensordepth<-210

# Create moisture status, 9 is the NASIS code for wet status
sitesoilmoist_table$obssoimoiststat<-9

# Create siteobsiidref, this is needed for proper loading into PedonPC
sitesoilmoist_table$siteobsiidref<-sitesoilmoist_table$seqnum

# Create obsdatekind column use 1 as a code for actual observation date
monitor_data_daily_convert$obsdatekind<- as.integer(1)

# Create column for datacollector, this should be the office responsible for the monitoring equipment
monitor_data_daily_convert$datacollector<- "11-ATL"

# Reorder data columns, probably not necessary, but makes more sense
monitor_data_daily_convert<-monitor_data_daily_convert[,c(3,1,4,5)]

# Open connection to Pedon PC access database (must have 32bit R running) you may need to change the path depending on your machine
PedonPC<-odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=C:/pedon/pedon.accdb")

#get siteobs table data from PedonPC, we will use this table to copy the columns into our dataset
pedon_pc_siteobs_table<-sqlFetch(PedonPC,"siteobs")

# Get sitesoilmoist from PedonPC, we will use this table to copy the columns into our dataset
ppc_sitesoilmoist_table<-sqlFetch(PedonPC,"sitesoilmoist")

# Get site table from PedonPC, this is needed to create a new site
ppc_site_table<-sqlFetch(PedonPC,"site")

# Convert factor to character data type
ppc_site_table$usiteid<-as.character(ppc_site_table$usiteid)

# Add a usiteid (change the id below to one relevant to your data)
ppc_site_table[1,1]<-"2017IA001001"

# Add an sdbiidref, required to load into PedonPC
ppc_site_table[1,68]<-1

# Add a siteiid, required to load into PedonPC
ppc_site_table[1,69]<-1

# Additional site data can be entered directly into PedonPC or NASIS

# Save site table to PedonPC
sqlSave(PedonPC,ppc_site_table,"site",append=T, rownames = F)

#
# This section deals with the siteobs table
#

# If siteobs does have data, keep only the columns
siteobs_columns_only<-pedon_pc_siteobs_table[0,]

# Merge the dataset with PedonPC data columns
c_monitor_d_d_c<-merge(siteobs_columns_only,monitor_data_daily_convert, all.y=T)

# This is what links the site obeservation to the site table.  The siteiidref should be the same as the site record id.
c_monitor_d_d_c$siteiidref<-as.integer(1)

# This is the id which will be linked to the sitesoimoist table later
c_monitor_d_d_c$siteobsiid<-c_monitor_d_d_c$seqnum

#
#This section deals with the sitesoimoist table
#

# If sitesoilmoist does have data, keep only the columns
sitesoilmoist_columns_only<-ppc_sitesoilmoist_table[0,]

# Merge the dataset with PedonPC data columns
ppc_sitesoilmoist_merge<-merge(sitesoilmoist_columns_only,sitesoilmoist_table, all.y=T)

# Keep only the columns needed for loading into PedonPC
ppc_sitesoilmoist_merge<-ppc_sitesoilmoist_merge[,1:11]

# Add dataset to existing PedonPC table 
pc_combined<-rbind(pedon_pc_siteobs_table,c_monitor_d_d_c)

# Change factors into character data type
pc_combined$datacollector<-as.character(pc_combined$datacollector)

#
# Save Monitoring Data to Pedon PC if this part fails add verbose=T to the code to track down errors
#

# Save siteobs table (warnings should show only for boolean data, which is ok)
sqlSave(PedonPC,pc_combined,"siteobs",append=T, rownames = F)

# Save sitesoilmoist table
sqlSave(PedonPC, ppc_sitesoilmoist_merge, "sitesoilmoist", append=T,rownames=F)

# Export site in PedonPC for upload to NASIS

# Open NASIS and upload Pedons from Pedon PC

#
# End of Monitoring data to NASIS Workflow
#



#
# Begin NASIS to R Workflow
#

# Load the site(s) of interest in NASIS seleceted set before using these functions

# get data from NASIS, this is a custom function which you can get from GitHub
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
