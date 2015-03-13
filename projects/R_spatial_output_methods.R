# some notes on possible ways to display pedon data in GE by generating kml file from the SPC using the plotKML package
# adding the file to GE as a network link with a periodic refresh
# attempting to simplify this process as much as possible

library(soilDB)
library(rgdal)

# lots of dependent packages - might want to install it to make sure you have them all
#install.packages("plotKML", dep=TRUE)
library(plotKML)

f <- fetchNASIS()

# remove sites without coordinates
keep.idx <- which(!is.na(f$x))
f <- f[keep.idx, ]

# extract site data
s <- site(f)

# plot data as KML
# set environment
plotKML.env(silent = FALSE, kmz = FALSE)
# initialize coordinates
coordinates(s) <- ~ x + y
proj4string(s) <- '+proj=longlat +datum=NAD83'
# create kml file
# Note: the file.name option writes the file to C:\Users\jay.skovlin\Documents\R_sites.kml
# TODO: Is there a way to stop the plotKML function from automatically opening the file when it is generated?
# this one passes in the site_id and taxonname as label fields, but could pass in any field from the SPC
plotKML(s, colour_scale=rep("#FFFF00", 2), points_names=paste(s$site_id, s$taxonname, sep=", "), folder.name="Sites", file.name="R_sites.kml")

# this creates a file called R_sites.kml - if it were saved to a standard location (C:\Users\jay.skovlin\Documents\R_sites.kml) 
# then this can be added as a network link with a periodic automatic refresh to GE
# it would then be a matter of re-running the plotKML() line to refresh the GE display and you wouldn't have to save and load the kml file
# each time a new file was generated

# here is a little bit fancier version with the siteobs date added as timestamp - this builds a time slider into the kml output
plotKML(s, colour_scale=rep("#FFFF00", 2), points_names=paste(s$site_id, s$taxonname, sep=", "), folder.name="Sites", file.name="R_sites.kml", TimeSpan.begin=format(s$obs_date, "%Y-%m-%d"), TimeSpan.end=format(s$obs_date, "%Y-%m-%d"))