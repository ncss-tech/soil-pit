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
