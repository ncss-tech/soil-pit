workingdays <- (52*5-10-3*5)*.75 # 52 weeks per year, 5 days per week, minus 10 holidays, minus 3 weeks vaction, at 75% an individuals time
projectsPerPerson <- 60/3.25 # 60 projects/ 3.25 people
workingdays/projectsPerPerson # equals number of days spent per sdjr project

sdjr <- function(days, projects, people){
  days/(projects/people)
}