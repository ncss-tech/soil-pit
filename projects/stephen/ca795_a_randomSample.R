# 1. Intersect ca795_a_smr premap and clusters, dissolve intersection, and enumerate table.
# 2. Calculate area, perimeter, and nparts of each ORIG_MUSYM.
# 3. Calculate number of samples per McKenzie's guidenance of 1/250 hectares.
# 2. Split shapefile into into hills and plains.
# 5. Mask hills using cost distance, and plains using roads.
# 4. Split each unique ORIG_MUSYM into its own shapefile by module Table/Shape of Attribute.
# 5. Read each shapefile in R with maptools (i.e. readShapePoly)
# 6. Sample each shapefile with spsample using type='stratified'. Include ifelse statement into n option, so as to sample each shapefile a minimum of x times, unless the sum of samples exceeds the threshold. 
#Intersect previous two layers with roads. Randomly sample each road intersection proportion to its true area. Is their a way to select those cells with the highest probability? Possibly mask areas with less than a given threshold.


library(sp)
library(rgdal)
library(raster)
library(RSAGA)
library(maptools)
library(foreign)
setwd("C:/Users/stephen/Documents/Work/workspace/MOJA")

pm=read.dbf("ca795_a_dtPremap.dbf")
pm.list=levels(pm$ORIG_MUSYM)
pmh=read.dbf("ca795a_mask_hills_plainsNoRoads.dbf")
pmh.list=levels(pmh$ORIG_MUSYM)
pmp=read.dbf("ca795a_mask_plains_roadClip.dbf")
pmp.list=levels(pmp$ORIG_MUSYM)

# Function to generate stratified-random samples for a list of clipped shapefiles proportional to their true extent
samplePolyList=function(poly.list,sample.table){
  for(i in poly.list){
  sample.subset=subset(sample.table,ORIG_MUSYM == i)
  polygon=readShapePoly(paste("ca795_a_dtPremap_sampleArea_ORIG_MUSYM__",i,".shp",sep=""))
    polygon.sample=spsample(polygon,n=ifelse(sum(sample.subset$SAMPLES>20),sum(sample.subset$SAMPLES),20),type='stratified',iter=100)
                            writePointsShape(polygon.sample,paste("ca795_a_dtPremap_sampleArea_ORIG_MUSYM_",i,"_samples.shp",sep="")) 
  }
}

samplePolyList(pm.list,pm)

# hexagonal grid from lower-left corner
s <- sapply(slot(x, 'polygons'), function(i) spsample(i, n=100, type='hexagonal', offset=c(0,0)))

# we now have a list of SpatialPoints objects, one entry per polygon of original data
plot(x) ; points(s[[4]], col='red', pch=3, cex=.5)

# stack into a single SpatialPoints object
s.merged <- do.call('rbind', s)


dsn=getwd()
ca795_a=readOGR(dsn=dsn,layer="ca795a_smr_clusters_edited.shp")
proj4string(ca795_a)

m

premap=read.csv("ca795a_smr_clusters_edited.csv")


premap.pct=function(pm){
  pm.list=levels(pm)
  for(i in length(pm.list)){
    pm.sub[i]=subset(pm,ORIG_MUSYM == pm.list[i])
    pm.sub=pm.sub[i]
    pm.sub$pct=c(round(pm.sub$acres/sum(pm.sub$acres),2)*100)
    write.csv(pm.sub,file=paste("pm.sub",i,".csv",sep=""))
    }
}
premap$acres=round(test$AREA*0.000247,1)

test.pediment=subset(test,ORIG_MUSYM == 'pediment')
test.pediment$ORIG_MUSYM=unclass(test.pediment$ORIG_MUSYM)
test.pediment$ORIG_MUSYM=as.factor(test.pediment$ORIG_MUSYM)
cbind(round(test.pediment$acres/sum(test.pediment$acres),2)*100)


clusters=raster("unsupervised_classification_30m_moja_30clusters.sdat")
extent(zones)
# for some reason extent and xmax values can not be capture with paste
rsaga.geoprocessor("grid_tools",0,list(
  INPUT="ca795_a.sgrd",
  TARGET="0",
  SCALE_UP_METHOD="0",
  GRID_GRID="ca795_a_test.sgrd",
  USER_GRID="ca795_a_OBJECTID.sgrd",
  USER_XMIN="570728.2",
  USER_XMAX="692258.2",
  USER_YMIN="3839108",
  USER_YMAX="3942458",
  USER_SIZE="30"))

ca795_a_OBJECTID=raster("ca795_a_OBJECTID.sdat")

zonal(zones,ca795_a_OBJECTID,stat="modal")
