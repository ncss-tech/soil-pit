library(soilDB)

# load data
f <- fetchNASIS()
ext_data <- get_extended_data_from_NASIS_db()

# extended data tables
str(ext_data)
# site existing veg data
head(ext_data$veg)

#subset siteexisting veg data to species
CORA <- ext_data$veg[ext_data$veg$plantsym == 'CORA', ]
YUBR <- ext_data$veg[ext_data$veg$plantsym == 'YUBR', ]

CORA$CORA <- CORA$plantsym
YUBR$YUBR <- YUBR$plantsym


library(plyr)
test <- join(site(f), CORA[,c(1,8)])
test <- join(test, YUBR[,c(1,8)])
test.sub <- subset(test, select=c("site_id","x","y","YUBR","CORA"))

test.sub$CORA <- as.character(as.factor(test.sub$CORA))
test.sub$YUBR <- as.character(as.factor(test.sub$YUBR))

test.sub$CORA[which(is.na(test.sub$CORA))] <- "NOCORA"
test.sub$YUBR[which(is.na(test.sub$YUBR))] <- "NOYUBR"

test.sub <- na.exclude(test.sub)
test.sub$both <- as.factor(ifelse(test.sub$YUBR=="NOYUBR" & test.sub$CORA=="CORA", 1, 0))

test2 <- na.exclude(test.sub)
coordinates(test2) <- ~x+y
proj4string(test2) <- CRS("+proj=longlat +datum=WGS84")
writeOGR(test2, dsn=getwd(), layer="yubrCORA", driver="ESRI Shapefile", overwrite=T)
