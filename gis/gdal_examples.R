gdal_setInstallation(search_path="C:/ProgramData/QGIS/QGISDufour/bin", rescan=T)


ogr2ogr -f "ESRI Shapefile" test.shp test.gdb ca794_a -nln ca794_a

library(raster)
library(rgdal)

ind <- readOGR(dsn="H:/Region_11_Soils_SSURGO_07302014/MLRA_11-IND_FY14.gdb", layer="SAPOLYGON", encoding="OpenFileGDB")

ogr2ogr(
  src_datasource_name="E:/geodata/project_data/11ATL/11ATL.gdb",
  dst_datasource_name="E:/geodata/project_data/11ATL/cache/11ATL.shp",
  layer="MUPOLYGON",
  where="MUSYM=='362'",
  verbose=TRUE)

test

ogr2ogr -where "MUSYM==362" "E:/geodata/project_data/11ATL/cache/11ATL.shp" "E:/geodata/project_data/11ATL/11ATL.gdb" "MUPOLYGON"

# Clip polygon using extent
ogr2ogr(
  src_datasource_name="M:/geodata/soils/MLRA_Soil_Survey_Areas_May2014.shp",
  dst_datasource_name="M:/geodata/project_data/11REGION/MLRA_Soil_Survey_Areas_May2014_r11.shp",
  layer="MLRA_Soil_Survey_Areas_May2014",
  t_srs=CRS("+init=epsg:5070"),
  where="NEW_MO IN ('11')",
  verbose=TRUE,
  overwrite=T, 
  progress=T)

bb <- bbox(readOGR(dsn="M:/geodata/project_data/11REGION/MLRA_Soil_Survey_Areas_May2014_r11.shp", layer="MLRA_Soil_Survey_Areas_May2014_r11"))

system(paste('"C:/Program Files/QGIS Dufour/bin/ogr2ogr.exe"', '-overwrite -t_srs EPSG:5070 -clipdst -49675.0230520471 1329474.02694086 1175426.50953029 2591124.11923647 M:/geodata/project_data/11REGION/us_eco_l4_no_r11.shp M:/geodata/ecology/us_eco_l4_no_st.shp'))

system(paste('"C:/Program Files/QGIS Dufour/bin/ogr2ogr.exe"', '-overwrite -t_srs EPSG:5070 -clipdst -49675.0230520471 1329474.02694086 1175426.50953029 2591124.11923647 M:/geodata/project_data/11REGION/geology_a_r11.shp M:/geodata/geology/geology_a_mbr.shp'))

system(paste('"C:/Program Files/QGIS Dufour/bin/ogr2ogr.exe"', '-overwrite -t_srs EPSG:5070 -clipdst -49675.0230520471 1329474.02694086 1175426.50953029 2591124.11923647 M:/geodata/project_data/11REGION/physiography_polygon_r11.shp M:/geodata/geology/physiography_polygon.shp'))