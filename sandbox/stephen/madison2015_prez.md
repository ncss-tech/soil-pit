
.libPaths(c("C:/R/win-library/3.1", "C:/Program Files/R/R-3.1.1/library"))

Digital summaries of legacy pedon descriptions
========================================================
author: Stephen Roecker, Dylan Beaudette, Jay Skovlin, Skye Wills
date: 6/1/2015


NRCS soil databases
========================================================

1. National Soil Information System (NASIS) (SQL Server)
   * SSURGO and Soil Data Access
   * STASTGO2
2. Soil Characterization Database (Access)
3. Ecological Site Descriptions (Text)
4. Official Series Descriptions (Text)

_* sorted by database sophistication_


Legacy pedon data within the US
========================================================


```r
library(aqp)
library(soilDB)
library(plyr)
library(ggplot2)
library(reshape2)
library(stringr)
library(knitr)


pedons <- c(577, 6152, 9517, 19058, 42587, 112182, 231609, 184913)
year <- c("<1950s", "1950s", "1960s", "1970s", "1980s", "1990s", "2000s", "2010s")

cat("# pedons = ", formatC(sum(pedons), big.mark = ",", format = "fg"), "\n", "# lab pedons = ~64,000", sep = "")
```

```
# pedons = 606,595
# lab pedons = ~64,000
```

```r
ggplot(data.frame(pedons, year), aes(x=year, y=pedons)) + geom_bar(stat="identity")
```

![plot of chunk unnamed-chunk-1](madison2015_prez-figure/unnamed-chunk-1-1.png) 

```r
# There has been lots of talk about the number or Soil Series, Components, Map units, etc... but little focus on the point data resource.
# Lots of talk about collecting new data, but little appreciation for existing data.
```




NASIS data structure
========================================================
![alt text](figures/nasis.png)



- Released in 1994, custom Microsft SQL Server
- Tables for: field pedons, lab pedons, component data, map units, legends, and projects
- Functions for: queries, tables, reports, interpretations, calculations/validations, and exports



NASIS data structure
=======================================================

### Horizon data

### Site (Covariate) data
- slope
- landform
- precipitation
- etc...


Tools for interacting with soil data
========================================================
### Tabular analysis

    1. Pencil and paper
    2. Excel
    3. PedonPC and AnalysisPC (Microsoft Access template) 
    4. NASIS
    5. R

### Spatial analysis
    1. SoilWeb
    2. Web Soil Survey
    3. Soil Data Viewer
    4. SSURGO file geodatabases
    5. R
    
_* sorted by user sophistication_




Objective
========================================================
### Problems
    1. Data is underutilized
    2. Inefficient tools
    3. Fluid series concepts
    4. Vaguely defined uncertainty metrics
    5. Data isn't digitized
    6. Tools are difficulat (especially R?)

### Solution ?
    1. standardized R reports




Why hasn't this been done already
========================================================
![alt text](figures/genhz-sketch.png)

- description styles
- legacy nomenclature
- varying depths




Methods
========================================================
0. Setup ODBC connection and install additional packages
1. Develop and assign a generic horizonation
2. Generate report and evaluate


[&#8594;&nbsp;extended tutorial for horizon generalization](https://r-forge.r-project.org/scm/viewvc.php/*checkout*/docs/aqp/gen-hz-assignment.html?root=aqp)
<br>
[&#8594;&nbsp;extended tutorial for R reports (Region 11 SharePoint)](https://ems-team.usda.gov/sites/NRCS_SSRA/mo-11/Soils%20%20GIS/Forms/AllItems.aspx?RootFolder=%2Fsites%2FNRCS%5FSSRA%2Fmo%2D11%2FSoils%20%20GIS%2Fguides%2FR&FolderCTID=0x0120007929E36D8FF15644B2C3F1488664C3CD&View=%7BFE55388F%2DFD5F%2D4A7B%2D98BD%2DA1F618066492%7D)


Assumptions
========================================================
- horizonation is exists and is accurate
- a subset of pedons (sample) should represent a component (population or aggregate)
- some semi-automated process is necessary to efficiently summarize soil data
- null hypthesis - pedons are assumed similar unless significantly(?) different 
- low-rv-high values should approximate the bulk of the distribution




Develop a typical horization
========================================================
- Look up the series RIC if available

![alt text](figures/RIC.png)

- sort by frequency

- graphically examine


Assign generic horizonation
========================================================
- pattern matching via [regular expression](http://www.regexr.com/) (REGEX)
 - this is where most micro-correlation decisions are defined

- GHL and rules for our sample dataset:
  - **A**: `^A$|Ad|Ap`
  - **Bt1**: `Bt1$`
  - **Bt2**: `^Bt2$`
  - **Bt3**: `^Bt3|^Bt4|CBt$|BCt$|2Bt|2CB$|^C$`
  - **Cr**: `Cr`
  - **R**: `R`

- special characters in REGEX rules: 
 - `|` = "or"
 - `^` = anchor to left-side
 - `$` = anchor to right-side



Evaluate typical horizonation
========================================================




Evaluate typical horizonation
========================================================

![plot of chunk plot-ghl-1](madison2015_prez-figure/plot-ghl-1-1.png) 

Demonstrate Reports
========================================================
- open existing reports

[&#8594;&nbsp;examples of R reports](https://github.com/ncss-tech/soil-pit/tree/master/examples)


Closing thoughts
========================================================
- we have a wealth of existing data
- data on soil series should be viewed in aggregate
- "we shouldn't let the perfect be the enemy of the good"
- reproducible research is good
- Soil scientists are great at collecting data, but we have to just as good at analyzing it.




Thank you, any questions...?
========================================================
**Links to Reports and supporting material**
- <span class="link-to-details">&#8594;&nbsp;[NCSS Job-Aids](http://www.nrcs.usda.gov/wps/portal/nrcs/detail/soils/edu/ncss/?cid=nrcs142p2_054322)</span>
- <span class="link-to-details">&#8594;&nbsp;[aqp tutorials](http://aqp.r-forge.r-project.org/)</span>
- <span class="link-to-details">&#8594;&nbsp;[soil-pit Github repository](https://github.com/sroecker01/soil-pit)
<br><br>

**Additional AQP Contributors:**
- Pierre Roudier (Landcare Research)

**Acknowledgements**
- Alena Stephens, John Hammerly, Jennifer Outcalt, Henry Ferguson, Paul Finnell, and others...
