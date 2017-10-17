options(stringsAsFactors = FALSE)

library(ggplot2)
library(raster)
library(sp)
library(sf)
library(soilDB)

# NASIS mapunits
mapunit <- get_component_correlation_data_from_NASIS_db()
components <- get_component_data_from_NASIS_db()
comp_sub <- subset(components, grepl("Urban", compname))

vars <- c("compname", "comppct_r", "dmuiid")
mapunit <- merge(mapunit, comp_sub[, vars], by = "dmuiid", all.x = TRUE)


# New polygons
mupolygon <- read_sf(dsn = "M:/geodata/project_data/FY2017/edited_databases/OH025_Urban_OH/MLRA_OH_Urban.gdb", layer = "soilmu_a_OH025_Urban")
st_crs(mupolygon) <- "+init=epsg:5070"
names(mupolygon) <- tolower(names(mupolygon))
mu_sub <- mupolygon[mupolygon$musym %in% mapunit$musym, ]

mu_sub <- within(mu_sub, {
  idx    = 0:(nrow(mu_sub) - 1)
  acres  = shape_area * 0.000247
  samp_n = ifelse(acres < 1, 1, round(acres / 1))
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

# USGS impervious layer
nlcd_imp <- raster("M:/geodata/land_use_land_cover/nlcd_2011_impervious_2011_edition_2014_10_10/nlcd_2011_impervious_2011_edition_2014_10_10.img")

# Extract data
data <- extract(nlcd_imp, mu_samp2, sp = TRUE)

# Summarize samples by musym
data2 <- as.data.frame(data)
data <- merge(data2, mapunit, by = c("musym", "areasymbol"), all.x = TRUE)

vars <- c("idx", "musym", "comppct_r")
poly_sum <- by(data, data$idx, function(x) { data.frame(
  x[1, vars],
  avg = round(mean(x$nlcd))
  )})
poly_sum <- do.call("rbind", poly_sum)

poly_sum2 <- merge(mu_sub, poly_sum, by = "idx", all.x = TRUE)
write_sf(poly_sum2, dsn = "C:/workspace2/r6_cincinatti_urban_percent_by_polygon.shp", layer = "USGS_avg")

mu_sum <- by(poly_sum2, poly_sum2$musym.x, function(x) {
  data.frame(x[1, c("musym.x", "comppct_r")],
             min = round(min(x$avg)),
             avg = round(weighted.mean(x$avg, w = x$acres)),
             max = round(max(x$avg))
             )
  })
mu_sum <- do.call("rbind", mu_sum)
mu_sum <- mu_sum[order(mu_sum$avg), ]

mu_sum1 <- cbind(mu_sum[, -2], dataset = "USGS")
mu_sum2 <- rbind(mu_sum1, with(mu_sum, data.frame(musym.x, geometry, avg = comppct_r, min = NA, max = NA, dataset = "NASIS")))

ggplot(mu_sum2, aes(x = musym.x, y = avg, col = dataset)) +
  geom_point() +
  geom_errorbar(aes(ymin = min, ymax = max)) + 
  ylab("Average USGS imperviousness") + xlab("MUSYM") +
  ggtitle("MLRA 121 - Clermont County, Ohio Urban update \n USGS imperviousness vs Urbanland comppct_r") +
  coord_flip()
