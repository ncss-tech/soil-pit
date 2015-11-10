slab_p <- function(spc, project, group) {
  l <- list()
  x <- unique(site(spc)[, project])
  
  for (i in seq(x)){
    idx <- which(site(spc)[, project] == x[i] & !is.na(site(spc)[group]))
    if(length(idx) > 0) {
      sub <- spc[idx]
      sub_group <- site(sub)[group]
      names(sub_group) <- "group"
      slot(sub, "site") <- cbind(site(sub), sub_group)
      l[[i]] <- slab(sub, group ~ clay + ph_h20 + bs_nh4oac + c_gcm2 + mehlich_p + bgluc, slab.structure = 5)
      l[[i]][project] <- x[i]
    }
  }
  names(l) <- x
  spc_slabs <- do.call(rbind, l)
}

depth_plots <- function(slabs, project, group){
  x <- unique(slabs[, project])
  for (i in seq(x)){
    idx <- slabs[project] == x[i]
    if(sum(idx) > 0) {
      sub <- subset(slabs, idx) # subset by kssl_project
      sub <- sub[which(apply(sub, 1, function(x) !any(is.na(x)))), ] # remove missing variables
      sub_project <-sub[project]
      names(sub_project) <- "project"
      sub <- cbind(sub, sub_project)
      
      col <- brewer.pal(n = length(unique(sub$variable)), name = "Set1")
      
      sub_plot <- xyplot(top ~ p.q50 | variable + project, groups = as.factor(group), data= sub,
                         ylab='Depth', xlab='median bounded by 25th and 75th percentiles',
                         lower = sub$p.q25, upper = sub$p.q75, ylim = c(max(sub$bottom), 0),
                         panel = panel.depth_function, alpha = 0.25, sync.colors = TRUE,
                         prepanel = prepanel.depth_function,
                         par.settings = list(superpose.line = list(lwd = 2, col = col)),
                         cf = sub$contributing_fraction, scales = list(relation = "free"),
                         auto.key = list(columns = 2, lines = TRUE, points = FALSE)
      )
      png(file = paste0(getwd(), "/figures/", x[i], "_slab_",  group,".png"), width = 12, height = 9, units = "in", res = 72)
      print(sub_plot)
      dev.off()
    }
  }
}
