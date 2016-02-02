dir.create(path="C:/workspace", recursive = T)
dir.create(path="C:/workspace/soil-pit/reports/genhz_rules", recursive = T) 
dir.create(path="C:/workspace/soil-pit/soilDB_x", recursive = T) 
dir.create(path="C:/R/win-library/3.2", recursive = T)

x <- '.libPaths(c("C:/R/win-library/3.2", "C:/Program Files/R/R-3.2.1/library"))'
write(x, file = "C:/workspace/.Rprofile")


# Download latest report and rules
download.file("https://raw.githubusercontent.com/ncss-tech/soil-pit/master/reports/pedon_summary_by_taxonname.Rmd", "C:/workspace/soil-pit/reports/pedon_summary_by_taxonname.Rmd", method = "libcurl")
download.file("https://raw.githubusercontent.com/ncss-tech/soil-pit/master/reports/lab_summary_by_taxonname.Rmd", "C:/workspace/soil-pit/reports/lab_summary_by_taxonname.Rmd", method = "libcurl")
download.file("https://raw.githubusercontent.com/ncss-tech/soil-pit/master/soilDB_x/utils.R", "C:/workspace/soil-pit/soilDB_x/utils.R", method = "libcurl")
download.file("https://raw.githubusercontent.com/ncss-tech/soil-pit/master/reports/genhz_rules/genhz_rules.zip", "C:/workspace/soil-pit/reports/genhz_rules/genhz_rules.zip", method = "libcurl")
download.file("https://raw.githubusercontent.com/ncss-tech/soil-pit/master/reports/mapunit_summary_by_shapefile.Rmd", "C:/workspace/soil-pit/reports/mapunit_summary_by_shapefile.Rmd", method = "libcurl") 
download.file("https://raw.githubusercontent.com/ncss-tech/soil-pit/master/reports/mapunit_summary_by_mukey.Rmd", "C:/workspace/soil-pit/reports/mapunit_summary_by_mukey.Rmd", method = "libcurl")


# Unzip files
unzip(zipfile="C:/soil-pit/reports/genhz_rules/genhz_rules.zip", exdir="C:/soil-pit/reports/genhz_rules")

# Install packages
packages <- c("aqp", "soilDB", "RODBC", "RCurl", "XML", "circular", "colorspace", "RColorBrewer", "plyr", "ggplot2", "reshape2", "knitr", "rmarkdown", "xtable", "lattice", "maps", "sp", "gdalUtils", "raster", "'rgdal")

local({
  r <- getOption("repos")
  r["CRAN"] <- "http://cran.mirrors.hoobly.com/"
  options(repos = r)
})

## Install and packages and dependencies
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages(lib.loc = "C:/R/win-library/3.2")[, "Package"])]
  if (length(new.pkg) > 0) 
    install.packages(new.pkg, lib = "C:/R/win-library/3.2", dependencies = TRUE)
}

ipak(packages)

