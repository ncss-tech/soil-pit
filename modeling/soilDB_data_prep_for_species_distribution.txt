library(soilDB)

# load data
f <- fetchNASIS()
ext_data <- get_extended_data_from_NASIS_db()

# extended data tables
str(ext_data)
# site existing veg data
head(ext_data$veg)

#subset siteexisting veg data to species
d <- ext_data$veg[ext_data$veg$plantsym == 'CORA', ]

# join subset to the site data by common siteiid
site(f) <- d

# create new dataframe from site(f)
idx <- complete.cases(site(f)[, c("site_id", "x_std",  "y_std")])
species.df <- site(f)[idx, c("site_id", "x_std",  "y_std", "plantsym")]

table(factor(species.df$plantsym))
head(species.df)