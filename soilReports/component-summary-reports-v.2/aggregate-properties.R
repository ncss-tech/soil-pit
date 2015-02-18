library(soilDB)
library(lattice)
library(colorspace)
library(reshape2)
library(plyr)

x <- fetchNASIS(rmHzErrors = FALSE, nullFragsAreZero = FALSE)

# subset select taxa
idx <- grep('whiterock|copperopolis|shabarudo|dunstone|loafercreek|crimeahouse|hennekenot', x$taxonname, ignore.case = TRUE)
x <- x[idx, ]

# compute redness via LAB color space
x.moist.LAB <- as(with(horizons(x), RGB(m_r, m_g, m_b)), 'LAB')
x$A <- x.moist.LAB@coords[, 2]

# normalize taxonnames
for(i in c('Whiterock', 'Copperopolis', 'Shabarudo', 'Dunstone', 'Loafercreek', 'Crimeahouse', 'Hennekenot'))
  x$taxonname[grep(i, x$taxonname, ignore.case = TRUE)] <- i

# check
table(x$taxonname)

# generalize geology
x$gengeology <- rep(NA, times=length(x))
x$gengeology[x$taxonname %in% c('Whiterock', 'Copperopolis')] <- 'Mariposa Slate'
x$gengeology[x$taxonname %in% c('Shabarudo')] <- 'Ione Formation'
x$gengeology[x$taxonname %in% c('Dunstone', 'Loafercreek')] <- 'Metavolcanic Rocks'
x$gengeology[x$taxonname %in% c('Crimeahouse', 'Hennekenot')] <- 'Serpentenite'

# check
table(x$taxonname, x$gengeology)


# aggregate by generalized geology
a <- slab(x, gengeology ~ clay + total_frags_pct + phfield + A, slab.fun=aqp:::.slab.fun.numeric.fast)

# combine gen. geol names with number of pedons
bedrock.tab <- table(x$gengeology)
a$gengeology <- factor(a$gengeology, levels=names(bedrock.tab), labels=paste(names(bedrock.tab), ' (', bedrock.tab, ')', sep=''))

# re-name soil property labels
levels(a$variable) <- c('Clay Content (%)', '>2mm Frag. Volume (%)', 'pH', 'Redness Index')

# define plotting style
tps <- list(superpose.line=list(col=c('RoyalBlue', 'DarkRed', 'DarkGreen', 'DarkOrange'), lwd=2))

# plot
p1 <- xyplot(top ~ p.q50 | variable, groups=gengeology, data=a, ylab='Depth',
       xlab='median bounded by 25th and 75th percentiles',
       lower=a$p.q25, upper=a$p.q75, ylim=c(105,-5),
       panel=panel.depth_function, alpha=0.25, sync.colors=TRUE,
       prepanel=prepanel.depth_function,
       cf=a$contributing_fraction,
       strip=strip.custom(bg=grey(0.85)),
       layout=c(4,1), scales=list(x=list(alternating=1, relation='free'), y=list(alternating=3)),
       par.settings=tps,
       auto.key=list(columns=4, lines=TRUE, points=FALSE)
)

# save as PDF
pdf(file='aggregate-soil-properties.pdf', width=11, height=8.5)
plot(p1)
dev.off()


# aggregate data by generalized taxonname
a.colors <- slab(x, taxonname ~ m_r + m_g + m_b + clay + phfield + total_frags_pct, slab.fun=mean, na.rm=TRUE)
a.colors <- subset(a.colors, subset=bottom < 150)

# convert long -> wide format
x.colors <- dcast(a.colors, taxonname + top + bottom ~ variable, value.var = 'value')

# generate a color for plotting, from RGB triplets
x.colors$soil_color <- NA
not.na <- which(complete.cases(x.colors[, c('m_r', 'm_g', 'm_b')]))
x.colors$soil_color[not.na] <- with(x.colors[not.na, ], rgb(m_r, m_g, m_b))

# aggregate bedrock depth probabilty by taxonname
x$soil.flag <- rep('soil', times=nrow(x))
x$soil.flag[grep('Cd|Cr|R', x$hzname)] <- 'not-soil'
table(x$soil.flag)

# slice-wise probabilities sum to 1
a.ml.soil <- slab(x, taxonname ~ soil.flag, cpm=1)

# extract depth at specific probability of contact
depth.prob <- ddply(a.ml.soil, 'taxonname', .fun=function(i) {
  min(i$top[which(i$not.soil >= 0.90)])
})

# add soil top and fix names
names(depth.prob)[2] <- 'soil.bottom'
depth.prob$soil.top <- 0

# init SPC and splice-in 90% soil interval as site attribute
depths(x.colors) <- taxonname ~ top + bottom
site(x.colors) <- depth.prob

# generate index for new ordering
new.order <- match(c('Whiterock', 'Copperopolis', 'Shabarudo', 'Dunstone', 'Loafercreek', 'Crimeahouse', 'Hennekenot'), profile_id(x.colors))

# save to PDF
pdf(file='profile-summaries.pdf', width=7, height=13)
par(mar=c(1,0,3,0), mfrow=c(4,1))
plot(x.colors, divide.hz=FALSE, name='', plot.order=new.order, col.label='Soil Color', lwd=1.25, axis.line.offset=-6, cex.depth.axis=1, cex.id=1)
addBracket(x.colors$soil.top, x.colors$soil.bottom, col='black', label='Pr(soil >= 90%)', label.cex=0.6)
title('Aggregate Soil Properties (mean)')

plot(x.colors, divide.hz=FALSE, color='clay', name='', plot.order=new.order, col.label='Clay Content (%)', lwd=1.25, axis.line.offset=-6, cex.depth.axis=1, cex.id=1)
addBracket(x.colors$soil.top, x.colors$soil.bottom, col='black', label='Pr(soil >= 90%)', label.cex=0.6)

plot(x.colors, divide.hz=FALSE, color='phfield', name='', plot.order=new.order, col.label='pH', lwd=1.25, axis.line.offset=-6, cex.depth.axis=1, cex.id=1)
addBracket(x.colors$soil.top, x.colors$soil.bottom, col='black', label='Pr(soil >= 90%)', label.cex=0.6)

plot(x.colors, divide.hz=FALSE, color='total_frags_pct', name='', plot.order=new.order, col.label='Total Rock Fragment Volume (%)', lwd=1.25, axis.line.offset=-6, cex.depth.axis=1, cex.id=1)
addBracket(x.colors$soil.top, x.colors$soil.bottom, col='black', label='Pr(soil >= 90%)', label.cex=0.6)

dev.off()
