# Projects per Person
workingdays <- (52*5-10-3*5)*.75 # 52 weeks per year, 5 days per week, minus 10 holidays, minus 3 weeks vaction, at 75% an individuals time
projectsPerPerson <- 69/4.5 # 69 projects/ 3.5 people
workingdays/projectsPerPerson # equals number of days spent per sdjr project

sdjr <- function(days, projects, people){
  days/(projects/people)
}

# Projects per Soil Series
office <- read.csv("11atl_goals.csv", stringsAsFactors=F)
projects <- str_split(office$Project.Name, pattern=" - ")
mapunits <- unlist(lapply(projects, function(x) x[3]))
majors <- unlist(lapply(str_split(mapunits, " "), function(x) x[1]))
components <- unique(unlist(lapply(str_split(majors, "-"), function(x) x[1])))
length(components)

