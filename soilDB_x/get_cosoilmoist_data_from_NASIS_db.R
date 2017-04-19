get_cosoilmoist_data_from_NASIS_db <- function(na = "None") {
  # must have RODBC installed
  if (!requireNamespace('RODBC')) stop('please install the `RODBC` package', call.=FALSE)
  
  q.cosoilmoist <- "SELECT dmuiidref AS dmuiid, coiid, compname, comppct_r, month, flodfreqcl, pondfreqcl, cosoilmoistiid, soimoistdept_l, soimoistdept_r, soimoistdept_h, soimoistdepb_l, soimoistdepb_r, soimoistdepb_h, soimoiststat
  
  FROM component_View_1 co LEFT OUTER JOIN
       comonth com ON com.coiidref = co.coiid LEFT OUTER JOIN
       cosoilmoist cosm ON cosm.comonthiidref = com.comonthiid
  
  ORDER BY dmuiid, compname, comppct_r, month, soimoistdept_r
  ;"
  
  
  # setup connection local NASIS
  channel <- RODBC::odbcDriverConnect(connection="DSN=nasis_local;UID=NasisSqlRO;PWD=nasisRe@d0n1y")
  
  
  # exec query
  d.cosoilmoist <- RODBC::sqlQuery(channel, q.cosoilmoist, stringsAsFactors = FALSE)
  
  
  # recode metadata domains
  d.cosoilmoist <- .metadata_replace(d.cosoilmoist)
  
  
  # replace NA values with None
  vars <- c("flodfreqcl", "pondfreqcl")
  d.cosoilmoist <- within(d.cosoilmoist, {
    flodfreqcl[is.na(flodfreqcl)] <- na
    pondfreqcl[is.na(pondfreqcl)] <- na
    })
  
  
  # cache original column names
  orig_names <- names(d.cosoilmoist)
  
  
  # relabel names
  names(d.cosoilmoist) <- gsub("^soimoist", "", names(d.cosoilmoist))


  # close connection
  RODBC::odbcClose(channel)
  
  
  # done
  return(d.cosoilmoist)
}