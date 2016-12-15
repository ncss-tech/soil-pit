test <- gsub(" ", "", tolower(read.csv("region11_SSURGO_export_2016_09_12.csv")$AREASYMBOL))


copy <- function(x) file.copy(
  paste0("M:/geodata/soils/download_SSURGO_20141031/soil_", x, "/soil_metadata_", x, ".xml"),
  paste0("R:/sroecker/fy16_rtsd/METADATA/", "soil_metadata_", x, ".met")
  )

sapply(test, copy)


test <- list.files("R:/sroecker/fy16_rtsd/METADATA/")
test2 <- substr(test, 15, 19)