library(foreign) # load packages
library(plyr)

mu <- read.dbf("muaoverlap.dbf", as.is = TRUE) # read exported tables from geodatabase
la <- read.dbf("laoverlap.dbf", as.is = TRUE)
test <- join(mu, la, by = "lareaovkey")
test <- subset(test, areatypena == "MLRA") # subset based on the MLRA
test2 <- ddply(test, .(mukey, mlra = areasymbol), summarize, sumacres = sum(areaovacre)) # calculate the acres per mukey
test3 <- test2[order(test2$mukey, test2$sumacres, decreasing = T), ] # resort the table for the next operation
test4 <- ddply(test3, .(mukey), summarize, maxacres = max(sumacres), mlra = mlra[1]) # select an unique mukey and match the mlra with maximum amount of acres for that mukey
