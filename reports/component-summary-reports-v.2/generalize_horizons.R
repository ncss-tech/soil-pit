
## TODO: generalize work-flow

library(soilDB)
library(MASS)
library(cluster)
library(latticeExtra)
library(gridExtra)

# setup plotting style
tps <- list(box.umbrella=list(col=grey(0.4)), 
								box.rectangle=list(col=grey(0.4)), 
								box.dot=list(col=grey(0.4), cex=0.75), 
								plot.symbol=list(col=grey(0.4), cex=0.5)
						)


# get pedon data, should be pre-filtered in NASIS
f <- fetchNASIS()

# visual check
par(mar=c(0,0,3,3))
new.order <- order(profileApply(f, max, v='clay'))
plot(f, name='hzname', label='pedon_id', id.style='side', cex.depth.axis=1.25, cex.names=0.7, plot.order=new.order, max.depth=100)
abline(h=c(50, 75, 100, 150), lty=2, col='grey')

plot(f, name='hzname', label='pedon_id', id.style='side', color='clay', cex.depth.axis=1.25, cex.names=0.7, max.depth=100)
plot(f, name='hzname', label='pedon_id', id.style='side', color='total_frags_pct', cex.depth.axis=1.25, cex.names=0.7, max.depth=100)

# determine set of pedon IDs and save to report-rules.R
dput(f$pedon_id)


# compute horizon depth mid-point
f$hz.mid.depth <- (f$hzdepb + f$hzdept) / 2


# eval similarity via principal coordinatess (clay + hz top boundary + total frag volume)
no.na.idx <- which(complete.cases(horizons(f)[, c('clay', 'hz.mid.depth', 'total_frags_pct')]))
d <- daisy(horizons(f)[no.na.idx, c('clay', 'hz.mid.depth', 'total_frags_pct')], stand=TRUE)

# reduce to 2D principle coordinates: fudge 0-distances by adding a little bit
f.pc <- isoMDS(d+0.001, trace=FALSE)
f$pc.1 <- rep(NA, times=nrow(horizons(f)))
f$pc.2 <- rep(NA, times=nrow(horizons(f)))
f$pc.1[no.na.idx] <- f.pc$points[, 1]
f$pc.2[no.na.idx] <- f.pc$points[, 2]

# eval original horizonation
sort(table(f$hzname), decreasing=TRUE)

# generalize horizons:
# note: 'genhz' column will eventially contain generalized hz labels in NASIS
n=c('A', 'Bw', 'C', 'Cr', 'R')
p=c('A|A1|A2', 'Bw|B2', 'BC$|C$', 'Cr', 'R')
f$genhz <- generalize.hz(f$hzname, n, p)

# check
table(f$genhz, f$hzname)

# sort hz names by principal coordinate 1 and clay content for plotting
pc1.levels <- names(sort(tapply(f$pc.1, f$hzname, median, na.rm=TRUE)))
clay.levels <- names(sort(tapply(f$clay, f$hzname, median, na.rm=TRUE)))

# plot distributions by original horizonation
p.pc.original <- bwplot(factor(hzname, levels=pc1.levels) ~ pc.1, data=horizons(f), subset=!is.na(pc.1), par.settings=tps)
p.clay.original <- bwplot(factor(hzname, levels=clay.levels) ~ clay, data=horizons(f), subset=!is.na(clay), par.settings=tps)
p.pc.genhz <- bwplot(genhz ~ pc.1, data=horizons(f), subset=!is.na(pc.1), par.settings=tps)
p.clay.genhz <- bwplot(genhz ~ clay, data=horizons(f), subset=!is.na(clay), par.settings=tps)

# annotate plots with original horizons
p.pc.genhz.final <- p.pc.genhz + layer(panel.text(x=f$pc.1[!is.na(f$pc.1), drop=TRUE], y=jitter(as.numeric(f$genhz[!is.na(f$pc.1), drop=TRUE]), factor=2), label=f$hzname[!is.na(f$pc.1), drop=TRUE], cex=0.75, font=2, col='RoyalBlue'))
p.clay.genhz.final <- p.clay.genhz  + layer(panel.text(x=f$clay[!is.na(f$clay), drop=TRUE], y=jitter(as.numeric(f$genhz[!is.na(f$clay), drop=TRUE]), factor=1.5), label=f$hzname[!is.na(f$clay), drop=TRUE], cex=0.75, font=2, col='RoyalBlue'))


# combine plots
p.clay <- c(p.clay.original, p.clay.genhz.final, x.same=TRUE, y.same=FALSE, layout=c(1,2))
p.pc <- c(p.pc.original, p.pc.genhz.final, x.same=TRUE, y.same=FALSE, layout=c(1,2))

# composite plots into a single figure
grid.arrange(p.pc, p.clay, ncol=2)

# visual check
f$newhz <- paste(f$hzname, f$genhz, sep='|')
plot(f, name='newhz', id.style='side')


# principal coordinate plot
# add point label: pedonID + horizon label
f$pc.label <- rep(NA, times=nrow(f))
f$pc.label[no.na.idx] <- with(as(f, 'data.frame')[no.na.idx, ], paste(hzname, pedon_id, sep='\n'))

# convert side+horizons into single table data and drop horizon labels that don't have data
f.h <- as(f, 'data.frame')[no.na.idx, ]
f.h$genhz <- factor(f.h$genhz)

# principal coordinate plot
pcplot <- xyplot(pc.2 ~ pc.1, groups=genhz, data=f.h, xlab='', ylab='', cex=2.5, scales=list(draw=FALSE), auto.key=list(columns=length(levels(f.h$genhz))), par.settings=list(superpose.symbol=list(pch=16, cex=2, alpha=0.5)), aspect=1) 

# annotate with original horizon name + pedon ID
pcplot + layer(panel.text(f.h$pc.1, f.h$pc.2, f.h$hzname, cex=0.85, font=2))

pcplot + layer(panel.text(f.h$pc.1, f.h$pc.2, f.h$hzname, cex=0.85, font=2, pos=3)) + layer(panel.text(f.h$pc.1, f.h$pc.2, f.h$pedon_id, cex=0.55, font=1, pos=1))
