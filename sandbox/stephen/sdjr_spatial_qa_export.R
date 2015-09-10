library(plyr)
library(foreign)

region <- read.csv("L:/geodata/soils/SSA_Regional_OWnership_MASTER_MLRA_OFFICE.csv")
test <- read.table("L:/geodata/project_data/11WAV/QA_MapunitCheck_RTSD_Region_11_WAV_FY15_edited2_gdb.txt", sep = "\t", header = TRUE)

test2 <- region[match(test$SurveyID, region$AREASYMBOL), ]
test3 <- test2[test2$Region == 11, ]



region <- read.csv("L:/geodata/soils/SSA_Regional_OWnership_MASTER_MLRA_OFFICE.csv")
check <- read.dbf("L:/geodata/project_data/11FIN/mupolygon_edits_final2.dbf", as.is = TRUE)
test <- sort(unique(check$AREASYMBOL))
test2 <- region[match(test, region$AREASYMBOL), ]
test3 <- test[test2$Region == 11]


# Export list
region <- read.csv("L:/geodata/soils/SSA_Regional_OWnership_MASTER_MLRA_OFFICE.csv")

R11ATL <- cbind(read.dbf("L:/geodata/project_data/11ATL/mupolygon_edits_final_with_Region10.dbf", as.is = TRUE), office = "11ATL")
R11CAR <- cbind(read.dbf("L:/geodata/project_data/11CAR/mupolygon_edits.dbf", as.is = TRUE), office = "11CAR")
R11CLI <- cbind(read.dbf("L:/geodata/project_data/11CLI/mupolygon_edits.dbf", as.is = TRUE), office = "11CLI")
R11GAL <- cbind(read.dbf("L:/geodata/project_data/11GAL/mupolygon_edits.dbf", as.is = TRUE), office = "11GAL")
R11JUE <- cbind(read.dbf("L:/geodata/project_data/11JUE/mupolygon_edits_with_Region10.dbf", as.is = TRUE), office = "11JUE")
R11SPR <- cbind(read.dbf("L:/geodata/project_data/11SPR/mupolygon_edits_with_Region10.dbf", as.is = TRUE), office = "11SPR")
R11UNI <- cbind(read.dbf("L:/geodata/project_data/11UNI/mupolygon_edits.dbf", as.is = TRUE), office = "11UNI")
R11WAV <- cbind(read.dbf("L:/geodata/project_data/11WAV/mupolygon_edits_with_Region10_and_Region11.dbf", as.is = TRUE), office = "11WAV")

offices <- rbind(R11ATL, R11CAR, R11CLI, R11GAL, R11JUE, R11SPR, R11UNI, R11WAV)

test <- ddply(offices, .(office, AREASYMBOL), summarize, n_musym = length(strsplit(paste0(sort(unique(MUSYM)), collapse = ", "), ", ")[[1]]), musym = paste0(sort(unique(MUSYM)), collapse = ", "), old_musym = paste0(sort(unique(ORIG_MUSYM)), collapse = ", "))

test2 <- join(test, region, by = "AREASYMBOL")
test3 <- subset(test2, Region == 11, select = c("office", "AREASYMBOL", "n_musym", "musym", "old_musym"))

test4 <- ddply(test3, .(AREASYMBOL), summarize, offices = paste0(office, collapse = ", "))
test5 <- join(test3, test4, by = "AREASYMBOL")
test5 <- data.frame(test5[c(1:3)], dom = "", test5[c(6, 4, 5)], stringsAsFactors = FALSE)

test5[test5$offices == "11ATL, 11WAV", "dom"] <- "11WAV"
test5[test5$offices == "11GAL, 11WAV", "dom"] <- "11WAV"
test5[test5$AREASYMBOL == "IL015", "dom"] <- "11WAV"
test5[test5$AREASYMBOL == "WI045", "dom"] <- "11JUE"

write.csv(test5, paste0("region11_spatial_changes_", format(Sys.time(), "%Y_%m_%d"), ".csv"))
