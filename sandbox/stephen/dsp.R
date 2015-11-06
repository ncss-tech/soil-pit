library(aqp)
library(lattice)
library(RColorBrewer)
library(plyr)
library(maps)
library(cluster)

options(stringsAsFactors = FALSE)


# Read in data

local <- "M:/"
# local <- "C:/Users/Stephen/Google Drive/"
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
data$total_c <- with(data, ifelse(is.na(total_c), tot_c, total_c)) # Could possibly create a label column to differentiate
data$c_gcm2 <- with(data, total_c * (100 - cf_labvol) * bd * (hor_bottom - hor_top))
data$total_n <- with(data, ifelse(is.na(total_n), tot_n, total_n)) # Could possibly create a label column to differentiate
data$n_gcm2 <- with(data, total_n * (100 - cf_labvol) * bd * (hor_bottom - hor_top))
data <- data[!names(data) %in% c("tot_c")]
site <- site[!names(site) %in% c("pedontype", "pedonpurpose")]


# Inspect projects

ddply(data, .(dsp_project), summarize, n_pedons = length(unique(user_pedon_id)), n_compare = length(unique(comparison)), n_plots = length(table(plot)))
by(data, data["dsp_project"], function(x) table(x$comparison))


# Build dsp object

dsp <- join(data, site, by = "user_pedon_id", type = "left")
dsp$dsp_project <- with(dsp, ifelse(is.na(dsp_project), "missing", dsp_project)) # Some of the sites don't match any pedons
dsp$piid <- paste0(dsp$user_pedon_id, "_", dsp$user_site_id)

depths(dsp) <- piid ~ hor_top + hor_bottom
site(dsp) <- ~ user_pedon_id + user_site_id + pedon_id + lab_samp + name + dsp_project + kssl_project + pr_name + comparison + cond + crop + agronfeat + plot + plot_id + plot_layout + region_strata + drainagecl + earthcovkind1 + earthcovkind2 + x + y + geographic_coord_source + current_taxon_name + soil + pedon_type + pedon_purpose + taxonkind + order + suborder + great_group + subgroup + family
# for some reason collectors, labpedonno and date won't promote to site 
# why does pedon_lab_sample__ almost equal pedonlabno, 
# data_site[with(data_site, which(lab_samp != labpedonno)), ]

dsp1 <- subsetProfiles(dsp, s="x != 'NA'")
dsp2 <- subsetProfiles(dsp, s="x == 'NA'")

coordinates(dsp1) <- ~ x + y
map("state")
plot(dsp1@sp, add = T)



## Aggregate properties by depth interval

# Split the projects and compute slabs
l <- list()
x <- unique(dsp$kssl_project)

for (i in seq(x)){
  sub <- dsp[which(dsp$kssl_project == x[i])]
  l[[i]] <- slab(sub, as.factor(comparison) ~ clay + ph_h20 + bs_nh4oac + c_gcm2 + mehlich_p + bgluc, slab.structure = 5)
  l[[i]]$kssl_project <- x[i]
}
names(l) <- x
dsp_slabs <- do.call(rbind, l)


# Generate depth plots for each project
for (i in seq(x)){
  sub <- subset(dsp_slabs, kssl_project == x[i]) # subset by kssl_project
  sub <- sub[which(apply(sub, 1, function(x) !any(is.na(x)))), ] # remove missing variables
  
  col <- brewer.pal(n = length(unique(sub$variable)), name = "Set1")
  
  sub_plot <- xyplot(top ~ p.q50 | variable + kssl_project, groups = as.factor(comparison), data= sub,
                     ylab='Depth', xlab='median bounded by 25th and 75th percentiles',
                     lower = sub$p.q25, upper = sub$p.q75, ylim = c(max(sub$bottom), 0),
                     panel = panel.depth_function, alpha = 0.25, sync.colors = TRUE,
                     prepanel = prepanel.depth_function,
                     par.settings = list(superpose.line = list(lwd = 2, col = col)),
                     cf = sub$contributing_fraction, scales = list(relation = "free"),
                     auto.key = list(columns = 2, lines = TRUE, points = FALSE)
                     )
  png(file = paste0(getwd(), "/figures/", x[i], "_slab.png"))
  print(sub_plot)
  dev.off()
  }


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
  sub_mds_df <- data.frame(sub_mds$point, comparison = as.factor(sub[row_idx, "comparison"]), kssl_project = as.factor(sub[row_idx, "kssl_project"]))
  
  col <- brewer.pal(n = length(levels(sub_mds_df$comparison)), name = "Set1") 
  
  sub_plot <- xyplot(MDS1 ~ MDS2 | kssl_project, groups = comparison, data = sub_mds_df, 
                     aspect = 1,
                     auto.key = list(columns=length(levels(sub_mds_df$comparison))),
                     par.settings=list(superpose.symbol=list(pch=19, cex=2, alpha=0.5, col = col))
  )
  png(file = paste0(getwd(), "/figures/", x[i], "_mds.png"))
  print(sub_plot)
  dev.off()}
  }



