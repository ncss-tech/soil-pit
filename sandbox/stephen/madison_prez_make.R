# Set soil series
series <- "Miami"

# Set percentiles
p <- c(0.5, 0.5, 0.95)

# load libraries
library(aqp)
library(soilDB)
library(plyr)
library(ggplot2)
library(reshape2)
library(stringr)
library(knitr)
library(maps)

setwd("C:/workspace/soil-pit/trunk/soil_reports")
source("report_functions.R")
source(paste0("./genhz_rules/", series, "_rules.R"))


# load NASIS data
l <- fetchNASISLabData()
f <- fetchNASIS()

lh <- horizons(l)
lp <- site(l)
h <- horizons(f)
s <- site(f)

names(lh) <- unlist(strsplit(names(lh), "measured"))
lh$cec7clay <- round(lh$cec7 / (lh$claytot - lh$claycarb), 2)
lp$cec7clayratiowtavg <- lp$cec7clayratiowtavg * 100

for (i in seq(nrow(lh))){
  if (is.na(lh$hzname[i])) {lh$hzname[i] <-lh$hznameoriginal[i]}
}

lh$hzname[is.na(lh$hzname)] <- "missing"
lh$genhz <- generalize.hz(lh$hzname, ghr$n, ghr$p)
horizons(l) <- lh
lh$hzdepm <- (lh$hzdept + lh$hzdepb)/2
genhz_med <- sort(tapply(lh$hzdepm, lh$genhz, median))
l$genhz <- factor(lh$genhz, levels = names(genhz_med), ordered = TRUE)                                                                                                       

h$hzname[is.na(h$hzname)] <- "missing"
h$genhz <- generalize.hz(h$hzname, ghr$n, ghr$p)
horizons(f) <- h
h$hzdepm <- (h$hzdept + h$hzdepb)/2
genhz_med <- sort(tapply(h$hzdepm, h$genhz, median))
f$genhz <- factor(h$genhz, levels = names(genhz_med), ordered = TRUE)                                                                                                       

lh <- horizons(l)
h <- horizons(f)

h <- data.frame(lapply(h, na_replace), stringsAsFactors = FALSE)


lh.num <- lh[c(12:(ncol(lh)-4), ncol(lh)-1, ncol(lh))]
lh.num <- Filter(f = function(x) !all(is.na(x)), x = lh.num)
lh.lo <- melt(lh.num, id.vars="genhz", measure.vars=names(lh.num)[c(1:(ncol(lh.num)-1))])
lh.5n <- ddply(lh.lo, .(variable, genhz), .fun=sum5n)
lh.c <- dcast(lh.5n, genhz~variable, value.var = "range")

lh.c