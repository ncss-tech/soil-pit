dir.create(path="C:/soil-pit/reports/genhz_rules", recursive = T) 
dir.create(path="C:/R/win-library/3.2", recursive = T)


install.packages(c("aqp", "soilDB", "RODBC", "RCurl", "XML", "circular", "colorspace", "RColorBrewer", "plyr", "ggplot2", "reshape2", "knitr", "rmarkdown", "xtable", "lattice", "maps", "sp", "gdalUtils", "raster", "'rgdal"), dependencies=TRUE)


# Download Rprofile
download.file("https://raw.githubusercontent.com/ncss-tech/soil-pit/master/sandbox/stephen/.Rprofile", "C:/soil-pit/.Rprofile", method = "libcurl")


# Download latest report and rules
download.file("https://raw.githubusercontent.com/ncss-tech/soil-pit/master/reports/pedon_summary_by_taxonname.Rmd", "C:/soil-pit/reports/pedon_summary_by_taxonname.Rmd", method = "libcurl")
download.file("https://raw.githubusercontent.com/ncss-tech/soil-pit/master/reports/lab_summary_by_taxonname.Rmd", "C:/soil-pit/reports/lab_summary_by_taxonname.Rmd", method = "libcurl")
download.file("https://raw.githubusercontent.com/ncss-tech/soil-pit/master/soilDB_x/utils.R", "C:/soil-pit/soilDB_x/utils.R", method = "libcurl")
download.file("https://raw.githubusercontent.com/ncss-tech/soil-pit/master/reports/genhz_rules/genhz_rules.zip", "C:/soil-pit/reports/genhz_rules/genhz_rules.zip", method = "libcurl")

download.file("https://raw.githubusercontent.com/ncss-tech/soil-pit/master/reports/mapunit_summary_by_shapefile.Rmd", "C:/soil-pit/reports/mapunit_summary_by_shapefile.Rmd", method = "libcurl") 
download.file("https://raw.githubusercontent.com/ncss-tech/soil-pit/master/reports/mapunit_summary_by_mukey.Rmd", "C:/soil-pit/reports/mapunit_summary_by_mukey.Rmd", method = "libcurl")


# Unzip files
unzip(zipfile="C:/soil-pit/reports/genhz_rules/genhz_rules.zip", exdir="C:/soil-pit/reports/genhz_rules")
