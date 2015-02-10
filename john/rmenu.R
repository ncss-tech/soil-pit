#Load Required Libraries
library(aqp)
library(soilDB)
library(maps)
library(sharpshootR)
library(cluster)
library(rgdal)
library(rgeos)

#Create a user entry prompt
rmenu <- function()
{
  as.character(readline("
1  Plot OSD Profile
2  Map Series Extent
3  Create Extent Shapefile
4  Plot Profiles of NASIS Pedons
5  Plot Map of NASIS Pedon Locations
6  Create NASIS pedon Shapefile
7  Plot Dendrogram from OSDs
8  Exit Menu

Choose a Task :>>>>>>>>>>>>> "))
}

input_taskchoice <- rmenu()
loadchoice <- function()
{
if(input_taskchoice == "1"){"plotOSDprofile.R"}else if(input_taskchoice == "2"){"mapseries.R"}else if(input_taskchoice == "3"){"createExtentShp.R"}else if(input_taskchoice == "4"){"plotNASIS.R"}else if(input_taskchoice == "5"){"mapnasis.R"}else if(input_taskchoice == "6"){"createNASISpedons.R"}else if(input_taskchoice == "7"){"Dendrogram.R"}else if(input_taskchoice == "8"){"exit.R"}else{"rmenu.R"}
}

loadsource <- loadchoice()

source(loadsource)