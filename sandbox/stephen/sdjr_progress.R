# Report to track SDJR progress and link to the gSSURGO

library(RCurl)
library(XML)
library(plyr)
library(stringr)

options(stringsAsFactors=F)

# LIMS Report: Project Mapunits with recorded acres 
url_p12 <- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-Project_mapunits_by_area_FY&office=%25&fy=2012&proj=%25"
p12 <- getURLContent(url_p12, ssl.verifypeer = F)
p12_p <- readHTMLTable(p12, stringsAsFactors = F)[[1]]

url_p13 <- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-Project_mapunits_by_area_FY&office=%25&fy=2013&proj=%25"
p13 <- getURLContent(url_p13, ssl.verifypeer = F)
p13_p <- readHTMLTable(p13, stringsAsFactors = F)[[1]]

url_p14 <- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-Project_mapunits_by_area_FY&office=%25&fy=2014&proj=%25"
p14 <- getURLContent(url_p14, ssl.verifypeer = F)
p14_p <- readHTMLTable(p14, stringsAsFactors = F)[[1]]

url_p15 <- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-Project_mapunits_by_area_FY&office=%25&fy=2015&proj=%25"
p15 <- getURLContent(url_p15, ssl.verifypeer = F)
p15_p <- readHTMLTable(p15, stringsAsFactors = F)[[1]]

p12_p$FY <- 2012
p13_p$FY <- 2013
p14_p$FY <- 2014
p15_p$FY <- 2015

names(p15_p) <- unlist(lapply(strsplit(names(p15_p), "\n"), paste, collapse=""))
names(p15_p) <- sapply(names(p15_p), function(x) paste(strsplit(x, " ")[[1]], collapse = "_"))
names(p12_p) <- names(p15_p)
names(p13_p) <- names(p15_p)
names(p14_p) <- names(p15_p)

sdjr <- rbind(p12_p, p13_p, p14_p, p15_p)


write.csv(sdjr, file = paste0("sdjr_progress_", format(Sys.time(), "%Y_%m_%d"), ".csv"))
