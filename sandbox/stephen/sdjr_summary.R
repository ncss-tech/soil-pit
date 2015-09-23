# Compare the goals to the corrselation report

options(stringsAsFactors = FALSE)
library(plyr)
library(lattice)

fy <- c(2012, 2013, 2014, 2015)
date <- "2015_09_18"
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


corrs2 <- ddply(corrs, .(region, fy, projectname, project_type), summarize, n = length(unique(project_acres)), acres = paste0(unique(project_acres), collapse = ", "))
corrs3 <- ddply(corrs2, .(region, fy, projectname, project_type, n), summarize, acres = as.numeric(strsplit(acres, ", ")[[1]]))
corrs4 <- ddply(corrs3, .(region, fy, projectname, project_type), summarize, acres = sum(acres))
                              
corrs_sub <- subset(corrs4, region == 11 & fy == 2015 & project_type == "SDJR")
goals_sub <- subset(goals, fy == 2015 & project_type == "SDJR")


j <- join(corrs_sub, goals_sub, type = "full", by = "projectname")


id <- which(is.na(j$region) & j$Reported > 0)
j[id, ]

tonie <- j[id, ]
write.csv(tonie, "tonie_list.csv")
