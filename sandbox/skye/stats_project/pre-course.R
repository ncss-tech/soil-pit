## helper fuction for installing required packages from CRAN
# a simple check is done to see if each is already installed
# p: vector of package names
# up: logical- upgrade installed packages?
ipkCRAN <- function(p, up){
  if (up) {
    install.packages(p, dependencies = TRUE)
  } else {
    new.pkg <- p[! (p %in% installed.packages()[, "Package"])]
    if (length(new.pkg) > 0) {
      message('installing packages from CRAN...')
      install.packages(new.pkg, dependencies = TRUE)
    }
  }
}


## list of packages
packages <- c(
  # soil
  "aqp", "soilDB", "sharpshootR", "soiltexture",
  # gis
  "sp", "sf", "raster", "rgdal", "gdalUtils", "RSAGA", "rgrass7",
  # data management
  "tidyverse", "devtools", "roxygen2", "Hmisc", "RODBC", "circular", "knitr", "markdown", "DT",
  # graphics
  "latticeExtra", "Cairo", "maps", "spData", "mapview", "plotrix", "rpart.plot",
  # modeling
  "car", "rms", "randomForest", "party", "caret", "vegan", "ape", "shape",
  # sampling
  "clhs",
  # graphical user interface
  "Rcmdr"
)

## install packages, upgrading as needed
ipkCRAN(packages, up=TRUE)

## install the latest version of packages from the AQP suite:
devtools::install_github("ncss-tech/aqp", dependencies=FALSE, upgrade_dependencies=FALSE)
devtools::install_github("ncss-tech/soilDB", dependencies=FALSE, upgrade_dependencies=FALSE)
devtools::install_github("ncss-tech/soilReports", dependencies=FALSE, upgrade_dependencies=FALSE)
devtools::install_github("ncss-tech/sharpshootR", dependencies=FALSE, upgrade_dependencies=FALSE)

## install additional packages
install.packages("printr", type = "source", repos = c("http://yihui.name/xran", "http://cran.rstudio.com"))

## load packages in the list
suppressWarnings(sapply(packages, library, character.only = TRUE, quietly = TRUE, logical.return = TRUE))