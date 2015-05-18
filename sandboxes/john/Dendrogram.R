#Create a user entry prompt
DendrogramOSD <- function()
  
{
   input_list <- readline("Enter the list of Series to Compare:>>> ")
    input_list <- as.character(unlist(strsplit(input_list, ",")))
    return(input_list)
}

input_DendrogramOSD <- DendrogramOSD()

# fetch and convert data into an SPC
mylist <- input_DendrogramOSD
dendrolist <- fetchOSD(mylist)

# plot dendrogram
SoilTaxonomyDendrogram(dendrolist, name='hzname', max.depth = 200, cex.names=0.856)
source("rmenu.R")