library(aqp)
library(lattice)
library(RColorBrewer)
library(plyr)
library(foreign)
library(rgdal)
library(raster)
library(maps)
library(cluster)
library(splines)
library(lme4)

options(stringsAsFactors = FALSE)
source("C:/workspace/soil-pit/trunk/sandbox/stephen/dsp_utils.R")

# Read in data

setwd("C:/Users/Stephen/Google Drive/projects/dsp")
# setwd("M:/projects/dsp")
data <- read.csv("dsp_data.csv")
site <- read.csv("dsp_site.csv")
label <- read.csv("dsp_label.csv")
load("geodata.Rdata")


# Rename headings and fix things

names(data) <- tolower(gsub("\\.", "_", names(data)))
names(data) <- gsub("hor_", "", names(data))
names(data)[which(names(data) == "userpedonid")] <- "user_pedon_id"
names(data)[which(names(data) == "bd_recon_moist")] <- "fm_recon_moist"

names(site) <- tolower(gsub("\\.", "_", names(site)))
names(site)[grep("std_", names(site))] <- c("y", "x")
names(site)[grep("pedon_lab_", names(site))] <- "lab_samp"


data$mid <- with(data, round((bottom - top) / 2))
data$bd <- apply(data[, grep("bd_", names(data))], 1, mean, na.rm = T)
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
site(dsp) <- ~ user_pedon_id + user_site_id + pedon_id + lab_samp + name + dsp_project + kssl_project + pr_name + n_compare + comparison + nlcd + cotton + corn + wheat + landfire + gcomparison + mcomparison + cond + crop + agronfeat + plot + plot_id + plot_layout + mlra_id + mlrarsym + us_l3name + us_l4name + region_strata + rocktype1 + rocktype2 + drainagecl + earthcovkind1 + earthcovkind2 + x + y + geographic_coord_source + elev + slope  + ppt + tmean + ffp + current_taxon_name + soil + pedon_type + pedon_purpose + taxonkind + order + suborder + great_group + subgroup + family
# for some reason collectors, labpedonno and date won't promote to site 
# why does pedon_lab_sample__ almost equal pedonlabno, 
# data_site[with(data_site, which(lab_samp != labpedonno)), ]

# dsp1 <- subsetProfiles(dsp, s="x != 'NA'")
# coordinates(dsp1) <- ~ x + y
# dsp2 <- subsetProfiles(dsp, s="x == 'NA'")



# Aggregate properties by depth interval

## Split the projects and compute slabs

comparison_slab <- slab_p(dsp, "kssl_project", "comparison")
nlcd_slab <- slab_p(dsp, "kssl_project", "nlcd")
landfire_slab <- slab_p(dsp, "kssl_project", "landfire")
corn_slab <- slab_p(dsp, "kssl_project", "corn")
cotton_slab <- slab_p(dsp, "kssl_project", "cotton")
wheat_slab <- slab_p(dsp, "kssl_project", "wheat")

## Generate depth plots for each project

depth_plots(comparison_slab, "kssl_project", "comparison")
depth_plots(nlcd_slab, "kssl_project", "nlcd")
depth_plots(landfire_slab, "kssl_project", "landfire")
depth_plots(corn_slab, "kssl_project", "corn")
depth_plots(cotton_slab, "kssl_project", "cotton")
depth_plots(wheat_slab, "kssl_project", "wheat")

# Multivariate plots

dsp_slice <- slice(dsp, 5 ~ ., strict = FALSE)
x <- unique(dsp_slice$kssl_project)

for (i in seq(x)){
  var <- c("clay", "ph_h20", "bs_nh4oac", "c_gcm2", "mehlich_p", "bgluc")
  dsp_sub <- dsp_slice[which(dsp_slice$kssl_project == x[i])]
  sub <- as(dsp_sub, "data.frame")
  sub <- Filter(function(x) !all(is.na(x)), x = sub) # remove missing columns
  col_idx <- which(names(sub) %in% var)
  row_idx <- which(apply(sub[col_idx], 1, function(x) !all(is.na(x)))) # remove missing rows
  sub2 <- sub[row_idx, col_idx, drop = FALSE]
  
  
  if (ncol(sub2) <= nrow(sub2) + 1) {
  sub_mds <- metaMDS(daisy(sub2, metric = "gower", stand = TRUE))
  sub_mds_df <- data.frame(sub_mds$point, group = as.factor(sub[row_idx, "group"]), kssl_project = as.factor(sub[row_idx, "kssl_project"]))
  
  col <- brewer.pal(n = length(levels(sub_mds_df$group)), name = "Set1") 
  
  sub_plot <- xyplot(MDS1 ~ MDS2 | kssl_project, groups = group, data = sub_mds_df, 
                     aspect = 1,
                     auto.key = list(columns=length(levels(sub_mds_df$group))),
                     par.settings=list(superpose.symbol=list(pch=19, cex=2, alpha=0.5, col = col))
  )
  png(file = paste0(getwd(), "/figures/", x[i], "_mds.png"))
  print(sub_plot)
  dev.off()}
  }



# Analyze effects
histogram(~ log(c_gcm2), dsp_df)

c_glm <-  glm(c_gcm2 ~ ns(mid, 3) + clay + ppt + tmean + slope + comparison + plot, data = dsp_df, family = gaussian(link = "log"))
anova(c_glm, test = "F")
