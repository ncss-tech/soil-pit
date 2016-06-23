library(plyr)
library(asdreader)
library(signal)


asd_folder <- "M:/projects/raca/All_429scans&data"
asd_files <- list.files(asd_folder, full.names = TRUE)

# vnir_files <- lapply(asd_files, function(x) get_spectra(x))
# vnir_files <- do.call(rbind, vnir_files)
# vnir_df <- as.data.frame(vnir_files)
# vnir_df$scan_path_name <- list.files(asd_folder)
# 
# save(vnir_df, file = "M:/projects/raca/vnir_df.Rdata")

load(file = "M:/projects/raca/vnir_df.Rdata")

test2 <- vnir_df[, - dim(vnir_df)[2]]
test3 <- princomp(test2)
vnir_scores <- as.data.frame(test3$scores[, 1:4])
vnir_scores$scan_path_name <- vnir_df$scan_path_name


pedons <- read.csv("M:/projects/raca/RaCA_lab_12-7/q_RaCA_analyze_central_12-7.csv")
names(pedons)[names(pedons) == "NaturalKEY"] <- "natural_key"
scan_legend <- read.csv("M:/projects/raca/New429 RaCA VNIR scan files by muglight.csv")

pedons$scan_path_name <- join(pedons, scan_legend, type = "left", by = "natural_key", match = "first")$scan_path_name
pedons2 <- join(pedons, vnir_scores, type = "left", by = "scan_path_name", match = "first")

cor(pedons2$Calc_SOC, pedons2[c("Comp.1", "Comp.2")], use = "complete.obs")

