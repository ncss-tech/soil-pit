options(stringsAsFactors = FALSE)

library(ggplot2)
library(soilDB)
library(sp)
library(sf)
library(raster)


# NASIS mapunits
mapunit <- get_mapunit_from_LIMS("SPATIAL - MLRA 111A - Indianapolis Urban Update - Phase 1")
components <- get_component_from_LIMS("SPATIAL - MLRA 111A - Indianapolis Urban Update - Phase 1")
comp_sub <- subset(components, grepl("Urban", compname))

vars <- c("compname", "comppct_r", "dmuiid")
mapunit <- merge(mapunit, comp_sub[, vars], by = "dmuiid", all.x = TRUE)


# New polygons
mupolygon <- read_sf(dsn = "E:/geodata/project_data/11IND/Urban/Urban_20171208.gdb", layer = "MUPOLYGON_11INDY_FY18_URBAN_CLIP")
st_crs(mupolygon) <- "+init=epsg:5070"
names(mupolygon) <- tolower(names(mupolygon))
mu_sub <- mupolygon[mupolygon$musym %in% mapunit$musym, ]

n <- 10
mu_sub <- within(mu_sub, {
  idx    = as.character(0:(nrow(mu_sub) - 1))
  acres  = shape_area * 0.000247
  samp_n = ifelse(acres < n, 1, round(acres / n))
})

# Generate samples
mu_samp <- by(mu_sub, mu_sub$idx, function(x) {
  mu_sp = as(x, "Spatial")
  mu_samp = spsample(mu_sp, x$samp_n, type = "random", iter = 10)
  if ("y" %in% names(as.data.frame(mu_samp))) {
    test = data.frame(as.data.frame(mu_samp), 
                      idx = x$idx[1], 
                      musym = x$musym[1],
                      areasymbol = x$areasymbol[1],
                      mukey = x$mukey[1],
                      area = x$shape_area[1]
    )
    coordinates(test) = ~ x + y
    proj4string(test) = "+init=epsg:5070"
    return(test)
  }
})
idx <- which(unlist(lapply(mu_samp, function(x) is.null(x))))
mu_samp2 <- mu_samp[-idx]
mu_samp2 <- do.call("rbind", mu_samp2)
# save(mu_samp2, file = "C:/workspace2/mu_samp2.RData")
load(file = "C:/workspace2/mu_samp2.RData")

# USGS impervious layer
nlcd_imp <- raster("E:/geodata/project_data/11IND/Urban/Land_Cover_Impervious_Surfaces_2011/IMPERVIOUS_SURFACE_2011_USGS_IN.tif")
nlcd <- raster("E:/geodata/project_data/11IND/nlcd30m_11IND_lulc2011.tif")


# Extract data
data1 <- extract(nlcd_imp, mu_samp2, sp = TRUE)
data2 <- extract(nlcd,     mu_samp2, sp = TRUE)


# Summarize samples by musym
data3 <- as.data.frame(data1)
data4 <- as.data.frame(data2)
data4 <- data4[c("idx", "nlcd30m_11IND_lulc2011")]
data4$idx.y <- data4$idx
data <- cbind(data3, data4)
with(data, any(idx != idx.y))
names(data)[c(5, 9)] <- c("urbanland", "nlcd")
data <- mutate(data, 
               nlcd = as.character(nlcd),
               idx  = as.character(idx)
               )

poly_sum <- ddply(data, .(idx, musym, nlcd), summarize, 
                  avg = round(mean(urbanland))
                  )

# vars <- c("idx", "musym", "nlcd")
# poly_sum <- {
#   split(data, data[vars], drop = TRUE) ->.;
#   lapply(., function(x) {data.frame(
#     x[1, vars],
#     avg = round(mean(urbanland))
#   )}) ->.;
#   do.call("rbind", .)
# }
poly_sum2 <- merge(mu_sub, poly_sum, by = "idx", all.x = TRUE)
write_sf(poly_sum2, dsn = "C:/workspace2/r11_indy_urban_percent_by_polygon.shp", layer = "USGS_avg", delete_dsn=TRUE)


poly_sum2 <- within(poly_sum2, {
  nlcd2 = ifelse(nlcd  %in% 24,    "industrial", nlcd)
  nlcd2 = ifelse(nlcd2 %in% 22:23, "residential", nlcd2)
  nlcd2 = ifelse(! nlcd2 %in% c("industrial", "residential"), "non-urban", nlcd2)
})

mu_sum <- ddply(poly_sum2, .(musym.x, nlcd2), summarize,
                min = round(quantile(avg, 0.05,na.rm = TRUE)),
                avg = round(weighted.mean(avg, w = acres, na.rm = TRUE)),
                max = round(quantile(avg, 0.95, na.rm = TRUE))
                )

# vars <- c("musym.x", "nlcd")
# mu_sum <- {
#   split(poly_sum2, poly_sum2[vars], drop = TRUE) ->.;
#   lapply(., function(x) { data.frame(
#     x[1, vars],
#     min = round(min(x$avg, na.rm = TRUE)),
#     avg = round(mean(x$avg, na.rm = TRUE)),
#     max = round(max(x$avg, na.rm = TRUE))
#   )}) ->.;
#   do.call("rbind", .)
# }


mu_sum <- subset(mu_sum, !is.na(avg) & avg > 5)
mu_sum$musym.x <- factor(mu_sum$musym.x)
mu_sum$musym.x <- reorder(mu_sum$musym.x, mu_sum$avg, median)
mu_sum$nlcd2 <- factor(mu_sum$nlcd2, levels = c("non-urban", "residential", "industrial"))

ggplot(mu_sum, aes(x = musym.x, y = avg)) +
  geom_point() +
  geom_errorbar(aes(ymin = min, ymax = max)) + 
  facet_grid(~ nlcd2) +
  ylab("Average USGS imperviousness") + xlab("MUSYM") +
  ggtitle("MLRA 111A - Indianapolis Urban update \n USGS imperviousness vs Urbanland comppct_r") +
  coord_flip()
