.metadata_replace <- function(df, invert=FALSE){
  get_metadata <- function() {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  q <- "SELECT mdd.DomainID, DomainName, ChoiceValue, ChoiceLabel, ChoiceDescription, ColumnPhysicalName, ColumnLogicalName
  
  FROM MetadataDomainDetail mdd
  INNER JOIN MetadataDomainMaster mdm ON mdm.DomainID = mdd.DomainID
  INNER JOIN (SELECT MIN(DomainID) DomainID, MIN(ColumnPhysicalName) ColumnPhysicalName, MIN(ColumnLogicalName) ColumnLogicalName FROM MetadataTableColumn GROUP BY DomainID, ColumnPhysicalName) mtc ON mtc.DomainID = mdd.DomainID
  
  ORDER BY DomainID, ColumnPhysicalName, ChoiceValue"
  
  # setup connection local NASIS
  channel <- RODBC::odbcDriverConnect(connection = "DSN=nasis_local; UID=NasisSqlRO; PWD=nasisRe@d0n1y")
  
  # exec query
  d <- RODBC::sqlQuery(channel, q, stringsAsFactors = FALSE)
  
  # close connection
  RODBC::odbcClose(channel)
  
  # done
  return(d)
}

# load current metadata table
metadata <- get_metadata()
# unique set of possible columns that will need replacement
possibleReplacements <- unique(metadata$ColumnPhysicalName)
# names of raw data
nm <- names(df)
# index to columns with codes to be replaced
columnsToWorkOn.idx <- which(nm %in% possibleReplacements)

# iterate over columns with codes
for (i in columnsToWorkOn.idx){
  # get the current metadata
  sub <- metadata[metadata$ColumnPhysicalName %in% nm[i], ]
  ifelse(invert == FALSE, 
         # replace codes with values
         df[, i] <- factor(df[, i], levels = sub$ChoiceValue, labels = sub$ChoiceLabel),
         # replace values with codes
         df[, i] <- factor(df[, i], levels = sub$ChoiceLabel, labels = sub$ChoiceValue))
}

return(df)
}
