Kokomo71$year <- as.Date(cut(Kokomo71$date,
                              breaks = "year"))
Kokomo71$month <- as.Date(cut(Kokomo71$date,
                              breaks = "month"))
Kokomo71$week <- as.Date(cut(Kokomo71$date,
                             breaks = "week",
                             start.on.monday = FALSE)) # changes weekly break point to Sunday


Kokomo71$inches <-(Kokomo71$feet*12) #feet x inches
Kokomo71$convin <- (Kokomo71$inches-21) #inches - 21
Kokomo71$cm <- (Kokomo71$convin*2.54) #converted inches x centimeters

Kokomo71$date<-as.POSIXlt(Kokomo71$date,format="%m/%d/%y %H:%M:%S")
Kokomo71 <- within(Kokomo71, {
  day =   as.character(format(Kokomo71$date, "%m/%d/%y"))
  Jday =  as.integer(format(Kokomo71$date, "%j"))
  year =  as.integer(format(Kokomo71$date, "%Y"))
  month = as.integer(format(Kokomo71$date, "%m"))
  week =  as.integer(format(Kokomo71$date, "%W"))
})

Kokomo71_sub08 <- subset(Kokomo71, year>2008) #subset out after 2008 data because there is an error

cmavmonths <- aggregate(cm ~ month+year, data = Kokomo71_sub08, mean) #mean of months and years
cmminmonth <- aggregate(cm ~ month+year, data = Kokomo71_sub08, "min") #min of months & years
cmmaxmonth <- aggregate(cm ~ month+year, data = Kokomo71_sub08, "max") #max of months & years

cmminyear <- aggregate(cm ~ year, data = Kokomo71_sub08, "min") #min of years
cmmaxyear <- aggregate(cm ~ year, data = Kokomo71_sub08, "max") #max of years

cmyear <- aggregate(cm ~ year, data = Kokomo71_sub08, mean) #averages years
cmavweek <- aggregate(cm ~ week+year, data = Kokomo71_sub08, mean) #averages of weeks & years
cmavday <- aggregate(cm ~ Jday+year, data = Kokomo71_sub08, mean) #averages of day & years
cmavdayweyr <- aggregate(cm ~ Jday+week+year, data = Kokomo71_sub08, mean) #averages of day, week, & years
cmav <-aggregate(cm ~ time+Jday+week+month+year, data = Kokomo71_sub08, mean) #averages of time, day, week, & years
cmavdaywemoyr <- aggregate(cm ~ Jday+week+month+year, data = Kokomo71_sub08, mean) #averages of day, week, month & years

#plot averages of years
ggplot(data = cmyear, aes(year, cm)) +
  geom_line(colour="purple")+ 
  ylim(100, -100)+
  geom_smooth(colour="green")+ 
  ylim(100, -100)

ggplot(data = cmyear, aes(year, cm)) +
  geom_point(colour="purple")+ 
  ylim(100, -100)+
  geom_smooth(colour="green")+ 
  ylim(100, -100)



#plot averages of months and years
ggplot(data = cmavmonths, aes(month, cm, group = year)) +
  geom_line(aes(colour= factor(year))) 
#  ylim(100, -100)

test = quantile(cmavmonths$cm, c(0, 0.95))[2:1]

ggplot(data = cmavmonths, aes(month, cm)) +
  geom_line(colour="purple") +
  geom_smooth(colour="green") + 
  ylim(100, -100) +
  facet_wrap(~ year)+
  ggtitle("Averages of Months and Years")+
  theme(plot.title = element_text(lineheight=.8, face="bold"))
ggplot(data = cmavmonths, aes(year, cm)) +
  geom_count(colour="purple")+ 
  ylim(100, -100)
ggplot(data = cmavmonths, aes(month, cm)) +
  geom_point(colour="purple")+ 
  ylim(100, -100)+facet_wrap(~year)+
  ggtitle("Averages of Months and Years")+
  theme(plot.title = element_text(lineheight=.8, face="bold"))
ggplot(data = cmavmonths, aes(year, cm)) +
  geom_point(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100) +
  ggtitle("Averages of Months and Years")+
  theme(plot.title = element_text(lineheight=.8, face="bold"))
ggplot(data = cmavmonths, aes(year, cm)) +
  geom_smooth(colour="purple")+ 
  ylim(100, -100)

#plot averages of months and years data
xyplot(cm ~ year | factor(month), data=cmavmonths, main='Averages of Months and Years', type=c('l', 'g'), as.table=TRUE, layout=c(2,6), xlab='month', ylab='cm')

#plot min of months and years
ggplot(data = cmminmonth, aes(year, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)

xyplot(cm ~ year | factor(month), data=cmminmonth, main='Mininum of Months and Years', type=c('l', 'g'), as.table=TRUE, layout=c(2,6), xlab='month', ylab='cm')

#plot min of years
ggplot(data = cmminyear, aes(year, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)

#plot max of months and years
ggplot(data = cmmaxmonth, aes(year, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)

xyplot(cm ~ year |factor(month), data=cmmaxmonth, main='Maximum of Months and Years', type=c('l', 'g'), as.table=TRUE, layout=c(2,6), xlab='month', ylab='cm')

#plot max of years
ggplot(data = cmmaxyear, aes(year, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)

#plot min, max, and averages together
ggplot(data = cmminyear, aes(year, cm)) +
  geom_line(colour="purple")+ 
  geom_line(data = cmmaxyear, aes(year, cm),colour="green")+
  geom_line(data = cmyear, aes(year, cm)) +
  geom_line(colour="red")+ ylim(100, -100)+
  ggtitle("Minimum, Average, & Maximum of Years")+
  theme(plot.title = element_text(lineheight=.8, face="bold"))

#plot average, min, & max of months & years. messy
ggplot(data = cmmaxmonth, aes(year, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+
  geom_line(data = cmminmonth, aes(year, cm)) +
  geom_line(colour="blue")+geom_smooth(colour="red")+
  geom_line(data = cmavmonths, aes(year, cm)) +
  geom_line(colour="pink")+
  geom_smooth(colour="yellow")+ 
  ylim(100, -100)

#plot averages of weeks & years
ggplot(data = cmavweek, aes(week, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)+
  ggtitle("Averages of Weeks & Years")+
  theme(plot.title = element_text(lineheight=.8, face="bold"))

ggplot(data = cmavweek, aes(week, cm, group=year)) +
  geom_line(aes(colour=factor(year)))+
  ylim(100, -100)+
  ggtitle("Averages of Weeks & Years")+
  theme(plot.title = element_text(lineheight=.8, face="bold"))



#plot averages of days & year ~ 
ggplot(data = cmavday, aes(Jday, cm)) +
  geom_jitter(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)



#plot averages of Jday, week, & years
ggplot(data = cmavdayweyr, aes(Jday, cm)) +
  geom_jitter(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)
ggplot(data = cmavdayweyr, aes(week, cm)) +
  geom_jitter(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)
ggplot(data = cmavdayweyr, aes(year, cm)) +
  geom_jitter(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)

#plot averages of Jday, week, month, & years as points
ggplot(data = cmavdaywemoyr, aes(year, cm)) +
  geom_jitter(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)
ggplot(data = cmavdaywemoyr, aes(month, cm)) +
  geom_jitter(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)
ggplot(data = cmavdaywemoyr, aes(week, cm)) +
  geom_jitter(colour="purple")+
  geom_smooth(colour="green")+
  ylim(100, -100)
ggplot(data = cmavdaywemoyr, aes(Jday, cm)) +
  geom_jitter(colour="purple")+
  geom_smooth(colour="green")+
  ylim(100, -100)


#plot count
ggplot(data = cmavdaywemoyr, aes(week, cm)) +
  geom_count(colour="purple")
ggplot(data = cmavdaywemoyr, aes(Jday, cm)) +
  geom_count(colour="purple")
ggplot(data = cmavdaywemoyr, aes(year, cm)) +
  geom_count(colour="purple")
ggplot(data = cmavdaywemoyr, aes(month, cm)) +
  geom_count(colour="purple")+ ylim(100, -100)

#plot averages of time, Jday, week, month, & years
ggplot(data = cmav, aes(year, cm)) +
  geom_count(colour="purple")+
  ylim(100, -100)
ggplot(data = cmav, aes(Jday, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)
ggplot(data = cmav, aes(month, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+
  ylim(100, -100)
ggplot(data = cmav, aes(year, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)
ggplot(data = cmav, aes(week, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)
ggplot(data = cmav, aes(week, cm, group=year)) +
  geom_line(aes(colour=factor(year)))+
    ylim(100, -100)
ggplot(data = cmav, aes(time, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)

ggplot(data = cmav, aes(Jday)) +
  geom_density(aes(cm))
ggplot(data = cmav, aes(cm)) +
  geom_density(aes(year))
ggplot(data = cmav, aes(cm)) +
  geom_density(aes(month))
ggplot(data = cmav, aes(cm)) +
  geom_density(aes(Jday))
ggplot(data = cmav, aes(cm)) +
  geom_density(aes(time))

#plot count
ggplot(data = cmav, aes(time, cm)) +
  geom_count(colour="purple")

#plot averages of Jday, week, month, & years as lines
ggplot(data = cmavdaywemoyr, aes(Jday, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)
ggplot(data = cmavdaywemoyr, aes(Jday, cm)) +
  geom_line(aes(colour=factor(month)))+
  ylim(100, -100)
ggplot(data = cmavdaywemoyr, aes(Jday, cm)) +
  geom_line(aes(colour=factor(year)))+
  ylim(100, -100)

ggplot(data = cmavdaywemoyr, aes(year, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+
  ylim(100, -100)
ggplot(data = cmavdaywemoyr, aes(month, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+ 
  ylim(100, -100)
#plot averages of months and years (includes: Jday, week, month, & years)
ggplot(data = cmavdaywemoyr, aes(month, cm, group=year)) +
  geom_smooth(aes(colour=factor(year)))+ 
  ylim(100, -100)
ggplot(data = cmavdaywemoyr, aes(week, cm)) +
  geom_line(colour="purple")+
  geom_smooth(colour="green")+
  ylim((100, -100)















