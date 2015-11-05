library(aqp)
library(plyr)
library(dplyr)

options(stringsAsFactors = FALSE)

data <- read.csv("C:/Users/Stephen/Google Drive/projects/dsp/dsp_data.csv")
site <- read.csv("C:/Users/Stephen/Google Drive/projects/dsp/dsp_site.csv")
label <- read.csv("C:/Users/Stephen/Google Drive/projects/dsp/dsp_label.csv")

site <- site[!names(site) %in% c("pedontype", "pedonpurpose")]

names(data) <- tolower(gsub("\\.", "_", names(data)))
names(data)[which(names(data) == "userpedonid")] <- "user_pedon_id"
names(site) <- tolower(gsub("\\.", "_", names(site)))
names(site)[grep("std_", names(site))] <- c("y", "x")
names(site)[grep("pedon_lab_", names(site))] <- "lab_samp"

ddply(data, .(dsp_project), summarize, n_pedons = length(unique(user_pedon_id)), n_compare = length(unique(comparison)))
by(data, data["DSP.Project"], function(x) table(x$comparison))

data_site <- join(site, data, by = "user_pedon_id")
data_spc <- data_site
data_spc$piid <- paste0(data_spc$user_pedon_id, "_", data_spc$user_site_id)
depths(data_spc) <- piid ~ hor_top + hor_bottom
site(data_spc) <- ~ user_pedon_id + user_site_id + pedon_id + lab_samp + labpedonno + name + dsp_project + kssl_project + pr_name + comparison + cond + crop + agronfeat + plot + plot_id + plot_layout + region_strata + drainagecl + earthcovkind1 + earthcovkind2 + x + y + geographic_coord_source + current_taxon_name + soil + pedon_type + pedon_purpose + taxonkind + order + suborder + great_group + subgroup + family

# for some reason collectors and date won't promote to site
# why does pedon_lab_sample__ almost equal pedonlabno, 
# data_site[with(data_site, which(lab_samp != labpedonno)), ]

data_spc1 <- subsetProfiles(data_spc, s="x != 'NA'")
data_spc2 <- subsetProfiles(data_spc, s="x == 'NA'")

coordinates(data_spc1) <- ~ x + y

