options(stringsAsFactors = FALSE)

library(plyr)
library(stringr)
library(RCurl)
library(XML)

# Projects per Person
workingdays <- (52*5-10-3*5)*.75 # 52 weeks per year, 5 days per week, minus 10 holidays, minus 3 weeks vaction, at 75% an individuals time (i.e. minus 15% for TSS and 10% for coffee breaks)
projectsPerPerson <- 69/4.5 # 69 projects/ 3.5 people
workingdays/projectsPerPerson # equals number of days spent per sdjr project

sdjr <- function(days, projects, people){
  days/(projects/people)
}

# Projects per Soil Series
goals <- goals_report(2015, "11-%25")
goals <- subset(goals, SS_Office != "")

goals$projects <- str_split(goals$Project_Name, pattern=" - ")
goals$mapunits <- unlist(lapply(goals$projects, function(x) x[3]))
goals$components <- unlist(lapply(str_split(goals$mapunits, " "), function(x) x[1]))

jue <- subset(goals, SS_Office == "11-JUE")
jue$components <- unlist(lapply(str_split(jue$mapunits, " "), function(x) x[2]))

test <- ddply(goals, .(SS_Office), summarise, n_projects = length(unique(Project_Name)), n_mapunits = length(unique(mapunits)), n_majors = length(unique(unlist(lapply(str_split(components, "-"), function(x) x[1])))))
test2 <- ddply(jue, .(SS_Office), summarise, n_projects = length(unique(Project_Name)), n_mapunits = length(unique(mapunits)), n_majors = length(unique(unlist(lapply(str_split(components, "-"), function(x) x[1])))))
test[7, ] <- test2

people <- c(2, 2.5, 3, 2.5, 3, 5, 3, 5, 4, 1, 3)

test$people <- round(people, 1)
test$days <- round(people*workingdays, 0)
test$days_projects_person <- round(test$days / (test$n_projects / test$people), 0)
test$days_majors_person <- round(test$days / (test$n_major / test$people), 0)
test <- rbind(test, c("Average", round(apply(test[2:8], 2, mean), 0)))

print(test)
