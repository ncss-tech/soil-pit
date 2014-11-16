raster.stack <- function(x, fname, datatype){
  for(i in seq(fname)){
    cat(paste(format(Sys.time(), "%Y-%m-%d %H:%M:%S"),"stacking", fname[i],"\n"))
    mosaic_rasters(
      gdalfile=c(x[[1]][i], x[[2]][i], x[[3]][i]),
      dst_dataset="E:/geodata/project_data/11ATL/test.tif",
      ot="Int16",
      separate=TRUE,
      co=c("BIGTIFF=YES", "COMPRESS=DEFLATE", "TILED=YES"),
      overwrite=TRUE,
      verbose=TRUE
    )
  }
}

execGRASS("r.param.scale",
          flags="overwrite",
          parameters=list(
            input="test.tif",
            output="test_profc",
            size=5,
            param="profc"))

execGRASS("r.out.gdal",
          parameters=list(
            input="test_profc",
            output="C:/Users/Stephen/Documents/test_profc.tif",
            nodata=-99999,
            type="Float32"))


test <- function(x, y){
  for(i in seq(x)){
    gdal_translate(
      src_dataset=x[i],
      dst_dataset=y[i],
      of="GTiff",
      ot="Float32",
      co=c("TILED=YES", "BIGTIFF=YES"),
      overwrite=TRUE,
      verbose=TRUE
      )

    gdaladdo(
      filename=y[i],
      r="nearest",
      levels=c(2, 4, 8, 16),
      clean=TRUE,
      ro=TRUE,
      verbose=T
    )
    
    gdalinfo(
      datasetname=y[i],
      stats=TRUE,
      hist=TRUE,
      verbose=T
    )
  }
}

office <- c("ATL", "AUR", "CAR", "CLI", "FIN", "GAL", "IND", "JUN", "SPR", "UNI", "WAV")
pdpath <- "D:/geodata/project_data/11"
x <- paste(pdpath, office, "/ned10m_11", office, ".tif", sep="")
y <- paste(pdpath, office, "/ned10m_11", office, "_compress.tif", sep="")

test(x, y)

