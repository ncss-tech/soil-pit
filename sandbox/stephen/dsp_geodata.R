options(stringsAsFactors = TRUE)

nlcd <- raster("M:/geodata/land_use_land_cover/nlcd_2011_landcover_2011_edition_2014_03_31.img")
landfire <- raster("M:/geodata/land_use_land_cover/us_130evt.tif")
cotton <- raster("M:/geodata/land_use_land_cover/crop_frequency_2008-2014/crop_frequency_cotton_2008-2014_nobackground.img")
corn <- raster("M:/geodata/land_use_land_cover/crop_frequency_2008-2014/crop_frequency_corn_2008-2014_no-background.img")
wheat <- raster("M:/geodata/land_use_land_cover/crop_frequency_2008-2014/crop_frequency_wheat_2008-2014_nobackground.img")
soybeans <- raster("M:/geodata/land_use_land_cover/crop_frequency_2008-2014/crop_frequency_soybeans_2008-2014_nobackground.img")
elev <- raster("M:/geodata/elevation/ned/ned30m_aea.img")
slope <- raster("M:/geodata/elevation/ned/ned30m_aea_slope.tif")
ppt <- raster("M:/geodata/climate/prism/PRISM_ppt_30yr_normal_800mM2_all_asc/PRISM_ppt_30yr_normal_800mM2_annual_asc.asc")
tmean <- raster("M:/geodata/climate/prism/PRISM_tmean_30yr_normal_800mM2_all_asc/PRISM_tmean_30yr_normal_800mM2_annual_asc.asc")
ffp <- raster("M:/geodata/climate/rmrs/ffp.txt"); proj4string(ffp) <- CRS("+init=epsg:4326")
eco <- readOGR(dsn = "M:/geodata/ecology", layer = "us_eco_l4_no_st", encoding = "ESRI Shapefile")
mlra <- readOGR(dsn = "M:/geodata/soils", layer = "mlra_a_mbr", encoding = "ESRI Shapefile")
geo <- readOGR(dsn = "M:/geodata/geology", layer = "geology_a_mbr", encoding = "ESRI Shapefile")

nlcd_txt <- read.csv("M:/geodata/land_use_land_cover/nlcd_2011_landcover_2011_edition_2014_03_31.txt")
landfire_txt <- read.csv("M:/geodata/land_use_land_cover/us_130evt.txt")

idx <- which(complete.cases(site[c("x", "y")]))
site_sp <- site[idx, ]
coordinates(site_sp) <- ~ x + y
proj4string(site_sp) <- CRS("+init=epsg:4326")
# writeOGR(site_sp, dsn = "M:/projects/dsp", layer = "site_points", driver = "ESRI Shapefile", overwrite_layer = TRUE)

map("state")
plot(site_sp, add = T)

geodata <- data.frame(
  idx = which(idx),
  nlcd = extract(nlcd, site_sp), 
  cotton = ordered(extract(cotton, site_sp)), 
  corn = ordered(extract(corn, site_sp)), 
  wheat = ordered(extract(wheat, site_sp)), 
  soybeans = ordered(extract(soybeans, site_sp)), 
  landfire = extract(landfire, site_sp), 
  elev = extract(elev, site_sp), 
  slope = extract(slope, site_sp), 
  tmean = extract(tmean, site_sp), 
  ppt = extract(ppt, site_sp), 
  ffp = extract(ffp, site_sp)
)
geodata <- cbind(geodata,
                 over(spTransform(site_sp, proj4string(eco)), eco)[c("US_L3NAME", "US_L4NAME")], 
                 over(spTransform(site_sp, proj4string(mlra)), mlra)[c("MLRA_ID", "MLRARSYM")],
                 over(spTransform(site_sp, proj4string(geo)), geo[c("ROCKTYPE1", "ROCKTYPE2")])
)
geodata$nlcd <- nlcd_txt[match(geodata$nlcd, nlcd_txt$Value), "Land_Cover"]
geodata$landfire <- landfire_txt[match(geodata$landfire, landfire_txt$VALUE), "SAF_SRM"]

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
geodata$gcomparison <- unlist(mapply(temp, geodata$nlcd, geodata$cotton, geodata$corn, geodata$wheat, geodata$soybeans, geodata$landfire))
save(geodata, file = "geodata.Rdata")

