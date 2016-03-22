## Purpose: apply GHL rules to selected pedons, and save to C:/data/horizon_agg.txt
## Author: D.E. Beaudette 
## Date: 2014-11-20

# load GLH rules and pedon ID selection
source('report-rules.R')

# load current NASIS data
f <- fetchNASIS()

# clear-out any existing files
rules.file <- 'C:/data/horizon_agg.txt'
write.table(data.frame(), file=rules.file, row.names=FALSE, quote=FALSE, na='', col.names=FALSE, sep='|')

# iterate over rules
for(comp in names(gen.hz.rules)) {
  # extract pedons listed in this rule
#   subset.idx <- which(f$pedon_id %in% gen.hz.rules[[comp]]$pedons)
  subset.idx <- grep(pattern=comp, f$taxonname, ignore.case=TRUE)
  
  f.i <- f[subset.idx, ]
  
  # generalize horizons:
  f.i$genhz <- generalize.hz(f.i$hzname, gen.hz.rules[[comp]]$n, gen.hz.rules[[comp]]$p)
  
  # extract horizons
  h <- horizons(f.i)
  
  # strip-out 'not-used' values
  h <- h[which(h$genhz != 'not-used'), c('phiid', 'genhz')]
  
  # append to NASIS import file
  if(nrow(h) > 0)
    write.table(h, file=rules.file, row.names=FALSE, quote=FALSE, na='', col.names=FALSE, sep='|', append=TRUE)
}

