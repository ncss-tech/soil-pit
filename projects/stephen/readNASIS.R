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


# State Correlation Reports
url <- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-Correlation_state_fy_id&asymbol=IN%25&fy=2015" # Works ... Thanks Kevin
test <- getURLContent(url, ssl.verifypeer=F)
