library(RCurl)
library(XML)
library(plyr)
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
library(RCurl)
library(XML)
url <- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-Correlation_state_fy_id&asymbol=%25&fy=2015" # Works ... Thanks Kevin
scor <- getURLContent(url, ssl.verifypeer = F)
scor2 <- readHTMLTable(scor, stringsAsFactors = F)

# Rename, subset and find spatial changes
test2 <- scor2[[1]]
names(test2) <- unlist(lapply(names(test2), function(x) strsplit(x, "\n")[[1]][2]))
names(test2) <- unlist(lapply(names(test2), function(x) paste(strsplit(x, " ")[[1]], collapse = "_")))
test3 <- subset(test2, grepl("11-", Office))
test3$Spatial <- test3$New_lmuiid != test3$Old_lmuiid | test3$New_Symbol != test3$Old_Musym
ddply(test3, .(Office), summarize, sum(Spatial))



# WEB-PROJECT-Counties+with+approved+projects+DU
url <- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-PROJECT-Counties+with+approved+projects+DU&fy=2015"
dureport <- getURLContent(url, ssl.verifypeer = F)
dureport2 <- readHTMLTable(dureport)
doc = htmlParse(dureport)
tableNodes <- getNodeSet(doc, "//table")

l <- list()
for (i in 1:length(tableNodes)){
  l[[i]] <- rbind(readHTMLList(tableNodes[[i]]), stringsAsFactors = F)
}
dureport3 <- ldply(l)
dureport3 <- data.frame(lapply(dureport3, function(x) as.character(x)), stringsAsFactors = F)

# Rename, subset and find spatial changes
names(dureport3) <- dureport3[1, ]
dureport3 <- dureport3[-1, ]
names(dureport3) <- unlist(lapply(names(dureport3), function(x) paste(strsplit(x, " ")[[1]], collapse = "_")))
dureport3 <- subset(dureport3, grepl("11-", Office))

ddply(dureport3, .(Office), summarize, length(unique(Project_Name)))

