library(aqp)
library(plyr)
library(maps)

options(stringsAsFactors = FALSE)

# Read in data

# setwd("C:/Users/Stephen/Google Drive/projects/dsp")
setwd("M:/projects/dsp")
data <- read.csv("./data/dsp_data.csv")
site <- read.csv("./data/dsp_site.csv")
label <- read.csv("./data/dsp_label.csv")


# Rename headings and fix things

names(data) <- tolower(gsub("\\.", "_", names(data)))
names(data) <- gsub("hor_", "", names(data))
names(data)[which(names(data) == "userpedonid")] <- "user_pedon_id"
names(data)[which(names(data) == "bd_recon_moist")] <- "fm_recon_moist"

names(site) <- tolower(gsub("\\.", "_", names(site)))
names(site)[grep("std_", names(site))] <- c("y", "x")
names(site)[grep("pedon_lab_", names(site))] <- "lab_samp"


data$depth <- with(data, round((bottom - top) / 2))
data$bd <- apply(data[, grep("bd_", names(data))], 1, mean, na.rm = T)
data$bd <- ifelse(is.na(data$bd), 1.3, data$bd)
data$cf_labvol <- ifelse(is.na(data$cf_labvol), 0, data$cf_labvol)
data$total_c <- with(data, ifelse(is.na(total_c), tot_c, total_c)) # Could possibly create a label column to differentiate
data$c_gcm2 <- with(data, total_c * (100 - cf_labvol) * bd * (bottom - top))
data$total_n <- with(data, ifelse(is.na(total_n), tot_n, total_n)) # Could possibly create a label column to differentiate
data$n_gcm2 <- with(data, total_n * (100 - cf_labvol) * bd * (bottom - top))
data <- data[!names(data) %in% c("tot_c")]

site <- site[!names(site) %in% c("pedontype", "pedonpurpose")]
site$idx <- row.names(site)


# Load geodata

site <- join(site, geodata, by = "idx", type = "left")
names(site) <- tolower(names(site))
site$corn <- ordered(site$corn)
site$cotton <- ordered(site$cotton)
site$wheat <- ordered(site$wheat)
site$soybeans <- ordered(site$soybeans)


# Inspect projects

dsp_sum <- ddply(data, .(kssl_project), summarize, n_pedons = length(unique(user_pedon_id)), n_compare = length(unique(comparison)), n_plots = length(table(plot)))
# kssl_project != dsp_project, WTF

dsp_df <- join(data, dsp_sum[c("kssl_project", "n_compare")], by = "kssl_project", type = "left")

dsp_df <- join(dsp_df, site, by = "user_pedon_id", type = "left")
dsp_df$kssl_project <- with(dsp_df, ifelse(is.na(kssl_project), "missing", kssl_project)) # Some of the sites don't match any pedons
dsp_df$piid <- paste0(dsp_df$user_pedon_id, "_", dsp_df$user_site_id)

dsp_df$mcomparison <- with(dsp_df, ifelse(n_compare == 1 & !is.na(gcomparison), gcomparison, comparison))

# by(dsp_df, dsp_df["kssl_project"], function(x) table(x$mcomparison))



# Build dsp object

dsp <- dsp_df
depths(dsp) <- piid ~ top + bottom
site(dsp) <- ~ user_pedon_id + user_site_id + pedon_id + lab_samp + name + dsp_project + kssl_project + pr_name + n_compare + comparison + nlcd + cotton + corn + wheat + landfire + gcomparison + mcomparison + cond + crop + agronfeat + plot + plot_id + plot_layout + mlra_id + mlrarsym + us_l3name + us_l4name + region_strata + rocktype1 + rocktype2 + drainagecl + earthcovkind1 + earthcovkind2 + x + y + geographic_coord_source + elev + slope  + precip + temp + ffp + current_taxon_name + soil + pedon_type + pedon_purpose + taxonkind + order + suborder + great_group + subgroup + family
# for some reason collectors, labpedonno and date won't promote to site 
# why does pedon_lab_sample__ almost equal pedonlabno, 
# data_site[with(data_site, which(lab_samp != labpedonno)), ]

# dsp1 <- subsetProfiles(dsp, s="x != 'NA'")
# coordinates(dsp1) <- ~ x + y
# dsp2 <- subsetProfiles(dsp, s="x == 'NA'")

save(data, site, dsp_df, dsp, file = "./data/dsp_prep.Rdata")
