get_lab_data_from_NASIS_db <- function() {
  
  # query lab data summary by horizon
  q.l.summary <- "SELECT p.phiid, cce


    FROM (
	(
	SELECT DISTINCT phiid FROM phorizon_View_1
	) as p

  LEFT OUTER JOIN (
	SELECT phiidref , Sum(caco3equivmeasured) AS cce
	FROM phlabresults_View_1
	GROUP BY phiidref
	) as f1_cce ON p.phiid = f1_cce.phiidref)

  ORDER BY p.phiid;"

# setup connection to our local NASIS database
channel <- odbcConnect('nasis_local', uid='NasisSqlRO', pwd='nasisRe@d0n1y') 

# exec queries
d.lab <- sqlQuery(channel, q.l.summary, stringsAsFactors=FALSE)

# close connection
odbcClose(channel)

# return a list of results
return(d.lab)
}
