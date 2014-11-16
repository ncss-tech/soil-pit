# Intersect ca795_int, ca795_a, and govt_ownership. Calculate Geometry. Export from ArcMap. Import to R. Run following script.

test<-tapply(data$acres, list(MUSYM=data$MUSYM, AGENCY=data$AGENCY), sum, na.rm=TRUE)