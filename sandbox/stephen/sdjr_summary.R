# Compare the goals to the corrselation report

options(stringsAsFactors = FALSE)

library(plyr)
library(lattice)
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


# Compare Project Acres to Goal Acres
corrs2 <- ddply(corrs, .(region, fy, projectname, project_type, sso), summarize, n = length(unique(project_acres)), acres = paste0(unique(project_acres), collapse = ", "), goal = paste0(unique(acre_goal), collapse = ", "))
corrs3 <- ddply(corrs2, .(region, fy, projectname, project_type, sso, n, goal), summarize, acres = sum(as.numeric(strsplit(acres, ", ")[[1]])))
corrs4 <- ddply(corrs2, .(region, fy, projectname, project_type, sso, n, acres), summarize, goal = sum(as.numeric(strsplit(goal, ", ")[[1]])))

corrs4$acres <- as.numeric(corrs4$acres)

#corrs4 <- ddply(corrs3, .(region, fy, projectname, project_type, sso), summarize, acres = sum(acres), goal = sum(goal))
                              
corrs_sub <- subset(corrs4, region == 11 & fy == 2015 & project_type == "SDJR")
goals_sub <- subset(goals, Region == 11 & fy == 2015 & project_type == "SDJR")

j <- join(corrs_sub, goals_sub, type = "full", by = "projectname")


id <- which(is.na(j$region) & j$Reported > 0)
j[id, ]

test <- subset(corrs_sub, sso == "11-IND")
test2 <- subset(goals_sub, SS_Office == "11-IND")
sum(test$goal)



# Summarize acres by areasymbol
corrs2 <- ddply(corrs, .(fy, region, projectname, project_type, sso, areasymbol), summarize, n = length(unique(new_acres)), acres = paste0(unique(new_acres), collapse = ", "))
corrs3 <- ddply(corrs2, .(fy, region, sso, projectname, project_type, areasymbol, n), summarize, acres = sum(as.numeric(strsplit(acres, ", ")[[1]])))


corrs3$acres <- as.numeric(corrs3$acres)

corrs_sub <- subset(corrs3, region == 11 & project_type == "SDJR")
corrs_sub$st <- substr(corrs_sub$areasymbol, 1, 2)

goals_sub <- subset(goals, Region == 11 & project_type == "SDJR")
test3 <- ddply(goals_sub, .(fy), summarize, acres = sum(Reported))


test <- ddply(corrs_sub, .(fy), summarize, acres = sum(acres))


test2 <- reshape(test, idvar = c("areasymbol"), v.names = "acres", timevar = "fy", direction = "wide")
#test2$acres.2012[is.na(test2$acres.2012)] <- 0
#test2$acres.2013[is.na(test2$acres.2013)] <- 0
#test2$acres.2014[is.na(test2$acres.2014)] <- 0
test2$acres.2015[is.na(test2$acres.2015)] <- 0
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

# Summarize acres by musym
corrs2 <- ddply(corrs, .(fy, region), summarize, key = unique(new_mukey))

c14 <- subset(corrs2, fy == 2014 & region == 11)
c15 <- subset(corrs2, fy == 2015 & region == 11)

r14 <- raster("M:/geodata/soils/gssurgo_fy14_250m.tif")
r14_dbf <- read.dbf("M:/geodata/soils/gssurgo_fy14_30m.tif.vat.dbf")
r14 <- ratify(r14, count=TRUE)
rat <- levels(r14)[[1]]
names(r14_dbf)[1] <- "ID"
names(c14)[3] <- "MUKEY"
rat_new <- join(rat, r14_dbf, type = "left", by = "ID")
rat_new <- join(rat_new, c14, type = "left", by = "MUKEY")
r14_2 <- r14
levels(r14_2) <- rat_new

r14_new <- raster("C:/workspace/gSSURGO_fy14_progress.tif")
# r14_new <- deratify(r14_2, att='fy', filename='gSSURGO_fy14_progress.tif', overwrite=TRUE, datatype='INT4U', format='GTiff', progress = "text")

# check: OK
plot(r14_new)


r15 <- raster("M:/geodata/soils/gssurgo_fy15_250m.tif")
r15_dbf <- read.dbf("M:/geodata/soils/gssurgo_fy15_30m.tif.vat.dbf")
r15 <- ratify(r15, count=TRUE)
rat <- levels(r15)[[1]]
names(r15_dbf)[1] <- "ID"
names(c15)[3] <- "MUKEY"
rat_new <- join(rat, r15_dbf, type = "left", by = "ID")
rat_new <- join(rat_new, c15, type = "left", by = "MUKEY")
levels(r15) <- rat_new

r15_new <- raster("C:/workspace/gSSURGO_fy15_progress.tif")
# r15_new <- deratify(r15, att='fy', filename='gSSURGO_fy15_progress.tif', overwrite=TRUE, datatype='INT4U', format='GTiff', progress = "text")

# check: OK
plot(r15_new)

wi <- subset(ssa, state == "wi")

spplot(test, sp.layout = wi, maxpixels = 50000, xlim = bbox(wi)[1, ], ylim = bbox(wi)[2, ], at = seq(2013, 2015, 1), col.regions = rainbow(3))


