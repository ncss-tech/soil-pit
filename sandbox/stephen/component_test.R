library(soilDB)
library(vegan)

test <- fetchNASIS_component_data(rmHzErrors = F)
test2 <- subsetProfiles(test, s = "compname == 'Patton'")

h <- horizons(test2)
horizons(test2)$hzdepm_r <- with(h, (hzdepb_r - hzdept_r) / 2)

vars <- c("fragvoltot_r", "sandtotal_r", "claytotal_l", "claytotal_r", "claytotal_h")
d <- profile_compare(test2, vars = vars, k = 0, max_d = 200)

h <- hclust(d)
plot(as.dendrogram(h))

plot(metaMDS(d))
