
# Later try using the NLCD water bodies layer

raster.reclassify <- function(x){
  m <- c(-3, 0, -99999)
  rclmat <- matrix(m, ncol=1, byrow=TRUE)
  x.rc <- paste(strsplit(x, ".sdat"), "_rc.sdat", sep="")
  for(i in seq(x)){
    r <- raster(x[i])
    reclassify(
      x=r,
      rcl=rclmat,
      filename=x.rc[i],
      NAflag=-99999,
      toptobottom=FALSE,
      overwrite=TRUE,
      progress="text"
    )
  }
}



  rsaga.geoprocessor("grid_filter", 5, env=myenv, list(
    GRID=paste(getwd(), "/ned", fact*10, "m_11", office, "_mask.sdat", sep=""),
    OUTPUT=paste(getwd(), "/ned", fact*10, "m_11", office, "_clump.sdat", sep=""),
    THRESHOLD=10))
  
