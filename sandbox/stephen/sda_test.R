library(soilDB)
library(XML)
library(httr)

ssa <- read.csv("C:/workspace/SSA_Regional_Ownership_MASTER_MLRA_OFFICE.csv", stringsAsFactors = FALSE)$AREASYMBOL

#ssa <- "MN071"

#ssa2 <- paste0("\'", ssa, "\'")

fetch <- function(x){
  query <- paste0("SELECT areasymbol, mukey, nationalmusym, musym, muname
    FROM mapunit
    INNER JOIN legend ON legend.lkey = mapunit.lkey
        WHERE legend.areasymbol = '", x, "'")
  print(x)
  SDA_query(query)
  }


results <- lapply(ssa, fetch)

results2 <- do.call(rbind, results)

