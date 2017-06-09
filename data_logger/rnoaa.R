library(rnoaa)

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

