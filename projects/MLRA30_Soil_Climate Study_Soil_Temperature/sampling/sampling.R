# To ensure that multivariate space is adequetly covered select sites from kmean clusters. Testing shows that a minimum of 40 sites is necessary to develop a suitable model. Also plot of cluster wss shows that cluster purity is maximized at about 20 classes. Therefore select 2 replicates from each cluster. Might be ideal to select sites closest to the cluster centriod in classes that are over sampled, or sites that are geographically clustered in order to reduce transportation costs. This sampling scheme is inline with the reseach on purposive sampling by Zhu and others. Also conceptual similar to the Latin Hypercube design by Minansy and McBratney.
# Need to include SCAN sites into the analysis. No point in duplicating data from scan sites. Deb Harms will provide the coordinates.
#Could possibly use clhs to select sites since we already have a similar distribution. However the above approach makes it simpler to add new sites in the future.

library(clhs)
library(plyr)
library(sp)
library(randomForest)
library(raster)
library(rgdal)



# Read MAST data
mastList.df <- read.csv("E:/Workspace/soilTemperatureMonitoring/R/HOBO_List_2013_0923_master.csv", header=T)
mastSites.df <- read.csv("E:/Workspace/soilTemperatureMonitoring/R/mastSites.csv")
mast.df <- join(mastSites.df,mastList.df,by="siteid")
mast.df <- subset(mast.df, select=c(siteid, tempF, numDays, utmeasting, utmnorthing))
mast.df$tempC <- (mast.df$tempF-32)*(5/9)
mast.sp <- mast.df
coordinates(mast.sp) <- ~ utmeasting+utmnorthing
proj4string(mast.sp)<- ("+init=epsg:26911")



# Take random sample of the MLRA
setwd("E:/Workspace/geodata")
mast.shp <- readOGR(dsn=getwd(), layer="mlra_a_mbr3031_utm", encoding="ESRI Shapefile")
rand.sp <- spsample(mast.shp, 5000, type="stratified")
plot(mast.shp)
points(mast.sp, pch=21, bg="grey")
points(rand.sp)

# Load geodata
geodata.st <- stack(paste("E:/workspace/geodata/", c("prism30m_vic8_tavg_1981_2010_annual_C.tif",
  "prism30m_vic8_ppt_1981_2010_annual_mm.tif",
  "landsat30m_vic8_tc.tif",
  "ned30m_vic8_solarcv.sdat",
  "nlcd30m_vic8_2006_mask.sdat"),
  sep=""))
geodata.st <- geodata.st[[c(1,2,3,6,7)]]
names(geodata.st) <- c("tavg", "ppt", "tc1", "srcv", "mask")

# Extract geodata
geodata.sp <- extract(geodata.st, rand.sp, sp=T)
geodata.df <- geodata.sp@data
geodata.df <- na.exclude(geodata.df)
summary(geodata.df)
geodata.df <- geodata.df[,c(1:4)]

mastGeo.sp <- extract(geodata.st, mast.sp, sp=T)
mastGeo.df <- mastGeo.sp@data
mastGeo.df <- na.exclude(mastGeo.df)
summary(mastGeo.df)

# Function to plot within group sum of squares (WSS)
kmeans.wss.plot=function(dataframe,sequence){
  n<-length(dataframe[,1])
  wss1<-(n-1)*sum(apply(dataframe,2,var))
  wss<-numeric(0)
  for(i in sequence) {
    h=hclust(dist(dataframe),method="ward")
    initial=tapply(as.matrix(dataframe),list(rep(cutree(h,k=i),ncol(dataframe)),col(dataframe)),mean)
    dimnames(initial)=list(NULL,dimnames(dataframe)[[2]])
    W<-sum(kmeans(dataframe,initial,iter.max=1000)$withinss)
    wss<-c(wss,W)
  }
  wss<-c(wss1,wss)
  plot(c(1,sequence),wss,type="l",xlab="Number of groups",ylab="Within groups sum of squares",lwd=2)  
}

kmeans.wss.plot(scale(geodata.df),c(2:100))


# Generate range of clusters
uClass.f<-function(dataframe,stack,sequence){
  uClass.list <- list()
  for(i in sequence){
    uClass.list[[1]] <- dataframe
    dataframe.sc <- scale(dataframe)
    h <- hclust(dist(dataframe.sc), method="ward")
    uClass.list[[2]] <- h
    initial <- tapply(as.matrix(dataframe.sc), list(rep(cutree(h, k=i),ncol(dataframe.sc)) ,col(dataframe.sc)) ,mean)
    dimnames(initial) <- list(NULL, dimnames(dataframe.sc)[[2]])
    km <- kmeans(dataframe.sc, initial, iter.max=1000)
    uClass.list[[3]] <- km
    cluster <- as.factor(km$cluster)
    train <- as.data.frame(cbind(dataframe, cluster))
    train.rf <- randomForest(cluster~., data=train, importance=T, proximity=T)
    dataframe.p <- predict(stack, train.rf,type='response', progress="text")
    writeRaster(dataframe.p, filename=paste("R:/soilTemperatureMonitoring/geodata/","cluster", i, ".tif", sep=""), format="GTiff", datatype="INT1U", overwrite=TRUE, progress="text")
    uClass.list[[4]] <- train.rf
  }
  return(uClass.list)
}


geodata.uc <- uClass.f(geodata.df,geodata.st,c(15))
save(geodata.uc, file="E:/workspace/soilTemperatureMonitoring/R/mastClusterData.Rdata")

test.r <- predict(geodata.st, train.rf,type='prob', index=1:15, progress="text")

# cluster means

# cluster plots
par(mfrow=c(1,2))
par(pty="s")
plot(test.c[,c(1,2)], type="n")
text(test.c[,c(1,2)], labels=row.names(test.c))
plot(test.c[,c(1,4)], type="n")
text(test.c[,c(1,4)], labels=row.names(test.c))


# kmeans sort
# Clustering methods create unequal size clusters. Perhaps we should distribute the sites proporional to the cluster sizes in order to preserve balance their numbers.
geodata.st <- addLayer(geodata.st, raster("R:/soilTemperatureMonitoring/geodata/cluster15.tif"))
names(geodata.st) <- c("tavg", "ppt", "tc1", "srcv", "mask","k15")

mastGeo.sp <- extract(geodata.st, mast.sp, sp=T)
mastGeo.df <- mastGeo.sp@data
mastGeo.df$k15 <- as.factor(mastGeo.df$k15)
summary(mastGeo.df$k15)
sum(count(names(summary(mastGeo.df$k15)))$freq)   
 

n <- 45
uc.rf <- geodata.uc[[4]]

probability <- round(predict(uc.rf, mastGeo.df, type="prob")*100,0); row.names(probability) <- as.character(mast.df$siteid) # probability of a site belonging to a cluster
areal.proportion <- round(prop.table(diag(uc.rf$confusion)),2)*100 # areal proportion or clusters
ideal.number <- round(areal.proportion/100 * n,0) # Ideal number of sites per cluster
current.number <- summary(predict(uc.rf, mastGeo.df)) # Current number of sites per cluster
redundant.number <- ideal.number - current.number
uc.table <- rbind(probability, areal.proportion, ideal.number, current.number, redundant.number) # combined table

write.csv(uc.table, "R:/soilTemperatureMonitoring/R/samplingClusters/mastClusterSummary.csv")

# Sort sites according to cluster centriods
# Example
test <- as.data.frame(cbind(rnorm(1000,mean=100,sd=2),rnorm(1000,mean=50,sd=1)))

n <- 15
test.km <- kmeans(test,n)$centers
test.clhs <- clhs(test,size=n,simple=F)$sampled_data
test <- cbind(test,kmeans(test,10)$cluster)
test.clhs.sub <- test[as.numeric(prettyNum(rownames(test.clhs))),]
d <- summary(as.factor(test.clhs.sub[,3])); d

test.d <-rbind(test.km,test.clhs)
test.dist <- dist(test.d, upper=T, diag=T)
test.sub <- round(as.matrix(test.dist)[1:n,(n+1):(n*2)],2)

site.list <- list()
comb.list <- list()
for(i in 1:n){
  x.i <- names(sort(test.sub[,i]))[1:n]
  y.i <- sort(test.sub[,i])[1:n]
  site.list[[i]] <- as.numeric(prettyNum(x.i))
  comb.list[[i]] <- y.i
}

t1 <- ldply(site.list)
t2 <- ldply(comb.list)
d <- summary(as.factor(t1[,1])); d

test2.c <- test.km2$cluster[1:68]; test2.c <- as.factor(test2.c)
summary(test2.c)
sum(count(names(summary(test2.c)))$freq)


n <- 15
n2 <- length(geodata.df[,1])

test.km2 <- geodata.uc[[16]]
test.km <- test.km2$centers
test2.c <- test.km2$cluster[1:n2]; test2.c <- as.factor(test2.c)
summary(test2.c) # number of sites per cluster
sum(count(names(summary(test2.c)))$freq)

test.d <-rbind(test2,test.km)
test.dist <- dist(test.d, upper=T, diag=T)
test.sub <- round(as.matrix(test.dist)[1:n2,(n2+1):(n+n2)],2)

site.list <- list()
comb.list <- list()
for(i in 1:n){
  x.i <- names(sort(test.sub[,i]))[1:10]
  y.i <- sort(test.sub[,i])[1:10]
  site.list[[i]] <- as.numeric(prettyNum(x.i))
  comb.list[[i]] <- y.i
}

t1 <- ldply(site.list)
t2 <- ldply(comb.list)
d <- summary(as.factor(t1[,1])); d # indicates sites that are redundant

for(i in length(t1[,1])
    if(d[i]>1) t1[2,i]
    
    #test[t1[,1],]
    mast.test <- mast.df[t1[,1],]
    mast.test.sp <- mast.test
    coordinates(mast.test.sp) <- ~ utmeasting+utmnorthing
    test2 <- remove.duplicates(mast.test.sp)
    test3 <- test2@data
    
    
# Subset mast sites with clhs
test.clhs50 <- clhs(mast.df, size=50, simple=F)$sampled_data
  
mast.test.sp <- test.clhs50
coordinates(mast.test.sp) <- ~ utmeasting+utmnorthing
test2 <- mast.test.sp
test3 <- test2@data
    
geoinfo <- extract(geodata,test2,sp=T)
geoinfo <- geoinfo@data
data <- cbind(test3,geoinfo)
    
summary(mast.lm <- lm(tempC~tavg+srcv+ppt+tc1,data=data, weights=numDays))
summary(predict(mast.lm)-data$tavg)
sort(data$siteid)


