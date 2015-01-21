test <- function () {
  if (!require(RODBC)) 
    stop("please install the `RODBC` package", call. = FALSE)
  q <- "SELECT muname, projectmapunitiid, projectiidref
  FROM (
mapunit_View_1
INNER JOIN projectmapunit_View_1 ON projectmapunit_View_1.muiidref = mapunit_View_1.muiid);"
  channel <- odbcConnect("nasis_local", uid = "NasisSqlRO", 
                         pwd = "nasisRe@d0n1y")
  d <- sqlQuery(channel, q, stringsAsFactors = FALSE)
  odbcClose(channel)
  return(d)
}

test2 <- test()

