mapunit.summary<-function(shapefile,sampleSize){
  # Import shapefile
  mapunit.sp<-readOGR(dsn=getwd(),layer=shapefile)

  # Sample soil map units
  mapunit.sps<-spsample(mapunit.sp,n=sampleSize,"stratified")
  mapunit.df<-cbind(mapunit.sps,over(mapunit.sps,mapunit.sp))

  # Load grids
  geodata.st <-stack(paste(c(
    "E:/workspace/geodata/ned30m_vic8.tif", 
    "E:/workspace/geodata/ned30m_vic8_slope.tif", 
    "E:/workspace/geodata/ned30m_vic8_aspect.tif",
    "E:/workspace/geodata/ned30m_vic8_solarcv.tif",
    "E:/workspace/geodata/ned30m_vic8_mrvbf.tif",
    "E:/workspace/geodata/mast30m_vic8_2013.tif", 
    "E:/workspace/geodata/prism30m_vic8_ppt_1981_2010_annual_mm.tif", 
    "E:/workspace/geodata/prism30m_vic8_tavg_1981_2010_annual_C.tif", 
    "E:/workspace/geodata/prism30m_vic8_ffp_1971_2001_annual_days.tif")))
  names(geodata.st) <- c("elev", "slope", "aspect", "solar", "mrvbf", "mast", "ppt", "temp", "ffp")

  # Extract geodata
  geodata.df <- extract(geodata.st, mapunit.sps, df=T)
  
  # Prep data
  data <- cbind(mapunit.df$MUSYM, geodata.df[,c(2:ncol(geodata.df))])
  names(data)[1] <- "MUSYM"
  data$mast[data$mast == -32768] <- NA
  
  elev.list<-c(-300,792,1128,1585,5000)
  slope.list<-c(0,2,4,8,15,30,50,75,350)
  aspect.list<-c(0,23,68,113,158,203,248,293,338,360) 
  solar.list<-c(0,25,50,100)
  mast.list<-c(-5,8,15,19,22,25,36)
  mrvbf.list<-c(0,0.5,30)
  
  data$elevBreaks <- cut(data$elev,breaks=elev.list, right=FALSE)
  data$slopeBreaks <- cut(data$slope,breaks=slope.list, right=FALSE)
  data$aspectBreaks <- cut(data$aspect,breaks=aspect.list, right=FALSE)
  data$solarBreaks <- cut(data$solar,breaks=solar.list, right=FALSE)
  data$mastBreaks <- cut(data$mast,breaks=mast.list, right=FALSE)
  data$mrvbfBreaks <- cut(data$mrvbf,breaks=mrvbf.list, right=FALSE)

  levels(data$elevBreaks) <- c("-50-792","792-1128","1128-1585","1585-3000")
  levels(data$slopeBreaks) <- c("0-2","2-4","4-8","8-15","15-30","30-50","50-75","75-350")
  levels(data$aspectBreaks) <- c("N","NE","E","SE","S","SW","W","NW","N")
  levels(data$solarBreaks) <- c("North","Flat","South")
  levels(data$mastBreaks) <- c("frigid","mesic","coolThermic","warmThermic","hyperthermic", "extremeHyperthermic")
  levels(data$mrvbfBreaks) <- c("upland","lowland")
  write.csv(data, paste(shapefile, ".sample.csv", sep=""))
  return(c(data, mapunit.sp))
  }

conditional.l.rv.h.summary <- function(x) {
  variable <- unique(x$variable)
  v <- na.omit(x$value) # extract column, from long-formatted input data
  ci <- quantile(v, na.rm=TRUE, probs=p) 
  d <- data.frame(min=ci[1], low=ci[2], rv=ci[3], high=ci[4], max=ci[5], stringsAsFactors=FALSE) # combine into DF
  d$range <- with(d, paste("(", paste(round(c(min, low, rv, high, max), 0),collapse='|'), ")", sep="")) # add 'range' column for pretty-printing
  return(d[6])
  }