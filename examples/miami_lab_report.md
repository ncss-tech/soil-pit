# Lab pedon report

```r
# Set soil series
series <- "Miami"

# Set percentiles
p <- c(0, 0.25, 0.5, 0.75, 1)
```




```
## finding horizonation errors ...
## horizon errors detected, use `get('bad.labpedon.ids', envir=soilDB.env)` for a list of pedon IDs
## NOTICE: multiple datums present
## NOTICE: duplicate horizons in query results, matching pedons:
## 1954IL111001
## converting Munsell to RGB ...
## mixing dry colors ... [3 of 41 horizons]
## mixing moist colors ... [74 of 878 horizons]
## replacing missing lower horizon depths with top depth + 1cm ... [1 horizons]
## finding horizonation errors ...
## horizon errors detected, use `get('bad.pedon.ids', envir=soilDB.env)` for a list of pedon IDs
```


## Brief summary of NCSS lab pedon data
![plot of chunk plot of pedons and locations](figure/plot of pedons and locations-1.png) 


|pedon_id       |taxonname |tax_subgroup        |part_size_class |pedon_type                         |describer                                         |
|:--------------|:---------|:-------------------|:---------------|:----------------------------------|:-------------------------------------------------|
|S1953IN177002  |MIAMI     |NA                  |NA              |NA                                 |NA                                                |
|S1982IL029040  |MIAMI     |typic hapludalfs    |fine-loamy      |NA                                 |NA                                                |
|S1981IN011002  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |NA                                                |
|S1981IN011006  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |NA                                                |
|S1981IN011012  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |NA                                                |
|S1981IN011016  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |NA                                                |
|S1982IN107001  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |Bill Hosteter                                     |
|S1982IN107002  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |Bill Hosteter                                     |
|S1982IN107005  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |Bill Hosteter and Doug Wolf                       |
|S1982IN107006  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |Bill Hosteter and Doug Wolf                       |
|78IN177007     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Williams and Blank                                |
|78IN177008     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Williams and Blank                                |
|84IN157023     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Mark McClain                                      |
|84IN157024     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Tom Ziegler                                       |
|83IL039008     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |NA                                                |
|84IN015011     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Bill Hosteter and Earnie Jensen                   |
|87IN107001     |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |WD Hosteter, Douglas Wolfe                        |
|87IN107008     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |B. Hostetler, J. Shively                          |
|88MI059003     |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |NA                                                |
|90IL045001     |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |R. Leeper and J. Brewbaker.                       |
|1968IN011001   |Miami     |NA                  |NA              |NA                                 |Sanders and Franzmeier                            |
|1968IN011007   |Miami     |NA                  |NA              |NA                                 |Sanders and Langlois                              |
|1968IN113001   |Miami     |NA                  |NA              |NA                                 |Franzmeier                                        |
|1968IN139001   |Miami     |NA                  |NA              |NA                                 |Zachary                                           |
|1969IN157001   |Miami     |NA                  |NA              |NA                                 |Meyers and Harlan                                 |
|1969IN157002   |Miami     |NA                  |NA              |NA                                 |Meyers and Harlan                                 |
|1977IN031004   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Shively                                           |
|1976IN151004   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Farmer                                            |
|1977IN177004   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Blank                                             |
|1977IN177008   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Blank and Meland                                  |
|1977IN177007   |Miami     |typic hapludalfs    |fine            |NA                                 |Blank and Meland                                  |
|1975IN023002   |Miami     |NA                  |NA              |NA                                 |Hosteter and Fink                                 |
|1976IN033003   |Miami     |NA                  |NA              |NA                                 |Sanders and Jensen                                |
|1974IN151002   |Miami     |NA                  |NA              |NA                                 |Farmer and Hillis                                 |
|1975IN169004   |Miami     |NA                  |NA              |NA                                 |Landrum and Langer                                |
|1975IN169009   |Miami     |NA                  |NA              |NA                                 |Ruesch and Landrum                                |
|1978IN065004   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Hillis and Le masters                             |
|1978IN031001   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Shively                                           |
|1979IN135033   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Neely and Houghtby                                |
|1979IN135034   |Miami     |typic hapludalfs    |fine            |NA                                 |Neely and Latowski                                |
|1978IN139008   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Brock and Rohleder                                |
|1977IN169017   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Langer and Schumacher                             |
|1978IN177007   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Williams and Blank                                |
|1978IN177008   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Williams and Blank                                |
|1980IN135063   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Neely and Latowski                                |
|1980IN139009   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Brock and Dalton                                  |
|1981IN085010   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Staley                                            |
|1983IN157001   |Miami     |typic hapludalfs    |NA              |NA                                 |Ziegler and Franzmeier                            |
|1984IN171025   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Shively                                           |
|1981IN007027   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Barnes and Plank                                  |
|1981IN047014   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Shively                                           |
|1984IN157023   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Mcclain and Ziegler                               |
|1984IN157024   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Ziegler and Hosteter                              |
|1986IL113004   |Miami     |oxyaquic hapludalfs |fine-loamy      |map unit inclusion                 |CLL                                               |
|1986IL113001   |Miami     |oxyaquic hapludalfs |fine-loamy      |map unit inclusion                 |CLL                                               |
|1984IL029003   |Miami     |oxyaquic hapludalfs |fine-loamy      |representative pedon for component |RGD, SCM                                          |
|1984IL029109   |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |AP, GH                                            |
|1984IL147022   |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |NA                                                |
|1955-OH141-010 |Miami     |NA                  |NA              |NA                                 |Petro & Finney                                    |
|1954-OH141-005 |Miami     |NA                  |NA              |NA                                 |Petro, Garner, Baldridge                          |
|1955-OH141-012 |Miami     |NA                  |NA              |NA                                 |Petro & Finney                                    |
|1954-OH027-013 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |bone                                              |
|1953-OH049-S21 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |n. holowaychuk                                    |
|1955-OH027-036 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |wiseman, bone                                     |
|1955-OH027-037 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |bone, siemond, schafer                            |
|1954-OH097-002 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |meeker, reese                                     |
|1955-OH097-003 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |schafer, reese                                    |
|1955-OH027-043 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |bone, wiseman                                     |
|1954-OH071-S16 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |dotson                                            |
|1954-OH057-001 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |evans, roseler                                    |
|1954-OH057-002 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |evans, roseler                                    |
|1954-OH023-S01 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |dotson, horse, holowaychuk                        |
|1954-OH021-S01 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |holowaychuk, dotson, morse                        |
|1955-OH141-013 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |petro, finney                                     |
|1959-OH017-S11 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |roseler, carner, reeder                           |
|1957-OH049-S32 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |n. holowaychuk, n. reeder                         |
|1960-OH165-041 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |garner, ernst                                     |
|1960-OH047-007 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |evans, reeder, donaoldson, petro                  |
|1959-OH135-016 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |schafer, lerch, hayhurst, Tornes, mcloda          |
|1958-OH021-005 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie                                           |
|1958-OH021-007 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie, evans                                    |
|1957-OH021-001 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie                                           |
|1958-OH021-004 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie                                           |
|1960-OH021-037 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie, dubford                                  |
|1960-OH135-056 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |mcloda, tornes, davis,                            |
|1959-OH021-015 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie, evans, powell, donaldson                 |
|1959-OH021-026 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie, powell                                   |
|1957-OH037-015 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |heffner, siegenthaler                             |
|1959-OH135-014 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, mcloda, tornes                             |
|1956-OH135-003 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, schafer                                    |
|1956-OH135-004 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, schafer                                    |
|1956-OH135-005 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, schafer                                    |
|1956-OH135-006 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, shcafer                                    |
|1956-OH141-018 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |evans, petro                                      |
|1956-OH141-027 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |r. h. jones                                       |
|1959-OH149-006 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |heffner, siegenthaler                             |
|1961-OH165-057 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |garner, ernst                                     |
|1963-OH113-010 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, davis, smeck                               |
|1961-OH021-047 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie, powell, siegenthaler                     |
|1961-OH091-011 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |heffner, siegenthaler, urban                      |
|1963-OH113-007 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, smeck, steiger, davis                      |
|1962-OH113-003 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |davis, lerch, calhoun                             |
|1971-OH017-002 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, & hale                                     |
|1967-OH049-007 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |r. l. blevens                                     |
|1969-OH047-003 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |petro                                             |
|1968-OH109-018 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lehman, bottrell                                  |
|1968-OH109-021 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lehman, bottrell                                  |
|1971-OH129-023 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |hall, williams, kerr, jones, mc kinney, le master |

```
## guessing horizon designations are stored in `hzname`
```

![plot of chunk format site data](figure/format site data-1.png) 


## Range in characteristics for NCSS pedon lab data
### Summary of soil profiles
Five number summary (min, 25th, median, 75th, max)(percentiles)

|variable           |range                   |
|:------------------|:-----------------------|
|noncarbclaywtavg   |(23, 28, 30, 32, 35)(9) |
|claytotwtavg       |(23, 28, 30, 32, 35)(9) |
|le0to100           |(0, 1, 2, 2, 2)(3)      |
|wf0175wtavgpsc     |(18, 24, 30, 34, 41)(9) |
|volfractgt2wtavg   |(0, 0, 2, 4, 5)(11)     |
|cec7clayratiowtavg |(45, 48, 50, 52, 54)(6) |

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png) 

```
## Error in eval(expr, envir, enclos): argument "by" is missing, with no default
```

```
## Error in melt(lp.thk, id.vars = "labpeiid", measure.vars = "thickness"): object 'lp.thk' not found
```

```
## Error in rbind(lp.lo1, lp.lo2): object 'lp.lo2' not found
```



|      variable      |          range          |
|:------------------:|:-----------------------:|
|  noncarbclaywtavg  | (23, 28, 30, 32, 35)(9) |
|    claytotwtavg    | (23, 28, 30, 32, 35)(9) |
|      le0to100      |   (0, 1, 2, 2, 2)(3)    |
|   wf0175wtavgpsc   | (18, 24, 30, 34, 41)(9) |
|  volfractgt2wtavg  |   (0, 0, 2, 4, 5)(11)   |
| cec7clayratiowtavg | (45, 48, 50, 52, 54)(6) |

```
## Error in na.exclude(lp.thk$thickness): object 'lp.thk' not found
```


### Summary of soil horizons


|         | 2B1| 2B2| 2B3| 2BC| 2BCt| 2BE2| 2Bt| 2Bt1| 2Bt2| 2Bt3| 2C| 2C1| 2C2| 2C3| 2C4| 2CBt|  A| A&B| A1| A2| A2/B1| A21| A22| A3| AB| Ap| AP| Ap1| AP1| Ap2| AP2|  B| B&A| B&C| B/C1| B1| B1T| B2| B21| B21T| B21T1| B21T2| B22| B22T| B23| B23T| B24T| B2T| B2T1| B2T2| B2T3| B3| B3-C1| B31| B32| B3T| B4| BA| BC| BC3| BCt| BCT| BCt1| BCt2| BE| BE1| BEt| Bt| Bt1| BT1| Bt2| BT2| Bt3| BT3| Bw|  C| C1| C1-B3| C11| C12| C2| C21| C22| C23| C3| C4| C5| CB| CBT|  E| E1| E2| EB| missing| Sum|
|:--------|---:|---:|---:|---:|----:|----:|---:|----:|----:|----:|--:|---:|---:|---:|---:|----:|--:|---:|--:|--:|-----:|---:|---:|--:|--:|--:|--:|---:|---:|---:|---:|--:|---:|---:|----:|--:|---:|--:|---:|----:|-----:|-----:|---:|----:|---:|----:|----:|---:|----:|----:|----:|--:|-----:|---:|---:|---:|--:|--:|--:|---:|---:|---:|----:|----:|--:|---:|---:|--:|---:|---:|---:|---:|---:|---:|--:|--:|--:|-----:|---:|---:|--:|---:|---:|---:|--:|--:|--:|--:|---:|--:|--:|--:|--:|-------:|---:|
|Ap       |   0|   0|   0|   0|    0|    0|   0|    0|    0|    0|  0|   0|   0|   0|   0|    0|  0|   0|  0|  0|     0|   0|   0|  0|  0| 52| 26|   3|   1|   3|   1|  0|   0|   0|    0|  0|   0|  0|   0|    0|     0|     0|   0|    0|   0|    0|    0|   0|    0|    0|    0|  0|     0|   0|   0|   0|  0|  0|  0|   0|   0|   0|    0|    0|  0|   0|   0|  0|   0|   0|   0|   0|   0|   0|  0|  0|  0|     0|   0|   0|  0|   0|   0|   0|  0|  0|  0|  0|   0|  0|  0|  0|  0|       0|  86|
|A        |   0|   0|   0|   0|    0|    0|   0|    0|    0|    0|  0|   0|   0|   0|   0|    0|  0|   0|  0| 14|     1|   2|   2|  2|  0|  0|  0|   0|   0|   0|   0|  0|   0|   0|    0|  0|   0|  0|   0|    0|     0|     0|   0|    0|   0|    0|    0|   0|    0|    0|    0|  0|     0|   0|   0|   0|  0|  0|  0|   0|   0|   0|    0|    0|  0|   0|   0|  0|   0|   0|   0|   0|   0|   0|  0|  0|  0|     0|   0|   0|  0|   0|   0|   0|  0|  0|  0|  0|   0|  0|  0|  0|  0|       0|  21|
|E        |   0|   0|   0|   0|    0|    0|   0|    0|    0|    0|  0|   0|   0|   0|   0|    0|  0|   0|  0|  0|     0|   0|   0|  0|  0|  0|  0|   0|   0|   0|   0|  0|   0|   0|    0|  0|   0|  0|   0|    0|     0|     0|   0|    0|   0|    0|    0|   0|    0|    0|    0|  0|     0|   0|   0|   0|  0|  0|  0|   0|   0|   0|    0|    0|  0|   0|   0|  0|   0|   0|   0|   0|   0|   0|  0|  0|  0|     0|   0|   0|  0|   0|   0|   0|  0|  0|  0|  0|   0| 14|  1|  1|  4|       0|  20|
|Bt       |   0|   0|   0|   0|    0|    0|   0|    0|    0|    0|  0|   0|   0|   0|   0|    0|  0|   0|  0|  0|     0|   0|   0|  0|  0|  0|  0|   0|   0|   0|   0|  0|   0|   0|    0|  0|   0|  0|   0|    0|     0|     0|   0|    0|   0|    0|    0|   0|    0|    0|    0|  0|     0|   0|   0|   0|  0|  0|  0|   0|   0|   0|    0|    0|  0|   0|   0|  0|  23|   6|  26|   6|  12|   7|  0|  0|  0|     0|   0|   0|  0|   0|   0|   0|  0|  0|  0|  0|   0|  0|  0|  0|  0|       0|  80|
|not-used |   0|   0|   0|   0|    0|    1|   0|    0|    0|    0|  0|   0|   0|   0|   0|    0| 10|   1| 16|  0|     0|   0|   0|  0|  1|  0|  0|   0|   0|   0|   0|  4|   1|   1|    1| 53|   3| 24|  12|   23|     1|     1|  14|   23|   3|   12|    1|   2|    1|    1|    1| 28|     1|   2|   2|   6|  1|  4|  0|   0|   0|   0|    0|    0| 25|   1|   2|  9|   0|   0|   0|   0|   0|   0|  1| 44| 56|     1|   1|   1| 52|   1|   1|   1| 21|  9|  3|  0|   0|  0|  0|  0|  0|       2| 486|
|2Bt      |   2|   2|   1|   0|    0|    0|   1|    3|    4|    3|  0|   0|   0|   0|   0|    0|  0|   0|  0|  0|     0|   0|   0|  0|  0|  0|  0|   0|   0|   0|   0|  0|   0|   0|    0|  0|   0|  0|   0|    0|     0|     0|   0|    0|   0|    0|    0|   0|    0|    0|    0|  0|     0|   0|   0|   0|  0|  0|  0|   0|   0|   0|    0|    0|  0|   0|   0|  0|   0|   0|   0|   0|   0|   0|  0|  0|  0|     0|   0|   0|  0|   0|   0|   0|  0|  0|  0|  0|   0|  0|  0|  0|  0|       0|  16|
|2BCt     |   0|   0|   0|   2|    2|    0|   0|    0|    0|    0|  0|   0|   0|   0|   0|    0|  0|   0|  0|  0|     0|   0|   0|  0|  0|  0|  0|   0|   0|   0|   0|  0|   0|   0|    0|  0|   0|  0|   0|    0|     0|     0|   0|    0|   0|    0|    0|   0|    0|    0|    0|  0|     0|   0|   0|   0|  0|  0| 28|   1|   5|   1|    1|    1|  0|   0|   0|  0|   0|   0|   0|   0|   0|   0|  0|  0|  0|     0|   0|   0|  0|   0|   0|   0|  0|  0|  0|  3|   1|  0|  0|  0|  0|       0|  45|
|2Cd      |   0|   0|   0|   0|    0|    0|   0|    0|    0|    0|  3|   4|   4|   2|   1|    1|  0|   0|  0|  0|     0|   0|   0|  0|  0|  0|  0|   0|   0|   0|   0|  0|   0|   0|    0|  0|   0|  0|   0|    0|     0|     0|   0|    0|   0|    0|    0|   0|    0|    0|    0|  0|     0|   0|   0|   0|  0|  0|  0|   0|   0|   0|    0|    0|  0|   0|   0|  0|   0|   0|   0|   0|   0|   0|  0|  0|  0|     0|   0|   0|  0|   0|   0|   0|  0|  0|  0|  0|   0|  0|  0|  0|  0|       0|  15|
|Sum      |   2|   2|   1|   2|    2|    1|   1|    3|    4|    3|  3|   4|   4|   2|   1|    1| 10|   1| 16| 14|     1|   2|   2|  2|  1| 52| 26|   3|   1|   3|   1|  4|   1|   1|    1| 53|   3| 24|  12|   23|     1|     1|  14|   23|   3|   12|    1|   2|    1|    1|    1| 28|     1|   2|   2|   6|  1|  4| 28|   1|   5|   1|    1|    1| 25|   1|   2|  9|  23|   6|  26|   6|  12|   7|  1| 44| 56|     1|   1|   1| 52|   1|   1|   1| 21|  9|  3|  3|   1| 14|  1|  1|  4|       2| 769|

```
## Error in eval(expr, envir, enclos): argument "by" is missing, with no default
```



|  genhz   |           hzdept            |            hzdepb            |          thickness          |
|:--------:|:---------------------------:|:----------------------------:|:---------------------------:|
|    Ap    |    (0, 0, 0, 0, 20)(86)     |   (8, 15, 18, 20, 30)(86)    |   (8, 15, 18, 20, 25)(84)   |
|    A     |   (5, 8, 13, 18, 28)(21)    |   (13, 18, 23, 30, 38)(21)   |   (7, 9, 10, 12, 20)(19)    |
|    E     |  (5, 10, 15, 18, 122)(20)   |  (15, 20, 23, 28, 137)(20)   |    (5, 7, 8, 10, 15)(18)    |
|    Bt    |   (8, 25, 40, 48, 79)(80)   |   (23, 43, 54, 66, 99)(80)   |   (7, 13, 17, 22, 33)(77)   |
| not-used |  (0, 28, 51, 86, 732)(486)  | (5, 41, 70, 108, 8888)(486)  | (-79, 10, 16, 25, 106)(497) |
|   2Bt    |  (23, 40, 54, 70, 89)(16)   |  (38, 58, 70, 85, 102)(16)   |  (10, 12, 15, 20, 23)(11)   |
|   2BCt   |  (28, 56, 64, 71, 104)(45)  |  (36, 66, 79, 94, 133)(45)   |   (5, 10, 13, 21, 39)(42)   |
|   2Cd    | (69, 96, 102, 131, 165)(15) | (89, 127, 142, 160, 190)(15) |  (18, 21, 28, 47, 71)(10)   |

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png) 


## Range in characteristics for generic horizons 
Five number summary (min, 25th, median, 75th, max)(percentiles) and total number of observations (n)


|  genhz   |            sandvc             |             sandco              |             sandmed             |             sandfine              |
|:--------:|:-----------------------------:|:-------------------------------:|:-------------------------------:|:---------------------------------:|
|    Ap    |  (0, 0.9, 1.2, 1.6, 3.3)(66)  |    (0, 2, 2.7, 3.5, 6.5)(67)    | (0.8, 3.2, 4.7, 7.3, 21.4)(67)  |   (1, 6.5, 8.5, 12.2, 21.9)(67)   |
|    A     |   (0, 0.5, 1, 1.4, 2.8)(21)   |   (1, 1.7, 2.5, 2.9, 5.6)(21)   | (1.3, 2.7, 3.5, 5.6, 12.7)(21)  |   (2.4, 4.9, 7.5, 13, 21.5)(21)   |
|    E     | (0.2, 0.7, 1.3, 2.2, 2.8)(10) |  (0.8, 2.2, 3.1, 3.7, 4.5)(12)  |   (1.5, 3, 3.2, 4.5, 7.8)(12)   |       (2, 5, 6, 8, 12)(12)        |
|    Bt    |  (0, 1.3, 1.8, 2.3, 4.4)(66)  |  (0.7, 2.8, 3.5, 4.3, 6.3)(66)  | (1.2, 4.3, 8.5, 11.1, 15.8)(66) |  (2, 10.1, 13.6, 16.8, 25.6)(66)  |
| not-used | (0, 1.3, 2.4, 3.9, 12.6)(383) | (0.4, 2.9, 4.2, 5.9, 31.7)(391) |  (0.8, 4, 5.9, 8.6, 28.9)(391)  | (1.5, 7.6, 10.2, 14.1, 26.2)(391) |
|   2Bt    | (0.8, 1.5, 1.8, 2.2, 3.3)(13) |    (2, 3, 3.4, 3.8, 4.1)(13)    |   (3.4, 4, 5.8, 8.6, 9.1)(13)   |  (5, 8.9, 12.9, 14.8, 16.8)(13)   |
|   2BCt   |      (1, 2, 3, 4, 6)(39)      |  (1.4, 3.6, 4.5, 5.2, 8.6)(39)  |  (1.4, 4, 4.8, 6.9, 13.2)(39)   |  (3.7, 7.8, 8.9, 12.8, 18.4)(39)  |
|   2Cd    |   (2, 3.2, 4.2, 5, 7.3)(10)   |      (3, 5, 8, 8, 11)(10)       |      (4, 6, 6, 8, 16)(10)       |  (6, 11.7, 15.1, 16.2, 20.8)(10)  |


|  genhz   |              sandvf              |              sandtot              |               siltco               |              siltfine              |
|:--------:|:--------------------------------:|:---------------------------------:|:----------------------------------:|:----------------------------------:|
|    Ap    |   (1, 4.5, 6.4, 8.2, 14.8)(67)   | (4.2, 18.7, 24.4, 31.9, 56.2)(83) |  (8.9, 15.2, 19, 23.8, 36.7)(39)   | (18.4, 30.3, 35.9, 41.6, 53.3)(39) |
|    A     |    (2.5, 4.4, 7, 9, 14.8)(21)    | (7.8, 14.8, 23.8, 32.9, 55.6)(21) |      (13, 15, 21, 23, 23)(6)       |  (30.2, 32.2, 33.5, 39, 53.5)(6)   |
|    E     |  (1.4, 5.2, 5.8, 7.1, 9.8)(12)   |      (6, 16, 19, 26, 46)(19)      | (13.4, 13.6, 15.5, 19.9, 27.4)(4)  |      (35, 38, 39, 42, 48)(4)       |
|    Bt    |   (1, 5.5, 7.2, 9.5, 11.7)(66)   |  (8.8, 21.5, 34, 41.1, 58.4)(76)  |  (7.2, 9.2, 11.1, 12.5, 29.7)(51)  | (8.2, 18.4, 19.7, 24.2, 37.3)(51)  |
| not-used | (1.2, 6.1, 8.1, 10.4, 40.9)(391) | (0, 23.2, 31.4, 39.2, 86.6)(477)  | (0.5, 11.8, 14.4, 16.5, 31.5)(168) |      (4, 20, 24, 28, 52)(169)      |
|   2Bt    |    (2, 5.1, 8, 9.4, 10.7)(13)    | (15, 23.8, 33.2, 39.3, 41.5)(13)  |      (10, 11, 12, 16, 17)(8)       |  (19, 20.8, 21.2, 22.5, 23.4)(8)   |
|   2BCt   |  (3.7, 6.9, 8.2, 10, 15.4)(39)   |     (11, 25, 31, 37, 54)(45)      | (8.7, 12.2, 13.7, 14.8, 28.4)(12)  | (16.5, 17.8, 22.5, 26.2, 33.4)(12) |
|   2Cd    |  (4, 8.2, 9.4, 10.1, 13.2)(10)   |     (22, 39, 42, 45, 63)(10)      |  (5.7, 14.2, 14.4, 14.5, 21.9)(5)  |   (17.4, 25, 25.5, 28, 28.6)(5)    |


|  genhz   |              silttot               |          claycarb          |             clayfine              |              claytot               |
|:--------:|:----------------------------------:|:--------------------------:|:---------------------------------:|:----------------------------------:|
|    Ap    | (28.1, 50.6, 56.1, 64.9, 72.7)(83) |  (NA, NA, NA, NA, NA)(0)   |       (2, 3, 4, 7, 15)(31)        |      (7, 16, 18, 20, 29)(83)       |
|    A     |  (32.3, 52.8, 57, 65.1, 71.5)(21)  |  (NA, NA, NA, NA, NA)(0)   |   (1.4, 3.4, 4, 5.5, 11.5)(12)    |   (9, 15.2, 18, 20.4, 28.2)(21)    |
|    E     |   (42, 54.7, 59.1, 66, 73.5)(19)   |  (NA, NA, NA, NA, NA)(0)   |   (2.2, 3.2, 3.9, 5.4, 9.3)(10)   |  (11, 15.2, 18.7, 22.8, 27.2)(19)  |
|    Bt    |      (18, 29, 34, 38, 62)(76)      |  (NA, NA, NA, NA, NA)(0)   |  (7, 15.1, 18.7, 20.8, 23.2)(18)  | (15.2, 26.9, 31.9, 38.2, 50.7)(76) |
| not-used |     (5, 35, 41, 46, 100)(477)      | (0.8, 0.9, 1.7, 2, 2.5)(9) | (0.8, 6.6, 9.4, 17.2, 29.7)(211)  |   (3, 19, 26.3, 33.6, 54.4)(476)   |
|   2Bt    |      (30, 33, 37, 40, 55)(13)      |  (NA, NA, NA, NA, NA)(0)   | (12.6, 16.5, 17.7, 18.9, 22.3)(8) |  (22, 25.3, 30.7, 34.7, 43.6)(13)  |
|   2BCt   |      (26, 36, 40, 44, 52)(45)      | (0, 0.3, 0.6, 0.8, 1.1)(2) |   (6, 10, 11.5, 14.1, 22.9)(31)   |  (14.3, 25, 29.4, 32.4, 45.9)(45)  |
|   2Cd    |      (23, 39, 40, 43, 50)(10)      |     (0, 0, 0, 0, 0)(2)     |    (3.9, 4.4, 5, 5.1, 7.1)(8)     |      (14, 16, 16, 18, 27)(10)      |


|  genhz   |          carbonorganicpct          |           carbontotalpct           |      fragwt25       |      fragwt520      |
|:--------:|:----------------------------------:|:----------------------------------:|:-------------------:|:-------------------:|
|    Ap    | (0.4, 0.96, 1.11, 1.25, 3.12)(38)  |    (0.7, 1, 1.3, 1.5, 4.3)(40)     | (0, 1, 1, 1, 2)(8)  | (0, 1, 2, 3, 3)(8)  |
|    A     | (0.29, 0.53, 0.58, 1.08, 1.27)(11) |   (0.2, 0.7, 0.7, 0.7, 2.3)(10)    | (0, 0, 0, 0, 0)(1)  | (0, 0, 0, 0, 0)(1)  |
|    E     | (0.71, 0.74, 0.76, 0.79, 0.82)(2)  | (0.35, 0.62, 0.75, 1.1, 1.68)(16)  | (0, 0, 0, 0, 0)(1)  | (0, 0, 0, 0, 0)(1)  |
|    Bt    | (0.16, 0.32, 0.39, 0.43, 1.06)(35) |   (0.3, 0.5, 0.5, 0.6, 0.9)(15)    | (0, 1, 2, 3, 6)(24) | (0, 1, 2, 2, 6)(24) |
| not-used |    (0, 0.3, 0.4, 0.6, 5.6)(90)     | (0.06, 0.41, 0.51, 0.68, 4.41)(92) | (0, 0, 3, 4, 6)(23) | (0, 0, 1, 4, 7)(23) |
|   2Bt    | (0.14, 0.22, 0.31, 0.33, 0.44)(6)  |    (0.2, 0.3, 0.4, 0.5, 0.5)(3)    | (2, 2, 2, 3, 3)(6)  | (1, 1, 1, 2, 5)(6)  |
|   2BCt   |    (0.1, 0.2, 0.2, 0.3, 0.3)(5)    | (0.58, 0.58, 0.58, 0.58, 0.58)(1)  | (3, 3, 4, 4, 6)(4)  | (2, 3, 4, 4, 4)(4)  |
|   2Cd    |  (0.08, 0.1, 0.13, 0.23, 0.33)(3)  |      (NA, NA, NA, NA, NA)(0)       | (4, 4, 5, 5, 5)(3)  | (3, 4, 4, 4, 5)(3)  |


|  genhz   |     fragwt2075      |      fragwt275       |        wtpct0175         |      wtpctgt2ws      |
|:--------:|:-------------------:|:--------------------:|:------------------------:|:--------------------:|
|    Ap    | (0, 0, 0, 0, 5)(8)  |  (0, 2, 4, 5, 7)(8)  |  (2, 17, 23, 31, 52)(8)  |  (0, 2, 4, 5, 7)(8)  |
|    A     | (0, 0, 0, 0, 0)(1)  |  (0, 0, 0, 0, 0)(1)  | (23, 23, 23, 23, 23)(1)  |  (0, 0, 0, 0, 0)(1)  |
|    E     | (0, 0, 0, 0, 0)(1)  |  (0, 0, 0, 0, 0)(1)  | (24, 24, 24, 24, 24)(1)  |  (0, 0, 0, 0, 0)(1)  |
|    Bt    | (0, 0, 0, 1, 3)(24) | (0, 3, 5, 7, 9)(24)  | (21, 30, 33, 38, 50)(24) | (0, 3, 5, 7, 9)(24)  |
| not-used | (0, 0, 0, 0, 1)(23) | (0, 1, 4, 8, 12)(23) | (4, 27, 33, 38, 46)(23)  | (0, 1, 4, 8, 12)(23) |
|   2Bt    | (0, 0, 0, 2, 6)(6)  | (3, 3, 4, 6, 14)(6)  | (29, 31, 33, 34, 39)(6)  | (3, 3, 4, 6, 14)(6)  |
|   2BCt   | (0, 0, 1, 2, 3)(4)  | (8, 8, 8, 8, 10)(4)  | (37, 38, 39, 40, 41)(4)  | (8, 8, 8, 8, 10)(4)  |
|   2Cd    | (0, 0, 0, 0, 1)(3)  |  (9, 9, 9, 9, 9)(3)  | (36, 37, 38, 46, 54)(3)  |  (9, 9, 9, 9, 9)(3)  |


|  genhz   |           ph1to1h2o            |           ph01mcacl2           |            resistivity            |                ec                 |
|:--------:|:------------------------------:|:------------------------------:|:---------------------------------:|:---------------------------------:|
|    Ap    | (4.7, 5.7, 6.2, 6.9, 7.7)(83)  | (4.5, 5.3, 5.6, 6.1, 7.3)(34)  |      (NA, NA, NA, NA, NA)(0)      |      (NA, NA, NA, NA, NA)(0)      |
|    A     | (4.5, 5.1, 5.7, 6.4, 7.5)(21)  |  (4.7, 5.1, 5.6, 6.3, 7.1)(3)  |      (NA, NA, NA, NA, NA)(0)      |      (NA, NA, NA, NA, NA)(0)      |
|    E     |  (4.6, 5, 5.2, 6.5, 7.4)(19)   |       (5, 5, 5, 5, 5)(1)       |      (NA, NA, NA, NA, NA)(0)      |      (NA, NA, NA, NA, NA)(0)      |
|    Bt    |  (4.4, 5.3, 6, 6.8, 8.3)(76)   | (4.2, 4.6, 5.3, 6.2, 7.3)(40)  |      (NA, NA, NA, NA, NA)(0)      |      (NA, NA, NA, NA, NA)(0)      |
| not-used | (4.5, 5.7, 7.1, 7.9, 8.6)(478) | (4.2, 5.7, 7.1, 7.6, 8.2)(143) |      (NA, NA, NA, NA, NA)(0)      |      (NA, NA, NA, NA, NA)(0)      |
|   2Bt    |   (4.6, 5, 6, 7.1, 8.3)(13)    |   (4.2, 4.3, 4.5, 6, 7.2)(6)   |      (NA, NA, NA, NA, NA)(0)      |      (NA, NA, NA, NA, NA)(0)      |
|   2BCt   | (4.9, 7.2, 7.7, 7.9, 8.6)(45)  |  (5.5, 7.2, 7.5, 7.5, 7.7)(7)  |      (NA, NA, NA, NA, NA)(0)      | (0.33, 0.33, 0.33, 0.33, 0.33)(1) |
|   2Cd    | (7.7, 7.8, 7.9, 8.3, 8.5)(10)  |  (7.6, 7.6, 7.7, 7.7, 7.7)(3)  | (6300, 6300, 6300, 6300, 6300)(1) | (0.27, 0.27, 0.28, 0.28, 0.28)(2) |


|  genhz   |         esp          |           sar           |           cecsumcations            |                cec7                |
|:--------:|:--------------------:|:-----------------------:|:----------------------------------:|:----------------------------------:|
|    Ap    | (0, 0, 0, 1, 14)(17) | (NA, NA, NA, NA, NA)(0) | (10.3, 11.9, 13.5, 16.2, 20.9)(35) | (10.3, 11.1, 12.3, 15.1, 16.4)(17) |
|    A     |  (0, 0, 0, 1, 3)(5)  | (NA, NA, NA, NA, NA)(0) | (7.3, 10.4, 11.3, 12.8, 17.6)(12)  |   (5, 6.6, 10.4, 10.4, 11.1)(5)    |
|    E     |  (0, 0, 0, 0, 0)(8)  | (NA, NA, NA, NA, NA)(0) | (10.3, 11.4, 11.9, 14.9, 24.9)(10) |  (10.3, 11.7, 12, 14.2, 15.3)(8)   |
|    Bt    | (0, 0, 1, 1, 16)(23) | (NA, NA, NA, NA, NA)(0) | (7.2, 15.3, 20.8, 23.5, 31.4)(28)  |  (8.6, 13.3, 15.3, 21, 31.4)(23)   |
| not-used | (0, 0, 0, 1, 12)(53) | (NA, NA, NA, NA, NA)(0) |     (10, 16, 18, 21, 30)(127)      | (5.4, 13.6, 17.1, 21.3, 29.2)(53)  |
|   2Bt    | (0, 0, 1, 1, 3)(11)  | (NA, NA, NA, NA, NA)(0) | (15.6, 17.7, 19.7, 20.9, 24.6)(9)  |  (12, 12.6, 17.6, 20.5, 24.6)(11)  |
|   2BCt   | (1, 2, 2, 10, 19)(3) |   (0, 0, 0, 0, 0)(1)    |      (NA, NA, NA, NA, NA)(0)       |    (8, 8.3, 8.7, 10.2, 11.8)(3)    |
|   2Cd    |  (0, 0, 1, 1, 1)(3)  |   (0, 0, 0, 0, 0)(2)    |      (NA, NA, NA, NA, NA)(0)       |    (5.7, 6.2, 6.7, 6.8, 6.9)(3)    |


|  genhz   |               ecec               |             sumbases              |      basesatsumcations       |        basesatnh4oac         |
|:--------:|:--------------------------------:|:---------------------------------:|:----------------------------:|:----------------------------:|
|    Ap    |   (9.8, 9.8, 9.8, 9.8, 9.8)(1)   |  (4.8, 7.7, 9.9, 11.7, 15.7)(17)  |   (34, 54, 61, 68, 84)(35)   |   (4, 7, 14, 68, 100)(37)    |
|    A     |     (NA, NA, NA, NA, NA)(0)      |    (1.6, 3, 5.5, 6.5, 6.7)(6)     |   (23, 41, 50, 58, 83)(12)   |    (2, 5, 6, 34, 64)(13)     |
|    E     |     (NA, NA, NA, NA, NA)(0)      |    (1.1, 4, 5.7, 8.1, 15.1)(9)    |   (11, 32, 38, 59, 79)(10)   |    (5, 22, 34, 39, 79)(9)    |
|    Bt    |  (9, 10.1, 11.6, 12.9, 15.4)(8)  |  (7.8, 11.4, 13, 17.1, 23.5)(25)  |   (43, 55, 62, 77, 93)(29)   |   (4, 62, 77, 85, 100)(28)   |
| not-used | (9.9, 11.3, 12.7, 13.7, 14.7)(3) | (4.7, 8.6, 11.6, 15.4, 28.6)(51)  |  (31, 51, 63, 74, 100)(132)  |  (4, 10, 15, 60, 100)(136)   |
|   2Bt    |  (9.8, 9.9, 10.1, 11, 12.7)(4)   |   (7.8, 8.5, 12, 15.9, 16.5)(9)   |   (48, 50, 65, 80, 94)(11)   |  (50, 66, 71, 80, 100)(11)   |
|   2BCt   |     (NA, NA, NA, NA, NA)(0)      | (25.7, 25.7, 25.7, 25.7, 25.7)(1) |   (96, 97, 98, 99, 100)(2)   | (100, 100, 100, 100, 100)(3) |
|   2Cd    |     (NA, NA, NA, NA, NA)(0)      |      (NA, NA, NA, NA, NA)(0)      | (100, 100, 100, 100, 100)(3) | (100, 100, 100, 100, 100)(3) |


|  genhz   |       caco3equiv        |             feoxalate             |                fetotal                 |             sioxalate             |
|:--------:|:-----------------------:|:---------------------------------:|:--------------------------------------:|:---------------------------------:|
|    Ap    | (NA, NA, NA, NA, NA)(0) | (0.61, 0.61, 0.61, 0.61, 0.61)(1) | (21092, 22100, 23108, 24116, 25124)(2) | (0.04, 0.04, 0.04, 0.04, 0.04)(1) |
|    A     | (NA, NA, NA, NA, NA)(0) |      (NA, NA, NA, NA, NA)(0)      |        (NA, NA, NA, NA, NA)(0)         |      (NA, NA, NA, NA, NA)(0)      |
|    E     | (NA, NA, NA, NA, NA)(0) |      (NA, NA, NA, NA, NA)(0)      |        (NA, NA, NA, NA, NA)(0)         |      (NA, NA, NA, NA, NA)(0)      |
|    Bt    |   (0, 0, 0, 4, 7)(3)    |      (NA, NA, NA, NA, NA)(0)      | (25609, 25609, 25609, 25609, 25609)(1) |      (NA, NA, NA, NA, NA)(0)      |
| not-used | (3, 23, 28, 34, 50)(79) | (0.69, 0.69, 0.69, 0.69, 0.69)(1) | (15477, 20109, 24742, 29374, 34006)(2) | (0.05, 0.05, 0.05, 0.05, 0.05)(1) |
|   2Bt    |   (0, 0, 1, 2, 2)(2)    | (0.53, 0.62, 0.71, 0.73, 0.76)(3) | (31679, 32532, 33384, 33628, 33872)(3) | (0.05, 0.05, 0.06, 0.06, 0.07)(3) |
|   2BCt   | (10, 16, 18, 20, 24)(6) | (0.28, 0.28, 0.28, 0.28, 0.28)(1) | (25871, 25871, 25871, 25871, 25871)(1) | (0.07, 0.07, 0.07, 0.07, 0.07)(1) |
|   2Cd    | (23, 26, 28, 30, 31)(3) | (0.12, 0.12, 0.13, 0.13, 0.14)(2) | (15971, 16787, 17602, 18418, 19234)(2) | (0.04, 0.04, 0.04, 0.05, 0.05)(2) |


|  genhz   |           extracid            |            extral            |             aloxalate             |                altotal                 |
|:--------:|:-----------------------------:|:----------------------------:|:---------------------------------:|:--------------------------------------:|
|    Ap    | (2.4, 4.2, 5.7, 6.2, 9.5)(35) | (0.3, 0.3, 0.3, 0.3, 0.3)(1) | (0.16, 0.16, 0.16, 0.16, 0.16)(1) | (26484, 32800, 39115, 45430, 51746)(2) |
|    A     | (3, 4.4, 5.6, 6.7, 10.2)(12)  |   (NA, NA, NA, NA, NA)(0)    |      (NA, NA, NA, NA, NA)(0)      |        (NA, NA, NA, NA, NA)(0)         |
|    E     | (2.5, 5.8, 9.2, 9.5, 9.8)(10) |   (NA, NA, NA, NA, NA)(0)    |      (NA, NA, NA, NA, NA)(0)      |        (NA, NA, NA, NA, NA)(0)         |
|    Bt    | (0.9, 4.6, 6.3, 8, 12.7)(29)  | (0.5, 0.6, 1.2, 1.4, 2.2)(8) |      (NA, NA, NA, NA, NA)(0)      | (31040, 31040, 31040, 31040, 31040)(1) |
| not-used | (0.6, 5, 6.5, 9.2, 14.7)(127) | (1.2, 1.5, 1.7, 2.2, 2.7)(3) |   (0.2, 0.2, 0.2, 0.2, 0.2)(1)    | (34129, 41621, 49112, 56604, 64096)(2) |
|   2Bt    | (1.8, 4.1, 7.7, 8.4, 9.4)(11) | (0.7, 1.3, 1.7, 1.9, 2.1)(4) | (0.11, 0.13, 0.16, 0.16, 0.17)(3) | (60455, 61226, 61997, 62918, 63838)(3) |
|   2BCt   | (1.2, 1.2, 1.2, 1.2, 1.2)(1)  |   (NA, NA, NA, NA, NA)(0)    | (0.07, 0.07, 0.07, 0.07, 0.07)(1) | (47938, 47938, 47938, 47938, 47938)(1) |
|   2Cd    |    (NA, NA, NA, NA, NA)(0)    |   (NA, NA, NA, NA, NA)(0)    | (0.02, 0.02, 0.02, 0.02, 0.02)(2) | (34133, 35101, 36070, 37038, 38006)(2) |


|  genhz   |            ptotal            |             dbthirdbar             |             dbovendry              |       aggstabpct        |
|:--------:|:----------------------------:|:----------------------------------:|:----------------------------------:|:-----------------------:|
|    Ap    | (427, 451, 474, 498, 522)(2) |   (1.3, 1.5, 1.5, 1.6, 1.7)(11)    | (1.35, 1.56, 1.64, 1.73, 1.77)(11) |  (3, 8, 14, 20, 25)(2)  |
|    A     |   (NA, NA, NA, NA, NA)(0)    |      (NA, NA, NA, NA, NA)(0)       | (1.53, 1.53, 1.53, 1.53, 1.53)(1)  | (NA, NA, NA, NA, NA)(0) |
|    E     |   (NA, NA, NA, NA, NA)(0)    | (2.06, 2.06, 2.06, 2.06, 2.06)(1)  | (2.08, 2.08, 2.08, 2.08, 2.08)(1)  | (NA, NA, NA, NA, NA)(0) |
|    Bt    | (295, 295, 295, 295, 295)(1) | (1.5, 1.54, 1.57, 1.63, 1.78)(23)  | (1.58, 1.66, 1.7, 1.73, 1.84)(23)  | (NA, NA, NA, NA, NA)(0) |
| not-used | (305, 326, 347, 368, 389)(2) | (1.23, 1.59, 1.82, 1.87, 2.02)(27) | (1.09, 1.64, 1.83, 1.9, 2.07)(31)  | (NA, NA, NA, NA, NA)(0) |
|   2Bt    | (387, 390, 394, 450, 505)(3) | (1.42, 1.51, 1.55, 1.59, 1.66)(9)  |  (1.52, 1.6, 1.69, 1.72, 1.77)(9)  |   (3, 3, 3, 3, 3)(1)    |
|   2BCt   | (486, 486, 486, 486, 486)(1) | (1.62, 1.69, 1.76, 1.81, 1.87)(3)  | (1.73, 1.77, 1.81, 1.88, 1.95)(3)  | (NA, NA, NA, NA, NA)(0) |
|   2Cd    | (326, 333, 340, 347, 354)(2) |  (1.7, 1.8, 1.88, 1.96, 1.98)(8)   |  (1.8, 1.85, 1.92, 1.98, 2.03)(8)  | (NA, NA, NA, NA, NA)(0) |


|  genhz   |           wthirdbarclod            |            wfifteenbar            |          wretentiondiffws          |         wfifteenbartoclay          |
|:--------:|:----------------------------------:|:---------------------------------:|:----------------------------------:|:----------------------------------:|
|    Ap    | (16.5, 17.4, 20.3, 21.9, 24.7)(11) |  (7.5, 9.2, 10.2, 11, 14.7)(13)   |    (0.1, 0.1, 0.2, 0.2, 0.2)(6)    |   (0.4, 0.4, 0.4, 0.5, 0.9)(13)    |
|    A     |      (NA, NA, NA, NA, NA)(0)       |       (9, 9, 10, 10, 10)(2)       |      (NA, NA, NA, NA, NA)(0)       |  (0.4, 0.44, 0.48, 0.53, 0.57)(2)  |
|    E     |    (9.7, 9.7, 9.7, 9.7, 9.7)(1)    | (10.8, 11.3, 11.8, 12.4, 12.9)(2) |      (NA, NA, NA, NA, NA)(0)       | (0.52, 0.53, 0.54, 0.55, 0.56)(2)  |
|    Bt    |  (15.9, 18.2, 19.2, 21, 23.7)(23)  |   (8, 10.5, 11.8, 13, 23.5)(25)   | (0.08, 0.11, 0.13, 0.14, 0.16)(17) | (0.33, 0.39, 0.42, 0.44, 0.52)(25) |
| not-used |  (10.7, 12.4, 15.3, 20, 26.4)(27)  |      (5, 8, 12, 18, 29)(44)       |   (0.1, 0.1, 0.1, 0.2, 0.2)(17)    | (0.3, 0.43, 0.47, 0.61, 1.92)(42)  |
|   2Bt    |      (16, 19, 20, 22, 22)(9)       | (10.1, 10.5, 11.5, 12.7, 12.9)(7) | (0.13, 0.14, 0.14, 0.15, 0.15)(6)  | (0.41, 0.41, 0.42, 0.43, 0.49)(6)  |
|   2BCt   |  (13.6, 15.3, 17, 18.1, 19.2)(3)   |   (8, 8.5, 9.6, 16.2, 17.7)(8)    |  (0.07, 0.1, 0.12, 0.15, 0.17)(2)  |    (0.4, 0.5, 0.5, 0.6, 0.6)(8)    |
|   2Cd    |      (11, 12, 13, 14, 17)(8)       |   (5.5, 6.9, 7.8, 7.9, 8.1)(5)    | (0.11, 0.12, 0.14, 0.14, 0.14)(3)  |  (0.4, 0.42, 0.43, 0.45, 0.48)(3)  |


|  genhz   |                  adod                   |                  cole                   |       liquidlimit       |           pi            |
|:--------:|:---------------------------------------:|:---------------------------------------:|:-----------------------:|:-----------------------:|
|    Ap    |  (1.006, 1.008, 1.01, 1.012, 1.015)(8)  |  (0.009, 0.014, 0.019, 0.02, 0.026)(6)  | (33, 33, 34, 34, 34)(2) | (13, 14, 16, 17, 18)(2) |
|    A     |         (NA, NA, NA, NA, NA)(0)         |         (NA, NA, NA, NA, NA)(0)         | (NA, NA, NA, NA, NA)(0) | (NA, NA, NA, NA, NA)(0) |
|    E     |         (NA, NA, NA, NA, NA)(0)         |         (NA, NA, NA, NA, NA)(0)         | (NA, NA, NA, NA, NA)(0) | (NA, NA, NA, NA, NA)(0) |
|    Bt    | (1.01, 1.013, 1.015, 1.016, 1.024)(21)  | (0.013, 0.019, 0.024, 0.026, 0.029)(17) | (34, 34, 34, 34, 34)(1) | (21, 21, 21, 21, 21)(1) |
| not-used | (1.004, 1.006, 1.009, 1.016, 1.021)(22) | (0.003, 0.008, 0.01, 0.019, 0.043)(17)  | (23, 27, 31, 35, 39)(2) | (10, 12, 15, 18, 20)(2) |
|   2Bt    | (1.013, 1.013, 1.014, 1.016, 1.025)(7)  | (0.019, 0.019, 0.021, 0.028, 0.031)(6)  | (36, 36, 36, 36, 36)(1) | (22, 22, 22, 22, 22)(1) |
|   2BCt   | (1.006, 1.008, 1.008, 1.009, 1.011)(4)  | (0.013, 0.015, 0.017, 0.019, 0.021)(2)  | (NA, NA, NA, NA, NA)(0) | (NA, NA, NA, NA, NA)(0) |
|   2Cd    | (1.006, 1.007, 1.007, 1.011, 1.013)(5)  | (0.007, 0.008, 0.008, 0.013, 0.018)(3)  | (20, 20, 20, 20, 20)(1) |   (8, 8, 8, 8, 8)(1)    |


|  genhz   |             cec7clay              |
|:--------:|:---------------------------------:|
|    Ap    |      (NA, NA, NA, NA, NA)(0)      |
|    A     |      (NA, NA, NA, NA, NA)(0)      |
|    E     |      (NA, NA, NA, NA, NA)(0)      |
|    Bt    |      (NA, NA, NA, NA, NA)(0)      |
| not-used | (0.36, 0.41, 0.46, 0.46, 0.47)(3) |
|   2Bt    |      (NA, NA, NA, NA, NA)(0)      |
|   2BCt   | (0.53, 0.53, 0.53, 0.53, 0.53)(1) |
|   2Cd    | (0.41, 0.42, 0.42, 0.42, 0.43)(2) |

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 


|         |  c|  cl| cos| fsl|   l| sc| scl| si| sic| sicl| sil| sl| Sum|
|:--------|--:|---:|---:|---:|---:|--:|---:|--:|---:|----:|---:|--:|---:|
|Ap       |  0|   3|   0|   1|  13|  0|   1|  0|   0|    1|  63|  1|  83|
|A        |  0|   0|   0|   1|   2|  0|   0|  0|   0|    1|  17|  0|  21|
|E        |  0|   0|   0|   0|   1|  0|   0|  0|   0|    1|  17|  0|  19|
|Bt       | 11|  37|   0|   0|  14|  0|   5|  0|   2|    5|   2|  0|  76|
|not-used | 48| 127|   1|  18| 181|  1|   8|  1|   6|   35|  49|  2| 477|
|2Bt      |  1|   6|   0|   0|   4|  0|   0|  0|   0|    1|   1|  0|  13|
|2BCt     |  1|  25|   0|   1|  14|  0|   0|  0|   1|    3|   0|  0|  45|
|2Cd      |  0|   1|   0|   1|   8|  0|   0|  0|   0|    0|   0|  0|  10|
|Sum      | 61| 199|   1|  22| 237|  1|  14|  1|   9|   47| 149|  3| 744|


