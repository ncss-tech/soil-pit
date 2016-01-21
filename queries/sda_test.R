library(soilDB)

ssa <- read.csv("M:/geodata/soils/SSA_Regional_Ownership_MASTER_MLRA_OFFICE.csv", stringsAsFactors = FALSE)
ssa <- ssa[ssa$Region == 11, "AREASYMBOL"]

#ssa <- "IN001"

fetch <- function(x){
  q <- paste0("SELECT DISTINCT areasymbol, mapunit.mukey, nationalmusym, musym, muname
                  FROM mapunit
                  INNER JOIN legend ON legend.lkey = mapunit.lkey
                  INNER JOIN component ON component.mukey = mapunit.mukey 
              WHERE legend.areasymbol = '", x, "'", sep='')
  print(x)
  res <- SDA_query(q)
  return(res)
}

results <- lapply(ssa, fetch)

results2 <- do.call(rbind, results)


