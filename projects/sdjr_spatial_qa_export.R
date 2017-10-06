options(stringsAsFactors = FALSE)

library(plyr)
library(foreign)

# Set parameters
Region  <- 11
ownership <- read.csv("M:/geodata/soils/SSA_Regional_Ownership_MASTER_fy17.csv")
names(ownership) <- tolower(names(ownership))
# topology <- read.csv("Recertify_List_20160620.csv")[, 1:2]

# Check whether QA_MapunitCheck applies to my region
# qa_mu <- read.table("M:/geodata/project_data/11WAV/QA_MapunitCheck_RTSD_Region_11_WAV_FY15_edited_gdb.txt", sep = "\t", header = TRUE)


R11 <- subset(ownership, region == Region)
# qa_mu_R11 <- qa_mu[qa_mu$SurveyID %in% R11$AREASYMBOL, ]

ownCloud <- "C:/Users/stephen.roecker/ownCloud/"

# Summmarize export list
vars <- c("AREASYMBOL", "MUSYM", "ORIG_MUSYM")

R11ATL <- cbind(sso = "11ATL", read.dbf(paste0(ownCloud, "r11_atl_spatial.dbf"), as.is = TRUE)[, vars])
R11AUR <- cbind(sso = "11AUR", read.dbf(paste0(ownCloud, "r11_aur_spatial.dbf"), as.is = TRUE)[, vars])
R11CLI <- cbind(sso = "11CLI", read.dbf(paste0(ownCloud, "r11_cli_spatial.dbf"), as.is = TRUE)[, vars])
R11FIN <- cbind(sso = "11FIN", read.dbf(paste0(ownCloud, "r11_fin_spatial.dbf"), as.is = TRUE)[, vars])
R11GAL <- cbind(sso = "11GAL", read.dbf(paste0(ownCloud, "r11_gal_spatial.dbf"), as.is = TRUE)[, vars])
R11IND <- cbind(sso = "11IND", read.dbf(paste0(ownCloud, "r11_ind_spatial.dbf"), as.is = TRUE)[, vars])
R11JUE <- cbind(sso = "11JUE", read.dbf(paste0(ownCloud, "r11_jue_spatial.dbf"), as.is = TRUE)[, vars])
R11MAN <- cbind(sso = "11MAN", read.dbf(paste0(ownCloud, "r11_man_spatial.dbf"), as.is = TRUE)[, vars])
R11UNI <- cbind(sso = "11UNI", read.dbf(paste0(ownCloud, "r11_uni_spatial.dbf"), as.is = TRUE)[, vars])
R11WAV <- cbind(sso = "11WAV", read.dbf(paste0(ownCloud, "r11_wav_spatial2.dbf"), as.is = TRUE)[, vars])

edits <- rbind(R11ATL, R11AUR, R11CLI, R11FIN, R11GAL, R11IND, R11JUE, R11MAN, R11UNI, R11WAV)
names(edits) <- tolower(names(edits))

edits_R11 <- edits[edits$areasymbol %in% R11$areasymbol, ]

corr <- ddply(edits_R11, .(sso, areasymbol), summarize, 
              n_musym = length(unique(musym)), 
              musym = paste(sort(unique(musym)), collapse = ", "), 
              old_musym = paste(sort(unique(orig_musym)), collapse = ", ")
              )
sso_dup <- ddply(corr, .(areasymbol), summarize, sso = paste(sso, collapse = ", "))
corr2 <- merge(corr, sso_dup, by = "areasymbol")
# corr2 <- merge(corr2, topology, by.x = "AREASYMBOL", by.y = "FIPS", all.y = TRUE)
corr2 <- with(corr2, data.frame(sso.x, sso.y, areasymbol, n_musym, old_musym), stringsAsFactors = FALSE)
corr2$state <- substr(corr2$areasymbol, 1, 2)
corr2 <- corr2[with(corr2, order(sso.x, areasymbol)), ]
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
