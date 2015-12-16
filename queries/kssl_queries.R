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
  
  write.csv(report, file = paste0("report_digitizing_unit_", format(Sys.time(), "%Y_%m_%d"), ".csv"))
  
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
  
  write.csv(corr, file = paste0("report_correlation_fy", fy, "_", format(Sys.time(), "%Y_%m_%d"), ".csv"))
  
  return(corr = corr)
}



sdjr_correlation <- function(asym, fyear1, fyear2){
  url <- paste0("https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-Correlation2_state_fy&asym=", asym, "&fyear1=", fyear1, "&fyear2=", fyear2)
  
  url_download <- function(x) {
    l <- list()
    for (i in seq(x)){
      cat(paste("working on", x[i], "\n"))
      cor_w <- getURLContent(x[i], ssl.verifypeer = F)
      if (length(readHTMLTable(cor_w, stringsAsFactors = F)) > 0) {
        l[[i]] <- readHTMLTable(cor_w, stringsAsFactors = F)[[1]]}
    }
    test <- length(l) > 0
    if (test) do.call("rbind", l) else message("no data")
  }
  
  corr <- url_download(url)
  
  # Rename, subset and find spatial changes
  names(corr) <- gsub("\n", "", names(corr))
  
  temp <- group_by(corr, projectiid, areasymbol) %>% summarize(n_musym = length(old_musym))
  corr <- left_join(corr, temp, by = c("projectiid", "areasymbol"))
  corr$spatial <- ifelse(corr$n_musym > 1 & corr$projecttypename == "SDJR", TRUE, FALSE)
  

  write.csv(corr, file = paste0("report_correlation_fy", fyear2, "_", format(Sys.time(), "%Y_%m_%d"), ".csv"))
  
  return(corr = corr)
}



# WEB-MLRA_Goals_Progress

goals_report <- function(fy, off){
  url <- paste0("https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-MLRA_Goals_Progress_Office_FY&fy=", fy, "&off=", off)
  goals_w <- getURLContent(url, ssl.verifypeer = F)
  doc <- htmlParse(goals_w)
  tableNodes <- getNodeSet(doc, "//tr")
  l <- list()
  for (i in 1:length(tableNodes)){
    l[[i]] <- rbind(readHTMLList(tableNodes[[i]]))
  }
  goals <- ldply(l)
  
  names(goals) <- c(goals[1, ])
  names(goals) <- sapply(names(goals), function(x) paste(strsplit(x, " ")[[1]], collapse = "_"))
  goals <- goals[-1, ]
  goals$fy <- fy
  
  write.csv(goals, file = paste0("report_goals_fy", fy, "_", format(Sys.time(), "%Y_%m_%d"), ".csv"))
  
  return(goals)
}

legends_report <- function(as) {
  url <- paste0("https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-legends&off=", as)
  
  url_download <- function(x) {
    l <- list()
    for (i in seq(x)){
      leg_w <- getURLContent(x[i], ssl.verifypeer = F)
      if (length(readHTMLTable(cor_w, stringsAsFactors = F)) > 0) {
        l[[i]] <- readHTMLTable(leg_w, stringsAsFactors = F)[[1]]}
    }
    ldply(l)
  }
  
  leg <- url_download(url)
  
  # Rename, subset and find spatial changes
  names(leg) <- unlist(lapply(names(leg), function(x) strsplit(x, "\n")[[1]][3]))
  names(leg) <- sapply(names(leg), function(x) paste(strsplit(x, " ")[[1]], collapse = "_"))
  names(leg) <- tolower(names(leg))
  
  num <- c("total_acres", "area_acres")
  leg[num] <- sapply(leg[num], as.numeric)
  
  write.csv(leg, file = paste0("report_legends_", format(Sys.time(), "%Y_%m_%d"), ".csv"))
  
  return(leg)
}