##
## TODO: 
## 1. further generalize functions so that they can be used for arbitrary pedon collections
## 2. import into SVN repo
## 3. use PO-logistic regression for horizon probability depth-functions
## 4. on component reports, use textural triangle density plot 
## 5. coallate TODO items from local_functions.R
## 6. generalize functions, move to sharpshootR package
## 7. other output formats: http://stackoverflow.com/questions/11025123/how-to-convert-r-markdown-to-pdf

## Notes:
## 1. pedons must be defined in report-rules
## 2. pedons must have WGS84 coordinates


## load libraries
library(knitr)
library(markdown)

## 1. generalize horizons... needs work

## 2. apply GHL using rules / pedons listed in report-rules.R
# source('apply_genhz_rules.R')

## 3. load rules into NASIS

## 4. report generation: 
setwd('reports')


## manual reports
comp <- 'amador'
save(comp, file='this.component.Rda')
knit('component-report.Rmd', quiet=TRUE) ; markdownToHTML('component-report.md', paste(comp, '.html', sep=''))


## generate component reports, one for each with gen hz rules
source('../genhz_rules.R')
# iterate over components with gen hz rules and make reports
for(comp in names(gen.hz.rules)) {
	filename <- paste(gsub(' ', '_', comp), '.html', sep='')
	save(comp, file='this.component.Rda')
	knit('component-report.Rmd', quiet=TRUE) ; markdownToHTML('component-report.md', filename)
}

