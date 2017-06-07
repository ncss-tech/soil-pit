mydata <- fetchNASIS()

#Plot Maps

map('county', 'Iowa')
points(y ~ x, data=site(mydata), pch=21, bg='RoyalBlue')

source("rmenu.R")