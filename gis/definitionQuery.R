# Definition query
# Copy Mapunit table out of NASIS 
setwd("C:/Users/stephen.roecker/Documents")
test <- read.csv("mapunit.table.csv")
mukey <- test$Rec.ID
paste("'", mukey[1:length(mukey)-1], "'",collapse=",", sep='')
# Paste results after the following, "MUKEY" IN ...