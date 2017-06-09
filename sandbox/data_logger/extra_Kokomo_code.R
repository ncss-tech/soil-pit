#plot min, max, and averages together
ggplot(data = cmminyear, aes(year, cm)) +geom_line(colour="purple")+ geom_line(data = cmmaxyear, aes(year, cm),colour="green")+geom_line(data = cmyear, aes(year, cm)) +geom_line(colour="red")+ ylim(300, -150)+ggtitle("Minimum, Average, & Maximum of Years")+theme(plot.title = element_text(lineheight=.8, face="bold"))

#plot averages of months and years
ggplot(data = cmavmonths, aes(year, cm)) +geom_jitter(colour="purple")+geom_smooth(colour="green")+ ylim(100, -100)

#plot 3d
attach(cmav)
plot3d(year, week, cm, col="purple", size=3)+ylim(300, -150)
plot3d(week, year, cm, col="purple", size=3)+ylim(300, -150)
plot3d(year, month, cm, col="purple", size=3)+ylim(300, -150)

attach(cmav)
scatterplot3d(year, week, cm, main="3D ~ CM, Week, & Year", pch=16, highlight.3d=TRUE,type="h")
scatterplot3d(year, month, cm, main="3D ~ CM, Month, & Year", pch=16, highlight.3d=TRUE,type="h")

attach(cmyear)
plot3d(year, cm, col="purple", size=3)+
  ylim(300, -150)
scatterplot3d(year, cm, main="3D ~ CM & Year", pch=16, highlight.3d=TRUE,type="h")

#ggplot(data = cmavdaywemoyr, aes(year, cm)) +geom_tile(aes(fill=factor(month)))

#plot raster & tile
ggplot(data = cmav, aes(year, cm))+
  geom_raster(aes(fill=year))
ggplot(data = cmav, aes(Jday, cm))+
  geom_raster(aes(fill=year))
ggplot(data = cmav, aes(Jday, cm))+
  geom_raster(aes(fill=Jday))
ggplot(data = cmav, aes(month, cm))+
  geom_tile( colour="purple1")+
  ylim(300, -150)

#plot scatterplot matrices
scatterplotMatrix(~cm+Jday+week+month+year|cm, data=cmav, main="CMAV")

#plot dotplot
ggplot(data=cmav, aes(x=cm, fill=factor(year)))+
  geom_dotplot()
ggplot(data=cmav, aes(x=cm, fill=factor(month)))+
  geom_dotplot(stackdir = "center")
ggplot(data=cmav, aes(x=cm, fill=factor(week)))+
  geom_dotplot(stackdir = "center")

#plot hexbin
bincmy<-hexbin(cm,year)
plot(bincmy, main="Year")
binycm<-hexbin(year,cm)
plot(binycm, main="Year")
binmocm<-hexbin(month,cm)
plot(binmocm, main="Month")
binjdcm<-hexbin(Jday,cm)
plot(binjdcm, main="J Day")




# graph by year:
ggplot(data = Kokomo71,
       aes(year, cm)) + 
  stat_summary(fun.y = "mean", # averages all observations for the year
               geom = "line") + # or "line"
  #scale_x_date(date_labels = "%Y", date_breaks = "1 year")+
  ylim(150, -5)

ggplot(data = Kokomo71,
       aes(year, cm)) +
  stat_summary(fun.y = "mean", # averages all observations for the year
               geom = "bar") + # or "line"
  #scale_x_date(date_labels = "%Y", date_breaks = "1 year")
  ylim(150, -5)

# graph by month:
ggplot(data = Kokomo71,
       aes(month, cm)) + 
  stat_summary(fun.y = "mean", # averages all observations for the month
               geom = "line") + # or "line"
  #scale_x_date(date_labels = "%m/%Y", date_breaks = "3 months")
  ylim(150, -5)

ggplot(data = Kokomo71,
       aes(month, cm)) + 
  stat_summary(fun.y = "mean", # averages all observations for the month
               geom = "bar") + # or "line"
  #scale_x_date(date_labels = "%m/%Y", date_breaks = "1 month") +
  ylim(150, -5) 

# graph by week:
ggplot(data = Kokomo71,
       aes(week, cm)) +
  stat_summary(fun.y = "mean", # averages all observations for the week
               geom = "line") + ylim(150, -5) # or "line"
#scale_x_date(date_labels = "%d/%m/%Y", date_breaks = "1 week") +
ylim(150, 0)

# graph by year:
ggplot(data = Kokomo71,
       aes(year, cm)) +
  stat_summary(fun.y = "mean", # averages all observations for the year in centimeters
               geom = "line") + # or "line"
  #  scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
  ylim(150, 0)


ggplot(data = Kokomo71,
       aes(year, cm)) +
  stat_summary(fun.y = "mean", # averages all observations for the year in inches
               geom = "line") + # or "line"
  #scale_x_date(date_labels = "%Y", date_breaks = "1 year")
  ylim(100, 0) 

#plot(as.Date(Kokomo71$date,'%d/%m/%Y'),Kokomo71$feet, xlab="Date", ylab= "Feet",type="l", lwd=2, col='purple', main="Kokomo 71")
#grid(col="darkgrey")



test <- aggregate(cm ~ month, data = Kokomo71, mean)
ggplot(data=test, aes(month, cm))+geom_line(colour='purple')+ylim(100, -60)

Kokomo71_2006 <- subset(Kokomo71, year %in% 2006:2006 & month %in% c(6, 7, 8))
Kokomo71_2007 <- subset(Kokomo71, year %in% 2007:2008 & month %in% c(6, 7, 8))
Kokomo71_2008 <- subset(Kokomo71, year %in% 2008:2009 & month %in% c(6, 7, 8))
Kokomo71_2009 <- subset(Kokomo71, year %in% 2009:2010 & month %in% c(6, 7, 8))
Kokomo71_2010 <- subset(Kokomo71, year %in% 2010:2011 & month %in% c(6, 7, 8))
Kokomo71_2011 <- subset(Kokomo71, year %in% 2011:2012 & month %in% c(6, 7, 8))
Kokomo71_2012 <- subset(Kokomo71, year %in% 2012:2013 & month %in% c(6, 7, 8))
Kokomo71_2013 <- subset(Kokomo71, year %in% 2013:2014 & month %in% c(6, 7, 8))
Kokomo71_2014 <- subset(Kokomo71, year %in% 2014:2015 & month %in% c(6, 7, 8))
Kokomo71_2015 <- subset(Kokomo71, year %in% 2015:2016 & month %in% c(6, 7, 8))
Kokomo71_2016 <- subset(Kokomo71, year %in% 2016:2016 & month %in% c(6, 7, 8))

#plot line
ggplot()+geom_line(data=Kokomo71_2006, aes (date, cm))+geom_line(data=Kokomo71_2007, aes (date, cm))+geom_line(data=Kokomo71_2008, aes (date, cm))+geom_line(data=Kokomo71_2010, aes (date, cm))+geom_line(data=Kokomo71_2011, aes (date, cm))+geom_line(data=Kokomo71_2012, aes (date, cm))+geom_line(data=Kokomo71_2013, aes (date, cm))+geom_line(data=Kokomo71_2014, aes (date, cm))+geom_line(data=Kokomo71_2015, aes (date, cm))+geom_line(data=Kokomo71_2016, aes (date, cm))+ ylim(300, -150)
#ggplot(data=Kokomo71_2006, aes (date, cm)) +geom_line() + ylim(100, -5)
#ggplot(data=Kokomo71_2007, aes (date, cm)) +geom_line() + ylim(100, -5)

Kokomo71_2016month <- subset(Kokomo71, year==2016 & month %in% c(2,3))
ggplot(data = Kokomo71_2016month, aes(day, cm))+geom_line() +ylim(300, -150) #messy plot for day, week, month

Kokomo71_month6 <- subset(Kokomo71, month=="6")
ggplot(data = Kokomo71_month6, aes(day, cm))+geom_line() +ylim(300, -150)

ggplot(data = Kokomo71_month6, aes(day, cm)) +geom_smooth(colour="purple")+ ylim(300, -150)

#plot averages of days & year
xyplot(cm ~ year | Jday, data=cmavday, main='Averages of Day and Years', type=c('l', 'g'), as.table=TRUE, layout=c(2,6), xlab='Jday', ylab='cm')

#plot data
xyplot(cm ~ year | month, data=cmavmonths, main='Water Table', type=c('l', 'g'), as.table=TRUE, layout=c(2,6), xlab='month', ylab='cm')

#plot Averages of Days & Years
xyplot(cm ~ year | Jday, data=cmavdayweyr, main='Averages of Day and Years', type=c('l', 'g'), as.table=TRUE, layout=c(2,6), xlab='Jday', ylab='cm')

#Plot Averages od Day & Years
xyplot(cm ~ year | Jday, data=cmavday, main='Averages of Day and Years', type=c('l', 'g'), as.table=TRUE, layout=c(2,6), xlab='Jday', ylab='cm')

a <- ggplot(data = cmavdaywemoyr, aes(year, cm)) +geom_jitter(aes (colour=year))+ ylim(100, -100)
a + geom_quantile(colour = "red",size = 2, alpha = 0.5, method="rqss", lambda=0.1)

ggplot(data=cmav, aes(year, cm))+
  stat_summary(geom="bar", aes(fill=year))
ggplot(data=cmav, aes(cm, month))+
  stat_summary(geom="bar", aes(fill=month))

#plot data gaps
levelplot(factor(!is.na(cm)) ~ month * factor(year) | year, main='Water Table',
          data=cmavmonths, layout=c(2,6), col.regions=c('grey', 'purple'), cuts=3, 
          colorkey=FALSE, as.table=TRUE, scales=list(alternating=3, cex=1), 
          par.strip.text=list(cex=0.85), strip=strip.custom(bg='yellow'), 
          xlab='month', ylab='year')

#doesn't work yet
cm1 <- unique(Kokomo71$year$cm)
cmavmonths <- seq.Date(as.Date(min(cmavmonths$year$cm)), as.Date(max(cmavmonths$year$cm)), by='3 months')
xyplot(cm ~ year | factor(year), data=cmavmonths, as.table=TRUE, type=c('l','g'), strip=strip.custom(bg=grey(0.80)), layout=c(1,length(cmavmonths), scales=list(alternating=3, x=list(at=cmavmonths, format="%Y")), ylab='cm', main='Water Table')
       
       #plot averages of weeks & years
       xyplot(cm ~ year | factor(week), data=cmavweek, main='Averages of Weeks and Years', type=c('l', 'g'), as.table=TRUE, layout=c(2,6), xlab='week', ylab='cm')

       
       #not quite right
       xyplot(cm ~ year | factor(year), data=cmyear, main='Averages of Years', type=c('l', 'g'), as.table=TRUE, layout=c(2,6), xlab='month', ylab='cm')
       
       #plot data
       #xyplot(cm ~ year | week, data=Kokomo71_month6, main='Water Table', type=c('l', 'g'), as.table=TRUE, layout=c(2,6), xlab='week', ylab='cm')
       
       #plot data gaps
       #levelplot(factor(!is.na(cm)) ~ month * factor(year) | year, main='Water Table',
       #          data=Kokomo71, layout=c(2,6), col.regions=c('grey', 'purple'), cuts=2, 
       #          colorkey=FALSE, as.table=TRUE, scales=list(alternating=3, cex=1), 
       #          par.strip.text=list(cex=0.85), strip=strip.custom(bg='yellow'), 
       #          xlab='month', ylab='year')
       
       #plot averages of weeks & years
       ggplot(data = cmavweek, aes(week, cm, group=year)) +
         geom_line(aes(colour=factor(year)))+
         ylim(200, -110)+
         ggtitle("Averages of Weeks & Years")+
         theme(plot.title = element_text(lineheight=.8, face="bold"))
       
       #plot averages of Jday, week, month, & years as lines
       ggplot(data = cmavdaywemoyr, aes(Jday, cm)) +
         geom_line(aes(colour=factor(month)))+
         ylim(200, -110)+
         ggtitle("Averages of Days and Months")+
         theme(plot.title = element_text(lineheight=.8, face="bold"))
       
       #plot averages of months and years data
       xyplot(cm ~ year | factor(month), data=cmavmonths, main='Averages of Months and Years', type=c('l', 'g'), as.table=TRUE, layout=c(2,6), xlab='month', ylab='cm')
       
       
       #plot averages of months and years
       ggplot(data = cmavmonths, aes(month, cm)) +
         geom_point(colour="purple")+ 
         ylim(200, -100)+facet_wrap(~year)+
         ggtitle("Averages of Months and Years")+
         theme(plot.title = element_text(lineheight=.8, face="bold"))
       
       #plot feet line -data from the csv before conversion to centimeters - shows data prior to 2008 is scewed
       ggplot(data=denham, aes (date, feet)) +geom_line(colour='purple')+ ylim(5, -2.5)+ggtitle("Feet Years")+theme(plot.title = element_text(lineheight=.8, face="bold")) 
       
       
       