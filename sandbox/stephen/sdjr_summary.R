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



# Compare Legend Acres to Project Acres
corrs2 <- ddply(corrs, .(region, fy, projectname, project_type, sso, areasymbol), summarize, n = length(unique(new_acres)), acres = paste0(unique(new_acres), collapse = ", "))
corrs3 <- ddply(corrs2, .(region, fy, projectname, project_type, sso, areasymbol, n), summarize, acres = sum(as.numeric(strsplit(acres, ", ")[[1]])))


corrs3$acres <- as.numeric(corrs3$acres)

corrs_sub <- subset(corrs3, region == 11 & fy == 2015 & project_type == "SDJR")
corrs_sub$st <- substr(corrs_sub$areasymbol, 1, 2)

test <- ddply(corrs_sub, .(areasymbol), summarize, acres = sum(acres))
