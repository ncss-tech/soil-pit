library(aqp)
library(dplyr)

options(stringsAsFactors = FALSE)

data <- read.csv("M:/projects/dsp/dsp_data.csv")
site <- read.csv("M:/projects/dsp/dsp_site.csv")
label <- read.csv("M:/projects/dsp/dsp_label.csv")

ddply(data, .(DSP.Project), summarize, n_pedons = length(unique(UserPedonID)), n_compare = length(unique(Comparison)))
by(data, data["DSP.Project"], function(x) table(x$Comparison))



site$UserPedonID <- site$User.Pedon.ID
coords <- c("Std.Longitude", "Std.Latitude")
site_sub <- site[complete.cases(site[coords]), ]
data_site <- join(site_sub, data, by = "UserPedonID")



names(data_site)[grep("Std.", names(data_site))] <- c("y", "x")
names(data_site) <- tolower(gsub("\\.", "_", names(data_site)))
data_spc <- data_site
depths(data_spc) <- UserPedonID ~ hor_top + hor_bottom
site(data_spc) <- ~ x + y + drainagecl +
coordinates(data_spc) <- ~ x + y
