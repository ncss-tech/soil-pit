# load required libraries
library(soilDB)
library(dismo)

#Create a user entry prompt
series <- function()
{
as.character(readline("Enter the Series to Map:>>>> "))
}

input_series <- series()


# plot map
seriesExtentAsGmap(input_series)
source("rmenu.R")