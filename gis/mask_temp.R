# Burn Flowline
for(i in seq(nhdgdb)){
  cat(paste(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "burning", nhdgdb[i], "\n"))
  gdal_rasterize(
    src_datasource=nhdgdb[i],
    dst_filename="C:/geodata/project_data/REGION11/nhd30m_fl_warp.tif",
    l="NHDFlowline",
    b=1,
    burn=1,
    verbose=TRUE
  ) 
}


# Burn gSSURGO into NLCD
nlcdpath <- paste(pdpath, office,"/nlcd", 30, "m_11", office, ".tif", sep="")
gssurgopath <- paste(pdpath, office,"/gssurgo", 30, "m_11", office, ".tif", sep="")
for(i in oseq(gssurgopath)){
  r <- raster(nlcdpath[i])
  bb <- bbox(r)
  cat(paste(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "warping", gssurgopath[i], "\n"))
  gdalwarp(
    srcfile=nlcdpath[i],
    dstfile=gssurgopath[i],
    s_srs="EPSG:5070",
    t_srs="EPSG:5070",
    r="near",
    ot="Int32",
    tr=c(30,30),
    te=c(bb[1,1], bb[2,1], bb[1,2], bb[2,2]),
    overwrite=TRUE,
    verbose=TRUE
  )
}

for(i in seq(gssurgopath)){
  cat(paste(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "burning", gssurgopath[i], "\n"))
  gdal_rasterize(
    src_datasource=geodatabase[i],
    dst_filename=gssurgopath[i],
    
    l="MUPOLYGON",
    a="MUKEY",
    verbose=TRUE
  ) 
}


