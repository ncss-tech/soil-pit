library(aqp)
library(plyr)
library(maps)

options(stringsAsFactors = FALSE)

# Read in data
local <- "M:/"
data <- read.csv(paste0(local, "projects/dsp/dsp_data.csv"))
site <- read.csv(paste0(local, "projects/dsp/dsp_site.csv"))
label <- read.csv(paste0(local, "projects/dsp/dsp_label.csv"))


# Rename headings and fix things
names(data) <- tolower(gsub("\\.", "_", names(data)))
names(data)[which(names(data) == "userpedonid")] <- "user_pedon_id"
names(data)[which(names(data) == "bd_recon_moist")] <- "fm_recon_moist"
names(site) <- tolower(gsub("\\.", "_", names(site)))
names(site)[grep("std_", names(site))] <- c("y", "x")
names(site)[grep("pedon_lab_", names(site))] <- "lab_samp"

data$bd <- apply(data[, grep("bd_", names(data))], 1, mean, na.rm = T)
data$cf_labvol <- ifelse(is.na(data$cf_labvol), 0, data$cf_labvol)
data$c_gcm <- with(data, total_c * (100 - cf_labvol) * bd * (hor_bottom - hor_top))
site <- site[!names(site) %in% c("pedontype", "pedonpurpose")]


# Inspect projects
ddply(data, .(dsp_project), summarize, n_pedons = length(unique(user_pedon_id)), n_compare = length(unique(comparison)), n_plots = length(table(plot)))
by(data, data["dsp_project"], function(x) table(x$comparison))


# Build spc object

data_site <- join(data, site, by = "user_pedon_id", type = "left")
data_site$dsp_project <- ifelse(is.na(data_site$dsp_project), "missing", data_site$dsp_project)# Some of the sites don't match any pedons
data_spc <- data_site
data_spc$piid <- paste0(data_spc$user_pedon_id, "_", data_spc$user_site_id)
depths(data_spc) <- piid ~ hor_top + hor_bottom
site(data_spc) <- ~ user_pedon_id + user_site_id + pedon_id + lab_samp + name + dsp_project + kssl_project + pr_name + comparison + cond + crop + agronfeat + plot + plot_id + plot_layout + region_strata + drainagecl + earthcovkind1 + earthcovkind2 + x + y + geographic_coord_source + current_taxon_name + soil + pedon_type + pedon_purpose + taxonkind + order + suborder + great_group + subgroup + family

# for some reason collectors, labpedonno and date won't promote to site 
# why does pedon_lab_sample__ almost equal pedonlabno, 
# data_site[with(data_site, which(lab_samp != labpedonno)), ]

data_spc1 <- subsetProfiles(data_spc, s="x != 'NA'")
data_spc2 <- subsetProfiles(data_spc, s="x == 'NA'")

coordinates(data_spc1) <- ~ x + y
map("state")
plot(data_spc1@sp, add = T)

#test <- slice(data_spc, 1 ~ ., strict = F)
data_spc$test <- paste0(data_spc$dsp_project, "_", data_spc$comparison)

l <- list()
x <- unique(data_spc$test)
for (i in seq(x)){
  sub <- data_spc[data_spc$test == x[i]]
  l[[i]] <- slab(sub, ~ total_c, slab.structure = 5)
}

test <- slab(data_spc, test ~ ph_h20, slab.structure = 5)
xyplot(top ~ p.q50 | test, data=test, ylab='Depth',
       xlab='median bounded by 25th and 75th percentiles',
       lower=test$p.q25, upper=test$p.q75, ylim=c(250,-5),
       panel=panel.depth_function, 
       prepanel=prepanel.depth_function,
       cf=test$contributing_fraction, scales=list(x=list(alternating=1))
)