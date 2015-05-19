

#Create a user entry prompt
series <- function()
{
  as.character(readline("Enter the Series to export:>>> "))
}

input_pedons <- fetchNASIS()

# keep only those pedons with real coordinates
good.idx <- which(!is.na(input_pedons$x))
input_pedons <- input_pedons[good.idx, ]

# init coordinates
coordinates(input_pedons) <- ~ x + y
proj4string(input_pedons) <- '+proj=latlong +datum=NAD83'

# extract only site data
pedon_points <- as(input_pedons, 'SpatialPointsDataFrame')

# project to UTM z15 NAD83
pedon_points <- spTransform(pedon_points, CRS('+proj=utm +zone=15 +datum=NAD83'))

# subsetting the columns useful for analysis
pedon_points <- pedon_points[, c("pedon_id","taxonname", "hillslope_pos", "elev_field", "slope_field", "aspect_field", "plantassocnm", "bedrckdepth", "bedrock_kind")]

# write to SHP
writeOGR(pedon_points, dsn='.', layer='NASIS-pedons', driver='ESRI Shapefile', overwrite_layer=TRUE)

source("rmenu.R")