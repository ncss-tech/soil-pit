get_metadata <- function() {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  q <- "SELECT * 
  
  FROM MetadataDomainMaster mdm
  INNER JOIN MetadataDomainDetail mdd ON mdd.DomainID = mdm.DomainID"
  
  # setup connection local NASIS
  channel <- RODBC::odbcDriverConnect(connection = "DSN=nasis_local; UID=NasisSqlRO; PWD=nasisRe@d0n1y")
  
  # exec query
  d <- RODBC::sqlQuery(channel, q, stringsAsFactors = FALSE)
  
  # close connection
  RODBC::odbcClose(channel)
  
  # done
  return(d)
}


get_component_data_from_NASIS_db <- function() {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  q <- "SELECT * FROM component_View_1 comp;"
  
  # setup connection local NASIS
  channel <- RODBC::odbcDriverConnect(connection="DSN=nasis_local; UID=NasisSqlRO; PWD=nasisRe@d0n1y")
  
  # exec query
  d <- RODBC::sqlQuery(channel, q, stringsAsFactors=FALSE)
  
  # close connection
  RODBC::odbcClose(channel)
  
  # test for no data
  if(nrow(d) == 0)
    stop('there are no NASIS components in your selected set!')
  
  # done
  return(d)
}
  

# get linked pedons by peiid and user pedon ID
# note that there may be >=1 pedons / coiid
get_copedon_from_NASIS_db <- function() {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  q <- "SELECT coiidref as coiid, peiidref as peiid, upedonid as pedon_id, rvindicator as representative 
  FROM copedon
  JOIN pedon ON peiidref = peiid
  WHERE rvindicator = 1;
  "
  # setup connection local NASIS
  channel <- RODBC::odbcDriverConnect(connection="DSN=nasis_local;UID=NasisSqlRO;PWD=nasisRe@d0n1y")
  
  # exec query
  d <- RODBC::sqlQuery(channel, q, stringsAsFactors=FALSE)
  
  # close connection
  RODBC::odbcClose(channel)
  
  # done
  return(d)
}



get_component_horizon_data_from_NASIS_db <- function() {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  q <- "SELECT chiid, coiidref as coiid, hzname, hzdept_r, hzdepb_r, fragvoltot_r, sandtotal_r, silttotal_r, claytotal_r, om_r, dbovendry_r, ksat_r, awc_r, lep_r, sar_r, ec_r, cec7_r, sumbases_r, ph1to1h2o_r
  FROM chorizon_View_1 
  ORDER BY coiidref, hzdept_r ASC;"
  
  # setup connection local NASIS
  channel <- RODBC::odbcDriverConnect(connection="DSN=nasis_local;UID=NasisSqlRO;PWD=nasisRe@d0n1y")
  
  # exec query
  d <- RODBC::sqlQuery(channel, q, stringsAsFactors=FALSE)
  
  # close connection
  RODBC::odbcClose(channel)
  
  # done
  return(d)
}


## TODO: this will not ID horizons with no depths
## TODO: better error checking / reporting is needed: coiid, dmu id, component name
fetchNASIS_component_data <- function() {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  # load data in pieces
  f.comp <- suppressWarnings(get_component_data_from_NASIS_db())
  f.chorizon <- get_component_horizon_data_from_NASIS_db()
  
  # test for bad horizonation... flag, and remove
  f.chorizon.test <- ddply(f.chorizon, 'coiid', test_hz_logic, topcol='hzdept_r', bottomcol='hzdepb_r', strict=TRUE)
  
  # which are the good (valid) ones?
  good.ids <- as.character(f.chorizon.test$coiid[which(f.chorizon.test$hz_logic_pass)])
  bad.ids <- as.character(f.chorizon.test$coiid[which(f.chorizon.test$hz_logic_pass == FALSE)])
  
  # keep the good ones
  f.chorizon <- f.chorizon[which(f.chorizon$coiid %in% good.ids), ]
  
  # upgrade to SoilProfilecollection
  depths(f.chorizon) <- coiid ~ hzdept_r + hzdepb_r
  
  ## TODO: this will fail in the presence of duplicates
  ## TODO: make this error more informative
  # add site data to object
  site(f.chorizon) <- f.comp # left-join via coiid
  
  # 7. save and mention bad pedons
  if(length(bad.ids) > 0) {
    bad.idx <- which(f.comp$coiid %in% bad.ids)
    bad.labels <- paste(f.comp[bad.idx, ]$dmudesc, f.comp[bad.idx, ]$compname, sep='-')
    assign('bad.components', value=cbind(coiid=bad.ids, component=bad.labels), envir=soilDB.env)
  }
  
  # print any messages on possible data quality problems:
  if(exists('bad.components', envir=soilDB.env))
    message("-> QC: horizon errors detected, use `get('bad.components', envir=soilDB.env)` for related coiid values")
  
  if(exists('tangled.comp.legend', envir=soilDB.env))
    message("-> QC: tangled [legend]--[correlation]--[data mapunit] links, use `get('bad.components', envir=soilDB.env)` for more information")
  
  # done, return SPC
  return(f.chorizon)
  
}


