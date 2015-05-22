
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

* Official Series Descriptions (Text)
* Ecological Site Descriptions (Text)
* Soil Characterization Database (Access)
* National Soil Information System (NASIS) (SQL Server)
   * SSURGO and Soil Data Access (snapshots)
   * STASTGO2
        

NASIS table structure
========================================================
* Illustrate child tables
* Discuss MS SQL Server
* Point data vs. aggregate data
* "The original digital soil morphometrics"

Lets Recap
=======================================================
* Image of soil scientist digging a hole, possibly collecting samples, processing samples, entering data, now what?
* Lots of work
* The purpose isn't to collect data, or to populate a database, it's to analyze data!!!
* Maybe use Stella's day in the life image


Tools for interacting with NASIS
========================================================
* Analysis
    1. Pen and paper
    2. Excel
    3. NASIS and Access
    4. R
* Public consumption of SSURGO
    1. SoilWeb
    2. Web Soil Survey
    3. Soil Data Viewer
    4. SSURGO file geodatabases
    5. R
    
_* sorted by user sophistication_
    
    
NASIS and R: a software duo
========================================================
* soilDB R package
    1. querying, formatting and cleaning functions

Questions and thoughts ?
========================================================
**How many Professors here teach a course in Data Analysis?**

**If not, why not?**

**Soil scientists are great at collecting data, but we have to just as good at analyzing it.**
