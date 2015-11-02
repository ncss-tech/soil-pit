library(soilDB)

#ssa <- read.csv("M:/geodata/soils/SSA_Regional_Ownership_MASTER_MLRA_OFFICE.csv", stringsAsFactors = FALSE)$AREASYMBOL

ssa <- "MN071"

ssa2 <- paste0("\'", ssa, "\'")

fetch <- function(x){
  query <- paste("SELECT areasymbol, nationalmusym, musym, muname
    FROM mapunit
    INNER JOIN legend ON legend.lkey = mapunit.lkey
        WHERE legend.areasymbol = ", x)
  print(x)
  SDA_query(query)
  }


results <- lapply(ssa2, fetch)

results <- do.call(rbind, results)

