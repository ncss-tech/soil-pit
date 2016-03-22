##
## TODO: 
## 3. use PO-logistic regression for horizon probability depth-functions
## 4. on component reports, use textural triangle density plot 
## 5. coallate TODO items from local_functions.R
## 6. generalize functions, move to sharpshootR package

## Notes:
## 1. pedons must be defined in report-rules
## 2. pedons must have WGS84 coordinates


## load libraries
library(rmarkdown)

## 1. generalize horizons... needs work

## 2. apply GHL using rules / pedons listed in report-rules.R
## can be done either by pedon ID list, or pattern matching of taxonname
# source('apply_genhz_rules.R')

## 3. load rules into NASIS

## manual reports
comp <- 'pentz'
path <- 'reports/'
filename <- paste(path, comp, '.html', sep='')
save(comp, file='this.component.Rda')
render('component-report.Rmd', output_format='html_vignette', output_file=filename, quiet = TRUE, clean=TRUE)



## generate component reports, one for each with gen hz rules
source('genhz_rules.R')
# iterate over components with gen hz rules and make reports
for(comp in names(gen.hz.rules)) {
	filename <- paste(gsub(' ', '_', comp), '.html', sep='')
	save(comp, file='this.component.Rda')
	render('component-report.Rmd', output_format='html_vignette', output_file=filename, quiet=TRUE, clean=TRUE)
}

