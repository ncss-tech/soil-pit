library(aqp)
library(lattice)
library(RColorBrewer)
library(plyr)
library(foreign)
library(maps)
library(rgdal)
library(raster)
library(cluster)

options(stringsAsFactors = FALSE)


# Read in data

setwd("M:/projects/dsp")
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


# Load geodata

nlcd <- raster("M:/geodata/land_use_land_cover/nlcd_2011_landcover_2011_edition_2014_03_31.img")
cotton <- raster("M:/geodata/land_use_land_cover/crop_frequency_2008-2014/crop_frequency_cotton_2008-2014_nobackground.img")
corn <- raster("M:/geodata/land_use_land_cover/crop_frequency_2008-2014/crop_frequency_corn_2008-2014_no-background.img")
wheat <- raster("M:/geodata/land_use_land_cover/crop_frequency_2008-2014/crop_frequency_wheat_2008-2014_nobackground.img")
soybeans <- raster("M:/geodata/land_use_land_cover/crop_frequency_2008-2014/crop_frequency_soybeans_2008-2014_nobackground.img")
landfire <- raster("M:/geodata/land_use_land_cover/us_130evt.tif")

nlcd_txt <- read.csv("M:/geodata/land_use_land_cover/nlcd_2011_landcover_2011_edition_2014_03_31.txt")
landfire_txt <- read.csv("M:/geodata/land_use_land_cover/us_130evt.txt")

idx <- complete.cases(site[c("x", "y")])
site_sp <- site[idx, ]
coordinates(site_sp) <- ~ x + y
proj4string(site_sp) <- CRS("+init=epsg:4326")
writeOGR(site_sp, dsn = "M:/projects/dsp", layer = "site_points", driver = "ESRI Shapefile", overwrite_layer = TRUE)

lcover <- data.frame(nlcd = extract(nlcd, site_sp), cotton = extract(cotton, site_sp), corn = extract(corn, site_sp), wheat = extract(wheat, site_sp), soybeans = extract(soybeans, site_sp), landfire = extract(landfire, site_sp))
lcover$nlcd <- nlcd_txt[match(lcover$nlcd, nlcd_txt$Value), "Land_Cover"]
lcover$landfire <- landfire_txt[match(lcover$landfire, landfire_txt$VALUE), "SAF_SRM"]

temp <- function(x1, x2, x3, x4, x5, x6){
  nonag <- x1 != "Cultivated Crops" & x6 != "LF 80: Agriculture" & x6 != "LF 20: Developed"
  ag <- !nonag
  if(is.na(x1)) {res = NA}
  if(nonag) {res = x6}
  if(ag) {res = as.character(x2)}
  if(ag & x2 == 0) {res = as.character(x3)}
  if(ag & x2 == 0 & x3 == 0) {res = as.character(x4)}
  if(ag & x2 == 0 & x3 == 0 & x4 == 0) {res = as.character(x5)}
  return(res)
}
lcover$gcomparison <- unlist(mapply(temp, lcover$nlcd, lcover$cotton, lcover$corn, lcover$wheat, lcover$soybeans, lcover$landfire))

site[idx, "nlcd"] <- lcover$nlcd 
site[idx, "cotton"] <- lcover$cotton
site[idx, "corn"] <- lcover$corn 
site[idx, "wheat"] <- lcover$wheat 
site[idx, "landfire"] <- lcover$landfire 
site[idx, "gcomparison"] <- lcover$gcomparison


# Inspect projects

dsp_sum <- ddply(data, .(kssl_project), summarize, n_pedons = length(unique(user_pedon_id)), n_compare = length(unique(comparison)), n_plots = length(table(plot)))
# kssl_project != dsp_project, WTF

dsp <- join(data, dsp_sum[c("kssl_project", "n_compare")], by = "kssl_project", type = "left")

dsp <- join(dsp, site, by = "user_pedon_id", type = "left")
dsp$kssl_project <- with(dsp, ifelse(is.na(kssl_project), "missing", kssl_project)) # Some of the sites don't match any pedons
dsp$piid <- paste0(dsp$user_pedon_id, "_", dsp$user_site_id)

dsp$mcomparison <- with(dsp, ifelse(n_compare == 1 & !is.na(gcomparison), gcomparison, comparison))

by(dsp, dsp["kssl_project"], function(x) table(x$mcomparison))


# Build dsp object

depths(dsp) <- piid ~ hor_top + hor_bottom
site(dsp) <- ~ user_pedon_id + user_site_id + pedon_id + lab_samp + name + dsp_project + kssl_project + pr_name + n_compare + comparison + nlcd + cotton + corn + wheat + landfire + gcomparison + mcomparison + cond + crop + agronfeat + plot + plot_id + plot_layout + region_strata + drainagecl + earthcovkind1 + earthcovkind2 + x + y + geographic_coord_source + current_taxon_name + soil + pedon_type + pedon_purpose + taxonkind + order + suborder + great_group + subgroup + family
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
comp <- "nlcd"
l <- list()
x <- unique(dsp$kssl_project)

for (i in seq(x)){
  idx <- which(dsp$kssl_project == x[i] & !is.na(site(dsp)[comp]))
  if(length(idx) > 0) {
  sub <- dsp[idx]
  group <- site(sub)[comp]
  names(group) <- "group"
  slot(sub, "site") <- cbind(site(sub), group) 
  l[[i]] <- slab(sub, group ~ clay + ph_h20 + bs_nh4oac + c_gcm2 + mehlich_p + bgluc, slab.structure = 5)
  l[[i]]$kssl_project <- x[i]
  }
}
names(l) <- x
dsp_slabs <- do.call(rbind, l)


# Generate depth plots for each project
for (i in seq(x)){
  idx <- dsp_slabs$kssl_project == x[i]
  if(sum(idx) > 0) {
  sub <- subset(dsp_slabs, idx) # subset by kssl_project
  sub <- sub[which(apply(sub, 1, function(x) !any(is.na(x)))), ] # remove missing variables
  
  col <- brewer.pal(n = length(unique(sub$variable)), name = "Set1")
  
  sub_plot <- xyplot(top ~ p.q50 | variable + kssl_project, groups = as.factor(group), data= sub,
                     ylab='Depth', xlab='median bounded by 25th and 75th percentiles',
                     lower = sub$p.q25, upper = sub$p.q75, ylim = c(max(sub$bottom), 0),
                     panel = panel.depth_function, alpha = 0.25, sync.colors = TRUE,
                     prepanel = prepanel.depth_function,
                     par.settings = list(superpose.line = list(lwd = 2, col = col)),
                     cf = sub$contributing_fraction, scales = list(relation = "free"),
                     auto.key = list(columns = 2, lines = TRUE, points = FALSE)
                     )
  png(file = paste0(getwd(), "/figures/", x[i], "_slab_",  comp,".png"))
  print(sub_plot)
  dev.off()
  }
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



