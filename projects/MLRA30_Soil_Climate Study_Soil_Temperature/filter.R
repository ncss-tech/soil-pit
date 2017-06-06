x<-"DEVA02_50cm_2003_erractic.txt"
test<-read.table(file=x,header=T,sep="\t",stringsAsFactors=F)

test.zoo<-read.zoo(test[,c(1,3)],format = "%m/%d/%y %H:%M:%S",tz="GMT")
plot(test.zoo,ylab="tempF")

test2<-test
test2[,2]<-test.filter

write.table(test2,file=x,sep="\t",row.names=F,quote=F)


# Function to filter sites, remove spikes that exceed x, subset first preferable
filter.mast<-function(tseries, x){
  names(tseries)<-c("date","tempF","tempC")  
  tseries$date <- as.POSIXlt(tseries$date, format="%m/%d/%y %H:%M:%S")
  tseries$Jday <- as.integer(format(tseries$date, "%j"))
  tseries$site<-as.factor(c("site"))
  tseries.stat <- aggregate(tempF ~ Jday+site, data=tseries, FUN=mean)
  tseries.stat$sd<- aggregate(tempF ~ Jday+site, data=tseries, FUN=sd, na.action=T)[,3]
  names(tseries.stat) <- c("Jday", "site", "mean", "sd")
  tseries.join <- join(tseries, tseries.stat, by="Jday")
  tseries.join$clean <- as.numeric(ifelse(tseries.join$tempF >= tseries.join$mean+x, "NA", ifelse(tseries$tempF <= tseries.join$mean-x, "NA", tseries$tempF)))
}
