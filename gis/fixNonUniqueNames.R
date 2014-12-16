mapunit.sp<-readOGR(dsn = "M:/geodata/cadastral/plsssection_a_mbr.gdb", layer = "plsssection_a_mbr", encoding="OpenFileGDB")

# Optional fix for 100k quads
slot(mapunit.sp, "data") <- mapunit.sp@data[,c(1:13, 18:19)]

id <- sapply(slot(mapunit.sp, "polygons"), function(x) slot(x, "ID"))
id <- as.numeric(id)
d <- slot(mapunit.sp,"data")

d.sub <- unique(d)
mapunit.sp2 <-mapunit.sp[rownames(d.sub),]

writeOGR(mapunit.sp2, dsn = "M:/geodata/cadastral", layer = "plsssection_a_mbr", driver = "ESRI Shapefile", overwrite_layer = TRUE)