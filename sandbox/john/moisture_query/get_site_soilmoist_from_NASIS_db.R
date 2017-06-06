get_site_soilmoist_from_NASIS_db <- function() {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  q.site_soilmoist <- "SELECT siteiid as siteiid, usiteid as site_id, obsdate as obs_date, utmzone, utmeasting, utmnorthing, -(longdegrees + CASE WHEN longminutes IS NULL THEN 0.0 ELSE longminutes / 60.0 END + CASE WHEN longseconds IS NULL THEN 0.0 ELSE longseconds / 60.0 / 60.0 END) as x, latdegrees + CASE WHEN latminutes IS NULL THEN 0.0 ELSE latminutes / 60.0 END + CASE WHEN latseconds IS NULL THEN 0.0 ELSE latseconds / 60.0 / 60.0 END as y, longstddecimaldegrees as x_std, latstddecimaldegrees as y_std, soimoistdept as t_sm_d, soimoistdepb as b_sm_d
 
FROM
 
site_View_1 INNER JOIN siteobs_View_1 ON site_View_1.siteiid = siteobs_View_1.siteiidref

  LEFT OUTER JOIN sitesoilmoist_View_1 ON siteobs_View_1.siteobsiid = sitesoilmoist_View_1.siteobsiidref
  
  ORDER BY site_View_1.siteiid ;"
  
  
  # setup connection local NASIS
  channel <- RODBC::odbcDriverConnect(connection="DSN=nasis_local;UID=NasisSqlRO;PWD=nasisRe@d0n1y")
  
  
  # exec query
  d.site_soilmoist <- RODBC::sqlQuery(channel, q.site_soilmoist, stringsAsFactors=FALSE)
  
  
  # recode metadata domains
  d.site_soilmoist <- uncode(d.site_soilmoist)
  
  # close connection
  RODBC::odbcClose(channel)
  
  # done
  return(d.site_soilmoist)
}

