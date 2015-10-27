## note: when multiple textures have been defined, only the first one is returned (alphabetical ?)

get_queries_NASIS_db <- function() {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  q <- "SELECT lmapunitiid
  
  FROM lmapunit_View_1;"
  
  # setup connection local NASIS
  channel <- RODBC::odbcDriverConnect(connection="DSN=nasis_local;UID=NasisSqlRO;PWD=nasisRe@d0n1y")
  
  # exec query
  d <- RODBC::sqlQuery(channel, q, stringsAsFactors=FALSE)

  # close connection
  RODBC::odbcClose(channel)
  
  # done
  return(d)
}


get_reports_NASIS_db <- function() {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  q <- "SELECT rptiid, rptname, grpname, nasissitename
  
  FROM report
  
  INNER JOIN nasisgroup ng ON ng.grpiid = report.grpiidref
  INNER JOIN nasissite ns ON ns.nasissiteiid = ng.nasissiteiidref;"
  
  # setup connection local NASIS
  channel <- RODBC::odbcDriverConnect(connection="DSN=nasis_local;UID=NasisSqlRO;PWD=nasisRe@d0n1y")
  
  # exec query
  d <- RODBC::sqlQuery(channel, q, stringsAsFactors=FALSE)
  
  # close connection
  RODBC::odbcClose(channel)
  
  # done
  return(d)
}
