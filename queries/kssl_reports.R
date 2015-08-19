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

correlation_report <- function(asymbol, fy){
  url <- paste0("https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-Correlation_state_fy&asymbol=", asymbol, "%25&fy=", fy) # Works ... Thanks Kevin
  
  url_download <- function(x) {
    l <- list()
    for (i in seq(x)){
      cor_w <- getURLContent(x[i], ssl.verifypeer = F)
      if (nchar(cor_w) > 900) {
        l[[i]] <- readHTMLTable(cor_w, stringsAsFactors = F)[[1]]}
    }
    ldply(l)
  }
  
  corr <- url_download(url)
  
  # Rename, subset and find spatial changes
  names(corr) <- unlist(lapply(names(corr), function(x) strsplit(x, "\n")[[1]][2]))
  names(corr) <- sapply(names(corr), function(x) paste(strsplit(x, " ")[[1]], collapse = "_"))
  
  corr$Region <- sapply(corr$Office, function(x) strsplit(x, "-")[[1]][1])
  
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
  
  corr$Old_Musym2 <- mapply(z_error, old = corr$Old_Musym, new = corr$New_Symbol)
  corr$spatial <- corr$New_lmuiid != corr$Old_lmuiid | corr$New_Symbol != corr$Old_Musym2
  corr$spatial_mukey <- corr$New_lmuiid != corr$Old_lmuiid
  corr$spatial_musym <- corr$New_Symbol != corr$Old_Musym2
  corr$region <- unlist(lapply(corr$Office, function(x) strsplit(x, "-")[[1]][1]))
  
  corr_spatial <- subset(corr, spatial == TRUE)
  
  write.dbf(corr, file = paste0("report_correlation_", format(Sys.time(), "%Y_%m_%d"), ".dbf"))
  write.dbf(corr_spatial, file = paste0("report_correlation_", format(Sys.time(), "%Y_%m_%d"), "_spatial.dbf"))
  
  return(list(corr = corr, corr_spatial = corr_spatial))
}

# WEB-MLRA_Goals_Progress

goals_report <- function(fy, off){
  url <- paste0("https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-MLRA_Goals_Progress&fy=", fy, "&off=", off)
  goals_w <- getURLContent(url, ssl.verifypeer = F)
  doc = htmlParse(goals_w)
  tableNodes <- getNodeSet(doc, "//tr")
  l <- list()
  for (i in 1:length(tableNodes)){
    l[[i]] <- rbind(readHTMLList(tableNodes[[i]]))
  }
  goals <- ldply(l)
  
  names(goals) <- c(goals[1, ])
  names(goals) <- sapply(names(goals), function(x) paste(strsplit(x, " ")[[1]], collapse = "_"))
  goals <- goals[-1, ]
  
  write.csv(goals, file = paste0("report_goals_", format(Sys.time(), "%Y_%m_%d"), ".csv"))
  
  return(goals)
}

