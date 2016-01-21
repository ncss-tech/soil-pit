# Lab pedon report

```r
# Set soil series
series <- "Miami"

# Set percentiles
p <- c(0, 0.25, 0.5, 0.75, 1)
```




```
## finding horizonation errors ...
```

```
## horizon errors detected, use `get('bad.labpedon.ids', envir=soilDB.env)` for a list of pedon IDs
```

```
## NOTICE: multiple `labsampnum` values / horizons; see pedon IDs:
## 1954IL111001
```

```
## mixing dry colors ... [3 of 48 horizons]
```

```
## mixing moist colors ... [74 of 969 horizons]
```

```
## replacing missing lower horizon depths with top depth + 1cm ... [1 horizons]
```

```
## -> QC: horizon errors detected, use `get('bad.pedon.ids', envir=soilDB.env)` for related userpedonid values
```


## Brief summary of NCSS lab pedon data
![plot of chunk plot of pedons and locations](figure/plot of pedons and locations-1.png)


|pedon_id       |taxonname |tax_subgroup        |part_size_class |pedon_type                         |describer                                                                                                                          |
|:--------------|:---------|:-------------------|:---------------|:----------------------------------|:----------------------------------------------------------------------------------------------------------------------------------|
|1998IN011001   |Miami     |oxyaquic hapludalfs |fine-loamy      |correlates to named soil           |Scot Haley USDA-NRCS Resource Soil Scientist, Jerry Larson USDA-NRCS Soil Data Quality Specialist, Bennie Clark MLRA Project Lader |
|1992IN0350935  |Miami     |typic hapludalfs    |fine-loamy      |correlates to named soil           |Gary R. Struben                                                                                                                    |
|S1953IN177002  |MIAMI     |NA                  |NA              |NA                                 |NA                                                                                                                                 |
|S1982IL029040  |MIAMI     |typic hapludalfs    |fine-loamy      |NA                                 |NA                                                                                                                                 |
|S1981IN011002  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |NA                                                                                                                                 |
|S1981IN011006  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |NA                                                                                                                                 |
|S1981IN011012  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |NA                                                                                                                                 |
|S1981IN011016  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |NA                                                                                                                                 |
|S1982IN107001  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |Bill Hosteter                                                                                                                      |
|S1982IN107002  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |Bill Hosteter                                                                                                                      |
|S1982IN107005  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |Bill Hosteter and Doug Wolf                                                                                                        |
|S1982IN107006  |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |Bill Hosteter and Doug Wolf                                                                                                        |
|78IN177007     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Williams and Blank                                                                                                                 |
|78IN177008     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Williams and Blank                                                                                                                 |
|84IN157023     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Mark McClain                                                                                                                       |
|84IN157024     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Tom Ziegler                                                                                                                        |
|83IL039008     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |NA                                                                                                                                 |
|84IN015011     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Bill Hosteter and Earnie Jensen                                                                                                    |
|87IN107001     |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |WD Hosteter, Douglas Wolfe                                                                                                         |
|87IN107008     |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |B. Hostetler, J. Shively                                                                                                           |
|88MI059003     |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |NA                                                                                                                                 |
|90IL045001     |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |R. Leeper and J. Brewbaker.                                                                                                        |
|S2001IN005002  |Miami     |oxyaquic hapludalfs |fine-loamy      |map unit inclusion                 |Bill Hosteter, Norm Stephens, Don Franzmeier                                                                                       |
|1968IN011001   |Miami     |NA                  |NA              |NA                                 |Sanders and Franzmeier                                                                                                             |
|1968IN011007   |Miami     |NA                  |NA              |NA                                 |Sanders and Langlois                                                                                                               |
|1968IN113001   |Miami     |NA                  |NA              |NA                                 |Franzmeier                                                                                                                         |
|1968IN139001   |Miami     |NA                  |NA              |NA                                 |Zachary                                                                                                                            |
|1969IN157001   |Miami     |NA                  |NA              |NA                                 |Meyers and Harlan                                                                                                                  |
|1969IN157002   |Miami     |NA                  |NA              |NA                                 |Meyers and Harlan                                                                                                                  |
|1977IN031004   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Shively                                                                                                                            |
|1976IN151004   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Farmer                                                                                                                             |
|1977IN177004   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Blank                                                                                                                              |
|1977IN177008   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Blank and Meland                                                                                                                   |
|1977IN177007   |Miami     |typic hapludalfs    |fine            |NA                                 |Blank and Meland                                                                                                                   |
|1975IN023002   |Miami     |NA                  |NA              |NA                                 |Hosteter and Fink                                                                                                                  |
|1976IN033003   |Miami     |NA                  |NA              |NA                                 |Sanders and Jensen                                                                                                                 |
|1974IN151002   |Miami     |NA                  |NA              |NA                                 |Farmer and Hillis                                                                                                                  |
|1975IN169004   |Miami     |NA                  |NA              |NA                                 |Landrum and Langer                                                                                                                 |
|1975IN169009   |Miami     |NA                  |NA              |NA                                 |Ruesch and Landrum                                                                                                                 |
|1978IN065004   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Hillis and Le masters                                                                                                              |
|1978IN031001   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Shively                                                                                                                            |
|1979IN135033   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Neely and Houghtby                                                                                                                 |
|1979IN135034   |Miami     |typic hapludalfs    |fine            |NA                                 |Neely and Latowski                                                                                                                 |
|1978IN139008   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Brock and Rohleder                                                                                                                 |
|1977IN169017   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Langer and Schumacher                                                                                                              |
|1978IN177007   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Williams and Blank                                                                                                                 |
|1978IN177008   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Williams and Blank                                                                                                                 |
|1980IN135063   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Neely and Latowski                                                                                                                 |
|1980IN139009   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Brock and Dalton                                                                                                                   |
|1981IN085010   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Staley                                                                                                                             |
|1983IN157001   |Miami     |typic hapludalfs    |NA              |NA                                 |Ziegler and Franzmeier                                                                                                             |
|1984IN171025   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Shively                                                                                                                            |
|1981IN007027   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Barnes and Plank                                                                                                                   |
|1981IN047014   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Shively                                                                                                                            |
|1984IN157023   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Mcclain and Ziegler                                                                                                                |
|1984IN157024   |Miami     |typic hapludalfs    |fine-loamy      |NA                                 |Ziegler and Hosteter                                                                                                               |
|1986IL113004   |Miami     |oxyaquic hapludalfs |fine-loamy      |map unit inclusion                 |CLL                                                                                                                                |
|1986IL113001   |Miami     |oxyaquic hapludalfs |fine-loamy      |map unit inclusion                 |CLL                                                                                                                                |
|1984IL029003   |Miami     |oxyaquic hapludalfs |fine-loamy      |representative pedon for component |RGD, SCM                                                                                                                           |
|1984IL029109   |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |AP, GH                                                                                                                             |
|1984IL147022   |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |NA                                                                                                                                 |
|07IN123027     |Miami     |oxyaquic hapludalfs |fine-loamy      |OSD pedon                          |Unknown                                                                                                                            |
|P2000IN005159  |Miami     |oxyaquic hapludalfs |fine-loamy      |representative pedon for component |Jerry Shivley                                                                                                                      |
|P2001IN005049  |Miami     |oxyaquic hapludalfs |fine-loamy      |representative pedon for component |Norm Stephens                                                                                                                      |
|1955-OH141-010 |Miami     |NA                  |NA              |NA                                 |Petro & Finney                                                                                                                     |
|1954-OH141-005 |Miami     |NA                  |NA              |NA                                 |Petro, Garner, Baldridge                                                                                                           |
|1955-OH141-012 |Miami     |NA                  |NA              |NA                                 |Petro & Finney                                                                                                                     |
|1954-OH027-013 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |bone                                                                                                                               |
|1953-OH049-S21 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |n. holowaychuk                                                                                                                     |
|1955-OH027-036 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |wiseman, bone                                                                                                                      |
|1955-OH027-037 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |bone, siemond, schafer                                                                                                             |
|1954-OH097-002 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |meeker, reese                                                                                                                      |
|1955-OH097-003 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |schafer, reese                                                                                                                     |
|1955-OH027-043 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |bone, wiseman                                                                                                                      |
|1954-OH071-S16 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |dotson                                                                                                                             |
|1954-OH057-001 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |evans, roseler                                                                                                                     |
|1954-OH057-002 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |evans, roseler                                                                                                                     |
|1954-OH023-S01 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |dotson, horse, holowaychuk                                                                                                         |
|1954-OH021-S01 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |holowaychuk, dotson, morse                                                                                                         |
|1955-OH141-013 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |petro, finney                                                                                                                      |
|1959-OH017-S11 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |roseler, carner, reeder                                                                                                            |
|1957-OH049-S32 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |n. holowaychuk, n. reeder                                                                                                          |
|1960-OH165-041 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |garner, ernst                                                                                                                      |
|1960-OH047-007 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |evans, reeder, donaoldson, petro                                                                                                   |
|1959-OH135-016 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |schafer, lerch, hayhurst, Tornes, mcloda                                                                                           |
|1958-OH021-005 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie                                                                                                                            |
|1958-OH021-007 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie, evans                                                                                                                     |
|1957-OH021-001 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie                                                                                                                            |
|1958-OH021-004 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie                                                                                                                            |
|1960-OH021-037 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie, dubford                                                                                                                   |
|1960-OH135-056 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |mcloda, tornes, davis,                                                                                                             |
|1959-OH021-015 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie, evans, powell, donaldson                                                                                                  |
|1959-OH021-026 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie, powell                                                                                                                    |
|1957-OH037-015 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |heffner, siegenthaler                                                                                                              |
|1959-OH135-014 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, mcloda, tornes                                                                                                              |
|1956-OH135-003 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, schafer                                                                                                                     |
|1956-OH135-004 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, schafer                                                                                                                     |
|1956-OH135-005 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, schafer                                                                                                                     |
|1956-OH135-006 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, shcafer                                                                                                                     |
|1956-OH141-018 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |evans, petro                                                                                                                       |
|1956-OH141-027 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |r. h. jones                                                                                                                        |
|1959-OH149-006 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |heffner, siegenthaler                                                                                                              |
|1961-OH165-057 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |garner, ernst                                                                                                                      |
|1963-OH113-010 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, davis, smeck                                                                                                                |
|1961-OH021-047 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |ritchie, powell, siegenthaler                                                                                                      |
|1961-OH091-011 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |heffner, siegenthaler, urban                                                                                                       |
|1963-OH113-007 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, smeck, steiger, davis                                                                                                       |
|1962-OH113-003 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |davis, lerch, calhoun                                                                                                              |
|1971-OH017-002 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lerch, & hale                                                                                                                      |
|1967-OH049-007 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |r. l. blevens                                                                                                                      |
|1969-OH047-003 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |petro                                                                                                                              |
|1968-OH109-018 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lehman, bottrell                                                                                                                   |
|1968-OH109-021 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |lehman, bottrell                                                                                                                   |
|1971-OH129-023 |Miami     |oxyaquic hapludalfs |fine-loamy      |NA                                 |hall, williams, kerr, jones, mc kinney, le master                                                                                  |
|1961IN003020   |Miami     |typic hapludalfs    |fine-loamy      |TUD pedon                          |soil survey staff                                                                                                                  |
|1983IN085022   |Miami     |typic hapludalfs    |fine-loamy      |TUD pedon                          |soil survey staff                                                                                                                  |
|1974IN113017   |Miami     |typic hapludalfs    |fine-loamy      |TUD pedon                          |soil survey staff                                                                                                                  |
|1979IN151021   |Miami     |oxyaquic hapludalfs |fine-loamy      |TUD pedon                          |soil survey staff                                                                                                                  |
|1979IN169020   |Miami     |typic hapludalfs    |fine-loamy      |TUD pedon                          |soil survey staff                                                                                                                  |
|S1974IN151002  |Miami     |typic hapludalfs    |fine-loamy      |taxadjunct to the series           |Farmer and Hillis                                                                                                                  |
|S1977IN169017  |Miami     |typic hapludalfs    |fine-loamy      |correlates to named soil           |Langer and Schumacher                                                                                                              |
|S1981IN085010  |Miami     |typic hapludalfs    |fine-loamy      |correlates to named soil           |Staley                                                                                                                             |
|S1976IN033003  |Miami     |typic hapludalfs    |fine-loamy      |undefined observation              |Sanders and Jensen                                                                                                                 |

![plot of chunk format site data](figure/format site data-1.png)![plot of chunk format site data](figure/format site data-2.png)![plot of chunk format site data](figure/format site data-3.png)![plot of chunk format site data](figure/format site data-4.png)![plot of chunk format site data](figure/format site data-5.png)![plot of chunk format site data](figure/format site data-6.png)![plot of chunk format site data](figure/format site data-7.png)![plot of chunk format site data](figure/format site data-8.png)


## Range in characteristics for NCSS pedon lab data
### Summary of soil profiles
Five number summary (min, 25th, median, 75th, max)(percentiles)

|      variable      |          range           |
|:------------------:|:------------------------:|
|  noncarbclaywtavg  | (23, 27, 30, 32, 35)(16) |
|    claytotwtavg    | (23, 27, 30, 32, 35)(16) |
|      le0to100      |    (0, 2, 2, 2, 3)(4)    |
|   wf0175wtavgpsc   |  (0, 0, 23, 32, 41)(16)  |
|  volfractgt2wtavg  |   (0, 1, 2, 4, 6)(12)    |
| cec7clayratiowtavg | (45, 48, 50, 52, 54)(7)  |

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)

|  variable   |          range           |
|:-----------:|:------------------------:|
| psctopdepth | (15, 19, 20, 24, 48)(23) |
| pscbotdepth | (51, 70, 70, 74, 98)(23) |
|  thickness  | (35, 50, 50, 50, 51)(23) |

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-2.png)


### Summary of soil horizons


|         | 2B1 | 2B2 | 2B3 | 2BC | 2BCt | 2BE2 | 2Bt | 2Bt1 | 2Bt2 | 2Bt3 | 2C | 2C1 | 2C2 | 2C3 | 2C4 |
|:--------|:---:|:---:|:---:|:---:|:----:|:----:|:---:|:----:|:----:|:----:|:--:|:---:|:---:|:---:|:---:|
|Ap       |  0  |  0  |  0  |  0  |  0   |  0   |  0  |  0   |  0   |  0   | 0  |  0  |  0  |  0  |  0  |
|A        |  0  |  0  |  0  |  0  |  0   |  0   |  0  |  0   |  0   |  0   | 0  |  0  |  0  |  0  |  0  |
|E        |  0  |  0  |  0  |  0  |  0   |  0   |  0  |  0   |  0   |  0   | 0  |  0  |  0  |  0  |  0  |
|Bt       |  0  |  0  |  0  |  0  |  0   |  0   |  0  |  0   |  0   |  0   | 0  |  0  |  0  |  0  |  0  |
|2Bt      |  2  |  2  |  0  |  0  |  0   |  1   |  2  |  3   |  4   |  3   | 0  |  0  |  0  |  0  |  0  |
|2BCt     |  0  |  0  |  1  |  2  |  3   |  0   |  0  |  0   |  0   |  0   | 0  |  0  |  0  |  0  |  0  |
|not-used |  0  |  0  |  0  |  0  |  0   |  0   |  0  |  0   |  0   |  0   | 0  |  0  |  0  |  0  |  0  |
|2Cd      |  0  |  0  |  0  |  0  |  0   |  0   |  0  |  0   |  0   |  0   | 3  |  4  |  4  |  2  |  1  |
|Sum      |  2  |  2  |  1  |  2  |  3   |  1   |  2  |  3   |  4   |  3   | 3  |  4  |  4  |  2  |  1  |


|         | 2CB | 2CBt | 2Cd | A  | A&B | A1 | A2 | A2/B1 | A21 | A22 | A3 | AB | Ap | AP | Ap1 |
|:--------|:---:|:----:|:---:|:--:|:---:|:--:|:--:|:-----:|:---:|:---:|:--:|:--:|:--:|:--:|:---:|
|Ap       |  0  |  0   |  0  | 0  |  0  | 0  | 0  |   0   |  0  |  0  | 0  | 0  | 53 | 26 |  3  |
|A        |  0  |  0   |  0  | 10 |  1  | 16 | 14 |   1   |  2  |  2  | 2  | 1  | 0  | 0  |  0  |
|E        |  0  |  0   |  0  | 0  |  0  | 0  | 0  |   0   |  0  |  0  | 0  | 0  | 0  | 0  |  0  |
|Bt       |  0  |  0   |  0  | 0  |  0  | 0  | 0  |   0   |  0  |  0  | 0  | 0  | 0  | 0  |  0  |
|2Bt      |  0  |  0   |  0  | 0  |  0  | 0  | 0  |   0   |  0  |  0  | 0  | 0  | 0  | 0  |  0  |
|2BCt     |  0  |  0   |  0  | 0  |  0  | 0  | 0  |   0   |  0  |  0  | 0  | 0  | 0  | 0  |  0  |
|not-used |  0  |  0   |  0  | 0  |  0  | 0  | 0  |   0   |  0  |  0  | 0  | 0  | 0  | 0  |  0  |
|2Cd      |  1  |  1   |  1  | 0  |  0  | 0  | 0  |   0   |  0  |  0  | 0  | 0  | 0  | 0  |  0  |
|Sum      |  1  |  1   |  1  | 10 |  1  | 16 | 14 |   1   |  2  |  2  | 2  | 1  | 53 | 26 |  3  |


|         | AP1 | Ap2 | AP2 | B | B&A | B&C | B/C1 | B1 | B1T | B2 | B21 | B21T | B21T1 | B21T2 | B22 |
|:--------|:---:|:---:|:---:|:-:|:---:|:---:|:----:|:--:|:---:|:--:|:---:|:----:|:-----:|:-----:|:---:|
|Ap       |  1  |  3  |  1  | 0 |  0  |  0  |  0   | 0  |  0  | 0  |  0  |  0   |   0   |   0   |  0  |
|A        |  0  |  0  |  0  | 0 |  1  |  0  |  0   | 0  |  0  | 0  |  0  |  0   |   0   |   0   |  0  |
|E        |  0  |  0  |  0  | 0 |  0  |  0  |  0   | 0  |  0  | 0  |  0  |  0   |   0   |   0   |  0  |
|Bt       |  0  |  0  |  0  | 0 |  0  |  0  |  0   | 0  |  3  | 0  |  0  |  23  |   1   |   1   |  0  |
|2Bt      |  0  |  0  |  0  | 0 |  0  |  0  |  0   | 0  |  0  | 0  |  0  |  0   |   0   |   0   |  0  |
|2BCt     |  0  |  0  |  0  | 0 |  0  |  0  |  0   | 0  |  0  | 0  |  0  |  0   |   0   |   0   |  0  |
|not-used |  0  |  0  |  0  | 4 |  0  |  1  |  1   | 53 |  0  | 24 | 12  |  0   |   0   |   0   | 14  |
|2Cd      |  0  |  0  |  0  | 0 |  0  |  0  |  0   | 0  |  0  | 0  |  0  |  0   |   0   |   0   |  0  |
|Sum      |  1  |  3  |  1  | 4 |  1  |  1  |  1   | 53 |  3  | 24 | 12  |  23  |   1   |   1   | 14  |


|         | B22T | B23 | B23T | B24T | B2T | B2T1 | B2T2 | B2T3 | B3 | B3-C1 | B31 | B32 | B3T | B4 | BA |
|:--------|:----:|:---:|:----:|:----:|:---:|:----:|:----:|:----:|:--:|:-----:|:---:|:---:|:---:|:--:|:--:|
|Ap       |  0   |  0  |  0   |  0   |  0  |  0   |  0   |  0   | 0  |   0   |  0  |  0  |  0  | 0  | 0  |
|A        |  0   |  0  |  0   |  0   |  0  |  0   |  0   |  0   | 0  |   0   |  0  |  0  |  0  | 0  | 4  |
|E        |  0   |  0  |  0   |  0   |  0  |  0   |  0   |  0   | 0  |   0   |  0  |  0  |  0  | 0  | 0  |
|Bt       |  23  |  0  |  12  |  1   |  2  |  1   |  1   |  1   | 0  |   0   |  0  |  0  |  0  | 0  | 0  |
|2Bt      |  0   |  0  |  0   |  0   |  0  |  0   |  0   |  0   | 0  |   0   |  0  |  0  |  0  | 0  | 0  |
|2BCt     |  0   |  0  |  0   |  0   |  0  |  0   |  0   |  0   | 28 |   1   |  2  |  2  |  6  | 0  | 0  |
|not-used |  0   |  3  |  0   |  0   |  0  |  0   |  0   |  0   | 0  |   0   |  0  |  0  |  0  | 1  | 0  |
|2Cd      |  0   |  0  |  0   |  0   |  0  |  0   |  0   |  0   | 0  |   0   |  0  |  0  |  0  | 0  | 0  |
|Sum      |  23  |  3  |  12  |  1   |  2  |  1   |  1   |  1   | 28 |   1   |  2  |  2  |  6  | 1  | 4  |


|         | BC | BC3 | BCt | BCT | BCt1 | BCt2 | BE | BE1 | BEt | Bt | Bt1 | BT1 | Bt2 | BT2 | Bt3 |
|:--------|:--:|:---:|:---:|:---:|:----:|:----:|:--:|:---:|:---:|:--:|:---:|:---:|:---:|:---:|:---:|
|Ap       | 0  |  0  |  0  |  0  |  0   |  0   | 0  |  0  |  0  | 0  |  0  |  0  |  0  |  0  |  0  |
|A        | 0  |  0  |  0  |  0  |  0   |  0   | 0  |  0  |  0  | 0  |  0  |  0  |  0  |  0  |  0  |
|E        | 0  |  0  |  0  |  0  |  0   |  0   | 25 |  1  |  0  | 0  |  0  |  0  |  0  |  0  |  0  |
|Bt       | 0  |  0  |  0  |  0  |  0   |  0   | 0  |  0  |  2  | 9  | 23  |  6  | 26  |  6  | 12  |
|2Bt      | 0  |  0  |  0  |  0  |  0   |  0   | 0  |  0  |  0  | 0  |  0  |  0  |  0  |  0  |  0  |
|2BCt     | 28 |  1  |  5  |  1  |  1   |  1   | 0  |  0  |  0  | 0  |  0  |  0  |  0  |  0  |  0  |
|not-used | 0  |  0  |  0  |  0  |  0   |  0   | 0  |  0  |  0  | 0  |  0  |  0  |  0  |  0  |  0  |
|2Cd      | 0  |  0  |  0  |  0  |  0   |  0   | 0  |  0  |  0  | 0  |  0  |  0  |  0  |  0  |  0  |
|Sum      | 28 |  1  |  5  |  1  |  1   |  1   | 25 |  1  |  2  | 9  | 23  |  6  | 26  |  6  | 12  |


|         | BT3 | Bw | C  | C1 | C1-B3 | C11 | C12 | C2 | C21 | C22 | C23 | C3 | C4 | C5 | CB |
|:--------|:---:|:--:|:--:|:--:|:-----:|:---:|:---:|:--:|:---:|:---:|:---:|:--:|:--:|:--:|:--:|
|Ap       |  0  | 0  | 0  | 0  |   0   |  0  |  0  | 0  |  0  |  0  |  0  | 0  | 0  | 0  | 0  |
|A        |  0  | 0  | 0  | 0  |   0   |  0  |  0  | 0  |  0  |  0  |  0  | 0  | 0  | 0  | 0  |
|E        |  0  | 0  | 0  | 0  |   0   |  0  |  0  | 0  |  0  |  0  |  0  | 0  | 0  | 0  | 0  |
|Bt       |  7  | 0  | 0  | 0  |   0   |  0  |  0  | 0  |  0  |  0  |  0  | 0  | 0  | 0  | 0  |
|2Bt      |  0  | 0  | 0  | 0  |   0   |  0  |  0  | 0  |  0  |  0  |  0  | 0  | 0  | 0  | 0  |
|2BCt     |  0  | 0  | 0  | 0  |   1   |  0  |  0  | 0  |  0  |  0  |  0  | 0  | 0  | 0  | 3  |
|not-used |  0  | 1  | 44 | 56 |   0   |  1  |  1  | 52 |  1  |  1  |  1  | 21 | 9  | 3  | 0  |
|2Cd      |  0  | 0  | 0  | 0  |   0   |  0  |  0  | 0  |  0  |  0  |  0  | 0  | 0  | 0  | 0  |
|Sum      |  7  | 1  | 44 | 56 |   1   |  1  |  1  | 52 |  1  |  1  |  1  | 21 | 9  | 3  | 3  |


|         | CBT | E  | E1 | E2 | EB | missing | Sum |
|:--------|:---:|:--:|:--:|:--:|:--:|:-------:|:---:|
|Ap       |  0  | 0  | 0  | 0  | 0  |    0    | 87  |
|A        |  0  | 0  | 0  | 0  | 0  |    0    | 54  |
|E        |  0  | 14 | 1  | 1  | 4  |    0    | 46  |
|Bt       |  0  | 0  | 0  | 0  | 0  |    0    | 160 |
|2Bt      |  0  | 0  | 0  | 0  | 0  |    0    | 17  |
|2BCt     |  1  | 0  | 0  | 0  | 0  |    0    | 87  |
|not-used |  0  | 0  | 0  | 0  | 0  |    2    | 306 |
|2Cd      |  0  | 0  | 0  | 0  | 0  |    0    | 17  |
|Sum      |  1  | 14 | 1  | 1  | 4  |    2    | 774 |


|  genhz   |           hzdept            |            hzdepb            |         thickness          |
|:--------:|:---------------------------:|:----------------------------:|:--------------------------:|
|    Ap    |    (0, 0, 0, 0, 20)(87)     |   (8, 15, 18, 20, 30)(87)    |  (8, 15, 18, 20, 30)(83)   |
|    A     |    (0, 0, 8, 15, 28)(54)    |   (5, 10, 18, 25, 38)(54)    |  (5, 10, 15, 20, 38)(34)   |
|    E     |  (5, 15, 18, 23, 122)(46)   |  (15, 23, 28, 30, 137)(46)   |   (5, 8, 10, 18, 30)(31)   |
|    Bt    |  (8, 25, 38, 48, 89)(160)   |  (23, 46, 56, 71, 114)(160)  |  (8, 28, 40, 53, 77)(70)   |
|   2Bt    |  (22, 38, 48, 61, 89)(17)   |  (38, 53, 61, 81, 102)(17)   |  (10, 25, 34, 42, 56)(8)   |
|   2BCt   |  (28, 53, 66, 76, 117)(87)  |  (36, 66, 81, 97, 157)(87)   |  (5, 12, 17, 23, 46)(73)   |
| not-used | (13, 36, 69, 97, 732)(306)  | (20, 51, 91, 130, 8888)(306) | (6, 45, 64, 81, 8822)(108) |
|   2Cd    | (60, 89, 102, 130, 165)(17) | (82, 112, 132, 155, 190)(17) |  (20, 50, 64, 75, 88)(8)   |

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png)


## Range in characteristics for generic horizons 
Five number summary (min, 25th, median, 75th, max)(percentiles) and total number of observations (n)


|  genhz   |            sandvc             |             sandco              |             sandmed             |             sandfine              |
|:--------:|:-----------------------------:|:-------------------------------:|:-------------------------------:|:---------------------------------:|
|    Ap    |  (0, 0.9, 1.2, 1.6, 3.3)(67)  |   (0, 2.1, 2.7, 3.5, 6.5)(68)   | (0.8, 3.2, 4.8, 7.1, 21.4)(68)  |   (1, 6.5, 8.6, 12.1, 21.9)(68)   |
|    A     |   (0, 0.6, 1, 1.6, 5.8)(45)   |   (1, 1.8, 2.7, 3.4, 7.7)(46)   | (1.2, 2.8, 3.6, 6.1, 14.7)(46)  |  (2.2, 5.1, 7.4, 11.8, 21.5)(46)  |
|    E     | (0.2, 0.8, 1.1, 1.8, 3.4)(28) |  (0.6, 2.1, 2.9, 3.5, 4.7)(30)  |  (1.3, 2.8, 3.2, 4.2, 7.8)(30)  |       (2, 5, 7, 8, 12)(30)        |
|    Bt    |  (0, 1, 1.6, 2.2, 6.4)(141)   |  (0.4, 2.7, 3.4, 4, 12.7)(143)  | (1.2, 5.2, 7.7, 9.8, 19.8)(143) |   (2, 9.6, 13, 15.2, 25.6)(143)   |
|   2Bt    | (0.5, 1.1, 1.8, 2.2, 3.3)(14) |   (2, 2.6, 3.2, 3.6, 4.1)(14)   |   (2.6, 4, 6.4, 8.6, 9.1)(14)   |  (5, 7.8, 11.5, 14.6, 16.8)(14)   |
|   2BCt   |      (0, 2, 2, 4, 9)(76)      | (1.1, 3.6, 4.4, 5.4, 11.2)(76)  | (1.4, 4.5, 5.4, 8.4, 28.1)(76)  | (3.7, 8.3, 10.6, 14.4, 26.2)(76)  |
| not-used | (0, 1.8, 3.1, 4.6, 12.6)(230) | (0.6, 3.5, 5.1, 6.6, 31.7)(235) | (0.8, 4.1, 5.5, 8.6, 28.9)(235) | (1.5, 7.8, 10.1, 14.3, 21.5)(235) |
|   2Cd    |  (2, 3.2, 3.8, 4.8, 7.3)(12)  |      (3, 6, 7, 8, 11)(12)       |      (4, 6, 6, 10, 16)(12)      |   (6, 11.7, 15.3, 16, 20.8)(12)   |


|  genhz   |              sandvf              |              sandtot               |               siltco               |              siltfine              |
|:--------:|:--------------------------------:|:----------------------------------:|:----------------------------------:|:----------------------------------:|
|    Ap    |   (1, 4.5, 6.4, 8.1, 14.8)(68)   | (4.2, 18.7, 24.4, 31.8, 56.2)(84)  | (8.9, 15.2, 19.1, 23.7, 36.7)(40)  | (18.4, 30.4, 35.9, 41.2, 53.3)(40) |
|    A     |  (2.4, 4.5, 6.4, 9.1, 14.8)(46)  |  (7.8, 16, 25.4, 31.2, 55.6)(53)   | (12.9, 16.6, 20.1, 22.5, 28.7)(14) | (28.9, 33.2, 35.5, 40.1, 53.5)(14) |
|    E     |   (1.4, 5, 5.8, 6.7, 9.8)(30)    |      (6, 15, 20, 26, 46)(45)       | (11.6, 13.4, 13.6, 17.4, 27.4)(9)  |      (28, 35, 40, 40, 48)(9)       |
|    Bt    |  (1, 5.5, 7.5, 9.3, 14.7)(143)   |  (6.3, 24, 33.4, 39.2, 58.4)(155)  | (3.2, 9.8, 11.4, 13.8, 31.5)(111)  |      (8, 19, 23, 27, 52)(111)      |
|   2Bt    |   (2, 4.9, 6.4, 9.2, 10.7)(14)   | (14.9, 22.2, 28.1, 38.7, 41.5)(14) |      (10, 11, 12, 16, 17)(9)       |   (19, 21, 21.2, 22.7, 23.4)(9)    |
|   2BCt   |  (2.8, 6.9, 8.8, 11, 21.4)(76)   |  (11.2, 25.4, 32.6, 40, 72.6)(87)  | (0.5, 10.8, 13.7, 15.3, 28.4)(33)  | (4.2, 17.3, 22.3, 25.6, 33.4)(33)  |
| not-used | (1.2, 6.8, 8.5, 10.7, 40.9)(235) |   (0, 24.8, 32.3, 41, 86.6)(299)   |  (3.8, 13.7, 15, 16.5, 25.2)(75)   |  (6.5, 20, 23.5, 26.6, 46.7)(76)   |
|   2Cd    |  (4, 8.5, 9.6, 10.3, 13.2)(12)   |      (22, 40, 44, 46, 63)(12)      |  (5.7, 13.6, 14.2, 14.4, 21.9)(7)  |  (17.4, 22.1, 25, 26.8, 28.6)(7)   |


|  genhz   |               silttot               |          claycarb          |             clayfine              |              claytot               |
|:--------:|:-----------------------------------:|:--------------------------:|:---------------------------------:|:----------------------------------:|
|    Ap    | (28.1, 50.7, 56.1, 64.9, 72.7)(84)  |  (NA, NA, NA, NA, NA)(0)   |       (2, 3, 5, 7, 15)(32)        |      (7, 16, 18, 20, 29)(84)       |
|    A     | (31.6, 52.8, 57.2, 65.1, 73.9)(53)  |  (NA, NA, NA, NA, NA)(0)   |  (0.8, 3.1, 4.2, 5.6, 17.1)(26)   |  (7.5, 13.5, 17, 19.9, 39.4)(53)   |
|    E     |  (38, 48.5, 53.3, 61.5, 73.5)(45)   |  (NA, NA, NA, NA, NA)(0)   |   (2.2, 5.1, 8.1, 11, 15.8)(27)   |      (11, 21, 24, 29, 37)(45)      |
|    Bt    | (13.3, 30.1, 35.1, 38.9, 67.2)(155) |  (NA, NA, NA, NA, NA)(0)   |  (7, 15.2, 18.6, 21.2, 26.5)(23)  | (15.2, 27.4, 31.6, 36, 50.7)(155)  |
|   2Bt    |      (30, 33, 37, 42, 55)(14)       |  (NA, NA, NA, NA, NA)(0)   | (12.6, 15.8, 18.1, 19.3, 23.5)(9) |  (22, 25.6, 30.8, 34.9, 43.6)(14)  |
|   2BCt   |       (5, 33, 38, 43, 52)(87)       | (0, 0.3, 0.6, 0.8, 1.1)(2) |  (6, 10.3, 12.9, 16.3, 23.7)(44)  | (14.3, 23.4, 28.6, 33.1, 50.9)(87) |
| not-used |      (8, 36, 41, 44, 100)(299)      | (0.8, 0.9, 1.7, 2, 2.5)(9) |  (2.9, 6.6, 9, 18.1, 29.7)(163)   |  (3, 18.1, 23.8, 35.5, 54.4)(298)  |
|   2Cd    |      (23, 37, 39, 42, 50)(12)       |   (0, 0, 0.3, 1, 1.8)(4)   |    (3.9, 4.5, 5, 5.9, 8.4)(10)    |      (14, 16, 17, 19, 27)(12)      |


|  genhz   |          carbonorganicpct          |           carbontotalpct           |      fragwt25       |      fragwt520      |
|:--------:|:----------------------------------:|:----------------------------------:|:-------------------:|:-------------------:|
|    Ap    | (0.4, 0.96, 1.11, 1.25, 3.12)(38)  |    (0.7, 1, 1.3, 1.5, 4.3)(41)     | (0, 1, 1, 1, 2)(9)  | (0, 1, 1, 3, 3)(9)  |
|    A     |   (0.3, 0.6, 1.2, 2.8, 5.6)(22)    | (0.23, 0.69, 1.22, 2.73, 4.41)(29) | (0, 0, 0, 0, 1)(4)  | (0, 0, 0, 0, 1)(4)  |
|    E     | (0.41, 0.56, 0.71, 0.76, 0.82)(3)  | (0.35, 0.47, 0.61, 0.99, 1.68)(34) | (0, 0, 0, 0, 0)(1)  | (0, 0, 0, 0, 0)(1)  |
|    Bt    | (0.16, 0.36, 0.44, 0.53, 1.12)(73) |   (0.3, 0.5, 0.6, 0.6, 0.9)(19)    | (0, 1, 2, 3, 6)(28) | (0, 1, 2, 2, 6)(28) |
|   2Bt    | (0.14, 0.22, 0.31, 0.33, 0.44)(6)  |  (0.23, 0.23, 0.4, 0.5, 0.73)(5)   | (2, 2, 3, 3, 8)(7)  | (1, 1, 1, 2, 5)(7)  |
|   2BCt   |   (0, 0.2, 0.3, 0.49, 0.59)(11)    | (0.46, 0.52, 0.58, 0.76, 0.95)(3)  | (3, 3, 4, 5, 6)(5)  | (2, 2, 3, 4, 4)(5)  |
| not-used |   (0, 0.24, 0.3, 0.42, 0.91)(34)   | (0.06, 0.35, 0.46, 0.58, 1.22)(49) | (0, 2, 4, 4, 6)(16) | (0, 1, 2, 5, 7)(16) |
|   2Cd    |  (0.08, 0.1, 0.13, 0.23, 0.33)(3)  |  (2.93, 3.2, 3.48, 3.75, 4.02)(2)  | (4, 5, 5, 7, 9)(5)  | (3, 4, 4, 5, 8)(5)  |


|  genhz   |     fragwt2075      |      fragwt275       |        wtpct0175         |      wtpctgt2ws      |
|:--------:|:-------------------:|:--------------------:|:------------------------:|:--------------------:|
|    Ap    | (0, 0, 0, 0, 5)(9)  |  (0, 2, 3, 5, 7)(9)  |  (2, 19, 21, 30, 52)(9)  |  (0, 2, 3, 5, 7)(9)  |
|    A     | (0, 0, 0, 0, 0)(4)  |  (0, 0, 0, 1, 1)(4)  | (12, 17, 21, 23, 24)(4)  |  (0, 0, 0, 1, 1)(4)  |
|    E     | (0, 0, 0, 0, 0)(1)  |  (0, 0, 0, 0, 0)(1)  | (24, 24, 24, 24, 24)(1)  |  (0, 0, 0, 0, 0)(1)  |
|    Bt    | (0, 0, 0, 1, 3)(28) | (0, 3, 4, 6, 9)(28)  | (4, 30, 32, 37, 50)(28)  | (0, 3, 4, 6, 9)(28)  |
|   2Bt    | (0, 0, 0, 1, 6)(7)  | (3, 3, 5, 8, 14)(7)  | (28, 30, 32, 34, 39)(7)  | (3, 3, 5, 8, 14)(7)  |
|   2BCt   | (0, 0, 0, 2, 3)(5)  | (7, 8, 8, 8, 10)(5)  | (33, 37, 39, 39, 41)(5)  | (7, 8, 8, 8, 10)(5)  |
| not-used | (0, 0, 0, 1, 1)(16) | (0, 4, 6, 9, 12)(16) | (13, 33, 37, 40, 46)(16) | (0, 4, 6, 9, 12)(16) |
|   2Cd    | (0, 0, 0, 1, 3)(5)  | (9, 9, 9, 11, 20)(5) | (36, 38, 43, 49, 54)(5)  | (9, 9, 9, 11, 20)(5) |


|  genhz   |           ph1to1h2o           |          ph01mcacl2           |            resistivity            |                ec                 |
|:--------:|:-----------------------------:|:-----------------------------:|:---------------------------------:|:---------------------------------:|
|    Ap    | (4.7, 5.7, 6.1, 6.8, 7.7)(84) | (4.5, 5.2, 5.6, 6.1, 7.3)(35) |      (NA, NA, NA, NA, NA)(0)      |      (NA, NA, NA, NA, NA)(0)      |
|    A     |  (4.5, 5.4, 6, 6.5, 7.5)(54)  |  (4.7, 5.5, 5.6, 6, 7.1)(7)   |      (NA, NA, NA, NA, NA)(0)      |      (NA, NA, NA, NA, NA)(0)      |
|    E     | (4.5, 5.1, 5.7, 6.6, 7.4)(45) |      (4, 4, 5, 5, 5)(2)       |      (NA, NA, NA, NA, NA)(0)      |      (NA, NA, NA, NA, NA)(0)      |
|    Bt    | (4.4, 5.3, 6, 6.8, 8.3)(155)  |      (4, 5, 6, 6, 8)(99)      |      (NA, NA, NA, NA, NA)(0)      |      (NA, NA, NA, NA, NA)(0)      |
|   2Bt    |  (4.6, 4.9, 5.7, 7, 8.3)(14)  | (4.2, 4.4, 4.6, 6.3, 7.2)(7)  |      (NA, NA, NA, NA, NA)(0)      |      (NA, NA, NA, NA, NA)(0)      |
|   2BCt   | (4.9, 6.5, 7.6, 7.8, 8.6)(87) | (5.1, 7.1, 7.5, 7.5, 8.1)(27) |      (NA, NA, NA, NA, NA)(0)      | (0.33, 0.33, 0.33, 0.33, 0.33)(1) |
| not-used |  (4.7, 6, 7.8, 8, 8.6)(299)   | (4.6, 7.3, 7.6, 7.7, 8.2)(60) |      (NA, NA, NA, NA, NA)(0)      |      (NA, NA, NA, NA, NA)(0)      |
|   2Cd    |  (7.7, 7.9, 8, 8.3, 8.5)(12)  | (7.6, 7.6, 7.7, 7.7, 7.7)(5)  | (6300, 6300, 6300, 6300, 6300)(1) | (0.27, 0.27, 0.28, 0.28, 0.28)(2) |


|  genhz   |         esp          |           sar           |           cecsumcations            |               cec7                |
|:--------:|:--------------------:|:-----------------------:|:----------------------------------:|:---------------------------------:|
|    Ap    | (0, 0, 0, 2, 14)(18) | (NA, NA, NA, NA, NA)(0) |  (10.3, 12, 13.8, 16.5, 20.9)(36)  | (10.3, 11.2, 12.2, 15, 16.4)(18)  |
|    A     | (0, 0, 0, 0, 5)(15)  | (NA, NA, NA, NA, NA)(0) | (7.3, 11.1, 13.8, 17.4, 29.2)(30)  |  (5, 10.5, 11.5, 19.8, 29.2)(15)  |
|    E     | (0, 0, 0, 0, 0)(15)  | (NA, NA, NA, NA, NA)(0) | (10.3, 11.9, 15.2, 17.3, 24.9)(18) |  (10.3, 12, 15, 16.6, 22.5)(15)   |
|    Bt    | (0, 0, 1, 1, 16)(28) | (NA, NA, NA, NA, NA)(0) | (7.2, 16.6, 19.5, 22.7, 31.4)(88)  | (8.6, 13.9, 16.4, 22.9, 31.4)(28) |
|   2Bt    | (0, 0, 1, 1, 3)(12)  | (NA, NA, NA, NA, NA)(0) | (15.6, 17.9, 19.3, 21.8, 29.5)(10) | (12, 12.6, 17.9, 21.1, 24.6)(12)  |
|   2BCt   | (0, 1, 2, 2, 19)(5)  |   (0, 0, 0, 0, 0)(1)    | (10.8, 14.4, 16.6, 18.5, 20.1)(10) |   (8, 8.7, 11.8, 17.9, 20.1)(5)   |
| not-used | (0, 0, 0, 1, 12)(30) | (NA, NA, NA, NA, NA)(0) | (12.8, 15.2, 17.6, 21.2, 26.3)(31) | (5.4, 10.8, 15.5, 21.2, 26.3)(30) |
|   2Cd    |  (0, 1, 1, 3, 4)(5)  |   (0, 0, 0, 0, 0)(2)    |      (NA, NA, NA, NA, NA)(0)       |   (5.7, 6.5, 6.7, 6.9, 9.1)(5)    |


|  genhz   |              ecec               |             sumbases              |      basesatsumcations       |        basesatnh4oac         |
|:--------:|:-------------------------------:|:---------------------------------:|:----------------------------:|:----------------------------:|
|    Ap    |  (9.8, 9.8, 9.8, 9.8, 9.8)(1)   |  (4.8, 7.8, 9.7, 11.5, 15.7)(18)  |   (34, 52, 60, 68, 84)(36)   |   (4, 7, 15, 68, 100)(38)    |
|    A     |     (NA, NA, NA, NA, NA)(0)     |       (2, 6, 9, 14, 21)(17)       |   (23, 48, 62, 69, 85)(30)   |    (2, 6, 15, 62, 88)(31)    |
|    E     |     (NA, NA, NA, NA, NA)(0)     |   (1.1, 5.1, 8, 10.9, 15.5)(16)   |   (11, 35, 52, 68, 79)(18)   |   (5, 31, 39, 69, 79)(17)    |
|    Bt    | (9, 10.4, 12.4, 13.1, 15.4)(10) |  (6.5, 11, 13.1, 17.1, 23.5)(30)  |   (33, 53, 61, 74, 93)(89)   |   (4, 10, 14, 65, 100)(88)   |
|   2Bt    |  (9.8, 9.9, 10.1, 11, 12.7)(4)  | (7.8, 8.6, 10.8, 15.9, 23.1)(10)  |   (48, 50, 63, 78, 94)(12)   |  (49, 65, 69, 84, 100)(12)   |
|   2BCt   |     (NA, NA, NA, NA, NA)(0)     |  (16.3, 21, 25.7, 31.3, 36.9)(3)  |  (44, 57, 76, 92, 100)(12)   |   (6, 8, 14, 95, 100)(14)    |
| not-used |  (9.9, 9.9, 9.9, 9.9, 9.9)(1)   | (4.7, 8.4, 11.6, 15.7, 28.6)(27)  |  (31, 48, 63, 78, 100)(36)   |   (4, 27, 58, 81, 100)(40)   |
|   2Cd    |     (NA, NA, NA, NA, NA)(0)     | (50.4, 50.5, 50.6, 50.8, 50.9)(2) | (100, 100, 100, 100, 100)(3) | (100, 100, 100, 100, 100)(5) |


|  genhz   |       caco3equiv        |             feoxalate             |        feextractable         |                fetotal                 |
|:--------:|:-----------------------:|:---------------------------------:|:----------------------------:|:--------------------------------------:|
|    Ap    | (NA, NA, NA, NA, NA)(0) | (0.46, 0.5, 0.54, 0.57, 0.61)(2)  | (1.2, 1.3, 1.4, 1.6, 1.9)(3) | (21092, 22100, 23108, 24116, 25124)(2) |
|    A     | (NA, NA, NA, NA, NA)(0) |      (NA, NA, NA, NA, NA)(0)      |   (NA, NA, NA, NA, NA)(0)    |        (NA, NA, NA, NA, NA)(0)         |
|    E     | (NA, NA, NA, NA, NA)(0) |      (NA, NA, NA, NA, NA)(0)      |   (NA, NA, NA, NA, NA)(0)    |        (NA, NA, NA, NA, NA)(0)         |
|    Bt    |   (0, 1, 4, 7, 45)(6)   | (0.69, 0.69, 0.69, 0.69, 0.69)(1) | (1.4, 1.6, 1.7, 1.7, 1.8)(4) | (25609, 27708, 29808, 31907, 34006)(2) |
|   2Bt    |   (0, 0, 1, 2, 2)(2)    | (0.32, 0.48, 0.62, 0.72, 0.76)(4) |  (1.8, 1.9, 1.9, 2, 2.2)(4)  | (31679, 32532, 33384, 33628, 33872)(3) |
|   2BCt   | (4, 14, 20, 25, 49)(23) | (0.22, 0.23, 0.25, 0.27, 0.28)(2) | (1.3, 1.3, 1.4, 1.6, 1.7)(3) | (25871, 25871, 25871, 25871, 25871)(1) |
| not-used | (5, 26, 30, 36, 50)(60) |      (NA, NA, NA, NA, NA)(0)      |      (1, 1, 1, 1, 1)(2)      | (15477, 15477, 15477, 15477, 15477)(1) |
|   2Cd    | (21, 23, 28, 31, 33)(5) | (0.07, 0.09, 0.11, 0.12, 0.14)(4) | (0.8, 0.9, 0.9, 1.1, 1.2)(4) | (15971, 16787, 17602, 18418, 19234)(2) |


|  genhz   |             sioxalate             |            extracid            |            extral             |             aloxalate             |
|:--------:|:---------------------------------:|:------------------------------:|:-----------------------------:|:---------------------------------:|
|    Ap    | (0.04, 0.04, 0.04, 0.04, 0.04)(2) | (2.4, 4.3, 5.7, 6.4, 9.5)(36)  | (0.3, 0.3, 0.3, 0.3, 0.3)(1)  | (0.15, 0.15, 0.16, 0.16, 0.16)(2) |
|    A     |      (NA, NA, NA, NA, NA)(0)      | (2.4, 4.5, 5.4, 6.4, 10.8)(30) |    (NA, NA, NA, NA, NA)(0)    |      (NA, NA, NA, NA, NA)(0)      |
|    E     |      (NA, NA, NA, NA, NA)(0)      | (2.5, 4.6, 8.6, 9.6, 10.6)(18) |    (NA, NA, NA, NA, NA)(0)    |      (NA, NA, NA, NA, NA)(0)      |
|    Bt    | (0.05, 0.05, 0.05, 0.05, 0.05)(1) |  (0.9, 5.4, 6.7, 9, 13.4)(89)  | (0.5, 0.7, 1.2, 1.7, 2.7)(10) |   (0.2, 0.2, 0.2, 0.2, 0.2)(1)    |
|   2Bt    | (0.05, 0.06, 0.06, 0.07, 0.07)(4) | (1.8, 5.9, 7.8, 8.8, 9.4)(12)  | (0.7, 1.3, 1.7, 1.9, 2.1)(4)  | (0.11, 0.15, 0.16, 0.17, 0.18)(4) |
|   2BCt   | (0.07, 0.07, 0.07, 0.07, 0.07)(2) |  (1, 1.9, 4.3, 5.3, 10.6)(12)  |    (NA, NA, NA, NA, NA)(0)    | (0.07, 0.09, 0.11, 0.12, 0.14)(2) |
| not-used |      (NA, NA, NA, NA, NA)(0)      |  (0.6, 5, 7.2, 8.9, 14.7)(31)  | (1.7, 1.7, 1.7, 1.7, 1.7)(1)  |      (NA, NA, NA, NA, NA)(0)      |
|   2Cd    | (0.04, 0.04, 0.04, 0.05, 0.05)(4) |    (NA, NA, NA, NA, NA)(0)     |    (NA, NA, NA, NA, NA)(0)    | (0.02, 0.02, 0.03, 0.04, 0.06)(4) |


|  genhz   |                altotal                 |                poxalate                |            ptotal            |             dbthirdbar             |
|:--------:|:--------------------------------------:|:--------------------------------------:|:----------------------------:|:----------------------------------:|
|    Ap    | (26484, 32800, 39115, 45430, 51746)(2) | (293.5, 293.5, 293.5, 293.5, 293.5)(1) | (427, 451, 474, 498, 522)(2) |   (1.3, 1.5, 1.5, 1.6, 1.7)(12)    |
|    A     |        (NA, NA, NA, NA, NA)(0)         |        (NA, NA, NA, NA, NA)(0)         |   (NA, NA, NA, NA, NA)(0)    | (1.23, 1.31, 1.39, 1.48, 1.56)(2)  |
|    E     |        (NA, NA, NA, NA, NA)(0)         |        (NA, NA, NA, NA, NA)(0)         |   (NA, NA, NA, NA, NA)(0)    | (2.06, 2.06, 2.06, 2.06, 2.06)(1)  |
|    Bt    | (31040, 39304, 47568, 55832, 64096)(2) |        (NA, NA, NA, NA, NA)(0)         | (295, 318, 342, 366, 389)(2) | (1.45, 1.54, 1.58, 1.62, 1.78)(28) |
|   2Bt    | (60455, 61226, 61997, 62918, 63838)(3) | (146.9, 146.9, 146.9, 146.9, 146.9)(1) | (387, 390, 394, 450, 505)(3) | (1.42, 1.5, 1.54, 1.59, 1.66)(10)  |
|   2BCt   | (47938, 47938, 47938, 47938, 47938)(1) | (116.1, 116.1, 116.1, 116.1, 116.1)(1) | (486, 486, 486, 486, 486)(1) | (1.59, 1.61, 1.69, 1.79, 1.87)(4)  |
| not-used | (34129, 34129, 34129, 34129, 34129)(1) |        (NA, NA, NA, NA, NA)(0)         | (305, 305, 305, 305, 305)(1) | (1.42, 1.77, 1.85, 1.89, 2.02)(20) |
|   2Cd    | (34133, 35101, 36070, 37038, 38006)(2) |      (104, 117, 130, 144, 157)(2)      | (326, 333, 340, 347, 354)(2) | (1.7, 1.81, 1.88, 1.95, 1.98)(10)  |


|  genhz   |             dbovendry              |       aggstabpct        |           wthirdbarclod            |            wfifteenbar            |
|:--------:|:----------------------------------:|:-----------------------:|:----------------------------------:|:---------------------------------:|
|    Ap    | (1.35, 1.56, 1.63, 1.72, 1.77)(12) |  (3, 8, 14, 20, 25)(2)  | (16.5, 17.5, 20.4, 22.8, 24.7)(12) |  (7.5, 9.2, 10.3, 11, 14.7)(14)   |
|    A     |    (1.1, 1.2, 1.4, 1.5, 1.6)(4)    | (NA, NA, NA, NA, NA)(0) | (21.5, 22.7, 23.9, 25.2, 26.4)(2)  |  (8.4, 9.3, 10.2, 11.8, 14.4)(6)  |
|    E     | (2.08, 2.08, 2.08, 2.08, 2.08)(1)  | (NA, NA, NA, NA, NA)(0) |    (9.7, 9.7, 9.7, 9.7, 9.7)(1)    | (10.8, 11.8, 12.9, 15.1, 17.4)(3) |
|    Bt    | (1.56, 1.66, 1.7, 1.73, 1.84)(28)  | (NA, NA, NA, NA, NA)(0) |  (15.4, 18, 19.3, 21.4, 24.8)(28)  |   (8, 10.5, 11.9, 13, 23.5)(30)   |
|   2Bt    | (1.52, 1.62, 1.69, 1.73, 1.77)(10) |   (3, 3, 3, 3, 3)(1)    |      (16, 19, 21, 22, 22)(10)      |  (10.1, 10.6, 12, 12.8, 16.7)(8)  |
|   2BCt   | (1.73, 1.75, 1.79, 1.84, 1.95)(4)  | (NA, NA, NA, NA, NA)(0) | (13.6, 16.2, 18.1, 19.4, 19.8)(4)  |  (8, 8.8, 12.1, 17.2, 23.7)(10)   |
| not-used | (1.57, 1.8, 1.88, 1.94, 2.07)(23)  | (NA, NA, NA, NA, NA)(0) | (10.7, 12.2, 14.2, 15.9, 25.9)(20) |      (5, 7, 10, 20, 29)(33)       |
|   2Cd    |   (1.8, 1.86, 1.94, 2, 2.05)(10)   | (NA, NA, NA, NA, NA)(0) |      (11, 12, 13, 13, 17)(10)      |    (5.5, 7.2, 7.8, 8, 9.3)(7)     |


|  genhz   |          wretentiondiffws          |         wfifteenbartoclay          |                  adod                  |             lep              |
|:--------:|:----------------------------------:|:----------------------------------:|:--------------------------------------:|:----------------------------:|
|    Ap    |    (0.1, 0.1, 0.2, 0.2, 0.2)(7)    |   (0.4, 0.4, 0.5, 0.5, 0.9)(14)    | (1.006, 1.008, 1.01, 1.012, 1.015)(9)  | (2.7, 2.7, 2.7, 2.7, 2.7)(1) |
|    A     |    (0.2, 0.2, 0.2, 0.2, 0.2)(2)    |  (0.4, 0.47, 0.61, 0.82, 1.92)(6)  | (1.009, 1.011, 1.013, 1.016, 1.018)(2) |   (NA, NA, NA, NA, NA)(0)    |
|    E     |      (NA, NA, NA, NA, NA)(0)       | (0.52, 0.54, 0.56, 0.57, 0.59)(3)  |        (NA, NA, NA, NA, NA)(0)         |   (NA, NA, NA, NA, NA)(0)    |
|    Bt    | (0.08, 0.11, 0.13, 0.14, 0.18)(21) | (0.33, 0.39, 0.42, 0.43, 0.52)(29) | (1.01, 1.013, 1.016, 1.019, 1.024)(26) |   (NA, NA, NA, NA, NA)(0)    |
|   2Bt    | (0.06, 0.13, 0.14, 0.15, 0.15)(7)  | (0.41, 0.41, 0.42, 0.43, 0.49)(7)  | (1.013, 1.013, 1.015, 1.018, 1.025)(8) | (4.7, 4.7, 4.7, 4.7, 4.7)(1) |
|   2BCt   | (0.07, 0.07, 0.08, 0.12, 0.17)(3)  |   (0.4, 0.4, 0.5, 0.6, 0.8)(10)    | (1.006, 1.008, 1.009, 1.011, 1.018)(5) | (3.4, 3.4, 3.4, 3.4, 3.4)(1) |
| not-used | (0.08, 0.1, 0.12, 0.15, 0.16)(11)  | (0.3, 0.44, 0.47, 0.59, 0.89)(32)  | (1.004, 1.006, 1.006, 1.01, 1.018)(15) |   (NA, NA, NA, NA, NA)(0)    |
|   2Cd    | (0.06, 0.07, 0.11, 0.14, 0.14)(5)  |  (0.4, 0.43, 0.45, 0.48, 0.48)(5)  | (1.006, 1.007, 1.007, 1.01, 1.013)(7)  | (1.4, 1.4, 1.5, 1.6, 1.6)(2) |


|  genhz   |                  cole                   |       liquidlimit       |           pi            |             cec7clay              |
|:--------:|:---------------------------------------:|:-----------------------:|:-----------------------:|:---------------------------------:|
|    Ap    |  (0.009, 0.015, 0.02, 0.023, 0.027)(7)  | (33, 33, 34, 34, 34)(2) | (13, 14, 16, 17, 18)(2) |      (NA, NA, NA, NA, NA)(0)      |
|    A     | (0.008, 0.011, 0.013, 0.016, 0.019)(2)  | (NA, NA, NA, NA, NA)(0) | (NA, NA, NA, NA, NA)(0) |      (NA, NA, NA, NA, NA)(0)      |
|    E     |         (NA, NA, NA, NA, NA)(0)         | (NA, NA, NA, NA, NA)(0) | (NA, NA, NA, NA, NA)(0) |      (NA, NA, NA, NA, NA)(0)      |
|    Bt    | (0.013, 0.019, 0.024, 0.026, 0.043)(21) | (34, 35, 36, 38, 39)(2) | (20, 20, 20, 21, 21)(2) |      (NA, NA, NA, NA, NA)(0)      |
|   2Bt    |  (0.019, 0.02, 0.021, 0.03, 0.048)(7)   | (36, 36, 36, 36, 36)(1) | (22, 22, 22, 22, 22)(1) |      (NA, NA, NA, NA, NA)(0)      |
|   2BCt   | (0.013, 0.017, 0.021, 0.027, 0.033)(3)  | (NA, NA, NA, NA, NA)(0) | (NA, NA, NA, NA, NA)(0) | (0.53, 0.53, 0.53, 0.53, 0.53)(1) |
| not-used | (0.003, 0.007, 0.009, 0.011, 0.021)(11) | (23, 23, 23, 23, 23)(1) | (10, 10, 10, 10, 10)(1) | (0.36, 0.41, 0.46, 0.46, 0.47)(3) |
|   2Cd    | (0.007, 0.008, 0.014, 0.015, 0.018)(5)  | (20, 20, 20, 20, 20)(1) |   (8, 8, 8, 8, 8)(1)    | (0.41, 0.42, 0.43, 0.44, 0.48)(4) |

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)


|         | cos| sl| fsl|   l| sil| si| scl|  cl| sicl| sc| sic|  c| Sum|
|:--------|---:|--:|---:|---:|---:|--:|---:|---:|----:|--:|---:|--:|---:|
|Ap       |   0|  1|   1|  13|  64|  0|   1|   3|    1|  0|   0|  0|  84|
|A        |   0|  0|   2|   5|  42|  0|   0|   2|    2|  0|   0|  0|  53|
|E        |   0|  0|   0|   6|  24|  0|   0|   7|    8|  0|   0|  0|  45|
|Bt       |   0|  0|   1|  24|   6|  0|   7|  85|   14|  0|   2| 16| 155|
|2Bt      |   0|  0|   0|   4|   1|  0|   0|   6|    2|  0|   0|  1|  14|
|2BCt     |   0|  0|   3|  30|   0|  0|   4|  37|    5|  0|   1|  7|  87|
|not-used |   1|  2|  14| 147|  13|  1|   2|  60|   15|  1|   6| 37| 299|
|2Cd      |   0|  0|   1|  10|   0|  0|   0|   1|    0|  0|   0|  0|  12|
|Sum      |   1|  3|  22| 239| 150|  1|  14| 201|   47|  1|   9| 61| 749|


