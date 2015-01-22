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


test.me <- merge(mapunit.df, projectmapunit.df, by.x="muiid", by.y="muiidref", all=TRUE)
test.me <- merge(project.df, test.me, by.x="projectiid", by.y="projectiidref", , all=TRUE)
names(test.me)[3] <- "mukey"
test.me <- subset(test.me, select=c("mukey"))
test.me <- unique(test.me)

# Definition query
muaggatt <- read.dbf("M:/geodata/project_data/11REGION/muaggatt.dbf")
muaggatt$mukey <- as.character(muaggatt$mukey)

test2 <- merge(muaggatt, test.me, by="mukey", )
paste("MUKEY IN (", noquote(paste("'", test2$mukey, "'", collapse=",", sep="")),")", sep="")
write.table(test2, "ES_MLRA_109_mupolygons.txt", quote=TRUE)

