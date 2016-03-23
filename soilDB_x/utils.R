get_new <- function(q = q) {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  
  
  # setup connection local NASIS
  channel <- RODBC::odbcDriverConnect(connection = "DSN=nasis_local; UID=NasisSqlRO; PWD=nasisRe@d0n1y")
  
  # exec query
  d <- RODBC::sqlQuery(channel, q, stringsAsFactors = FALSE)
  
  # close connection
  RODBC::odbcClose(channel)
  
  # done
  return(d)
}

pindex <- function(x, interval){
  if (class(x)[1] == "data.frame") {x1 <- dim(x)[2]; x2 <- 1}
  if (class(x)[1] == "SoilProfileCollection") {x1 <- length(x); x2 <-0}
  if (class(x)[1] == "table") {x1 <- dim(x)[2]; x2 <- 0}
  n <- x1 - x2
  times <- ceiling(n/interval)
  x <- rep(1:(times + x2), each = interval, length.out = n)
}

na_replace <- function(x){
  if(class(x)[1] == "character" | class(x)[1] == "logical") {x <- replace(x, is.na(x) | x == "NA", "missing")} 
  else (x <-  x)
}


precision.f <- function(x){
  if (!all(is.na(x))) {y = str_length(str_split(format(max(x, na.rm = T), scientific=F), "\\.")[[1]][2])} else y = 0
  if (is.na(y)) y = 0 else y = y
}


sum5n <- function(x, n = NULL) {
  variable <- unique(x$variable)
  precision <- precision.f(x$value)
  n <- length(na.omit(x$value))
  ci <- data.frame(rbind(quantile(x$value, na.rm = TRUE, probs = p)))
  ci$range <- with(ci, paste0("(", paste0(round(ci, precision), collapse=", "), ")", "(", n, ")")) # add 'range' column for pretty-printing
  return(ci["range"])
}

sum5n2 <- function(x) {
  variable <- unique(x$variable)
  v <- na.omit(x$value) # extract column, from long-formatted input data
  precision <- if(variable == 'Circularity') 1 else 0
  ci <- data.frame(rbind(quantile(x$value, na.rm = TRUE, probs = p)))
  ci$range <- with(ci, paste0("(", paste0(round(ci, precision), collapse=", "), ")")) # add 'range' column for pretty-printing
  return(ci["range"])
}

ogr_extract <- function(pd, geodatabase, cache, project){
  ogr2ogr(
    src_datasource_name = paste0(pd, geodatabase),
    dst_datasource_name = cache,
    layer = "Project_Record",
    where = paste0("PROJECT_NAME IN (", noquote(paste("'", project, "'", collapse=",", sep="")),")"),
    s_srs = CRS("+init=epsg:5070"),
    t_srs = CRS("+init=epsg:5070"),
    overwrite = T,
    simplify = 2,
    verbose = TRUE)
}
  
raster_extract <- function(x){
  # Load grids
  g10.st <- stack(
    paste0(pd, "ned10m_", office, "_slope5.tif"), 
    paste0(pd, "ned10m_", office, "_aspect5.tif")
    )
  g30.st <- stack(
    paste0(pd, "ned30m_", office, ".tif"),
    paste0(pd, "ned30m_", office, "_wetness.tif"),
    paste0(pd, "ned30m_", office, "_mvalleys.tif"),
    paste0(pd, "ned30m_", office, "_z2stream.tif"),
    paste0(pd, "nlcd30m_", office, "_lulc2011.tif")
    )
  g800.st <- stack(
    paste0(rd, "prism800m_11R_ppt_1981_2010_annual_mm.tif"),
    paste0(rd, "prism800m_11R_tmean_1981_2010_annual_C.tif")
    )
  g1000.st <- stack(
    paste0(rd, "rmrs1000m_11R_ffp_1961_1990_annual_days.tif")
    )
  
  names(g10.st) <- c("slope", "aspect")
  names(g30.st) <- c("elev", "wetness", "valley", "relief", "lulc")
  names(g800.st) <- c("ppt", "temp")
  names(g1000.st) <- c("ffp")
  
  # Extract geodata
  g10.e <- extract(g10.st, x)
  g30.e <- extract(g30.st, x)
  g800.e <- extract(g800.st, x)
  g1000.e <- extract(g1000.st, x)
  geodata <- data.frame(g10.e, g30.e, g800.e, g1000.e)
  
  # Prep data
  geodata$aspect <- circular(geodata$aspect, template="geographic", units="degrees", modulo="2pi")
  
  slope<-c(0, 2, 6, 12, 18, 30, 50, 75, 350)
  aspect<-c(0, 23, 68, 113, 158, 203, 248, 293, 338, 360) 
  valley<-c(0, 0.5, 30)
  lulc <- 1:256-1
  
  geodata$slope_classes <- cut(geodata$slope, breaks = slope, right=FALSE)
  geodata$aspect_classes <- cut(geodata$aspect, breaks = aspect, right=FALSE)
  geodata$valley_classes <- cut(geodata$valley, breaks = valley, right=FALSE)
  geodata$lulc_classes <- cut(geodata$lulc, breaks = lulc, right=FALSE)
  
  levels(geodata$slope_classes) <- c("0-2","2-6","6-12","12-18","18-30","30-50","50-75","75-350")
  levels(geodata$aspect_classes) <- c("N","NE","E","SE","S","SW","W","NW","N")
  levels(geodata$valley_classes) <- c("upland","lowland")
  levels(geodata$lulc_classes) <- c('Unclassified','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','Open Water','Perennial Snow/Ice','NA','NA','NA','NA','NA','NA','NA','NA','Developed, Open Space','Developed, Low Intensity','Developed, Medium Intensity','Developed, High Intensity','NA','NA','NA','NA','NA','NA','Barren Land','NA','NA','NA','NA','NA','NA','NA','NA','NA','Deciduous Forest','Evergreen Forest','Mixed Forest','NA','NA','NA','NA','NA','NA','NA','NA','Shrub/Scrub','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','Herbaceuous','NA','NA','NA','NA','NA','NA','NA','NA','NA','Hay/Pasture','Cultivated Crops','NA','NA','NA','NA','NA','NA','NA','Woody Wetlands','NA','NA','NA','NA','Emergent Herbaceuous Wetlands','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA','NA')

  return(geodata = geodata)
}


na_remove <- function(df, by = "col"){
  if (by == "col"){df[, which(apply(df, 2, function(x) !all(is.na(x))))]
    }
}


.metadata_replace <- function(df){
  get_metadata <- function() {
    # must have RODBC installed
    if(!requireNamespace('RODBC'))
      stop('please install the `RODBC` package', call.=FALSE)
    
    q <- "SELECT mdd.DomainID, DomainName, ChoiceValue, ChoiceLabel, ChoiceDescription, ColumnPhysicalName, ColumnLogicalName
    
    FROM MetadataDomainDetail mdd
    INNER JOIN MetadataDomainMaster mdm ON mdm.DomainID = mdd.DomainID
    INNER JOIN (SELECT MIN(DomainID) DomainID, MIN(ColumnPhysicalName) ColumnPhysicalName, MIN(ColumnLogicalName) ColumnLogicalName FROM MetadataTableColumn GROUP BY DomainID) mtc ON mtc.DomainID = mdd.DomainID
    
    ORDER BY DomainID, ChoiceValue"
    
    # setup connection local NASIS
    channel <- RODBC::odbcDriverConnect(connection = "DSN=nasis_local; UID=NasisSqlRO; PWD=nasisRe@d0n1y")
    
    # exec query
    d <- RODBC::sqlQuery(channel, q, stringsAsFactors = FALSE)
    
    # close connection
    RODBC::odbcClose(channel)
    
    # done
    return(d)
  }
  
  metadata <- get_metadata()
  
  for (i in seq_along(df)){
    if (any(names(df[i]) %in% unique(metadata$ColumnPhysicalName))) {
      sub <- metadata[metadata$ColumnPhysicalName %in% names(df[i]), ]
      df[i] <- factor(df[i], levels = sub$ChoiceValue, labels = sub$ChoiceLabel)
    } else df[i] = df[i]
  }
  
  return(df)
}


