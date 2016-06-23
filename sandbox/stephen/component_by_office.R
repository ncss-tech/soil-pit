options(stringsAsFactors = FALSE)

library(plyr)
library(dplyr)

series <- c("Ackmore", "Colo", "Nodaway", "Olmitz", "Vesser", "Zook", "Lawson", "Ely", "Bremer", "Wabash")
offices <- c("11-ATL", "11-WAV", "11-GAL")

mapunit <- read.csv("mapunit.csv")
legend <- read.csv("legend.csv")
component <- read.csv("component.csv")
ssa <- read.csv("M:/geodata/soils/SSA_Regional_Ownership_MASTER_MLRA_OFFICE.csv")

map2 <- subset(mapunit, select = c(musym, muname, muacres, mukey, lkey))
leg2 <- subset(legend, select = c(areasymbol, areaname, mlraoffice, lkey))

ssa2 <- subset(ssa, select = c(AREASYMBOL, Region, MLRA_CODE))
names(ssa2) <- tolower(names(ssa2))
idx <- ssa2$mlra_code %in% offices
ssa2 <- ssa2[idx, ]

comp2 <- subset(component, majcompflag == "Yes", select = c(compname, comppct_r, cokey, mukey))
idx <- comp2$compname %in% series
comp2 <- comp2[idx, ]

test <- join(map2, comp2, type = "right", by = "mukey")
test <- join(leg2, test, type = "right", by = "lkey")
test <- join(ssa2, test, type = "right", by = "areasymbol")

test$comp_acres <- with(test, (comppct_r / 100) * muacres)

comp_summary <- group_by(test, mlra_code, compname) %>% summarize(comp_acres = sum(comp_acres))
comp_summary <- data.frame(comp_summary, stringsAsFactors = FALSE)
comp_summary2 <- reshape(comp_summary, v.names = "comp_acres", idvar = "compname", direction = "wide", timevar = "mlra_code")
names(comp_summary2) <- sub("comp_acres.", "", names(comp_summary2))  
