library(lattice)
library(sp)
library(raster)
library(clhs)

# Create a sixteen square polygon
grd <- GridTopology(c(1, 1), c(1, 1), c(4, 4))
polys <- as.SpatialPolygons.GridTopology(grd)

png(file = "sample_comparison.png", width = 8, height = 3, units = "in", res = 300)
par(mfrow = c(1, 3))
plot(polys, main = "Simple random sample", cex.main = 1.5)
test <- spsample(polys, n = 16, type = "random")
points(test, pch = 16, cex = 2)

plot(polys, main = "Systematic sample", cex.main = 1.5)
# Generate systematic random sample
test <- spsample(polys, n = 16, type = "regular")
points(test, pch = 16, cex = 2)

plot(polys, main = "Stratified random sample", cex.main = 1.5)
# Generate a spatially stratified random sample
# test <- spsample(polys, n = 16, type = "stratified")
# points(test, pch = 16, cex = 2)

s <- sapply(slot(polys, 'polygons'), function(x) spsample(x, n = 1, type = "random"))
s <- do.call("rbind", s)
points(s, pch = 16, cex = 2) # randomly select 1 square and plot


dev.off()


png(file = "sample_multistage.png", width = 3, height = 3, units = "in", res = 300)
par(fin = c(3, 3), mai = c(0, 1, 0, 0))
plot(polys, main = "Two-stage random", cex.main = 2)

# Select 8 samples from each square
s <- sapply(slot(polys, 'polygons'), function(x) spsample(x, n = 8, type = "random"))
points(sample(s, 1)[[1]], pch = 16, cex = 2) # randomly select 1 square and plot
points(sample(s, 1)[[1]], pch = 16, cex = 2) # randomly select 1 square and plot

dev.off()


data(volcano) # details at http://geomorphometry.org/content/volcano-maungawhau
volcano_r <- raster(as.matrix(volcano[87:1, 61:1]), crs = CRS("+init=epsg:27200"), xmn = 2667405, xmx = 2667405 + 61*10, ymn = 6478705, ymx = 6478705 + 87*10) # import volcano DEM
test <- as(extent(volcano_r), "SpatialPolygons") # create a polygon from the spatial extent of the volcano dataset
names(volcano_r) <- "elev"
slope_r <- terrain(volcano_r, opt = "slope", unit = "radians") # calculate slope from the DEM
rs <- stack(volcano_r, slope_r)

sr400 <- spsample(test, n = 400, type = "random") # take a large random sample
sr <- spsample(test, n = 20, type = "random") # take a small random sample
str <- spsample(test, n = 23, type = "stratified", iter = 1000) # take a small stratified random sample
str <- str[1:20]
cs <- clhs(rs, size = 20, progress = FALSE, simple = FALSE) # take a cLHS sample

s <- rbind(data.frame(method = "Simple Random",extract(rs, sr)),
                data.frame(method = "Stratified Random", extract(rs, str)),
                data.frame(method = "cLHS", cs$sampled_data@data)
)
s$slope <- as.numeric(s$slope)

lty <- 1:3
col <- c("orange", "blue", "black")

densityplot(~ slope, group = method, data = s, 
            xlab = "Slope Gradient (%)", main = "Comparison of Different Sampling Methods",
            lty = lty, lwd = 3, col = "black", type = c("g", "n"),
            key = list(columns = 3, lines = list(lty = lty, lwd = 3), text = list(levels(as.factor(s$method))))
            )

            
par(mfrow = c(1, 3))
plot(volcano_r, main = "Simple random", cex.main = 2)
points(sr, pch = 3, cex = 1.2)

plot(volcano_r, main = "Stratified random", cex.main = 2)
points(str, pch = 3, cex = 1.2)

plot(volcano_r, main = "cLHS", cex.main = 2)
points(cs$sampled_data, pch = 3, cex = 1.2)


