library(aqp)
library(soilDB)
library(reshape2)
library(plyr)
library(latticeExtra)

# fetchSCAN can accept multiple years
x <- fetchSCAN(site.code=2014, year=c(2006:2016))

# check the results
str(x, 1)

# tabulate number of soil moisture measurements per depth (cm)
table(x$SMS$depth)

# get unique set of soil moisture sensor depths
sensor.depths <- unique(x$SMS$depth)

# generate a better axis for dates
date.axis <- seq.Date(as.Date(min(x$SMS$Date)), as.Date(max(x$SMS$Date)), by='3 months')

# plot soil moisture time series, panels are depth
xyplot(value ~ Date | factor(depth), data=x$SMS, as.table=TRUE, type=c('l','g'), strip=strip.custom(bg=grey(0.80)), layout=c(1,length(sensor.depths)), scales=list(alternating=3, x=list(at=date.axis, format="%b\n%Y")), ylab='Volumetric Water Content', main='Soil Moisture at Several Depths')