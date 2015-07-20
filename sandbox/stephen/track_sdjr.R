sdjr2012 <- read.csv("sdjr2012.csv")
sdjr2013 <- read.csv("sdjr2013.csv")
sdjr2014 <- read.csv("sdjr2014.csv")
sdjr2015 <- read.csv("sdjr2015.csv")

sdjr2012$FY <- 2012
sdjr2013$FY <- 2013
sdjr2014$FY <- 2014
sdjr2015$FY <- 2015

sdjr <- rbind(sdjr2012, sdjr2013, sdjr2014, sdjr2015)

write.csv(sdjr, "sdjr.csv")