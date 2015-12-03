library(soilDB)

ssa <- read.csv("M:/geodata/soils/SSA_Regional_Ownership_MASTER_MLRA_OFFICE.csv", stringsAsFactors = FALSE)$AREASYMBOL

#ssa <- c("MN071",'CA113','CA654')
ssa <- "PA603"

fetch <- function(x){
  q <- paste0("SELECT areasymbol, nationalmusym, musym, muname
                  FROM mapunit
                  INNER JOIN legend ON legend.lkey = mapunit.lkey
                  WHERE legend.areasymbol = '", x, "'", sep='')
  print(x)
  res <- SDA_query(q)
  return(res)
}

results <- lapply(ssa, fetch)

results2 <- do.call(rbind, results)


