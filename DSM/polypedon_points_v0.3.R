#
#
#    Polypedon approach to generating boosted model training points 03/28/2018
#
# This method is currently being developed by Dave White, Soil Scientist, USDA-NRCS
# For questions or comments please contact Dave at : david.white@nm.usda.gov
#
#
# Introduction: This method has been developed to boost model training points.
# Occasionally, there is a need for more training points. Many times there is 
# not enough data to effectivly run various statistical models. Boosting model
# training points, helps to ensure every class has a minimun number of points.
# This method makes the assumption that a soil polypedon contains a collection
# of similar soil pedons. Thus, the sampling location (pedon), has a polygon 
# associated with it, which contains similar soils. The current approach below, 
# assumes that you have a folder containing individual shape files of points and
# polygons for each class to be modeled. Currently I hand digitize polygons, 
# around all of my training points. Then I split the shape files by attribute
# into the same folder, each shape file is named with the class name being modeled.
# 
# Process:
# 1. A raster stack of all covariates is created.
# 2. The polygon and points shapefile is loaded.
# 3. The raster stack is cropped by the polygon shapefile
# 4. The number of covariates in the raster stack is reduced by:
#         - near zero variance filter
#         - degree of correlation filter
#         - iterative principal component analysis
#           *note iPCA is a work in progress as well, currently it
#           only iterates through 2 pcas.
# 5. The new reduced raster stack is run through mess similarity index
#     *note this method requires at a miimum 2 points to work properly.
#     Occasionally, more than two points are necessary. This is a work 
#     in progress. In the future, I may implement the ability to use 
#     the gowers similarity index.
# 6. The mess similarity index is converted to a cost raster and incorperated 
# back into the raster stack.
# 7. Points are generated using cLHS on the reduced raster stack utilizing the 
# mess similarity index as the cost raster.
#
# This is very much a work in progress. However, preliminary results show that
# generating 5 to 10 points per modeling class boosts model performance by about
# 30 percent. 
#
# At the end of the script there is 50 or more warnings, this is a normal output from the 
# mess similarity index from the dismo packge
#
# Future work to be done:
# 1. automate the process of creating polypedon polygons through the use of image segmentation
# 2. Fix the iPCA function to automatically iterate through to until the specified threshold is reached
# 3. Implement the option to use the gowers similarity index
# 4. Statistically validate this process
#
#


# load libraries
library(rgdal)
library(raster)
library(dismo)
library(clhs)
library(cluster)
library(caret)
library(corrplot)
library(psych)
library(amap)
library(rgeos)
library(doParallel)
library(dplyr)

# Load Raster Data
setwd("E:/Animas_Valley_Playa/AVP_Modeling_04102017/covariates/clipWhole/")


r.convexity.tif <- raster("convexity.tif")
r.convidx.tif <- raster("convidx.tif")
r.ctid8.tif <- raster("ctid8.tif")
r.ctidi.tif <- raster("ctidi.tif")
r.difinsol10m.tif <- raster("difinsol10m.tif")
r.dirinsol10m.tif <- raster("dirinsol10m.tif")
r.dwncrv.tif <- raster("dwncrv.tif")
r.flowpathlen.tif <- raster("flowpathlen.tif")
r.insoldur10m.tif <- raster("insoldur10m.tif")
r.localcrv.tif <- raster("localcrv.tif")
r.localdwncrv.tif <- raster("localdwncrv.tif")
r.localupcrv.tif <- raster("localupcrv.tif")
r.longcrv.tif <- raster("longcrv.tif")
r.massbalanceindex.tif <- raster("massbalanceindex.tif")
r.maxcrv.tif <- raster("maxcrv.tif")
r.maxht.tif <- raster("maxht.tif")
r.midslppos.tif <- raster("midslppos.tif")
r.mincrv.tif <- raster("mincrv.tif")
r.mrrtf.tif <- raster("mrrtf.tif")
r.mrvbf.tif <- raster("mrvbf.tif")
r.plancrv.tif <- raster("plancrv.tif")
r.profcrv.tif <- raster("profcrv.tif")
r.proidx.tif <- raster("proidx.tif")
r.relslppos.tif <- raster("relslppos.tif")
r.ridgelevel.tif <- raster("ridgelevel.tif")
r.sagawi.tif <- raster("sagawi.tif")
r.spi.tif <- raster("spi.tif")
r.stdht.tif <- raster("stdht.tif")
r.surftexture.tif <- raster("surftexture.tif")
r.tcilow.tif <- raster("tcilow.tif")
r.totinsol10m.tif <- raster("totinsol10m.tif")
r.tpi.tif <- raster("tpi.tif")
r.trugidx.tif <- raster("trugidx.tif")
r.upcrv.tif <- raster("upcrv.tif")
r.upheightdi.tif <- raster("upheightdi.tif")
r.valleydepth.tif <- raster("valleydepth.tif")
r.vertdiststream.tif <- raster("vertdiststream.tif")
r.vrm.tif <- raster("vrm.tif")
r.xseccrv.tif <- raster("xseccrv.tif")
r.augmsavi2.tif <- raster("augmsavi2.tif")
r.jun4o3.tif <- raster("jun4o3.tif")
r.jun4o7.tif <- raster("jun4o7.tif")
r.jun5o6.tif <- raster("jun5o6.tif")
r.jun6o2.tif <- raster("jun6o2.tif")
r.jun6o5.tif <- raster("jun6o5.tif")
r.jun6o7.tif <- raster("jun6o7.tif")
r.jun7o6.tif <- raster("jun7o6.tif")
r.juncalsed.tif <- raster("juncalsed.tif")
r.jungypsic.tif <- raster("jungypsic.tif")
r.junmsavi2.tif <- raster("junmsavi2.tif")
r.junnatric.tif <- raster("junnatric.tif")
r.marmsavi2.tif <- raster("marmsavi2.tif")
r.naipb1.tif <- raster("naipb1.tif")
r.naipb2.tif <- raster("naipb2.tif")
r.naipb3.tif <- raster("naipb3.tif")



# Create a raster stack of all covariates
r.stack <- stack(r.convexity.tif, r.convidx.tif, r.ctid8.tif, r.ctidi.tif, r.difinsol10m.tif, 
                 r.dwncrv.tif, r.flowpathlen.tif, r.insoldur10m.tif, 
                 r.localcrv.tif, r.localcrv.tif, 
                 r.localupcrv.tif, r.longcrv.tif, r.massbalanceindex.tif, r.maxcrv.tif, r.maxht.tif, 
                 r.midslppos.tif, 
                 r.mincrv.tif, r.mrrtf.tif, r.mrvbf.tif, r.plancrv.tif, r.profcrv.tif, 
                 r.proidx.tif, r.relslppos.tif, r.ridgelevel.tif, 
                 r.sagawi.tif, r.spi.tif, r.stdht.tif, 
                 r.surftexture.tif, r.tcilow.tif, r.totinsol10m.tif, r.tpi.tif, r.trugidx.tif, 
                 r.upcrv.tif, r.upheightdi.tif, r.valleydepth.tif, r.vertdiststream.tif, r.vrm.tif, 
                 r.xseccrv.tif, r.augmsavi2.tif, r.jun4o3.tif, r.jun4o7.tif, r.jun5o6.tif, 
                 r.jun6o2.tif, r.jun6o5.tif, r.jun6o7.tif, r.jun7o6.tif, r.juncalsed.tif, 
                 r.jungypsic.tif, r.junmsavi2.tif, 
                 r.junnatric.tif, r.marmsavi2.tif,
                 r.naipb1.tif, 
                 r.naipb2.tif, r.naipb3.tif)

to.remove <- ls()
to.remove <- c(to.remove[!grepl("r.stack", to.remove)], "to.remove")
rm(list=to.remove)

# This is the name of the shapefiles, both polygons and points
# it is important that both are names similarly
layer.names <- c("agustin", "cave")

# path to the folder containing the shapefiles
setwd("E:/Animas_Valley_Playa/AVP_Modeling_02232018/Polypedons/polypedon by comps")

# path to the output folder where polypedon points shapefiles are to be written
out.folder <- "E:/Animas_Valley_Playa/AVP_Modeling_02232018/Polypedons/polypedon by comps/generated_points"

# cutoff number for correlation reduction, 0.95 will remove any covariates that are >95% correlated
cutoff <- 0.8

# The number of polypedon points to be generated utilizing cLHS
size <- 5

# The number of iterations to run for cLHS
iter <- 1000

for(i in layer.names){
  layernm <- i
  polypeds <- readOGR(dsn = ".", layer = layernm)
  pedon.pts <- readOGR(dsn = ".", layer = paste0('pts_', layernm))
  layer.name <- layernm
  folder <- out.folder
  
  DataReduction <- function(r.stack, polypeds, cutoff){
    # create a buffer around the points and mask the raster stack
    # points buffer
    #p.buff <- gBuffer(pedon.pts, width = 200) Can use a buffer if there are no polygons
    p.buff <- polypeds
    r.crop <- crop(r.stack, p.buff)
    r.buff <- rasterize(p.buff, r.crop)
    r.mask <- mask(r.crop, r.buff)
    r.stk.1 <- trim(r.mask)
    
    
    # create data frame from raster stack
    stack.df <- as.data.frame(r.stk.1, na.rm = TRUE)
    
    to.remove <- ls()
    matches <- c("stack.df", "polypeds", "pedon.pts", "layer.name", "folder", 
                 "out.folder", "in.folder", "size", "iter", "layernm", "cutoff", "layer.names")
    to.remove <- c(to.remove[!grepl(paste0(matches, collapse = "|"), to.remove)], "to.remove")
    rm(list=to.remove)
    gc()
    
    # near zero filtering and correlation reduction
    cl <- makeCluster(detectCores()-1, output = "")
    registerDoParallel(cl)
    zeroVar <- nearZeroVar(stack.df, foreach = TRUE, allowParallel = TRUE)
    stopCluster(cl)
    
    # remove covariates with near zero var
    stack.df <- if(length(zeroVar) > 0){
      stack.df[, -zeroVar]
    } else {
      stack.df
    }
    
    
    # filtering by correlation
    # Create correlation matrix
    cor.mat <- cor(stack.df)
    highCorr <- findCorrelation(cor.mat, cutoff = cutoff)
    # remove covariates with high degree of correlation
    stack.df <- if(length(highCorr) > 0){
      stack.df[, -highCorr]
    } else {
      stack.df
    }
    rm(zeroVar)
    rm(highCorr)
    gc()
    
    
    
    #ipca
    
    iPCA <- function(stack.df){
      cor.mat <- cor(stack.df)
      trans <- pca(cor.mat, center = TRUE, reduce = TRUE)
      evectors <- trans$loadings
      len <- length(stack.df)
      evalue <- trans$eig
      evalues <- matrix(evalue, nrow = len, ncol = len, byrow = TRUE)
      sdev <- matrix((trans$sdev), nrow = len, ncol = len, byrow = TRUE)
      
      # compute loading factors and convert to a data frame       
      lf <- as.data.frame(abs((evectors*(sqrt(evalues)))/(sdev)))
      
      # add row and sum up loading factors
      lf$loadings <- rowSums(lf[, c(1:len)])
      
      # sort by loadings
      lf <- lf[order(-lf$loadings), ]
      
      # now we need to determine which covariates to drop
      esum <- sum(evalue)
      len <- length(evalue)
      cum.var <- matrix(evalue, nrow = len, byrow = TRUE)
      cum.var <- as.data.frame.matrix(cum.var)
      esum <- rep(esum, len)
      cum.var$esum <- esum
      cum.var$var <- cum.var$V1 / cum.var$esum
      cum.var$cumvar <- cumsum(cum.var$var)
      
      cum.var.len <- nrow(cum.var) # starting number of covariates
      pc.len <- nrow(filter(cum.var, cumvar <= .95)) #number of covariates to keep
      
      # narrowing down the list
      lf.subset <- lf[1:pc.len, ]
      
      stack.names <- rownames(lf.subset)
      
      
      stack.df <- (stack.df[,c(stack.names)])
      return(stack.df)
    }
    
    stack.df <- iPCA(stack.df)
    stack.df <- iPCA(stack.df)
    
  }
  
  stk.names <- DataReduction(r.stack = r.stack, polypeds = polypeds, cutoff = cutoff)
  
  r.stk.2 <- subset(r.stack, names(stk.names))
  


  
  gc()
  
  
  
  
  PolypedPts <- function(r.stk.2, polypeds, pedon.pts, folder, layer.name, size, iter){
    p.buff <- polypeds
    r.crop <- crop(r.stk.2, p.buff)
    r.buff <- rasterize(p.buff, r.crop)
    r.mask <- mask(r.crop, r.buff)
    r.stk.2 <- trim(r.mask)
    plot(r.stk.2)
    pts.df <- extract(r.stk.2, pedon.pts)
    
    to.remove <- ls()
    matches <- c("r.stk.2", "pts.df", "polypeds", "pedon.pts", "layer.name", "folder", "layer.names",
                 "layernm", "r.stack", "cutoff", "in.folder", "out.folder", "size", "iter")
    to.remove <- c(to.remove[!grepl(paste0(matches, collapse = "|"), to.remove)], "to.remove")
    rm(list=to.remove)
    gc()
    
    # computing the mess index
    mess.out <- mess(r.stk.2, pts.df, full = FALSE)
    
    
    # change the mess output to a cost output
    r.cost <- (-1 * mess.out)*100
    plot(r.cost)
    
    # change name from mess to cost
    names(r.cost)[1] <- 'cost'
    
    
    # add cost to the stack
    r.stk.2$cost <- r.cost
    
    # create clhs stack
    r.raster <- rasterize(polypeds, r.stk.2)
    r.clhs <- mask(r.stk.2, r.raster, na.rm=TRUE)
    
    #raster to points - creates a spatial poins data frame for cLHS to sample from (every pixel becomes a point)
    s <- rasterToPoints(r.clhs, spatial=TRUE)
    
    # this line is needed to implement cost  
    r.clhs$cost <- runif(nrow(r.clhs))
    
    # the clhs function
    s.clhs <- clhs(s, size=size, progress=TRUE, iter=iter, cost='cost', simple=FALSE)
    
    
    #extract indicies
    subset.idx <- s.clhs$index_samples
    
    #save cLHS points to shp
    writeOGR(s[subset.idx, ], dsn= folder,
             layer=layer.name, driver='ESRI Shapefile', overwrite_layer = TRUE)
    
  }
  
  
  PolypedPts(r.stk.2 = r.stk.2, polypeds = polypeds, pedon.pts = pedon.pts, 
             layer.name = layer.name, folder = folder, size = size, iter = iter)
  
  
  to.remove <- ls()
  matches <- c("r.stack", "layer.names", "out.folder", "size", "iter", "cutoff")
  to.remove <- c(to.remove[!grepl(paste0(matches, collapse = "|"), to.remove)], "to.remove")
  rm(list=to.remove)
  gc()
  
  to.remove <- ls()
  matches <- c("r.stack", "layer.names", "out.folder", "size", "iter", "cutoff")
  to.remove <- c(to.remove[!grepl(paste0(matches, collapse = "|"), to.remove)], "to.remove")
  rm(list=to.remove)
  gc()
  
  
}


