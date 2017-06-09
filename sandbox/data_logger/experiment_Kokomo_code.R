# First plot
p1 <- ggplot(Kokomo71, aes(x=year, y=cm, colour=year, group=month)) +
  geom_line() +
  ggtitle("Growth curve for individual chicks")

# Second plot
p2 <- ggplot(Kokomo71, aes(x=year y=cm, colour=year)) +
  geom_point(alpha=.3) +
  geom_smooth(alpha=.2, size=1) +
  ggtitle("Fitted growth curve per diet")

# Third plot

k <- data.frame(Kokomo71)
data = melt(k)
ggplot(k, aes(x=cm, )) +geom_density(alpha=0.25)

ggplot(data=Kokomo71, aes(x=cm, fill=year))+geom_density(colour='purple')

ggplot(subset(Kokomo71, year==2006), aes(x=cm)) +
  geom_density(colour='purple') +ggplot (subset(Kokomo71, year==2007), aes(x=cm)) +
  geom_density(colour='red') +(subset(Kokomo71, year==2008), aes(x=cm)) +
  geom_density(colour='blue') +(subset(Kokomo71, year==2009), aes(x=cm)) +
  geom_density(colour='green') + (subset(Kokomo71, year==2010), aes(x=cm)) +
  geom_density(colour='lightskyblue') +
  ggtitle("2006 - 2016")

a=ggplot(subset(Kokomo71, year==2006), aes(x=cm, fill=year)) +
  geom_density(colour='purple') +
  ggtitle("2006")

b=ggplot(subset(Kokomo71, year==2007), aes(x=cm, colour=year)) +
  geom_density(colour='red') +
  ggtitle("2007")

c=ggplot(subset(Kokomo71, year==2008), aes(x=cm, colour=year)) +
  geom_density(colour='blue') +
  ggtitle("2008")

d=ggplot(subset(Kokomo71, year==2009), aes(x=cm, colour=year)) +
  geom_density(colour='green') +
  ggtitle("2009")

e=ggplot(subset(Kokomo71, year==2010), aes(x=cm, colour=year)) +
  geom_density(colour='lightskyblue') +
  ggtitle("2010")

f=ggplot(subset(Kokomo71, year==2011), aes(x=cm, colour=year)) +
  geom_density(colour='yellow') +
  ggtitle("2011")

g= ggplot(subset(Kokomo71, year==2012), aes(x=cm, colour=year)) +
  geom_density(colour='dark pink') +
  ggtitle("2012")

h=ggplot(subset(Kokomo71, year==2013), aes(x=cm, colour=year)) +
  geom_density(colour='cyan4') +
  ggtitle("2013")

i=ggplot(subset(Kokomo71, year==2014), aes(x=cm, colour=year)) +
  geom_density(colour='purple') +
  ggtitle("2014")

j=ggplot(subset(Kokomo71, year==2015), aes(x=cm, colour=year)) +
  geom_density(colour='stateblue3') +
  ggtitle("2015")

k=ggplot(subset(Kokomo71, year==2016), aes(x=cm, colour=year)) +
  geom_density(colour='maroon') +
  ggtitle("2016")

plot (density(Kokomo71$year, col="red"))
lines (density(Kokomo71$year2, col="blue"))

myData <- melt(Kokomo71$year)
densityplot(~a +b + c, data = myData, auto.key = TRUE)

#ggplot(Kokomo71, aes(x=cm, fill=year))+geom_density(a,b,c,d,e,f,g,h,i,j,k)

# Fourth plot
p4 <- ggplot(subset(Kokomo71, year==2012), aes(x=cm, fill=year)) +
  geom_histogram(colour="black", binwidth=50) +
  facet_grid(year ~ .) +
  ggtitle("Final weight, by diet") +
  theme(legend.position="none")  

multiplot(p1, p2, p3, p4, cols=2)
#> `geom_smooth()` using method = 'loess'