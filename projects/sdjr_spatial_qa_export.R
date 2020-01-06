library(dplyr)
library(foreign)

# Set parameters
r11  <- 11
ownCloud <- "M:/geodata/project_data/FY2018_EXPORT/"

owners <- sf::read_sf(dsn = "C:/workspace2/github/SSURGO-QA/trunk/SSURGO_Soil_Survey_Area.gdb", layer = "SSA_Regional_Ownership_Master", stringsAsFactors = FALSE)
class(owners) <- "data.frame"
R11 <- subset(owners, Region == r11)
names(R11) <- tolower(names(R11))

# qa_mu_R11 <- qa_mu[qa_mu$SurveyID %in% R11$AREASYMBOL, ]
# topology <- read.csv("Recertify_List_20160620.csv")[, 1:2]

# Check whether QA_MapunitCheck applies to my region
# qa_mu <- read.table("M:/geodata/project_data/11WAV/QA_MapunitCheck_RTSD_Region_11_WAV_FY15_edited_gdb.txt", sep = "\t", header = TRUE)



# Summmarize export list
vars <- c("AREASYMBOL", "MUSYM", "ORIG_MUSYM")

edits <- list(
  R11ATL = cbind(mlrassoarea = "11ATL", read.dbf(paste0(ownCloud, "r11_atl_spatial.dbf"), as.is = TRUE)[vars]),
  # R11AUR <- cbind(mlrassoarea = "11AUR", read.dbf(paste0(ownCloud, "r11_aur_spatial.dbf"), as.is = TRUE)[vars]),
  R11CLI <- cbind(mlrassoarea = "11CLI", read.dbf(paste0(ownCloud, "r11_cli_spatial.dbf"), as.is = TRUE)[vars]),
  R11FIN = cbind(mlrassoarea = "11FIN", read.dbf(paste0(ownCloud, "r11_fin_spatial.dbf"), as.is = TRUE)[vars]),
  # R11GAL <- cbind(mlrassoarea = "11GAL", read.dbf(paste0(ownCloud, "r11_gal_spatial.dbf"), as.is = TRUE)[vars]),
  R11IND = cbind(mlrassoarea = "11IND", read.dbf(paste0(ownCloud, "r11_ind_spatial.dbf"), as.is = TRUE)[vars]),
  R11JUE <- cbind(mlrassoarea = "11JUE", read.dbf(paste0(ownCloud, "r11_jue_spatial_v2.dbf"), as.is = TRUE)[vars]),
  R11MAN = cbind(mlrassoarea = "11MAN", read.dbf(paste0(ownCloud, "r11_man_spatial.dbf"), as.is = TRUE)[vars]),
  R11SPR = cbind(mlrassoarea = "11SPR", read.dbf(paste0(ownCloud, "r11_spr_spatial.dbf"), as.is = TRUE)[vars]),
  R11UNI = cbind(mlrassoarea = "11UNI", read.dbf(paste0(ownCloud, "r11_uni_spatial.dbf"), as.is = TRUE)[vars]),
  R11WAV <- cbind(mlrassoarea = "11WAV", read.dbf(paste0(ownCloud, "r11_wav_spatial.dbf"), as.is = TRUE)[vars])
)
edits <- do.call("rbind", edits)
names(edits) <- tolower(names(edits))
edits$state <- substr(edits$areasymbol, 1, 2)

edits_R11 <- subset(edits, areasymbol %in% R11$areasymbol)

corr <- group_by(edits_R11, mlrassoarea, state, areasymbol) %>%
  summarize(n_musym = length(unique(musym)), 
            musym = paste(sort(unique(musym)), collapse = ", "), 
            old_musym = paste(sort(unique(orig_musym)), collapse = ", ")
            )
sso_dup <- group_by(corr, areasymbol) %>%
  summarize(mlrassoarea = paste(mlrassoarea, collapse = ", ")
            )
corr2 <- left_join(corr, sso_dup, by = "areasymbol") %>%
  select(state, mlrassoarea.x, mlrassoarea.y, areasymbol, n_musym, musym, old_musym) %>%
  arrange(areasymbol)

# corr2$dom <- ifelse(corr2$mlrassoarea.y == "11ATL, 11GAL", "11ATL", NA)

def calc(field1, field2):
  if field2 != None :
  return field2
else:
  return field1

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
