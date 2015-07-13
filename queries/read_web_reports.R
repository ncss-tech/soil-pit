library(RCurl)
library(XML)
library(stringr)


# see http://ascii.cl/htmlcodes.htm for html conversion codes

# Early test with Jason
url <- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=Horizon_Primary_Characterization_Report_Lab_4_R"
test <- getURLContent(getURLContent(url, ssl.verifypeer=F))


# SDJR project MUKEY list
project <- "SDJR - MLRA 111A - Crosby-Lewisburg silt loams, 0 to 2 percent slopes"
project <- str_replace_all(project, " ", "%20") # Insert %20 in spaces
url <- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-Projectmapunits"
newurl <- paste0(url, '&p1=', project)
test <- getURLContent(newurl, ssl.verifypeer=F)

test2 <- xmlToList(test)
test2 <- test2$body$form$div$div$div$text
test2 <- strsplit(test2, "\n")
test2 <- strsplit(test2[[1]], "\\|")
test2 <- na.omit(as.numeric(unlist(test2))) # Success


# WEB-Correlation_state_fy_ids
url <- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-Correlation_state_fy_id&asymbol=%25&fy=2015" # Works ... Thanks Kevin
test <- getURLContent(url, ssl.verifypeer=F)
test2 <- readHTMLTable(test)

# Rename, subset and find spatial changes
test2 <- test2[[1]]
names(test2) <- unlist(lapply(names(test2), function(x) strsplit(x, "\n")[[1]][2]))
names(test2) <- unlist(lapply(names(test2), function(x) paste(strsplit(x, " ")[[1]], collapse = "_")))
test3 <- subset(test2, grepl("11-", Office))
test3 <- data.frame(lapply(test3, function(x) as.character(x)), stringsAsFactors = F)

