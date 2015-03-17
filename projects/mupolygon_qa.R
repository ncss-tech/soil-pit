mupolygon <- read.csv("mupolygon.csv", stringsAsFactors=FALSE)
id <- mupolygon$Editor_Field != ""
edit <- mupolygon[id, ]

# Summarize tabular changes
id <- edit$MUSYM != edit$ORIG_MUSYM
tab <- edit[id, ]

ddply(tab, .(MUSYM), summarize, n = length(ORIG_MUSYM), p = paste0(c(unique(ORIG_MUSYM)), collapse=","))

# Summarize spatial changes
id <- edit$MUSYM == test$ORIG_MUSYM
spa <- edit[id, ]
