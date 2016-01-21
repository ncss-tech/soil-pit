
# Map Unit Spatial Summary Report

This report summarizes the geographic setting of a list of MUSYM within a shapefile. It is intented to be used to compare and contrast map units, and suggest possible Low, RV, and High values for soil components. 








### Shapefile Name

```
## [1] "201511IND034_Clrmntsltlm,0t1prcns_QA"
```


### Variables


|Abbreviation |Measures                            |Unit                                 |Source                                                           |
|:------------|:-----------------------------------|:------------------------------------|:----------------------------------------------------------------|
|elev         |elevation                           |meters                               |30-meter USGS National Elevation Dataset (NED)                   |
|slope        |slope gradient                      |percent                              |10-meter NED                                                     |
|aspect       |slope aspect                        |degrees                              |10-meter NED                                                     |
|valley       |multiresolution valley bottom index |unitless                             |30-meter NED                                                     |
|wetness      |topographic Wetness index           |unitless                             |30-meter NED                                                     |
|relief       |height above channel                |meters                               |30-meter NED                                                     |
|ppt          |annual precipitation                |millimeters                          |800-meter 30-year normals (1981-2010) from PRISM Climate Dataset |
|temp         |annual air temperature              |degrees Celsius                      |800-meter 30-year normals (1981-2010) from PRISM Climate Dataset |
|ffp          |frost free period                   |days                                 |1000-meter 30-year normals (1961-1990) from USFS RMRS            |
|lulc         |land use and land cover             |landcover class (e.g. Wood Wetlands) |2011 National Land Cover Dataset (NLCD)                          |


## Map of soil polygons
Don't be concerned if the soil map units don't line up with the counties. The county layer being used is an internal R layer that is highly generalized.

![plot of chunk plot soil map units](figure/plot soil map units-1.png)

## Soil polygon metrics
Five number summary (min, 25th, median, 75th, max)(percentiles) and contingency table (counts)(n) 
Circularity is an estimate of SHAPE complexity (Hole and Campbell, 1975), computed as a ratio of mupolygon length / mupolygon circumference. The SHAPE complexity of a perfect circle would equal 1.


|  SSA_MUSYM   | variable |         range         | nArces | nPolygons |
|:------------:|:--------:|:---------------------:|:------:|:---------:|
| *mlra_mapnit |  Acres   | (0, 4, 9, 30, 18610)  | 182722 |   1415    |
| OH015 Cle1A  |  Acres   | (0, 7, 21, 64, 18610) | 66890  |    215    |
| OH025 Cle1A  |  Acres   | (0, 3, 8, 20, 14186)  | 46565  |    406    |
| OH027 Cle1A  |  Acres   | (0, 5, 13, 44, 3843)  | 17541  |    229    |
| OH071 Cle1A  |  Acres   |  (0, 4, 7, 20, 9195)  | 32665  |    309    |
| OH165 Cle1A  |  Acres   |  (1, 4, 9, 30, 4973)  | 19062  |    256    |

```
## Error in kable_markdown(x = structure(character(0), .Dim = c(0L, 0L), .Dimnames = list(: the table must have a header (column names)
```

![plot of chunk soil polygon metrics](figure/soil polygon metrics-1.png)

## Contingency tables (percent) 


|             | 0-2 | 2-6 | 6-12 | 12-18 | 18-30 | 30-50 | 50-75 | 75-350 |
|:------------|:---:|:---:|:----:|:-----:|:-----:|:-----:|:-----:|:------:|
|*mlra_mapnit | 93  |  7  |  0   |   0   |   0   |   0   |   0   |   0    |
|OH015 Cle1A  | 93  |  7  |  0   |   0   |   0   |   0   |   0   |   0    |
|OH025 Cle1A  | 93  |  7  |  0   |   0   |   0   |   0   |   0   |   0    |
|OH027 Cle1A  | 94  |  6  |  0   |   0   |   0   |   0   |   0   |   0    |
|OH071 Cle1A  | 95  |  5  |  0   |   0   |   0   |   0   |   0   |   0    |
|OH165 Cle1A  | 83  | 17  |  0   |   0   |   0   |   0   |   0   |   0    |



|             | N  | NE | E | SE | S  | SW | W  | NW |
|:------------|:--:|:--:|:-:|:--:|:--:|:--:|:--:|:--:|
|*mlra_mapnit | 9  | 7  | 9 | 11 | 13 | 17 | 21 | 14 |
|OH015 Cle1A  | 9  | 7  | 9 | 11 | 13 | 18 | 19 | 14 |
|OH025 Cle1A  | 10 | 8  | 8 | 10 | 12 | 16 | 22 | 15 |
|OH027 Cle1A  | 9  | 6  | 8 | 12 | 12 | 15 | 22 | 18 |
|OH071 Cle1A  | 6  | 6  | 9 | 12 | 14 | 21 | 21 | 11 |
|OH165 Cle1A  | 10 | 8  | 9 | 12 | 12 | 13 | 19 | 17 |



|             | upland | lowland |
|:------------|:------:|:-------:|
|*mlra_mapnit |   3    |   97    |
|OH015 Cle1A  |   4    |   96    |
|OH025 Cle1A  |   4    |   96    |
|OH027 Cle1A  |   1    |   99    |
|OH071 Cle1A  |   1    |   99    |
|OH165 Cle1A  |   5    |   95    |



|             | Unclassified | NA | Open Water | Perennial Snow/Ice | Developed, Open Space | Developed, Low Intensity | Developed, Medium Intensity | Developed, High Intensity | Barren Land | Deciduous Forest |
|:------------|:------------:|:--:|:----------:|:------------------:|:---------------------:|:------------------------:|:---------------------------:|:-------------------------:|:-----------:|:----------------:|
|*mlra_mapnit |      0       | 0  |     0      |         0          |           4           |            2             |              0              |             0             |      0      |        22        |
|OH015 Cle1A  |      0       | 0  |     0      |         0          |           4           |            2             |              0              |             0             |      0      |        21        |
|OH025 Cle1A  |      0       | 0  |     0      |         0          |           6           |            3             |              1              |             0             |      0      |        33        |
|OH027 Cle1A  |      0       | 0  |     0      |         0          |           2           |            1             |              0              |             0             |      0      |        13        |
|OH071 Cle1A  |      0       | 0  |     0      |         0          |           3           |            1             |              0              |             0             |      0      |        13        |
|OH165 Cle1A  |      0       | 0  |     0      |         0          |           6           |            3             |              1              |             0             |      0      |        20        |
|Sum          |      0       | 0  |     0      |         0          |          26           |            12            |              3              |             1             |      0      |       121        |


|             | Evergreen Forest | Mixed Forest | Shrub/Scrub | Herbaceuous | Hay/Pasture | Cultivated Crops | Woody Wetlands | Emergent Herbaceuous Wetlands | Sum |
|:------------|:----------------:|:------------:|:-----------:|:-----------:|:-----------:|:----------------:|:--------------:|:-----------------------------:|:---:|
|*mlra_mapnit |        0         |      1       |      0      |      1      |      7      |        62        |       0        |               0               | 100 |
|OH015 Cle1A  |        0         |      1       |      0      |      1      |      6      |        64        |       0        |               0               | 100 |
|OH025 Cle1A  |        0         |      0       |      0      |      1      |     10      |        47        |       0        |               0               | 100 |
|OH027 Cle1A  |        0         |      2       |      0      |      0      |      4      |        77        |       0        |               0               | 100 |
|OH071 Cle1A  |        0         |      1       |      0      |      0      |      2      |        79        |       0        |               0               | 100 |
|OH165 Cle1A  |        0         |      0       |      0      |      0      |     16      |        52        |       0        |               0               | 100 |
|Sum          |        1         |      4       |      1      |      4      |     46      |       382        |       0        |               0               | 600 |

## Quantile breaks
Five number summary (min, 25th, median, 75th, max)(percentiles) and number of random samples (n)


|  SSA_MUSYM   |           elev            |      slope       |     valley      |       wetness        |      relief      |   n    |
|:------------:|:-------------------------:|:----------------:|:---------------:|:--------------------:|:----------------:|:------:|
| *mlra_mapnit | (197, 279, 289, 301, 343) | (0, 0, 1, 1, 39) | (0, 3, 4, 5, 7) | (9, 13, 14, 15, 23)  | (0, 0, 1, 1, 56) | 164106 |
| OH015 Cle1A  | (263, 286, 290, 297, 329) | (0, 0, 1, 1, 33) | (0, 3, 4, 6, 6) | (9, 13, 14, 15, 22)  | (0, 0, 1, 1, 18) | 60113  |
| OH025 Cle1A  | (218, 270, 275, 280, 296) | (0, 0, 1, 1, 18) | (0, 3, 4, 5, 7) | (10, 13, 14, 15, 22) | (0, 0, 1, 1, 28) | 41856  |
| OH027 Cle1A  | (277, 299, 304, 309, 328) | (0, 0, 0, 1, 10) | (0, 5, 5, 6, 6) | (10, 13, 14, 15, 23) | (0, 0, 1, 1, 29) | 15769  |
| OH071 Cle1A  | (270, 299, 308, 316, 343) | (0, 0, 0, 1, 36) | (0, 4, 5, 6, 6) | (9, 13, 14, 15, 22)  | (0, 0, 1, 1, 18) | 29281  |
| OH165 Cle1A  | (197, 268, 280, 288, 302) | (0, 0, 1, 1, 39) | (0, 2, 3, 4, 6) | (10, 13, 13, 14, 20) | (0, 1, 1, 2, 56) | 17087  |



|  SSA_MUSYM   |              ppt               |         temp         |            ffp            |         aspect          |   n    |
|:------------:|:------------------------------:|:--------------------:|:-------------------------:|:-----------------------:|:------:|
| *mlra_mapnit | (1035, 1078, 1085, 1092, 1150) | (11, 11, 12, 12, 13) | (171, 175, 175, 175, 178) | (69, 307, 250, 180, 70) | 164106 |
| OH015 Cle1A  | (1080, 1087, 1092, 1101, 1150) | (11, 12, 12, 12, 12) | (174, 175, 175, 175, 177) | (66, 306, 246, 178, 67) | 60113  |
| OH025 Cle1A  | (1035, 1076, 1079, 1081, 1096) | (11, 12, 12, 12, 13) | (175, 175, 175, 176, 178) | (81, 319, 262, 196, 82) | 41856  |
| OH027 Cle1A  | (1048, 1065, 1077, 1086, 1098) | (11, 11, 11, 11, 12) | (173, 174, 175, 175, 175) | (81, 313, 262, 188, 82) | 15769  |
| OH071 Cle1A  | (1048, 1084, 1088, 1093, 1102) | (11, 11, 11, 12, 12) | (171, 175, 175, 175, 175) | (49, 280, 230, 163, 50) | 29281  |
| OH165 Cle1A  | (1037, 1054, 1069, 1072, 1078) | (11, 12, 12, 12, 13) | (173, 174, 175, 175, 177) | (87, 325, 267, 186, 88) | 17087  |

![plot of chunk quantiles by musym](figure/quantiles by musym-1.png)
