library(soilDB)
library(ggplot2)
library(reshape2)
library(plyr)
library(sp)
library(raster)
library(rgdal)
library(randomForest)
library(splines)
library(caret)

# Load data
site <- get_site_data_from_NASIS_db()
veg <- get_vegplot_from_NASIS_db()
inventory <- veg$inventory

# Merge and subset only vegplots with coordinates
id <- inventory$plantsym == "CORA"
vegi <- inventory[id, ]
vegi <- merge(vegi, site, by = "siteiid", all = TRUE)
id <- is.na(vegi$plantsym)
vegi[id, "plantsym"] <- "0"
id <- complete.cases(vegi$x, vegi$y)
vegi <- vegi[id, ]

# pain2

# Convert to a spatial object and project
vegi_sp <- vegi
coordinates(vegi_sp) <- ~x+y
proj4string(vegi_sp) <- CRS("+init=epsg:4326")

# Write a shapefile
writeOGR(vegi_sp, dsn = getwd(), layer = "vegi", driver = "ESRI Shapefile")


# Load geodata
setwd("M:/geodata/project_data/8VIC")

grid.list <- c(
  "mast30m_vic8_2013.tif",
  "prism30m_vic8_tavg_1981_2010_annual_C.tif",
  "prism30m_vic8_ppt_1981_2010_annual_mm.tif",
  "prism30m_vic8_ppt_1981_2010_summer_mm.tif"
)

geodata <- stack(grid.list)
names(geodata) <- c("mast", "maat", "map", "msp")

# Join veg and geodata
geo <- extract(geodata, vegi_sp, df=T)
vegig <- cbind(data.frame(vegi), geo)
vegig <- vegig[, c("plantsym", "mast", "maat", "map", "msp")]
vegig <- na.exclude(vegig)
vegig$plantsym <- as.factor(vegig$plantsym)

# Exploratory analysis
vegi <- melt(vegig, id = "plantsym")

qplot(plantsym, value, data = vegi, geom = "boxplot") + facet_wrap(~variable, scales = "free")

ddply(vegi, .(plantsym, variable), summarise, min = min(value), mean = round(mean(value), 0), max = max(value))

panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}
panel.hist <- function(x, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col = "cyan", ...)
}

pairs(na.exclude(vegig[2:5]), panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor)


# GLM
# vegi
vegi_full <- glm(plantsym ~ . + ns(maat, 2) + ns(map, 2) + ns(msp, 3), data = vegig, family = binomial)
vegi_glm <- glm(plantsym ~ ns(map, 2) + maat + msp, data = vegig, family = binomial)
summary(vegi_glm)
confusionMatrix(vegi_glm$y>0.5, predict(vegi_glm, type = "response")>0.5)

plot(vegi_glm)
termplot(vegi_glm, partial.resid = TRUE) # looks like their is an outlier in this plot thats screwing up the plot, removed observation 181, remoing 50, 3, 56 also helps and allows for a 3rd order spline


vegi_rf <- randomForest(plantsym ~ ., data = vegig)
print(vegi_rf)

varImpPlot(vegi_rf)

predfun <- function(model, data) {
  v <- predict(model, data, type="response")
}
boer4.raster <- predict(geodata.r, boer4.glm, fun=predfun, index=1, progress='text')
writeRaster(boer4.raster,filename="G:/workspace/boer4.glm2.raster.tif",format="GTiff",datatype="FLT4S",overwrite=T,NAflag=-99999, progress="text")


# Bioclim
library(dismo)
geodata.sb.r <- geodata.r[[c(11,14)]]
boer4.sb.df <- subset(boer4.df, boer4=="boer4")
boer4.sb.sp <- boer4.sb.df ; coordinates(boer4.sb.sp) <- ~easting+northing
boer4.bc <- bioclim(geodata.sb.r,boer4.sb.sp)
boer4.bc.r <- predict(geodata.sb.r, boer4.bc, progress="text")
writeRaster(boer4.bc.r,filename="G:/workspace/boer4.bioclim.raster.tif",format="GTiff",datatype="FLT4S",overwrite=T,NAflag=-99999, progress="text")
