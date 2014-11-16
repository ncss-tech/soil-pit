mlra <- readOGR(dsn=getwd(), layer="mlra_a_mbr_Dissolve")

id <- sapply(slot(mlra, "polygons"), function(x) slot(x, "ID"))
id <- as.numeric(id)

d <- slot(mlra,"data")
d.sub <- subset(d, MLRARSYM == "30")

plot(mlra[rownames(d.sub),])



test <- readOGR(dsn="I:/geodata/hydrography/NHDH_IN.gdb", layer="NHDWaterbody", encoding="OpenFileGDB")
id <- sapply(slot(mlra, "polygons"), function(x) slot(x, "ID"))
id <- as.numeric(id)

d <- slot(test,"data")
d.sub <- subset(d, Shape_Area > 40489, select=(Shape_Area))

plot(test[rownames(d.sub),])