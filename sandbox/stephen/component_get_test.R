library(soilDB)
library(plyr)

source("C:/workspace/soil-pit.git/trunk/soilDB_x/utils.R")
source("C:/workspace/soil-pit.git/trunk/soilDB_x/get_component_data_from_NASIS_db.R")

options(stringsAsFactors = FALSE)


comp <- get_component_data_from_NASIS_db()

comp <- na_remove(comp)
comp <- metadata_replace(df)
