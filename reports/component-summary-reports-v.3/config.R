## this is where you define input data sources


## determine subsetting rule:
## pattern: matching based on the component name specified in report-rules.R
## pedon.id.list: matching based on list of pedon IDs specified in report-rules.R
subset.rule <- 'pattern'
# subset.rule <- 'pedon.id.list'

## report details:
# probabilities for low-rv-high calculations
p.low.rv.high <- c(0.05, 0.5, 0.95)

# quantile type
q.type <- 7

# ML profile smoothing
ml.profile.smoothing <- 0.65

## GIS data details
# map unit linework 
mu.dsn <- 'L:/CA630/FG_CA630_OFFICIAL.gdb'
mu.layer <- 'ca630_a'

# define raster variable names and data sources, store in a list
# prefix variable names with gis_
# these should all share the same CRS
r <- list(
  gis_ppt=raster('L:/Geodata/climate/raster/ppt_mm_1981_2010.tif'),
  gis_tavg=raster('L:/Geodata/climate/raster/tavg_1981_2010.tif'),
  gis_ffd=raster('L:/Geodata/climate/raster/ffd_mean_800m.tif'),
  gis_gdd=raster('L:/Geodata/climate/raster/gdd_mean_800m.tif'),
  gis_elev=raster('L:/Geodata/DEM_derived/elevation_30m.tif'),
  gis_solar=raster('L:/Geodata/DEM_derived/beam_rad_sum_mj_30m.tif'),
  gis_mast=raster('S:/NRCS/Archive_Dylan_Beaudette/CA630-models/hobo_soil_temperature/spatial_data/mast-model.tif'),
  gis_slope=raster('L:/Geodata/elevation/10_meter/ca630_slope'),
  gis_geomorphons=raster('L:/Geodata/DEM_derived/forms10.tif')
)

## map unit data: load the official version
mu <-  readOGR(dsn=mu.dsn, layer=mu.layer, encoding='encoding', stringsAsFactors=FALSE)

# convert: character -> integer -> character
# drops all bogus or undefined map units
mu$MUSYM <- as.character(as.integer(as.character(mu$MUSYM)))

## local tweaks:
# these all have the same CRS, manuall fix the MAST layer
projection(r[['gis_mast']]) <- projection(r[['gis_elev']])


