# Pedon report


```r
# Set Global Parameters
series <- "Lecyr"
p <- c(0, 0.10, 0.5, 0.90, 1)
```




```
## converting Munsell to RGB ...
## replacing missing lower horizon depths with top depth + 1cm ... [2 horizons]
## finding horizonation errors ...
```

## Summary of Sites

```
##       pedon_id taxonname               pedon_type
## 1   1803-072-9     Lecyr correlates to named soil
## 2 2011CA795024     Lecyr                OSD pedon
## 4   1803-072-2     Lecyr correlates to named soil
## 5 2011CA795025     Lecyr taxadjunct to the series
## 6 2011CA795029     Lecyr correlates to named soil
##                                           describer
## 1 Leon Lato, Stephen Roecker, Carrie-Ann Houdeshell
## 2 Stephen Roecker, Leon Lato, Carrie-Ann Houdeshell
## 4                                         Leon Lato
## 5                                   Stephen Roecker
## 6                                   Stephen Roecker
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 

```
##   value            total_srf    surface_fgravel       surface_gravel
## 1 (all) (10, 31, 75, 78, 79) (0, 0, 10, 16, 20) (10, 30, 70, 74, 75)
##   surface_cobbles  surface_stones surface_boulders surface_channers
## 1 (0, 0, 2, 4, 5) (0, 0, 0, 1, 1)  (0, 0, 0, 0, 0)  (0, 0, 0, 0, 0)
##   surface_flagstones
## 1    (0, 0, 0, 1, 2)
```

## Summary of Pedons

```r
plot(f, label="pedon_id")
```

```
## guessing horizon designations are stored in `hzname`
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-31.png) 

```r
h <- horizons(f)

# Horizon designations by generic horizon
addmargins(table(f@horizons$genhz, f@horizons$hzname))
```

```
##       
##         A Ak B'kkq BAk BAkq Bk Bk1 Bk2 Bkkq Bkkqm Bkq Bkq1 Bkq2 Sum
##   A     4  1     0   0    0  0   0   0    0     0   0    0    0   5
##   BAk   0  0     0   4    1  1   0   0    0     0   0    0    0   6
##   Bk    0  0     1   0    0  0   1   1    1     0   1    1    1   7
##   Bkkq  0  0     0   0    0  1   0   0    2     3   0    0    0   6
##   Sum   4  1     1   4    1  2   1   1    3     3   1    1    1  24
```

```r
# Summarize numeric variables by generic horizon
h$gravel <- h$gravel-h$fine_gravel
h.m <- melt(h, id.vars="genhz", measure.vars=c('clay', 'sand', 'fine_gravel', 'gravel', 'cobbles', 'stones', 'total_frags_pct', 'phfield', 'cce', 'd_value', 'd_chroma', 'm_value', 'm_chroma'))
h.summary <- ddply(h.m, .(variable,genhz), .fun=conditional.l.rv.h.summary)

thk <- ddply(h, .(peiid, genhz), summarize, thickness=sum(hzdepb-hzdept))
thk.m <- melt(thk, id.vars="genhz", measure.vars="thickness")
thk.summary <- ddply(thk.m, .(variable, genhz), .fun=conditional.l.rv.h.summary)

# Range in characteristics for generic horizons (min, 10th, median, 90th, max)
format(cast(rbind(h.summary, thk.summary), genhz ~ variable, value='range'), justify="centre")
```

```
##   genhz               clay                 sand          fine_gravel
## 1   A   (6, 7, 8, 10, 10)  (55, 57, 65, 68, 70)  (5, 7, 10, 18, 20) 
## 2  BAk  (8, 8, 10, 11, 12) (50, 50, 55, 60, 60)  (5, 7, 10, 12, 15) 
## 3   Bk   (4, 4, 6, 8, 10)  (65, 68, 75, 86, 93) (10, 10, 15, 16, 17)
## 4  Bkkq  (6, 6, 7, 9, 10)  (60, 60, 70, 70, 70)  (0, 2, 8, 10, 10)  
##                 gravel            cobbles          stones
## 1 (10, 16, 25, 40, 40)  (0, 0, 1, 4, 5)   (0, 0, 0, 0, 0)
## 2  (6, 8, 30, 50, 50)   (0, 0, 2, 5, 5)   (0, 0, 0, 0, 0)
## 3  (8, 9, 50, 60, 60)  (2, 4, 10, 19, 30) (0, 0, 0, 1, 2)
## 4 (0, 10, 20, 40, 55)   (0, 0, 2, 8, 10)  (0, 0, 0, 1, 2)
##        total_frags_pct                   phfield                  cce
## 1 (27, 32, 46, 53, 55)  (7.9, 7.9, 8, 8.3, 8.4)  (NA, NA, NA, NA, NA)
## 2 (20, 22, 54, 60, 63) (8.3, 8.3, 8.3, 8.4, 8.4) (16, 16, 17, 21, 22)
## 3 (27, 33, 75, 84, 90) (8.3, 8.3, 8.5, 8.7, 8.7) (16, 17, 19, 34, 38)
## 4 (0, 16, 40, 54, 63)  (8.3, 8.3, 8.5, 8.7, 8.7) (24, 25, 26, 38, 43)
##           d_value        d_chroma         m_value        m_chroma
## 1 (5, 5, 5, 6, 6) (3, 3, 4, 4, 4) (3, 3, 4, 4, 4) (4, 4, 4, 4, 4)
## 2 (5, 5, 5, 6, 6) (4, 4, 4, 4, 4) (3, 4, 4, 4, 5) (4, 4, 4, 4, 5)
## 3 (5, 6, 7, 8, 8) (2, 2, 3, 3, 4) (3, 4, 6, 8, 8) (3, 3, 4, 4, 4)
## 4 (5, 6, 7, 8, 8) (2, 2, 3, 4, 4) (4, 5, 6, 7, 7) (3, 4, 4, 4, 4)
##              thickness
## 1   (4, 5, 6, 7, 7)   
## 2 (17, 17, 19, 20, 21)
## 3 (31, 36, 58, 72, 75)
## 4  (1, 6, 23, 41, 47)
```

```r
# Box plots of numeric variables by generic horizon
bwplot(genhz ~ value|variable, data=rbind(h.m, thk.m), scales=list(x="free"))          
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-32.png) 

```r
# Texture by generic horizon
addmargins(table(h$genhz, h$texture_class))
```

```
##       
##        cb  l ls mat  s sl Sum
##   A     0  0  0   0  0  5   5
##   BAk   0  1  0   0  0  5   6
##   Bk    1  0  2   0  1  3   7
##   Bkkq  0  0  0   1  0  5   6
##   Sum   1  1  2   1  1 18  24
```

```r
# Tex Mod & Class by generic horizon
addmargins(table(h$genhz, h$texture))
```

```
##       
##        CB CEM-GRV-SL CEM-MAT GR-SL GRV-L GRV-LS GRV-SL GRX-S GRX-SL Sum
##   A     0          0       0     1     0      0      4     0      0   5
##   BAk   0          0       0     2     1      0      2     0      1   6
##   Bk    1          0       0     1     0      2      0     1      2   7
##   Bkkq  0          2       1     0     0      0      2     0      1   6
##   Sum   1          2       1     4     1      2      8     1      4  24
```

```r
# Dry hue by generic horizon
addmargins(table(h$genhz, h$d_hue))
```

```
##       
##        10YR Sum
##   A       5   5
##   BAk     6   6
##   Bk      7   7
##   Bkkq    6   6
##   Sum    24  24
```

```r
# Moist hue by generic horizon
addmargins(table(h$genhz, h$m_hue))
```

```
##       
##        10YR Sum
##   A       5   5
##   BAk     6   6
##   Bk      7   7
##   Bkkq    6   6
##   Sum    24  24
```

```r
# Dry value by generic horizon
addmargins(table(h$genhz, h$d_value))
```

```
##       
##         5  6  7  8 Sum
##   A     4  1  0  0   5
##   BAk   5  1  0  0   6
##   Bk    1  0  4  2   7
##   Bkkq  1  0  3  2   6
##   Sum  11  2  7  4  24
```

```r
# Moist value by generic horizon
addmargins(table(h$genhz, h$m_value))
```

```
##       
##         3  4  5  6  7  8 Sum
##   A     2  3  0  0  0  0   5
##   BAk   1  4  1  0  0  0   6
##   Bk    1  0  1  2  1  2   7
##   Bkkq  0  1  0  3  2  0   6
##   Sum   4  8  2  5  3  2  24
```

```r
# Dry chroma by generic horizon
addmargins(table(h$genhz, h$d_chroma))
```

```
##       
##         2  3  4 Sum
##   A     0  1  4   5
##   BAk   0  0  6   6
##   Bk    3  3  1   7
##   Bkkq  2  2  2   6
##   Sum   5  6 13  24
```

```r
# Moist chroma by generic horizon
addmargins(table(h$genhz, h$m_chroma))
```

```
##       
##         3  4  5 Sum
##   A     0  5  0   5
##   BAk   0  5  1   6
##   Bk    3  4  0   7
##   Bkkq  1  5  0   6
##   Sum   4 19  1  24
```

```r
# Effervescence by generic horizon
addmargins(table(h$genhz, h$effervescence))
```

```
##       
##        strong violent Sum
##   A         2       3   5
##   BAk       0       6   6
##   Bk        0       6   6
##   Bkkq      1       5   6
##   Sum       3      20  23
```

```r
# Thickness of diagnostic horizons
diag.thk <- ddply(f@diagnostic, .(peiid, diag_kind), summarize, thickness=sum(featdepb-featdept))
diag.m <- melt(f@diagnostic, id.vars="diag_kind", measure.vars=c('featdept', 'featdepb'))
diag.thk.m <- melt(diag.thk, id.vars="diag_kind", measure.vars='thickness')
diag.m <- rbind(diag.m, diag.thk.m)
d.cs <- ddply(diag.m, .(variable, diag_kind), .fun=conditional.l.rv.h.summary)
format(cast(d.cs, diag_kind ~ variable, value='range'), justify="centre")
```

```
##         diag_kind           featdept               featdepb
## 1 calcic horizon  (6, 9, 21, 26, 26) (50, 58, 76, 128, 150)
## 2 cambic horizon   (7, 7, 7, 7, 7)    (26, 26, 26, 26, 26) 
## 3 ochric epipedon  (0, 0, 0, 0, 0)     (6, 6, 14, 20, 21)  
##                thickness
## 1 (44, 46, 54, 112, 136)
## 2  (19, 19, 19, 19, 19) 
## 3   (6, 6, 14, 20, 21)
```

```r
bwplot(diag_kind ~ value|variable, data=diag.m, scales=list(x="free"), xlab="cm")          
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-33.png) 

