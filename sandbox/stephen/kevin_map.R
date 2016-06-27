library(raster)
library(foreign)
library(plyr)

fy12 <- raster("E:/geodata/soils/gssurgo250m_region11_fy12_muagg.tif")
fy12_dbf <- read.dbf("E:/geodata/soils/gssurgo250m_region11_fy12_muagg.tif.vat.dbf")
fy12_rat <- ratify(fy12, count = TRUE)
fy12_lev <- levels(fy12_rat)[[1]]
names(fy12_dbf)[c(1, 17)] <- c("ID", "AWS50")
rat_new <- join(fy12_lev, fy12_dbf, type = "left", by = "ID")
levels(fy12) <- rat_new
fy12_new <- deratify(fy12, att='AWS50', filename='gssurgo_fy12_aws50.tif', overwrite = TRUE, datatype='INT4U', format = "GTiff", progress = "text")

fy16 <- raster("E:/geodata/soils/gssurgo250m_region11_fy16_muagg.tif")
fy16_dbf <- read.dbf("E:/geodata/soils/gssurgo250m_region11_fy16_muagg.tif.vat.dbf")
fy16_rat <- ratify(fy16, count = TRUE)
fy16_lev <- levels(fy16_rat)[[1]]
names(fy16_dbf)[c(1, 17)] <- c("ID", "AWS50")
rat_new2 <- join(fy16_lev, fy16_dbf, type = "left", by = "ID")
levels(fy16) <- rat_new
fy16_new <- deratify(fy16, att='AWS50', filename='gssurgo_fy16_aws50.tif', overwrite = TRUE, datatype='INT4U', format = "GTiff", progress = "text")
