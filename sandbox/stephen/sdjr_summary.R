#### Summarize the SDJR lmapunit Correlation Report

options(stringsAsFactors = FALSE)

library(plyr)
library(lattice)
library(foreign)
library(raster)
library(rgdal)

fy <- c(2012, 2013, 2014, 2015)
date <- "2015_09_24"
date2 <- "2015_09_23"

corr_reports <- "report_correlation_fy"
goal_reports <- "report_goals_fy"

corr_files <- paste0(corr_reports, fy, "_", date, ".csv")
goal_files <- paste0(goal_reports, fy, "_", date2, ".csv")
import <- function(x, y){
  l <- list()
  for (i in seq(x)){
    l[[i]] <- read.csv(x[i])
    l[[i]]$fy <- y[i] 
  }
  ldply(l)
}

corrs <- import(corr_files, fy)
goals <- import(goal_files, fy)
names(goals)[c(5, 7)] <- c("project_type", "projectname")
corrs$project_type <- substr(corrs$projectname, 1, 4)
goals$project_type <- substr(goals$projectname, 1, 4)



### Compare Project Acres to Goal Acres

corrs2 <- ddply(corrs, .(region, fy, projectname, project_type, sso), summarize, n = length(unique(project_acres)), acres = paste0(unique(project_acres), collapse = ", "), goal = paste0(unique(acre_goal), collapse = ", "))
corrs2 <- ddply(corrs2, .(region, fy, projectname, project_type, sso, n, goal), summarize, acres = sum(as.numeric(strsplit(acres, ", ")[[1]])))
corrs2 <- ddply(corrs2, .(region, fy, projectname, project_type, sso, n, acres), summarize, goal = sum(as.numeric(strsplit(goal, ", ")[[1]])))
corrs2$acres <- as.numeric(corrs2$acres)

#corrs4 <- ddply(corrs3, .(region, fy, projectname, project_type, sso), summarize, acres = sum(acres), goal = sum(goal))
                              
corrs_sub <- subset(corrs2, region == 11 & fy == 2015 & project_type == "SDJR")
goals_sub <- subset(goals, Region == 11 & fy == 2015 & project_type == "SDJR")

j <- join(corrs_sub, goals_sub, type = "full", by = "projectname")
id <- which(is.na(j$region) & j$Reported > 0)
j[id, ]

test <- subset(corrs_sub, sso == "11-IND")
test2 <- subset(goals_sub, SS_Office == "11-IND")
sum(test$goal)



### Summarize acres by areasymbol

corrs2 <- ddply(corrs, .(fy, region, projectname, project_type, sso, areasymbol), summarize, n = length(unique(new_acres)), acres = paste0(unique(new_acres), collapse = ", "))
corrs2 <- ddply(corrs2, .(fy, region, sso, projectname, project_type, areasymbol, n), summarize, acres = sum(as.numeric(strsplit(acres, ", ")[[1]])))
corrs2$acres <- as.numeric(corrs2$acres)

corrs_sub <- subset(corrs2, region == 11 & project_type == "SDJR")
corrs_sub$st <- substr(corrs_sub$areasymbol, 1, 2)
goals_sub <- subset(goals, Region == 11 & project_type == "SDJR")
#test3 <- ddply(goals_sub, .(fy), summarize, acres = sum(Reported))


test <- ddply(corrs_sub, .(fy), summarize, acres = sum(acres))
test2 <- reshape(test, idvar = c("areasymbol"), v.names = "acres", timevar = "fy", direction = "wide")
fy <- c("FY2012", "FY2013", "FY2014", "FY2015")
names(test2)[3:6] <- fy

ssa <- readOGR(dsn = "M:/geodata/soils/soilsa_a_nrcs.shp", layer = "soilsa_a_nrcs", encoding = "ESRI Shapefile")
ssa <- spTransform(ssa, CRS("+init=epsg:5070"))
ssa$state <- substr(ssa$areasymbol, 1, 2)

test3 <- join(data.frame(ssa), test2, by = "areasymbol")
ssa@data <- test3
temp <- subset(ssa, state == "WI")
temp2 <- temp[fy]
spplot(temp2)



### Summarize acres by musym

corrs_mukey <- ddply(corrs, .(fy, region), summarize, MUKEY = unique(new_mukey))
corrs_ssaMusym <- ddply(corrs, .(fy, region), summarize, MUKEY = unique(paste0(areasymbol,"_", old_musym)))

fy12 <- subset(corrs_mukey, fy == 2012 & region == 11)
fy13 <- subset(corrs_ssaMusym, fy == 2013 & region == 11); 
fy14 <- subset(corrs_mukey, fy == 2014 & region == 11)
fy15 <- subset(corrs_mukey, fy == 2015 & region == 11)

fy13_r <- raster("M:/geodata/soils/gssurgo_fy13_250m.tif")
fy13_r_dbf <- read.dbf("M:/geodata/soils/gssurgo_fy13_30m.tif.vat.dbf")
fy13_r <- ratify(fy13_r, count=TRUE)
rat <- levels(fy13_r)[[1]]
names(fy13_r_dbf)[1] <- "ID"
names(fy13_r_dbf)[3] <- "MUKEY"
rat_new <- join(rat, fy13_r_dbf, type = "left", by = "ID")
rat_new <- join(rat_new, fy13, type = "left", by = "MUKEY")
fy13_r_2 <- fy13_r
levels(fy13_r_2) <- rat_new
fy13_r_new <- raster("C:/workspace/gSSURGO_fy13_progress.tif")
# fy13_r_new <- deratify(fy13_r_2, att='fy', filename='gSSURGO_fy13_progress.tif', overwrite=TRUE, datatype='INT4U', format='GTiff', progress = "text")


fy14_r <- raster("M:/geodata/soils/gssurgo_fy14_250m.tif")
fy14_r_dbf <- read.dbf("M:/geodata/soils/gssurgo_fy14_30m.tif.vat.dbf")
fy14_r <- ratify(fy14_r, count=TRUE)
rat <- levels(fy14_r)[[1]]
names(fy14_r_dbf)[1] <- "ID"
rat_new <- join(rat, fy14_r_dbf, type = "left", by = "ID")
rat_new <- join(rat_new, fy14, type = "left", by = "MUKEY")
fy14_r_2 <- fy14_r
levels(fy14_r_2) <- rat_new
fy14_r_new <- raster("C:/workspace/gSSURGO_fy14_progress.tif")
# fy14_r_new <- deratify(fy14_r_2, att='fy', filename='gSSURGO_fy14_progress.tif', overwrite=TRUE, datatype='INT4U', format='GTiff', progress = "text")


fy15_r <- raster("M:/geodata/soils/gssurgo_fy15_250m.tif")
fy15_r_dbf <- read.dbf("M:/geodata/soils/gssurgo_fy15_30m.tif.vat.dbf")
fy15_r <- ratify(fy15_r, count=TRUE)
rat <- levels(fy15_r)[[1]]
names(fy15_r_dbf)[1] <- "ID"
rat_new <- join(rat, fy15_r_dbf, type = "left", by = "ID")
rat_new <- join(rat_new, fy15, type = "left", by = "MUKEY")
levels(fy15_r) <- rat_new
fy15_r_new <- raster("C:/workspace/gSSURGO_fy15_progress.tif")
# fy15_r_new <- deratify(fy15_r, att='fy', filename='gSSURGO_fy15_progress.tif', overwrite=TRUE, datatype='INT4U', format='GTiff', progress = "text")

wi <- subset(ssa, state == "WI")
test <- stack(fy13_r_new, fy14_r_new, fy15_r_new)
names(test) <- c("FY13_SDJR_Progress", "FY14_SDJR_Progress", "FY15_SDJR_Progress")
spplot(test, sp.layout = wi, maxpixels = 5000, xlim = bbox(wi)[1, ], ylim = bbox(wi)[2, ], colorkey = FALSE, col.regions = "blue", strip = strip.custom(bg = grey(0.85)))

test_f <- function(x) test = unique(x)

test <- by(corrs, corrs[c("fy", "region")], function(x) cbind(unique(x$new_mukey), unique(x$old_mukey)))
test2 <- cbind(expand.grid(dimnames(test)), do.call(rbind, test))
