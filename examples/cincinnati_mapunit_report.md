Map Unit Spatial Summary Report
===============================

This report summarizes the geographic setting of a list of MUKEY within a file geodatabase. It is intented to be used to compare and contrast map units, and suggest possible Low, RV, and High values for components.

### Project Name

    ## [1] "SDJR - MLRA 114A - Cincinnati silt loam, 6 to 12 percent slopes, eroded"

### Variables

|Abbreviation|Measure|Units|Source|
|------------|-------|-----|------|
|elev|elevation|meters|30-meter USGS National Elevation Dataset (NED)|
|slope|slope gradient|percent|10-meter NED|
|aspect|slope aspect|degrees|10-meter NED|
|valley|multiresolution valley bottom index|unitless|30-meter NED|
|wetness|topographic wetness index|unitless|30-meter NED|
|relief|height above channel|meters|30-meter NED|
|ppt|annual precipitation|millimeters|800-meter 30-year normals (1981-2010) from PRISM Climate Dataset|
|temp|anuual air temperature|degrees Celsius|800-meter 30-year normals (1981-2010) from PRISM Climate Dataset|
|ffp|frost free period|days|1000-meter 30-year normals (1961-1990) from USFS RMRS|
|lulc|land use and land cover|landcover class (e.g. Woody Wetlands)|2011 National Land Cover Dataset (NLCD)|

Map of soil map units
---------------------

Don't be concerned if the soil map units don't line up with the counties. The county layer being used is an internal R layer that is highly generalized. ![](cincinnati_mapunit_report_files/figure-markdown_github/plot%20soil%20map%20units-1.png)

Soil polygon metrics
--------------------

Five number summary (min, 25th, median, 75th, max)(percentiles) and contingency table (counts)(n)

<!-- html table generated in R 3.1.1 by xtable 1.7-4 package -->
<!-- Tue Mar 31 13:01:14 2015 -->
<table border=1>
<caption align="top"> 
Summary of MUSYM by AREASYMBOL
</caption>
<tr> <th>  </th> <th> 
SSA\_MUSYM
</th> <th> 
variable
</th> <th> 
range
</th> <th> 
nArces
</th> <th> 
nPolygons
</th>  </tr>
  <tr> <td align="center"> 
1
</td> <td align="center"> 
\*new\_mlra\_mapunit
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(0, 3, 7, 15, 931)
</td> <td align="center"> 
94393
</td> <td align="center"> 
6761
</td> </tr>
  <tr> <td align="center"> 
2
</td> <td align="center"> 
IN029 CnC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(0, 4, 9, 15, 97)
</td> <td align="center"> 
3513
</td> <td align="center"> 
308
</td> </tr>
  <tr> <td align="center"> 
3
</td> <td align="center"> 
IN031 CkC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(0, 3, 5, 10, 48)
</td> <td align="center"> 
2175
</td> <td align="center"> 
270
</td> </tr>
  <tr> <td align="center"> 
4
</td> <td align="center"> 
IN041 CcC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(0, 2, 3, 7, 74)
</td> <td align="center"> 
1043
</td> <td align="center"> 
163
</td> </tr>
  <tr> <td align="center"> 
5
</td> <td align="center"> 
IN047 CkC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(0, 4, 7, 14, 223)
</td> <td align="center"> 
6867
</td> <td align="center"> 
590
</td> </tr>
  <tr> <td align="center"> 
6
</td> <td align="center"> 
IN071 CkkC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(1, 4, 7, 14, 155)
</td> <td align="center"> 
5335
</td> <td align="center"> 
454
</td> </tr>
  <tr> <td align="center"> 
7
</td> <td align="center"> 
IN077 CnC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(0, 3, 5, 11, 150)
</td> <td align="center"> 
9506
</td> <td align="center"> 
949
</td> </tr>
  <tr> <td align="center"> 
8
</td> <td align="center"> 
IN115 CnC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(0, 4, 6, 11, 44)
</td> <td align="center"> 
389
</td> <td align="center"> 
41
</td> </tr>
  <tr> <td align="center"> 
9
</td> <td align="center"> 
IN137 CcC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(0, 3, 6, 14, 241)
</td> <td align="center"> 
19756
</td> <td align="center"> 
1617
</td> </tr>
  <tr> <td align="center"> 
10
</td> <td align="center"> 
IN155 CnC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(0, 6, 12, 27, 189)
</td> <td align="center"> 
5204
</td> <td align="center"> 
224
</td> </tr>
  <tr> <td align="center"> 
11
</td> <td align="center"> 
IN175 ChC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(1, 8, 15, 33, 931)
</td> <td align="center"> 
2249
</td> <td align="center"> 
48
</td> </tr>
  <tr> <td align="center"> 
12
</td> <td align="center"> 
OH001 CkC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(2, 6, 10, 23, 132)
</td> <td align="center"> 
2674
</td> <td align="center"> 
146
</td> </tr>
  <tr> <td align="center"> 
13
</td> <td align="center"> 
OH015 CnC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(1, 6, 12, 21, 475)
</td> <td align="center"> 
1283
</td> <td align="center"> 
55
</td> </tr>
  <tr> <td align="center"> 
14
</td> <td align="center"> 
OH017 CnC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(1, 5, 11, 29, 199)
</td> <td align="center"> 
467
</td> <td align="center"> 
15
</td> </tr>
  <tr> <td align="center"> 
15
</td> <td align="center"> 
OH025 CcC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(0, 4, 9, 21, 430)
</td> <td align="center"> 
23624
</td> <td align="center"> 
1212
</td> </tr>
  <tr> <td align="center"> 
16
</td> <td align="center"> 
OH025 CnC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(12, 33, 54, 75, 96)
</td> <td align="center"> 
109
</td> <td align="center"> 
2
</td> </tr>
  <tr> <td align="center"> 
17
</td> <td align="center"> 
OH045 CkC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(0, 10, 19, 34, 396)
</td> <td align="center"> 
3067
</td> <td align="center"> 
73
</td> </tr>
  <tr> <td align="center"> 
18
</td> <td align="center"> 
OH061 CmC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(0, 2, 4, 9, 22)
</td> <td align="center"> 
72
</td> <td align="center"> 
11
</td> </tr>
  <tr> <td align="center"> 
19
</td> <td align="center"> 
OH071 ChC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(1, 3, 6, 12, 87)
</td> <td align="center"> 
1715
</td> <td align="center"> 
192
</td> </tr>
  <tr> <td align="center"> 
20
</td> <td align="center"> 
OH073 CkC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(5, 15, 21, 44, 162)
</td> <td align="center"> 
870
</td> <td align="center"> 
27
</td> </tr>
  <tr> <td align="center"> 
21
</td> <td align="center"> 
OH089 CkC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(2, 7, 17, 27, 128)
</td> <td align="center"> 
2164
</td> <td align="center"> 
93
</td> </tr>
  <tr> <td align="center"> 
22
</td> <td align="center"> 
OH165 CnC2
</td> <td align="center"> 
Acres
</td> <td align="center"> 
(1, 3, 5, 10, 81)
</td> <td align="center"> 
2312
</td> <td align="center"> 
271
</td> </tr>
   </table>

Polygon Boxplots
----------------

Graphical five number summary plus outliers (outliers, 5th, 25th, median, 75th, 95th, outliers)(percentiles). Circularity is an estimate of shape complexity (Hole and Campbell, 1975), computed as a ratio of mupolygon length / mupolygon circumference. The shape complexity of a perfect circle would equal 1. ![](cincinnati_mapunit_report_files/figure-markdown_github/bwplot%20of%20polygon%20metrics-1.png)

Contingency tables (percent)
----------------------------

<!-- html table generated in R 3.1.1 by xtable 1.7-4 package -->
<!-- Tue Mar 31 13:01:15 2015 -->
<table border=1>
<caption align="top"> 
Slope breaks
</caption>
<tr> <th>  </th> <th> 
0-2
</th> <th> 
2-6
</th> <th> 
6-12
</th> <th> 
12-18
</th> <th> 
18-30
</th> <th> 
30-50
</th> <th> 
50-75
</th> <th> 
75-350
</th>  </tr>
  <tr> <td align="center"> 
\*new\_mlra\_mapunit
</td> <td align="center"> 
3
</td> <td align="center"> 
30
</td> <td align="center"> 
47
</td> <td align="center"> 
15
</td> <td align="center"> 
5
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
IN029 CnC2
</td> <td align="center"> 
6
</td> <td align="center"> 
35
</td> <td align="center"> 
46
</td> <td align="center"> 
11
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
IN031 CkC2
</td> <td align="center"> 
8
</td> <td align="center"> 
35
</td> <td align="center"> 
43
</td> <td align="center"> 
12
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
IN041 CcC2
</td> <td align="center"> 
1
</td> <td align="center"> 
16
</td> <td align="center"> 
57
</td> <td align="center"> 
20
</td> <td align="center"> 
6
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
IN047 CkC2
</td> <td align="center"> 
3
</td> <td align="center"> 
19
</td> <td align="center"> 
39
</td> <td align="center"> 
27
</td> <td align="center"> 
12
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
IN071 CkkC2
</td> <td align="center"> 
1
</td> <td align="center"> 
29
</td> <td align="center"> 
61
</td> <td align="center"> 
8
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
IN077 CnC2
</td> <td align="center"> 
4
</td> <td align="center"> 
30
</td> <td align="center"> 
51
</td> <td align="center"> 
13
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
IN115 CnC2
</td> <td align="center"> 
6
</td> <td align="center"> 
27
</td> <td align="center"> 
43
</td> <td align="center"> 
19
</td> <td align="center"> 
6
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
IN137 CcC2
</td> <td align="center"> 
7
</td> <td align="center"> 
33
</td> <td align="center"> 
44
</td> <td align="center"> 
13
</td> <td align="center"> 
3
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
IN155 CnC2
</td> <td align="center"> 
3
</td> <td align="center"> 
30
</td> <td align="center"> 
48
</td> <td align="center"> 
15
</td> <td align="center"> 
4
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
IN175 ChC2
</td> <td align="center"> 
1
</td> <td align="center"> 
24
</td> <td align="center"> 
62
</td> <td align="center"> 
11
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
OH001 CkC2
</td> <td align="center"> 
3
</td> <td align="center"> 
45
</td> <td align="center"> 
42
</td> <td align="center"> 
8
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
OH015 CnC2
</td> <td align="center"> 
2
</td> <td align="center"> 
29
</td> <td align="center"> 
46
</td> <td align="center"> 
19
</td> <td align="center"> 
3
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
OH017 CnC2
</td> <td align="center"> 
0
</td> <td align="center"> 
18
</td> <td align="center"> 
50
</td> <td align="center"> 
20
</td> <td align="center"> 
9
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
OH025 CcC2
</td> <td align="center"> 
2
</td> <td align="center"> 
30
</td> <td align="center"> 
44
</td> <td align="center"> 
16
</td> <td align="center"> 
7
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
OH025 CnC2
</td> <td align="center"> 
4
</td> <td align="center"> 
31
</td> <td align="center"> 
51
</td> <td align="center"> 
12
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
OH045 CkC2
</td> <td align="center"> 
1
</td> <td align="center"> 
13
</td> <td align="center"> 
56
</td> <td align="center"> 
24
</td> <td align="center"> 
6
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
OH061 CmC2
</td> <td align="center"> 
0
</td> <td align="center"> 
4
</td> <td align="center"> 
33
</td> <td align="center"> 
35
</td> <td align="center"> 
27
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
OH071 ChC2
</td> <td align="center"> 
1
</td> <td align="center"> 
33
</td> <td align="center"> 
54
</td> <td align="center"> 
9
</td> <td align="center"> 
3
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
OH073 CkC2
</td> <td align="center"> 
1
</td> <td align="center"> 
13
</td> <td align="center"> 
45
</td> <td align="center"> 
31
</td> <td align="center"> 
10
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
OH089 CkC2
</td> <td align="center"> 
1
</td> <td align="center"> 
15
</td> <td align="center"> 
57
</td> <td align="center"> 
23
</td> <td align="center"> 
4
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
  <tr> <td align="center"> 
OH165 CnC2
</td> <td align="center"> 
3
</td> <td align="center"> 
50
</td> <td align="center"> 
37
</td> <td align="center"> 
6
</td> <td align="center"> 
3
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> </tr>
   </table>
<!-- html table generated in R 3.1.1 by xtable 1.7-4 package -->
<!-- Tue Mar 31 13:01:15 2015 -->
<table border=1>
<caption align="top"> 
Aspect breaks
</caption>
<tr> <th>  </th> <th> 
N
</th> <th> 
NE
</th> <th> 
E
</th> <th> 
SE
</th> <th> 
S
</th> <th> 
SW
</th> <th> 
W
</th> <th> 
NW
</th>  </tr>
  <tr> <td align="center"> 
\*new\_mlra\_mapunit
</td> <td align="center"> 
11
</td> <td align="center"> 
11
</td> <td align="center"> 
12
</td> <td align="center"> 
14
</td> <td align="center"> 
14
</td> <td align="center"> 
13
</td> <td align="center"> 
13
</td> <td align="center"> 
12
</td> </tr>
  <tr> <td align="center"> 
IN029 CnC2
</td> <td align="center"> 
8
</td> <td align="center"> 
14
</td> <td align="center"> 
14
</td> <td align="center"> 
14
</td> <td align="center"> 
15
</td> <td align="center"> 
15
</td> <td align="center"> 
12
</td> <td align="center"> 
8
</td> </tr>
  <tr> <td align="center"> 
IN031 CkC2
</td> <td align="center"> 
9
</td> <td align="center"> 
9
</td> <td align="center"> 
12
</td> <td align="center"> 
14
</td> <td align="center"> 
13
</td> <td align="center"> 
15
</td> <td align="center"> 
14
</td> <td align="center"> 
14
</td> </tr>
  <tr> <td align="center"> 
IN041 CcC2
</td> <td align="center"> 
13
</td> <td align="center"> 
15
</td> <td align="center"> 
14
</td> <td align="center"> 
12
</td> <td align="center"> 
13
</td> <td align="center"> 
13
</td> <td align="center"> 
11
</td> <td align="center"> 
11
</td> </tr>
  <tr> <td align="center"> 
IN047 CkC2
</td> <td align="center"> 
11
</td> <td align="center"> 
11
</td> <td align="center"> 
11
</td> <td align="center"> 
12
</td> <td align="center"> 
14
</td> <td align="center"> 
15
</td> <td align="center"> 
13
</td> <td align="center"> 
12
</td> </tr>
  <tr> <td align="center"> 
IN071 CkkC2
</td> <td align="center"> 
9
</td> <td align="center"> 
10
</td> <td align="center"> 
12
</td> <td align="center"> 
16
</td> <td align="center"> 
16
</td> <td align="center"> 
15
</td> <td align="center"> 
11
</td> <td align="center"> 
10
</td> </tr>
  <tr> <td align="center"> 
IN077 CnC2
</td> <td align="center"> 
10
</td> <td align="center"> 
8
</td> <td align="center"> 
11
</td> <td align="center"> 
15
</td> <td align="center"> 
15
</td> <td align="center"> 
14
</td> <td align="center"> 
14
</td> <td align="center"> 
14
</td> </tr>
  <tr> <td align="center"> 
IN115 CnC2
</td> <td align="center"> 
12
</td> <td align="center"> 
15
</td> <td align="center"> 
13
</td> <td align="center"> 
10
</td> <td align="center"> 
13
</td> <td align="center"> 
13
</td> <td align="center"> 
10
</td> <td align="center"> 
13
</td> </tr>
  <tr> <td align="center"> 
IN137 CcC2
</td> <td align="center"> 
11
</td> <td align="center"> 
11
</td> <td align="center"> 
12
</td> <td align="center"> 
13
</td> <td align="center"> 
14
</td> <td align="center"> 
14
</td> <td align="center"> 
13
</td> <td align="center"> 
12
</td> </tr>
  <tr> <td align="center"> 
IN155 CnC2
</td> <td align="center"> 
11
</td> <td align="center"> 
13
</td> <td align="center"> 
16
</td> <td align="center"> 
15
</td> <td align="center"> 
13
</td> <td align="center"> 
13
</td> <td align="center"> 
11
</td> <td align="center"> 
9
</td> </tr>
  <tr> <td align="center"> 
IN175 ChC2
</td> <td align="center"> 
11
</td> <td align="center"> 
12
</td> <td align="center"> 
13
</td> <td align="center"> 
18
</td> <td align="center"> 
15
</td> <td align="center"> 
8
</td> <td align="center"> 
11
</td> <td align="center"> 
12
</td> </tr>
  <tr> <td align="center"> 
OH001 CkC2
</td> <td align="center"> 
12
</td> <td align="center"> 
13
</td> <td align="center"> 
12
</td> <td align="center"> 
12
</td> <td align="center"> 
13
</td> <td align="center"> 
13
</td> <td align="center"> 
12
</td> <td align="center"> 
13
</td> </tr>
  <tr> <td align="center"> 
OH015 CnC2
</td> <td align="center"> 
8
</td> <td align="center"> 
13
</td> <td align="center"> 
16
</td> <td align="center"> 
12
</td> <td align="center"> 
13
</td> <td align="center"> 
15
</td> <td align="center"> 
14
</td> <td align="center"> 
10
</td> </tr>
  <tr> <td align="center"> 
OH017 CnC2
</td> <td align="center"> 
10
</td> <td align="center"> 
6
</td> <td align="center"> 
5
</td> <td align="center"> 
15
</td> <td align="center"> 
17
</td> <td align="center"> 
10
</td> <td align="center"> 
14
</td> <td align="center"> 
24
</td> </tr>
  <tr> <td align="center"> 
OH025 CcC2
</td> <td align="center"> 
11
</td> <td align="center"> 
10
</td> <td align="center"> 
11
</td> <td align="center"> 
13
</td> <td align="center"> 
13
</td> <td align="center"> 
13
</td> <td align="center"> 
15
</td> <td align="center"> 
14
</td> </tr>
  <tr> <td align="center"> 
OH025 CnC2
</td> <td align="center"> 
13
</td> <td align="center"> 
8
</td> <td align="center"> 
5
</td> <td align="center"> 
2
</td> <td align="center"> 
8
</td> <td align="center"> 
17
</td> <td align="center"> 
19
</td> <td align="center"> 
27
</td> </tr>
  <tr> <td align="center"> 
OH045 CkC2
</td> <td align="center"> 
12
</td> <td align="center"> 
13
</td> <td align="center"> 
11
</td> <td align="center"> 
14
</td> <td align="center"> 
13
</td> <td align="center"> 
13
</td> <td align="center"> 
12
</td> <td align="center"> 
13
</td> </tr>
  <tr> <td align="center"> 
OH061 CmC2
</td> <td align="center"> 
13
</td> <td align="center"> 
9
</td> <td align="center"> 
2
</td> <td align="center"> 
15
</td> <td align="center"> 
15
</td> <td align="center"> 
15
</td> <td align="center"> 
18
</td> <td align="center"> 
15
</td> </tr>
  <tr> <td align="center"> 
OH071 ChC2
</td> <td align="center"> 
13
</td> <td align="center"> 
13
</td> <td align="center"> 
13
</td> <td align="center"> 
13
</td> <td align="center"> 
10
</td> <td align="center"> 
13
</td> <td align="center"> 
14
</td> <td align="center"> 
12
</td> </tr>
  <tr> <td align="center"> 
OH073 CkC2
</td> <td align="center"> 
6
</td> <td align="center"> 
13
</td> <td align="center"> 
13
</td> <td align="center"> 
15
</td> <td align="center"> 
17
</td> <td align="center"> 
17
</td> <td align="center"> 
12
</td> <td align="center"> 
7
</td> </tr>
  <tr> <td align="center"> 
OH089 CkC2
</td> <td align="center"> 
10
</td> <td align="center"> 
11
</td> <td align="center"> 
12
</td> <td align="center"> 
19
</td> <td align="center"> 
17
</td> <td align="center"> 
12
</td> <td align="center"> 
11
</td> <td align="center"> 
9
</td> </tr>
  <tr> <td align="center"> 
OH165 CnC2
</td> <td align="center"> 
15
</td> <td align="center"> 
10
</td> <td align="center"> 
12
</td> <td align="center"> 
11
</td> <td align="center"> 
11
</td> <td align="center"> 
11
</td> <td align="center"> 
12
</td> <td align="center"> 
17
</td> </tr>
   </table>
<!-- html table generated in R 3.1.1 by xtable 1.7-4 package -->
<!-- Tue Mar 31 13:01:15 2015 -->
<table border=1>
<caption align="top"> 
Upland vs. lowland
</caption>
<tr> <th>  </th> <th> 
upland
</th> <th> 
lowland
</th>  </tr>
  <tr> <td align="center"> 
\*new\_mlra\_mapunit
</td> <td align="center"> 
43
</td> <td align="center"> 
57
</td> </tr>
  <tr> <td align="center"> 
IN029 CnC2
</td> <td align="center"> 
52
</td> <td align="center"> 
48
</td> </tr>
  <tr> <td align="center"> 
IN031 CkC2
</td> <td align="center"> 
28
</td> <td align="center"> 
72
</td> </tr>
  <tr> <td align="center"> 
IN041 CcC2
</td> <td align="center"> 
71
</td> <td align="center"> 
29
</td> </tr>
  <tr> <td align="center"> 
IN047 CkC2
</td> <td align="center"> 
66
</td> <td align="center"> 
34
</td> </tr>
  <tr> <td align="center"> 
IN071 CkkC2
</td> <td align="center"> 
38
</td> <td align="center"> 
62
</td> </tr>
  <tr> <td align="center"> 
IN077 CnC2
</td> <td align="center"> 
33
</td> <td align="center"> 
67
</td> </tr>
  <tr> <td align="center"> 
IN115 CnC2
</td> <td align="center"> 
56
</td> <td align="center"> 
44
</td> </tr>
  <tr> <td align="center"> 
IN137 CcC2
</td> <td align="center"> 
34
</td> <td align="center"> 
66
</td> </tr>
  <tr> <td align="center"> 
IN155 CnC2
</td> <td align="center"> 
40
</td> <td align="center"> 
60
</td> </tr>
  <tr> <td align="center"> 
IN175 ChC2
</td> <td align="center"> 
50
</td> <td align="center"> 
50
</td> </tr>
  <tr> <td align="center"> 
OH001 CkC2
</td> <td align="center"> 
24
</td> <td align="center"> 
76
</td> </tr>
  <tr> <td align="center"> 
OH015 CnC2
</td> <td align="center"> 
71
</td> <td align="center"> 
29
</td> </tr>
  <tr> <td align="center"> 
OH017 CnC2
</td> <td align="center"> 
62
</td> <td align="center"> 
38
</td> </tr>
  <tr> <td align="center"> 
OH025 CcC2
</td> <td align="center"> 
47
</td> <td align="center"> 
53
</td> </tr>
  <tr> <td align="center"> 
OH025 CnC2
</td> <td align="center"> 
46
</td> <td align="center"> 
54
</td> </tr>
  <tr> <td align="center"> 
OH045 CkC2
</td> <td align="center"> 
65
</td> <td align="center"> 
35
</td> </tr>
  <tr> <td align="center"> 
OH061 CmC2
</td> <td align="center"> 
85
</td> <td align="center"> 
15
</td> </tr>
  <tr> <td align="center"> 
OH071 ChC2
</td> <td align="center"> 
35
</td> <td align="center"> 
65
</td> </tr>
  <tr> <td align="center"> 
OH073 CkC2
</td> <td align="center"> 
64
</td> <td align="center"> 
36
</td> </tr>
  <tr> <td align="center"> 
OH089 CkC2
</td> <td align="center"> 
56
</td> <td align="center"> 
44
</td> </tr>
  <tr> <td align="center"> 
OH165 CnC2
</td> <td align="center"> 
24
</td> <td align="center"> 
76
</td> </tr>
   </table>
<!-- html table generated in R 3.1.1 by xtable 1.7-4 package -->
<!-- Tue Mar 31 13:01:15 2015 -->
<table border=1>
<caption align="top"> 
Landuse and Landcover
</caption>
<tr> <th>  </th> <th> 
Unclassified
</th> <th> 
NA
</th> <th> 
Open Water
</th> <th> 
Perennial Snow/Ice
</th> <th> 
Developed, Open Space
</th> <th> 
Developed, Low Intensity
</th> <th> 
Developed, Medium Intensity
</th> <th> 
Developed, High Intensity
</th> <th> 
Barren Land
</th> <th> 
Deciduous Forest
</th> <th> 
Evergreen Forest
</th> <th> 
Mixed Forest
</th> <th> 
Shrub/Scrub
</th> <th> 
Herbaceuous
</th> <th> 
Hay/Pasture
</th> <th> 
Cultivated Crops
</th> <th> 
Woody Wetlands
</th> <th> 
Emergent Herbaceuous Wetlands
</th> <th> 
Sum
</th>  </tr>
  <tr> <td align="center"> 
\*new\_mlra\_mapunit
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
5
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
55
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
3
</td> <td align="center"> 
19
</td> <td align="center"> 
14
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
IN029 CnC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
8
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
48
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
5
</td> <td align="center"> 
28
</td> <td align="center"> 
7
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
IN031 CkC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
70
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
4
</td> <td align="center"> 
22
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
IN041 CcC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
79
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
6
</td> <td align="center"> 
7
</td> <td align="center"> 
6
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
IN047 CkC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
79
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
5
</td> <td align="center"> 
5
</td> <td align="center"> 
8
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
IN071 CkkC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
6
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
40
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
2
</td> <td align="center"> 
24
</td> <td align="center"> 
25
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
IN077 CnC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
3
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
58
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
2
</td> <td align="center"> 
2
</td> <td align="center"> 
18
</td> <td align="center"> 
14
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
IN115 CnC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
4
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
64
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
8
</td> <td align="center"> 
19
</td> <td align="center"> 
3
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
IN137 CcC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
3
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
59
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
2
</td> <td align="center"> 
14
</td> <td align="center"> 
20
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
IN155 CnC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
4
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
48
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
1
</td> <td align="center"> 
30
</td> <td align="center"> 
14
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
IN175 ChC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
5
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
49
</td> <td align="center"> 
5
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
23
</td> <td align="center"> 
16
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
OH001 CkC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
3
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
26
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
41
</td> <td align="center"> 
27
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
OH015 CnC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
3
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
33
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
9
</td> <td align="center"> 
41
</td> <td align="center"> 
12
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
OH017 CnC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
25
</td> <td align="center"> 
15
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
50
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
2
</td> <td align="center"> 
2
</td> <td align="center"> 
3
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
OH025 CcC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
8
</td> <td align="center"> 
3
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
61
</td> <td align="center"> 
2
</td> <td align="center"> 
1
</td> <td align="center"> 
1
</td> <td align="center"> 
5
</td> <td align="center"> 
15
</td> <td align="center"> 
5
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
OH025 CnC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
2
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
46
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
8
</td> <td align="center"> 
40
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
OH045 CkC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
5
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
35
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
33
</td> <td align="center"> 
24
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
OH061 CmC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
4
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
76
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
9
</td> <td align="center"> 
9
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
OH071 ChC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
5
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
33
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
4
</td> <td align="center"> 
27
</td> <td align="center"> 
29
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
OH073 CkC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
5
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
51
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
3
</td> <td align="center"> 
2
</td> <td align="center"> 
17
</td> <td align="center"> 
21
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
OH089 CkC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
6
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
28
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
39
</td> <td align="center"> 
23
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
OH165 CnC2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
11
</td> <td align="center"> 
4
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
46
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
1
</td> <td align="center"> 
2
</td> <td align="center"> 
20
</td> <td align="center"> 
11
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
100
</td> </tr>
  <tr> <td align="center"> 
Sum
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
2
</td> <td align="center"> 
0
</td> <td align="center"> 
118
</td> <td align="center"> 
31
</td> <td align="center"> 
7
</td> <td align="center"> 
1
</td> <td align="center"> 
0
</td> <td align="center"> 
1137
</td> <td align="center"> 
24
</td> <td align="center"> 
2
</td> <td align="center"> 
14
</td> <td align="center"> 
74
</td> <td align="center"> 
444
</td> <td align="center"> 
344
</td> <td align="center"> 
0
</td> <td align="center"> 
0
</td> <td align="center"> 
2200
</td> </tr>
   </table>

Quantile breaks
---------------

Five number summary (min, 25th, median, 75th, max)(percentiles) and number of random samples (n)

<!-- html table generated in R 3.1.1 by xtable 1.7-4 package -->
<!-- Tue Mar 31 13:01:18 2015 -->
<table border=1>
<tr> <th>  </th> <th> 
SSA\_MUSYM
</th> <th> 
elev
</th> <th> 
slope
</th> <th> 
valley
</th> <th> 
wetness
</th> <th> 
relief
</th> <th> 
ppt
</th> <th> 
temp
</th> <th> 
ffp
</th> <th> 
n
</th>  </tr>
  <tr> <td align="center"> 
1
</td> <td align="center"> 
\*new\_mlra\_mapunit
</td> <td align="center"> 
(155, 248, 268, 288, 363)
</td> <td align="center"> 
(0, 5, 7, 11, 69)
</td> <td align="center"> 
(0, 0, 1, 2, 9)
</td> <td align="center"> 
(8, 10, 11, 12, 22)
</td> <td align="center"> 
(0, 2, 6, 12, 112)
</td> <td align="center"> 
(972, 1073, 1115, 1130, 1183)
</td> <td align="center"> 
(10, 12, 12, 12, 13)
</td> <td align="center"> 
(159, 172, 175, 176, 182)
</td> <td align="center"> 
63788
</td> </tr>
  <tr> <td align="center"> 
2
</td> <td align="center"> 
IN029 CnC2
</td> <td align="center"> 
(170, 263, 276, 296, 314)
</td> <td align="center"> 
(0, 4, 6, 9, 37)
</td> <td align="center"> 
(0, 0, 0, 2, 6)
</td> <td align="center"> 
(9, 10, 11, 12, 20)
</td> <td align="center"> 
(0, 3, 7, 12, 78)
</td> <td align="center"> 
(1069, 1096, 1113, 1118, 1126)
</td> <td align="center"> 
(12, 12, 12, 12, 12)
</td> <td align="center"> 
(168, 170, 172, 173, 176)
</td> <td align="center"> 
2353
</td> </tr>
  <tr> <td align="center"> 
3
</td> <td align="center"> 
IN031 CkC2
</td> <td align="center"> 
(223, 252, 289, 302, 324)
</td> <td align="center"> 
(0, 3, 6, 9, 49)
</td> <td align="center"> 
(0, 0, 2, 4, 6)
</td> <td align="center"> 
(9, 11, 11, 13, 20)
</td> <td align="center"> 
(0, 1, 4, 7, 30)
</td> <td align="center"> 
(1104, 1123, 1127, 1130, 1139)
</td> <td align="center"> 
(11, 12, 12, 12, 12)
</td> <td align="center"> 
(167, 169, 171, 172, 174)
</td> <td align="center"> 
1493
</td> </tr>
  <tr> <td align="center"> 
4
</td> <td align="center"> 
IN041 CcC2
</td> <td align="center"> 
(240, 271, 285, 296, 323)
</td> <td align="center"> 
(0, 6, 9, 12, 28)
</td> <td align="center"> 
(0, 0, 0, 1, 7)
</td> <td align="center"> 
(9, 10, 10, 11, 16)
</td> <td align="center"> 
(0, 6, 10, 15, 51)
</td> <td align="center"> 
(1082, 1083, 1086, 1088, 1091)
</td> <td align="center"> 
(11, 11, 11, 11, 11)
</td> <td align="center"> 
(168, 168, 169, 169, 169)
</td> <td align="center"> 
701
</td> </tr>
  <tr> <td align="center"> 
5
</td> <td align="center"> 
IN047 CkC2
</td> <td align="center"> 
(221, 281, 289, 295, 316)
</td> <td align="center"> 
(0, 6, 10, 14, 51)
</td> <td align="center"> 
(0, 0, 0, 1, 6)
</td> <td align="center"> 
(8, 10, 10, 11, 21)
</td> <td align="center"> 
(0, 5, 10, 17, 98)
</td> <td align="center"> 
(1082, 1094, 1100, 1112, 1124)
</td> <td align="center"> 
(11, 11, 12, 12, 12)
</td> <td align="center"> 
(167, 168, 168, 168, 171)
</td> <td align="center"> 
4643
</td> </tr>
  <tr> <td align="center"> 
6
</td> <td align="center"> 
IN071 CkkC2
</td> <td align="center"> 
(165, 187, 205, 255, 277)
</td> <td align="center"> 
(0, 5, 7, 9, 29)
</td> <td align="center"> 
(0, 0, 1, 2, 9)
</td> <td align="center"> 
(9, 10, 11, 12, 18)
</td> <td align="center"> 
(0, 2, 5, 8, 31)
</td> <td align="center"> 
(1147, 1174, 1177, 1180, 1183)
</td> <td align="center"> 
(12, 12, 12, 12, 12)
</td> <td align="center"> 
(174, 175, 175, 176, 177)
</td> <td align="center"> 
3570
</td> </tr>
  <tr> <td align="center"> 
7
</td> <td align="center"> 
IN077 CnC2
</td> <td align="center"> 
(174, 214, 231, 253, 291)
</td> <td align="center"> 
(0, 5, 7, 10, 61)
</td> <td align="center"> 
(0, 0, 1, 3, 9)
</td> <td align="center"> 
(9, 11, 11, 13, 20)
</td> <td align="center"> 
(0, 1, 4, 8, 84)
</td> <td align="center"> 
(1113, 1133, 1143, 1147, 1157)
</td> <td align="center"> 
(12, 12, 12, 12, 12)
</td> <td align="center"> 
(172, 175, 176, 176, 178)
</td> <td align="center"> 
6362
</td> </tr>
  <tr> <td align="center"> 
8
</td> <td align="center"> 
IN115 CnC2
</td> <td align="center"> 
(168, 262, 264, 267, 274)
</td> <td align="center"> 
(0, 5, 7, 11, 25)
</td> <td align="center"> 
(0, 0, 0, 1, 4)
</td> <td align="center"> 
(9, 10, 11, 11, 15)
</td> <td align="center"> 
(0, 4, 8, 14, 73)
</td> <td align="center"> 
(1020, 1123, 1125, 1127, 1130)
</td> <td align="center"> 
(12, 12, 12, 12, 13)
</td> <td align="center"> 
(174, 175, 175, 175, 177)
</td> <td align="center"> 
281
</td> </tr>
  <tr> <td align="center"> 
9
</td> <td align="center"> 
IN137 CcC2
</td> <td align="center"> 
(233, 279, 288, 294, 323)
</td> <td align="center"> 
(0, 4, 7, 10, 45)
</td> <td align="center"> 
(0, 0, 1, 4, 6)
</td> <td align="center"> 
(8, 10, 11, 12, 22)
</td> <td align="center"> 
(0, 2, 5, 9, 80)
</td> <td align="center"> 
(1110, 1121, 1124, 1130, 1147)
</td> <td align="center"> 
(12, 12, 12, 12, 12)
</td> <td align="center"> 
(167, 171, 172, 173, 175)
</td> <td align="center"> 
13393
</td> </tr>
  <tr> <td align="center"> 
10
</td> <td align="center"> 
IN155 CnC2
</td> <td align="center"> 
(155, 264, 270, 277, 296)
</td> <td align="center"> 
(0, 5, 7, 10, 36)
</td> <td align="center"> 
(0, 0, 1, 2, 6)
</td> <td align="center"> 
(9, 10, 11, 12, 19)
</td> <td align="center"> 
(0, 2, 5, 9, 51)
</td> <td align="center"> 
(1055, 1128, 1132, 1134, 1140)
</td> <td align="center"> 
(12, 12, 12, 12, 13)
</td> <td align="center"> 
(173, 175, 175, 176, 182)
</td> <td align="center"> 
3551
</td> </tr>
  <tr> <td align="center"> 
11
</td> <td align="center"> 
IN175 ChC2
</td> <td align="center"> 
(165, 183, 189, 197, 271)
</td> <td align="center"> 
(0, 5, 7, 10, 35)
</td> <td align="center"> 
(0, 0, 1, 2, 5)
</td> <td align="center"> 
(9, 10, 11, 11, 17)
</td> <td align="center"> 
(0, 3, 6, 9, 25)
</td> <td align="center"> 
(1155, 1157, 1158, 1160, 1172)
</td> <td align="center"> 
(12, 12, 12, 12, 13)
</td> <td align="center"> 
(175, 176, 176, 177, 177)
</td> <td align="center"> 
1497
</td> </tr>
  <tr> <td align="center"> 
12
</td> <td align="center"> 
OH001 CkC2
</td> <td align="center"> 
(229, 277, 284, 293, 313)
</td> <td align="center"> 
(0, 4, 6, 8, 30)
</td> <td align="center"> 
(0, 1, 2, 3, 5)
</td> <td align="center"> 
(9, 11, 12, 13, 21)
</td> <td align="center"> 
(0, 1, 4, 8, 35)
</td> <td align="center"> 
(1074, 1091, 1099, 1117, 1132)
</td> <td align="center"> 
(11, 12, 12, 12, 12)
</td> <td align="center"> 
(173, 174, 174, 175, 176)
</td> <td align="center"> 
1806
</td> </tr>
  <tr> <td align="center"> 
13
</td> <td align="center"> 
OH015 CnC2
</td> <td align="center"> 
(195, 252, 261, 266, 290)
</td> <td align="center"> 
(0, 5, 7, 11, 36)
</td> <td align="center"> 
(0, 0, 0, 1, 6)
</td> <td align="center"> 
(9, 10, 10, 11, 21)
</td> <td align="center"> 
(0, 8, 15, 26, 107)
</td> <td align="center"> 
(1080, 1101, 1106, 1113, 1137)
</td> <td align="center"> 
(12, 12, 12, 12, 13)
</td> <td align="center"> 
(175, 176, 177, 177, 178)
</td> <td align="center"> 
865
</td> </tr>
  <tr> <td align="center"> 
14
</td> <td align="center"> 
OH017 CnC2
</td> <td align="center"> 
(215, 241, 258, 269, 280)
</td> <td align="center"> 
(1, 6, 9, 13, 58)
</td> <td align="center"> 
(0, 0, 0, 1, 3)
</td> <td align="center"> 
(9, 10, 11, 11, 17)
</td> <td align="center"> 
(0, 5, 12, 20, 51)
</td> <td align="center"> 
(1040, 1046, 1050, 1052, 1062)
</td> <td align="center"> 
(12, 13, 13, 13, 13)
</td> <td align="center"> 
(172, 173, 174, 174, 174)
</td> <td align="center"> 
323
</td> </tr>
  <tr> <td align="center"> 
15
</td> <td align="center"> 
OH025 CcC2
</td> <td align="center"> 
(155, 240, 254, 263, 288)
</td> <td align="center"> 
(0, 5, 7, 11, 69)
</td> <td align="center"> 
(0, 0, 1, 2, 6)
</td> <td align="center"> 
(9, 10, 11, 12, 22)
</td> <td align="center"> 
(0, 3, 8, 16, 112)
</td> <td align="center"> 
(1025, 1057, 1070, 1079, 1098)
</td> <td align="center"> 
(12, 13, 13, 13, 13)
</td> <td align="center"> 
(175, 176, 176, 177, 180)
</td> <td align="center"> 
15880
</td> </tr>
  <tr> <td align="center"> 
16
</td> <td align="center"> 
OH025 CnC2
</td> <td align="center"> 
(240, 254, 257, 263, 292)
</td> <td align="center"> 
(1, 5, 6, 9, 28)
</td> <td align="center"> 
(0, 0, 1, 2, 4)
</td> <td align="center"> 
(10, 11, 11, 12, 14)
</td> <td align="center"> 
(0, 3, 12, 18, 33)
</td> <td align="center"> 
(1083, 1093, 1094, 1095, 1096)
</td> <td align="center"> 
(12, 12, 12, 12, 12)
</td> <td align="center"> 
(175, 176, 176, 176, 176)
</td> <td align="center">  
83
</td> </tr>
  <tr> <td align="center"> 
17
</td> <td align="center"> 
OH045 CkC2
</td> <td align="center"> 
(244, 280, 288, 308, 363)
</td> <td align="center"> 
(0, 7, 9, 12, 37)
</td> <td align="center"> 
(0, 0, 0, 1, 6)
</td> <td align="center"> 
(9, 10, 10, 11, 18)
</td> <td align="center"> 
(0, 6, 13, 20, 63)
</td> <td align="center"> 
(972, 986, 998, 1008, 1013)
</td> <td align="center"> 
(10, 11, 11, 11, 11)
</td> <td align="center"> 
(161, 165, 167, 168, 169)
</td> <td align="center"> 
2084
</td> </tr>
  <tr> <td align="center"> 
18
</td> <td align="center"> 
OH061 CmC2
</td> <td align="center"> 
(208, 228, 237, 244, 265)
</td> <td align="center"> 
(4, 10, 15, 18, 30)
</td> <td align="center"> 
(0, 0, 0, 0, 2)
</td> <td align="center"> 
(9, 10, 10, 10, 13)
</td> <td align="center"> 
(0, 11, 16, 30, 64)
</td> <td align="center"> 
(1037, 1041, 1045, 1046, 1070)
</td> <td align="center"> 
(12, 13, 13, 13, 13)
</td> <td align="center"> 
(172, 174, 174, 177, 178)
</td> <td align="center">  
55
</td> </tr>
  <tr> <td align="center"> 
19
</td> <td align="center"> 
OH071 ChC2
</td> <td align="center"> 
(245, 295, 307, 324, 357)
</td> <td align="center"> 
(1, 5, 7, 9, 31)
</td> <td align="center"> 
(0, 0, 1, 2, 6)
</td> <td align="center"> 
(9, 11, 11, 12, 18)
</td> <td align="center"> 
(0, 3, 6, 9, 37)
</td> <td align="center"> 
(1050, 1064, 1071, 1080, 1097)
</td> <td align="center"> 
(11, 11, 11, 11, 12)
</td> <td align="center"> 
(172, 173, 174, 175, 176)
</td> <td align="center"> 
1189
</td> </tr>
  <tr> <td align="center"> 
20
</td> <td align="center"> 
OH073 CkC2
</td> <td align="center"> 
(231, 288, 315, 336, 361)
</td> <td align="center"> 
(0, 7, 10, 14, 33)
</td> <td align="center"> 
(0, 0, 0, 1, 3)
</td> <td align="center"> 
(9, 10, 10, 11, 15)
</td> <td align="center"> 
(0, 5, 10, 17, 47)
</td> <td align="center"> 
(997, 998, 999, 1000, 1001)
</td> <td align="center"> 
(10, 10, 11, 11, 11)
</td> <td align="center"> 
(167, 168, 169, 169, 169)
</td> <td align="center"> 
596
</td> </tr>
  <tr> <td align="center"> 
21
</td> <td align="center"> 
OH089 CkC2
</td> <td align="center"> 
(250, 291, 302, 311, 338)
</td> <td align="center"> 
(0, 7, 9, 12, 36)
</td> <td align="center"> 
(0, 0, 0, 1, 5)
</td> <td align="center"> 
(9, 10, 11, 11, 18)
</td> <td align="center"> 
(0, 4, 9, 16, 47)
</td> <td align="center"> 
(1015, 1017, 1017, 1018, 1024)
</td> <td align="center"> 
(10, 11, 11, 11, 11)
</td> <td align="center"> 
(159, 161, 162, 162, 163)
</td> <td align="center"> 
1481
</td> </tr>
  <tr> <td align="center"> 
22
</td> <td align="center"> 
OH165 CnC2
</td> <td align="center"> 
(209, 250, 266, 276, 298)
</td> <td align="center"> 
(0, 4, 5, 8, 37)
</td> <td align="center"> 
(0, 1, 2, 3, 5)
</td> <td align="center"> 
(9, 11, 12, 13, 22)
</td> <td align="center"> 
(0, 1, 3, 8, 81)
</td> <td align="center"> 
(1034, 1056, 1064, 1069, 1075)
</td> <td align="center"> 
(11, 12, 12, 12, 13)
</td> <td align="center"> 
(172, 175, 175, 175, 177)
</td> <td align="center"> 
1582
</td> </tr>
   </table>
<!-- html table generated in R 3.1.1 by xtable 1.7-4 package -->
<!-- Tue Mar 31 13:01:22 2015 -->
<table border=1>
<tr> <th>  </th> <th> 
SSA\_MUSYM
</th> <th> 
aspect
</th> <th> 
n
</th>  </tr>
  <tr> <td align="center"> 
1
</td> <td align="center"> 
\*new\_mlra\_mapunit
</td> <td align="center"> 
(18, 283, 198, 117, 19)
</td> <td align="center"> 
63788
</td> </tr>
  <tr> <td align="center"> 
2
</td> <td align="center"> 
IN029 CnC2
</td> <td align="center"> 
(336, 233, 157, 76, 337)
</td> <td align="center"> 
2353
</td> </tr>
  <tr> <td align="center"> 
3
</td> <td align="center"> 
IN031 CkC2
</td> <td align="center"> 
(28, 290, 209, 128, 30)
</td> <td align="center"> 
1493
</td> </tr>
  <tr> <td align="center"> 
4
</td> <td align="center"> 
IN041 CcC2
</td> <td align="center"> 
(270, 181, 91, 9, 271)
</td> <td align="center"> 
701
</td> </tr>
  <tr> <td align="center"> 
5
</td> <td align="center"> 
IN047 CkC2
</td> <td align="center"> 
(36, 298, 216, 135, 37)
</td> <td align="center"> 
4643
</td> </tr>
  <tr> <td align="center"> 
6
</td> <td align="center"> 
IN071 CkkC2
</td> <td align="center"> 
(356, 248, 177, 102, 357)
</td> <td align="center"> 
3570
</td> </tr>
  <tr> <td align="center"> 
7
</td> <td align="center"> 
IN077 CnC2
</td> <td align="center"> 
(32, 295, 213, 138, 33)
</td> <td align="center"> 
6362
</td> </tr>
  <tr> <td align="center"> 
8
</td> <td align="center"> 
IN115 CnC2
</td> <td align="center"> 
(230, 142, 55, 330, 235)
</td> <td align="center"> 
281
</td> </tr>
  <tr> <td align="center"> 
9
</td> <td align="center"> 
IN137 CcC2
</td> <td align="center"> 
(19, 283, 199, 117, 20)
</td> <td align="center"> 
13393
</td> </tr>
  <tr> <td align="center"> 
10
</td> <td align="center"> 
IN155 CnC2
</td> <td align="center"> 
(303, 204, 123, 50, 304)
</td> <td align="center"> 
3551
</td> </tr>
  <tr> <td align="center"> 
11
</td> <td align="center"> 
IN175 ChC2
</td> <td align="center"> 
(307, 198, 127, 46, 308)
</td> <td align="center"> 
1497
</td> </tr>
  <tr> <td align="center"> 
12
</td> <td align="center"> 
OH001 CkC2
</td> <td align="center"> 
(342, 251, 163, 73, 343)
</td> <td align="center"> 
1806
</td> </tr>
  <tr> <td align="center"> 
13
</td> <td align="center"> 
OH015 CnC2
</td> <td align="center"> 
(309, 223, 129, 57, 313)
</td> <td align="center"> 
865
</td> </tr>
  <tr> <td align="center"> 
14
</td> <td align="center"> 
OH017 CnC2
</td> <td align="center"> 
(85, 323, 266, 178, 91)
</td> <td align="center"> 
323
</td> </tr>
  <tr> <td align="center"> 
15
</td> <td align="center"> 
OH025 CcC2
</td> <td align="center"> 
(57, 316, 238, 151, 58)
</td> <td align="center"> 
15880
</td> </tr>
  <tr> <td align="center"> 
16
</td> <td align="center"> 
OH025 CnC2
</td> <td align="center"> 
(114, 344, 307, 241, 157)
</td> <td align="center">  
83
</td> </tr>
  <tr> <td align="center"> 
17
</td> <td align="center"> 
OH045 CkC2
</td> <td align="center"> 
(9, 278, 190, 104, 10)
</td> <td align="center"> 
2084
</td> </tr>
  <tr> <td align="center"> 
18
</td> <td align="center"> 
OH061 CmC2
</td> <td align="center"> 
(67, 322, 261, 179, 93)
</td> <td align="center">  
55
</td> </tr>
  <tr> <td align="center"> 
19
</td> <td align="center"> 
OH071 ChC2
</td> <td align="center"> 
(161, 72, 342, 256, 162)
</td> <td align="center"> 
1189
</td> </tr>
  <tr> <td align="center"> 
20
</td> <td align="center"> 
OH073 CkC2
</td> <td align="center"> 
(347, 235, 170, 87, 352)
</td> <td align="center"> 
596
</td> </tr>
  <tr> <td align="center"> 
21
</td> <td align="center"> 
OH089 CkC2
</td> <td align="center"> 
(331, 220, 151, 79, 332)
</td> <td align="center"> 
1481
</td> </tr>
  <tr> <td align="center"> 
22
</td> <td align="center"> 
OH165 CnC2
</td> <td align="center"> 
(148, 47, 329, 253, 149)
</td> <td align="center"> 
1582
</td> </tr>
   </table>

Boxplots of map unit properties
-------------------------------

Graphical five number summary plus outliers (outliers, 5th, 25th, median, 75th, 95th, outliers)(percentiles)

![](cincinnati_mapunit_report_files/figure-markdown_github/bwplot%20of%20map%20unit%20properties-1.png)
