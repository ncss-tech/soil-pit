library(sp)

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
test <- spsample(polys, n = 16, type = "stratified")
points(test, pch = 16, cex = 2)

dev.off()


png(file = "sample_multistage.png", width = 3, height = 3, units = "in", res = 300)
par(fin = c(3, 3), mai = c(0, 1, 0, 0))
plot(polys, main = "Two-stage random", cex.main = 2)

# Select 8 samples from each square
s <- sapply(slot(polys, 'polygons'), function(x) spsample(x, n = 8, type = "random"))
points(sample(s, 1)[[1]], pch = 16, cex = 2) # randomly select 1 square and plot
points(sample(s, 1)[[1]], pch = 16, cex = 2) # randomly select 1 square and plot

dev.off()



test <- as(extent(volcano_r), "SpatialPolygons") # create a polygon from the spatial extent of the volcano dataset

sr400 <- spsample(test, n = 400, type = "random") # take a large random sample
sr <- spsample(test, n = 20, type = "random") # take a small random sample
str <- spsample(test, n = 23, type = "stratified", iter = 1000) # take a small stratified random sample
str <- str[1:20]
# cs <- clhs(rs, size = 20, progress = FALSE, simple = FALSE) # take a cLHS sample

s <- rbind(cbind(method = "Simple Random",extract(rs, sr)),
                cbind(method = "Stratified Random", extract(rs, str)),
                cbind(method = "cLHS", cs$sampled_data@data)
)
s$slope <- as.numeric(s$slope)

col <- c("orange", "blue", "black")

densityplot(~ slope, group = method, data = s, xlab = "Slope Gradient (%)",
            col = col, lwd = 3, main = "Comparison of Different Sampling Methods", type = c("g", "n"),
            key = list(columns = 3, lines = list(col = col, lwd = 3), text = list(levels(as.factor(s$method))))
            )

            
par(mfrow = c(1, 3))
plot(volcano_r, main = "Simple random", cex.main = 2)
points(sr, pch = 3, cex = 1.2)

plot(volcano_r, main = "Stratified random", cex.main = 2)
points(str, pch = 3, cex = 1.2)

plot(volcano_r, main = "cLHS", cex.main = 2)
points(cs$sampled_data, pch = 3, cex = 1.2)


