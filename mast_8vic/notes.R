setwd("M:/projects/soilTemperatureMonitoring/R")

library(lattice)
library(latticeExtra)
library(stringr)
library(plyr)
library(rms)
library(zoo)

# path to temperature data
p<-"P:/dataRaw/rawTxtFiles"

## process individual files and save daily mean temp
source("P:/R/process_files_test.R")

## create environmental data summaries
# source('process_gis_data.R')

# load cached versions
load(file = "mastSeries.Rdata")

load('hobo_gis_data.Rda')

# Plot sites visually inspect for flat lines and spikes
test<-subset(mastSeries_df,site == "JTNP08")
test.zoo<-read.zoo(test[,c(1,3)],format = "%m/%d/%y %H:%M:%S",tz="GMT")
plot(test.zoo,ylab="tempF")

# Aggregate by Year, Month, and Julian day (i.e. 1-365, 366 for leap years)
ms.df<-mastSeries_df
ms.df$date<-as.POSIXlt(ms.df$date,format="%m/%d/%y %H:%M:%S")
ms.df$day<-as.character(format(ms.df$date, "%m/%d/%y"))
ms.df$Jday <- as.integer(format(ms.df$date, "%j"))

ms.D.df <- aggregate(tempF ~ site + day, data=ms.df, FUN=mean, na.action=na.exclude)
ms.D.df <- aggregate(day~site, data=ms.D.df, function(i)length(na.omit(i)))
names(ms.D.df) <- c("siteid","numDays")

ms.Jd.df <- aggregate(tempF ~ siteid + Jday, data=ms.df, FUN=mean)
mastSites.df <- aggregate(tempF ~ siteid, data=ms.Jd.df, FUN=mean)
mastSites.df$siteid <- as.factor(mastSites.df$siteid)

mastSites.df <- join(mastSites.df,ms.D.df,by="siteid")
write.csv(mastSites.df, "mastSites.csv")

## fit model: this is used to fill missing data
dd <- datadist(d.daily)
options(datadist="dd")
(l.daily <- ols(temp ~ rcs(day, 5) * site, data=d.daily))


# check: OK
pp <- Predict(l.daily, day=1:356, site=NA)
p.1 <- xyplot(yhat ~ day | site, data=pp, col='RoyalBlue', lwd=2, type='l', ylab='Daily Mean Temperature (F)', xlab='Julian Day', scales=list(y=list(alternating=3), x=list(alternating=1)), as.table=TRUE, strip=strip.custom(bg=grey(0.8)))
p.2 <- xyplot(temp ~ day | site, data=d.daily, cex=0.5, col='black', type=c('p','g'), as.table=TRUE)

p.1 + p.2


# xyplot(temp ~ day, groups=site, data=d.daily, lwd=2, type='l', ylab='Daily Mean Temperature (F)', xlab='Julian Day', scales=list(y=list(alternating=3), x=list(alternating=1)), as.table=TRUE, strip=strip.custom(bg=grey(0.8)), auto.key=list(columns=4, lines=TRUE, points=FALSE), subset=site %in% c('Wardsferry_North','Wardsferry_FairgroundsNorth'))



## compute un-biased MAST values (no missing days allowed)
# how many days of non-missing data per site?
aggregate(temp ~ site, data=d.daily, function(i) length(na.omit(i)))

# compute mean: these are the values that should be used within out model
site.MAST <- aggregate(temp ~ site, data=d.daily, FUN=mean)

# save to CSV for later
write.csv(site.MAST, file='unbiased_MAST_values.csv', row.names=FALSE)


## compute monthly averages
# make a fake 2011 date based on Julian day
d.daily$fake.date <- as.Date(paste('2011', d.daily$day), "%Y %j")
# format as month
d.daily$month <- format(d.daily$fake.date, "%b")
d.monthly <- aggregate(temp ~ site + month, data=d.daily, FUN=mean)

# check: OK
bwplot(site ~ temp | month, data=d.daily)


## join with environmental covariates
d.monthly <- join(d.monthly, as.data.frame(h[, c('site','elev','solar')]), by='site')


## fit monthly model using environmental parameters
dd <- datadist(d.monthly)
options(datadist="dd")

## check model form... needs more eval
(l.monthly <- ols(temp ~ solar + elev * month, data=d.monthly))

plot(Predict(l.monthly, elev=NA, month=c('Jan','Jul','Sep')))


## create monthly MAST rasters




