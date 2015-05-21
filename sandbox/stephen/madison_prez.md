
Digital summaries of legacy pedon descriptions
========================================================
author: Stephen Roecker, Dylan Beaudette, Jay Skovlin, Skye Wills
date: 6/1/2015


Legacy pedon data within the US
========================================================


```
total = 606595 ,  total lab pedons = ~64k
```

![plot of chunk unnamed-chunk-1](madison_prez-figure/unnamed-chunk-1-1.png) 




NRCS soil databases
========================================================

* Text files (more like text boxes)
    * Official Series Descriptions (OSD)
    * Ecological Site Descriptions (ESD)
* Databases
    * Soil Characterization Database (Access)
    * National Soil Information System (NASIS) (SQL Server)
        * SSURGO and Soil Data Access (SDA) (snapshots) 
        * STASTGO2
        

Figure of NASIS table structure
========================================================
* Illustrate child tables
* Discuss MS SQL Server
* Point data vs. aggregate data
* "The original digital soil morphometrics"


Tools for interacting with NASIS
========================================================
* Analysis
    1. Excel
    2. Pedon PC Plus / Analysis PC
    3. NASIS and Access
    4. R
* Public consumption of SSURGO
    1. SoilWeb
    2. Web Soil Survey
    3. Soil Data Viewer
    4. SSURGO file geodatabases
    5. R

_* sorted by user sophistication_
    
    
NASIS and R: what a team
========================================================
* soilDB R package
    1. querying, formatting and cleaning functions

Question ?
========================================================
**How many Professors heard teach a course in Data Analysis?**
