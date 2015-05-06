library(RCurl)

url <- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=Horizon_Primary_Characterization_Report_Lab_4_R"
test <- getURLContent(url, ssl.verifypeer=F)



# SDJR project MUKEY list
library(RCurl)

project <- "SDJR - MLRA 111A - Crosby-Lewisburg silt loams, 0 to 2 percent slopes"
url <- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-Projectmapunits"
newurl <- paste0(url, '&p1=', project)
theReport = urllib.urlopen(theURL)

url <- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-Projectmapunits&p1=SDJR - MLRA 111A - Crosby-Lewisburg silt loams, 0 to 2 percent slopes"
test <- getURLContent(url, ssl.verifypeer=F)
