# Compare the goals to the corrselation report

options(stringsAsFactors = FALSE)
library(plyr)
library(lattice)

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

test <- ddply(corrs_sub, .(fy, st, areasymbol), summarize, acres = sum(acres))

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
corrs2 <- ddply(corrs, .(fy), summarize, key = unique(new_mukey))

corrs2 <- subset(corrs2, fy == 2015 & region 11)

r <- raster("M:/geodata/soils/gssurgo_fy15_250m.tif")
r <- ratify(r, count=TRUE)
rat <- levels(r)[[1]]
names(corrs2)[2] <- "ID"
rat_new <- join(rat, corrs2, type = "left", by = "ID")
levels(r) <- rat_new

r_new <- deratify(r, att='fy', filename='gSSURGO_test.tif', overwrite=TRUE, datatype='INT4U', format='GTiff', progress = "text")

# check: OK
plot(r_new)



