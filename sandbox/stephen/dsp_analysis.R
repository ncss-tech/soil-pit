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
source("C:/workspace/soil-pit/trunk/sandbox/stephen/gfits.R")

# Read in data

# setwd("C:/Users/Stephen/Google Drive/projects/dsp")
setwd("M:/projects/dsp")
load("./data/dsp_prep.Rdata")
load("./data/dsp_geodata.Rdata")



# Inspect projects

map("state", main = "test")
map.axes()
title("Location of the Dynamic Soil Property Studies")
plot(site_sp, add = T)

by(dsp_df, dsp_df["kssl_project"], function(x) table(x$mcomparison))




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
  var <- c("clay", "ph_h20", "bs_nh4oac", "c_gcm2", "bd", "mehlich_p", "bgluc")
  dsp_sub <- dsp[which(dsp$kssl_project == x[i])]
  sub <- as(dsp_sub, "data.frame")
  sub <- Filter(function(x) !all(is.na(x)), x = sub) # remove missing columns
  col_idx <- which(names(sub) %in% var)
  row_idx <- which(apply(sub[col_idx], 1, function(x) !all(is.na(x)))) # remove missing rows
  sub2 <- sub[row_idx, col_idx, drop = FALSE]
  
  
  if (ncol(sub2) <= nrow(sub2) + 1) {
  sub_mds <- metaMDS(daisy(sub2, metric = "gower", stand = TRUE))
  sub_mds_df <- data.frame(sub_mds$point, group = as.factor(sub[row_idx, "comparison"]), kssl_project = as.factor(sub[row_idx, "kssl_project"]), hzname = sub[row_idx, "desg"])
  
  col <- brewer.pal(n = length(levels(sub_mds_df$group)), name = "Set1") 
  
  sub_plot <- xyplot(MDS1 ~ MDS2 | kssl_project, groups = group, data = sub_mds_df, 
                     aspect = 1,
                     auto.key = list(columns=length(levels(sub_mds_df$group))),
                     par.settings=list(superpose.symbol=list(pch=19, cex=2, alpha=0.5, col = col)))
  sub_plot <- sub_plot + layer(panel.abline(h=0, v=0, col='grey', lty=3)) + layer(panel.text(sub_mds_df$MDS2, sub_mds_df$MDS1, sub_mds_df$hzname, cex=0.85, font=2, pos=3))
                     
  png(file = paste0(getwd(), "/figures/", x[i], "_mds.png"), width = 9, height = 9, units = "in", res = 150)
  print(sub_plot)
  dev.off()}
  }



# Analyze effects
histogram(~ log(c_gcm2), dsp_df)

c_glm <-  glm(c_gcm2 ~ ns(depth, 3) + clay + ppt + tmean + slope + comparison + plot, data = dsp_df, family = quasipoisson())
test <- anova(c_glm, test = "F")
test_dev <- data.frame(dev = round(test$Deviance[-1] / test[1, "Resid. Dev"], 2), names = attributes(test)$row.names[-1], depth = "0 - 70 cm")


dsp_sub <- dsp_df[dsp_df$depth < 10, ]
c_glm2 <-  glm(c_gcm2 ~ ns(depth, 3) + clay + ppt + tmean + slope + comparison + plot, data = dsp_sub, family = quasipoisson())
test_sub <- anova(c_glm2, test = "F")
test_sub_dev <- data.frame(dev = round(test_sub$Deviance[-1] / test_sub[1, "Resid. Dev"], 2), names = attributes(test_sub)$row.names[-1], depth = "0 - 10 cm")

dsp_sub2 <- dsp_df[dsp_df$depth > 10, ]
c_glm3 <-  glm(c_gcm2 ~ ns(depth, 3) + clay + ppt + tmean + slope + comparison + plot, data = dsp_sub2, family = quasipoisson())
test_sub2 <- anova(c_glm3, test = "F")
test_sub_dev2 <- data.frame(dev = round(test_sub2$Deviance[-1] / test_sub2[1, "Resid. Dev"], 2), names = attributes(test_sub2)$row.names[-1], depth = "10 - 70 cm")

glm_table <- rbind(test_dev, test_sub_dev, test_sub_dev2)
glm_table$depth <- with(glm_table, factor(depth, levels = c("0 - 70 cm", "0 - 10 cm", "10 - 70 cm")))
glm_table$names <- with(glm_table, factor(names, levels = test_dev$names)

png(file = paste0(getwd(), "/figures/", "glm_plots.png"), width = 9, height = 5, units = "in", res = 150)
barchart(dev ~ names | depth, data = glm_table, scales = list(rot = c(45, 0)))
dev.off()
# kable(test)
# kable(test)


