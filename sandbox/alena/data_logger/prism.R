library(prism)

get_prism_annual(type="all", years = 2000:2007, keepZip = TRUE)

get_prism_dailys()

get_prism_normals()

get_prism_monthlys(type="tmean", years = 2000:2007, keepZip = FALSE)

#list the available data sets to load that have already been downloaded
ls_prism_data(absPath = TRUE, name=TRUE)

