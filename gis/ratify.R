# Dylan's exmaple has the ID column as the MUKEY
# Natively from the file geodatabase gSSURGO is a multi-attribute raster
# Alteration of Dylan's code as follows
library(Hmisc)
library(soilDB)
library(plyr)
library(raster)
setwd("C:/Users/stephen.roecker/Documents")

# load chunk of gSSURGO
r <- raster('MuRaster_90m_clip.tif')
r <- ratify(r)
rat <- levels(r)[[1]]

mu <- read.dbf('MuRaster_90m_clip.tif.vat.dbf',as.is=TRUE)
names(mu)[1] <- 'ID'
mu$MUKEY <- as.integer(mu$MUKEY)

rat.new <- join(rat, mu, by='ID', type='left')
levels(r) <- rat.new
r.mu <- deratify(r, att='MUKEY')

summary(r) ; summary(r.mu)

# Load NASIS report
ecosites<-read.csv("Book1.csv",stringsAsFactors=F)

# Join gSSURGO to NASIS report
names(ecosites)[19]<-"MUKEY"
rat.new<-join(rat,ecosites,by="MUKEY")
levels(test.r) <- rat.new

# convert into standard raster based on new column
r.new <- deratify(test.r, att='Ecosite')

# Write raster
writeRaster(r.new,"test.r.new.tif",format="GTiff",overwrite=T,NAflag=-9999)


