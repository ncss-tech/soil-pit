mydata <- fetchNASIS()

#plot profiles
plotSPC(mydata, name="hzname", alt.label="pedon_id")
title('NASIS Pedons', line=1, cex.main=1)

source("rmenu.R")