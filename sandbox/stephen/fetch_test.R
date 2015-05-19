library(foreign)
library(soilDB)

mapunit.t <- function () {
  if (!require(RODBC)) 
    stop("please install the `RODBC` package", call. = FALSE)
  q <- "SELECT muname, muiid
  FROM mapunit_View_1;"
  channel <- odbcConnect("nasis_local", uid = "NasisSqlRO", 
                         pwd = "nasisRe@d0n1y")
  d <- sqlQuery(channel, q, stringsAsFactors = FALSE)
  odbcClose(channel)
  return(d)
}

mapunit.df <-mapunit.t()

projectmapunit.t <- function () {
  if (!require(RODBC)) 
    stop("please install the `RODBC` package", call. = FALSE)
  q <- "SELECT projectiidref, muiidref
  FROM projectmapunit_View_1;"
  channel <- odbcConnect("nasis_local", uid = "NasisSqlRO", 
                         pwd = "nasisRe@d0n1y")
  d <- sqlQuery(channel, q, stringsAsFactors = FALSE)
  odbcClose(channel)
  return(d)
}

projectmapunit.df <- projectmapunit.t()

project.t <- function () {
  if (!require(RODBC)) 
    stop("please install the `RODBC` package", call. = FALSE)
  q <- "SELECT projectiid, projectname
  FROM project_View_1;"
  channel <- odbcConnect("nasis_local", uid = "NasisSqlRO", 
                         pwd = "nasisRe@d0n1y")
  d <- sqlQuery(channel, q, stringsAsFactors = FALSE)
  odbcClose(channel)
  return(d)
}

project.df <- project.t()

legend.m.t <- function () {
  if (!require(RODBC)) 
    stop("please install the `RODBC` package", call. = FALSE)
  q <- "SELECT muiidref, lmapunitiid
  FROM lmapunit_View_1;"
  channel <- odbcConnect("nasis_local", uid = "NasisSqlRO", 
                         pwd = "nasisRe@d0n1y")
  d <- sqlQuery(channel, q, stringsAsFactors = FALSE)
  odbcClose(channel)
  return(d)
}

legend.m.df <- unique(legend.m.t())

test.me <- merge(mapunit.df, projectmapunit.df, by.x="muiid", by.y="muiidref", all=TRUE)
test.me <- merge(project.df, test.me, by.x="projectiid", by.y="projectiidref", , all=TRUE)
test.me <- merge(legend.m.df, test.me, by.x="mapunitiid", by.y="projectiidref", , all=TRUE)
names(test.me)[3] <- "mukey"
test.me <- subset(test.me, select=c("mukey"))






# Definition query
muaggatt <- read.dbf("M:/geodata/project_data/11REGION/muaggatt.dbf")
muaggatt$mukey <- as.character(muaggatt$mukey)

test2 <- merge(muaggatt, test, by="mukey", all=TRUE)
paste("MUKEY IN (", noquote(paste("'", test2$mukey, "'", collapse=",", sep="")),")", sep="")

test3 <- subset(test2, select=c("mukey", "muiidref", "ES109"))
write.csv(test3, "ES_MLRA_109_mupolygons.csv")

