library(plyr)
library(foreign)


# Set parameters

region  <- 11
ownership <- read.csv("M:/geodata/soils/SSA_Regional_Ownership_MASTER_MLRA_OFFICE.csv")




# Check whether QA_MapunitCheck applies to my region

qa_mu <- read.table("M:/geodata/project_data/11WAV/QA_MapunitCheck_RTSD_Region_11_WAV_FY15_edited_gdb.txt", sep = "\t", header = TRUE)


R11 <- subset(ownership, Region == region)
qa_mu_R11 <- qa_mu[qa_mu$SurveyID %in% R11$AREASYMBOL, ]




# Summmarize export list

R11ATL <- cbind(read.dbf("M:/geodata/project_data/11ATL/mupolygon_edits_final_with_Region10.dbf", as.is = TRUE), sso = "11ATL")
R11CAR <- cbind(read.dbf("M:/geodata/project_data/11CAR/mupolygon_edits.dbf", as.is = TRUE), sso = "11CAR")
R11CLI <- cbind(read.dbf("M:/geodata/project_data/11CLI/mupolygon_edits.dbf", as.is = TRUE), sso = "11CLI")
R11FIN <- cbind(read.dbf("M:/geodata/project_data/11FIN/mupolygon_edits_final.dbf", as.is = TRUE), sso = "11FIN")
R11GAL <- cbind(read.dbf("M:/geodata/project_data/11GAL/mupolygon_edits.dbf", as.is = TRUE), sso = "11GAL")
R11IND <- cbind(read.dbf("M:/geodata/project_data/11IND/mupolygon_edits.dbf", as.is = TRUE), sso = "11IND")
R11JUE <- cbind(read.dbf("M:/geodata/project_data/11JUE/mupolygon_edits_with_Region10.dbf", as.is = TRUE), sso = "11JUE")
R11SPR <- cbind(read.dbf("M:/geodata/project_data/11SPR/mupolygon_edits_with_Region10.dbf", as.is = TRUE), sso = "11SPR")
R11UNI <- cbind(read.dbf("M:/geodata/project_data/11UNI/mupolygon_edits.dbf", as.is = TRUE), sso = "11UNI")
R11WAV <- cbind(read.dbf("M:/geodata/project_data/11WAV/mupolygon_edits_with_Region10_and_Region11.dbf", as.is = TRUE), sso = "11WAV")

edits <- rbind(R11ATL, R11CAR, R11CLI, R11FIN, R11GAL, R11IND, R11JUE, R11SPR, R11UNI, R11WAV)
edits <- edits[edits$AREASYMBOL %in% R11$AREASYMBOL, ]


corr <- ddply(edits, .(sso, AREASYMBOL), summarize, n_musym = length(strsplit(paste0(sort(unique(MUSYM)), collapse = ", "), ", ")[[1]]), musym = paste0(sort(unique(MUSYM)), collapse = ", "), old_musym = paste0(sort(unique(ORIG_MUSYM)), collapse = ", "))
sso_dup <- ddply(corr, .(AREASYMBOL), summarize, sso = paste0(sso, collapse = ", "))
corr2 <- merge(corr, sso_dup, by = "AREASYMBOL")
corr2 <- data.frame(corr2[c(2, 6, 1)], dom = "", corr2[c(3, 4, 5)], stringsAsFactors = FALSE)
corr2$state <- substr(corr2$AREASYMBOL, 1, 2)
corr2 <- corr2[with(corr2, order(sso.x, AREASYMBOL)), ]
row.names(corr2) <- 1:nrow(corr2)

corr2[corr2$sso == "11ATL, 11WAV", "dom"] <- "11WAV"
corr2[corr2$sso == "11GAL, 11WAV", "dom"] <- "11WAV"
corr2[corr2$AREASYMBOL == "IL015", "dom"] <- "11WAV"
corr2[corr2$AREASYMBOL == "WI045", "dom"] <- "11JUE"

write.csv(corr2, paste0("region11_SSURGO_export_", format(Sys.time(), "%Y_%m_%d"), ".csv"))
