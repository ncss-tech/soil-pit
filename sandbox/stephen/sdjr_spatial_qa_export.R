options(stringsAsFactors = FALSE)

library(plyr)
library(foreign)

# Set parameters
Region  <- 11
ownership <- read.csv("M:/geodata/soils/SSA_Regional_Ownership_MASTER_MLRA_OFFICE.csv")
names(ownership) <- tolower(names(ownership))
# topology <- read.csv("Recertify_List_20160620.csv")[, 1:2]

# Check whether QA_MapunitCheck applies to my region
# qa_mu <- read.table("M:/geodata/project_data/11WAV/QA_MapunitCheck_RTSD_Region_11_WAV_FY15_edited_gdb.txt", sep = "\t", header = TRUE)


R11 <- subset(ownership, region == Region)
# qa_mu_R11 <- qa_mu[qa_mu$SurveyID %in% R11$AREASYMBOL, ]


# Summmarize export list
vars <- c("AREASYMBOL", "MUSYM", "ORIG_MUSYM")

R11ATL <- cbind(sso = "11ATL", read.csv("M:/geodata/project_data/11ATL/11ATL_mupolygon_edits_fy16_v3_with_Region10.txt", as.is = TRUE)[, vars])
R11CLI <- cbind(sso = "11CLI", read.dbf("M:/geodata/project_data/11CLI/11CLI_mupolygon_edits_fy16_v2.dbf", as.is = TRUE)[, vars])
R11FIN <- cbind(sso = "11FIN", read.dbf("M:/geodata/project_data/11FIN/11FIN_mupolygon_edits_fy16.dbf", as.is = TRUE)[, vars])
R11GAL <- cbind(sso = "11GAL", read.dbf("M:/geodata/project_data/11GAL/11GAL_mupolygon_edits_fy16_v3.dbf", as.is = TRUE)[, vars])
R11IND <- cbind(sso = "11IND", read.dbf("M:/geodata/project_data/11IND/11IND_mupolygon_edits_fy16.dbf", as.is = TRUE)[, vars])
R11MAN <- cbind(sso = "11MAN", read.dbf("M:/geodata/project_data/11MAN/11MAN_mupolygon_edits_fy16_v2.dbf", as.is = TRUE)[, vars])
R11SPR <- cbind(sso = "11SPR", read.csv("M:/geodata/project_data/11SPR/11SPR_mupolygon_edits_fy16_with_Region10.txt", as.is = TRUE)[, vars])
R11WAV <- cbind(sso = "11WAV", read.csv("M:/geodata/project_data/11WAV/11WAV_mupolygon_edits_fy16_with_Region10.txt", as.is = TRUE)[, vars])

edits <- rbind(R11ATL, R11CLI, R11FIN, R11GAL, R11IND, R11MAN, R11SPR)
names(edits) <- tolower(names(edits))

edits_R11 <- edits[edits$AREASYMBOL %in% R11$AREASYMBOL, ]

corr <- ddply(edits_R11, .(sso, AREASYMBOL), summarize, 
              n_musym = length(unique(MUSYM)), 
              musym = paste(sort(unique(MUSYM)), collapse = ", "), 
              old_musym = paste(sort(unique(ORIG_MUSYM)), collapse = ", ")
              )
sso_dup <- ddply(corr, .(AREASYMBOL), summarize, sso = paste(sso, collapse = ", "))
corr2 <- merge(corr, sso_dup, by = "AREASYMBOL")
# corr2 <- merge(corr2, topology, by.x = "AREASYMBOL", by.y = "FIPS", all.y = TRUE)
corr2 <- with(corr2, data.frame(sso.x, sso.y, AREASYMBOL, n_musym, old_musym), stringsAsFactors = FALSE)
corr2$state <- substr(corr2$AREASYMBOL, 1, 2)
corr2 <- corr2[with(corr2, order(sso.x, AREASYMBOL)), ]
row.names(corr2) <- 1:nrow(corr2)

corr2$dom <- ifelse(corr2$sso.y == "11ATL, 11GAL", "11ATL", NA)


# Changes to IN
edits$state <- substr(edits$areasymbol, 1, 2)
test <- ddply(edits, .(areasymbol), summarize, 
              musym = paste(unique(orig_musym), collapse = ", "),
              new_musym = paste(unique(musym), collapse = ", ")
              )
write.csv(test, "test.csv", row.names = FALSE)


# Changes sitting on the staging server
ss <- read.csv("staging_server_2016_09_15.csv") # web scrape file
names(ss) <- "survey"
ss$areasymbol <- substr(ss[, 1], 1, 5)
ss$spatial <- !grepl("tabular", ss[, 1])

ss_r11 <- subset(ss, areasymbol %in% R11$areasymbol & spatial == TRUE)
ss_recalled <- subset(ss_r11, !ss_r11$areasymbol %in% test$areasymbol)
ss_missing <- subset(test, !areasymbol %in% ss$areasymbol & areasymbol %in% R11$areasymbol)
ss_missing_neighbors <- subset(test, !areasymbol %in% ss$areasymbol & !areasymbol %in% R11$areasymbol)


ss_neighbors <- merge(test["areasymbol"], ss, by = "areasymbol", all.x = TRUE)
ss_neighbors <- merge(ss_neighbors, ownership[c("areasymbol", "region")], by.x = "areasymbol", by.y = "areasymbol", all.x = TRUE)
ss_neighbors_missing <- subset(ss_neighbors, Region != 11)
