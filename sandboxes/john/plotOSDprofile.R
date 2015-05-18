# load required libraries
library(soilDB)
library(dismo)

#Create a user entry prompt
OSDseries <- function()
{
  as.character(readline("Enter the Series to Plot:>>> "))
}

input_OSDseries <- OSDseries()

# fetch and convert data into an SPC
s <- fetchOSD(input_OSDseries)

# plot profile
plot(s, name='hzname', cex.names=0.85, axis.line.offset=-20)
source("rmenu.R")