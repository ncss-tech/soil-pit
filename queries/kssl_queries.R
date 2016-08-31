# WEB-PROJECT-Counties+with+approved+projects+DU

du_report <- function(fy) {
  url <- paste0("https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-PROJECT-Counties+with+approved+projects+DU&fy=", fy)
  report_html <- getURLContent(url, ssl.verifypeer = F)
  
  # This report has a funky structure, need to reformat
  doc = htmlParse(report_html)
  tableNodes <- getNodeSet(doc, "//tr")
  
  l <- list()
  for (i in 1:length(tableNodes)){
    l[[i]] <- rbind(readHTMLList(tableNodes[[i]]), stringsAsFactors = F)
  }
  report <- ldply(l)
  
  # Rename, subset and find spatial changes
  names(report) <- report[1, ] # append first row to column names
  report <- report[-1, ] # remove the first row
  names(report) <- unlist(lapply(names(report), function(x) paste(strsplit(x, " ")[[1]], collapse = "_"))) # reformat column names
  
  write.csv(report, 
            file = paste0(
              "report_digitizing_unit_",
              format(Sys.time(), "%Y_%m_%d"),
              ".csv"),
            row.names = FALSE
            )
  
  return(du = report)
}

# WEB-Correlation_state_fy_ids
# new similar reports by Jason, 
# https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-ARCGIS_PROJECT-CHANGES_FY&asymbol=WI001&fy=2015
# https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-ARCGIS_PROJECT-CHANGES_FY
# https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-PROJECT-LMU_TEXT_METADATA_BY_AREASYMBOL


correlation_report <- function(asymbol, fy){
  url <- paste0("https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-Correlation_state_fy&asymbol=", asymbol, "&fy=", fy) # Works ... Thanks Kevin and Jason
  
  url_download <- function(x) {
    l <- list()
    for (i in seq(x)){
      cat(paste("working on", x[i], "\n"))
      cor_w <- getURLContent(x[i], ssl.verifypeer = F)
      if (length(readHTMLTable(cor_w, stringsAsFactors = F)) > 0) {
        l[[i]] <- readHTMLTable(cor_w, stringsAsFactors = F)[[1]]}
    }
    test <- length(l) > 0
    if (test) ldply(l) else message("no data")
  }
  
  corr <- url_download(url)
  
  # Rename, subset and find spatial changes
  names(corr) <- gsub("\n", "", names(corr))
  
  corr$region <- sapply(corr$sso, function(x) strsplit(x, "-")[[1]][1])
  corr$fy <- fy
  
  z_error <- function(old, new){
    n <- nchar(old)
    first <- substr(old, 1, 1)
    last <- substr(old, n, n)
    new2 <- old
    
    if (old != new & (first == "z" | last == "z")) {new2 <- paste0(strsplit(old, "z")[[1]], collapse = "")}
    else old
    if (old != new & (first == "x" | last == "x")) {new2 <- paste0(strsplit(old, "x")[[1]], collapse = "")}
    else old
    if (old != new & (last == "c")) {new2 <- paste0(strsplit(old, "c")[[1]], collapse = "")}
    else old
    if (old == new) new2 <- new
    
    return(new2)
  }
  
  corr$old_musym2 <- mapply(z_error, old = corr$old_musym, new = corr$new_musym)
  corr$spatial <- corr$new_musym != corr$old_musym2
  
  write.csv(corr, 
            file = paste0(
              "report_correlation_fy",
              fy, 
              "_", 
              format(Sys.time(), "%Y_%m_%d"), 
              ".csv"),
            row.names = FALSE
            )
  
  return(corr = corr)
}



sdjr_correlation <- function(asymbol, project_id, start_date, finish_date){
  options(stringsAsFactors = FALSE)

  url <- paste0("https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-spatial_asym_uprojectid_dates&asymbol=", asymbol, "&project_id=", project_id, "&start_date=", start_date, "&finish_date=", finish_date)
  
  url_download <- function(x) {
    l <- list()
    for (i in seq_along(x)){
      cat(paste("working on", x[i], "\n"))
      cor_w <- RCurl::getURLContent(x[i], ssl.verifypeer = F)
      cor_t <- XML::readHTMLTable(cor_w, stringsAsFactors = FALSE)
      if (length(cor_t) > 0) {
        l[[i]] <- cor_t[[1]]}
    }
    test <- length(l) > 0
    if (test) do.call("rbind", l) else message("no data")
  }
  
  corr <- url_download(url)
  
  
# Rename, subset and find spatial changes
  names(corr) <- gsub("\n", "", names(corr), fixed = TRUE)

  vals <- c("projectiid", "areasymbol")
  temp <- by(corr, corr[, vals], function(x) data.frame(
    unique(x[, vals]),
    n_musym = length(x$musym))
    )
  temp <- do.call("rbind", temp)
  corr <- merge(corr, temp, by = vals, all.x = TRUE, sort = FALSE)
  
  corr <- transform(corr, muacres = as.numeric(muacres), new_muacres = as.numeric(new_muacres))
  corr <- as.data.frame(lapply(corr[seq_along(corr)], function(x) if (is.character(x)) ifelse(x == "", NA, x) else x))
  
  spatial <- function(muacres, new_muacres, n_musym, musym, new_musym) {
    acre_test <- NA
    n_test <- NA
    musym_test <- NA
    
    # acre test
    if (!is.na(muacres) & !is.na(new_muacres)) {
      if (muacres != new_muacres) acre_test <- TRUE 
      else acre_test <- FALSE} 
    else acre_test <- NA
    # musym test
    if (!is.na(new_musym)) {
      if (musym != new_musym & !grepl("^[zxaZ]|[zxaZS]$|+$|_old$", musym)) 
        {musym_test <- TRUE} 
      else musym_test <- FALSE} 
    else musym_test <- NA
    # n test
    if (n_musym > 1) n_test <- TRUE 
    else n_test <- FALSE
    return(any(acre_test, n_test, musym_test))
  }
  
  corr$spatial_change <- with(corr, mapply(spatial, muacres, new_muacres, n_musym, musym, new_musym))
  
#   (lmu.musym NOT LIKE '[zx]%' OR lmu.musym NOT LIKE '%[ZS]' OR lmu.musym NOT LIKE '%[zx]' OR lmu.musym NOT LIKE '%[Z]' OR # Region 11 rules for legend constraint error
#   lmu.musym NOT LIKE '[a]%' OR lmu.musym NOT LIKE '%[a]' OR lmu.musym NOT LIKE '%[+]' OR lmu.musym NOT LIKE '%[_old]')) OR # Other Region rules for legend constraint error
  
  asym <-paste0(asymbol[1], "_", asymbol[length(asymbol)], "_", format(Sys.time(), "%Y_%m_%d"))
  write.csv(corr, 
            file = paste0(
              "report_correlation_fy", 
              format(as.Date(finish_date, "%m/%d/%Y"), "%Y"), 
              "_", 
              asym,
              ".csv"), 
            row.names = FALSE)
  
  return(corr = corr)
}



# WEB-MLRA_Goals_Progress

goals_report <- function(fy, office){
  
  url <- paste0("https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-MLRA_Goals_Progress_Office_FY&fy=", fy, "&off=", office)
  goals_w <- getURLContent(url, ssl.verifypeer = F)
  doc <- htmlParse(goals_w)
  tableNodes <- getNodeSet(doc, "//tr")
  
  l <- list()
  for (i in seq_along(tableNodes)){
    l[[i]] <- rbind(readHTMLList(tableNodes[[i]]))
  }
  
  goals <- as.data.frame(do.call(
    rbind, 
    l[-c(1, length(l))]
    ))
  
  names(goals) <-l[[1]][1, ]
  names(goals) <- sapply(names(goals), function(x) paste(strsplit(x, " ")[[1]], collapse = "_"))
  names(goals) <- tolower(names(goals))
  
  goals <- transform(goals, 
                     fy = fy, 
                     goaled = as.numeric(goaled),
                     reported = as.numeric(reported)
  )
  
  write.csv(goals, file = paste0(
    "report_goals_fy", 
    substr(fy, 3, 4),
    "_",
    format(Sys.time(), "%Y_%m_%d"),
    ".csv"),
    row.names = FALSE)
  
  return(goals)
}

legends_report <- function(areasymbol) {
  url <- paste0("https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-legends&off=", areasymbol)
  
  url_download <- function(x) {
    l <- list()
    for (i in seq(x)){
      cat(paste("working on", x[i], "\n"))
      leg_r <- getURLContent(x[i], ssl.verifypeer = F)
      leg_t <- readHTMLTable(leg_r, stringsAsFactors = F)
      if (length(leg_t) > 0) {
        l[[i]] <- leg_t[[1]]
        }
    }
    do.call(rbind, l)
  }
  
  leg <- url_download(url)
  
  # Rename, subset and find spatial changes
  names(leg) <- unlist(lapply(names(leg), function(x) strsplit(x, "\n")[[1]][3]))
  names(leg) <- sapply(names(leg), function(x) paste(strsplit(x, " ")[[1]], collapse = "_"))
  names(leg) <- tolower(names(leg))
  
  num <- c("total_acres", "area_acres")
  leg[num] <- sapply(leg[num], as.numeric)
  
  write.csv(leg, 
            file = paste0(
              "report_legends_",
              format(Sys.time(),
                     "%Y_%m_%d"),
              ".csv"),
            row.names = FALSE)
  
  return(leg)
}