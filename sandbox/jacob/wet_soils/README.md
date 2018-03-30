Analysis of selected Pedon-level soil properties for Wet Soils groupings

Jacob Isleib, USDA-NRCS Soil Scientist, Tolland CT

Objective:  Soils are characterized in part according to their place on the dry-to-wet spectrum.  Interpretive groups such and drainage class, numeric values such as depth to seasonal high water table, and other properties are used to describe, either relatively or absolutely, a pedon’s “wetness”.  Using morphologic and measured chemical properties, we seek to evaluate whether indirect soil characteristics support classes of wetness and whether there are any distinct groups of pedons based on the data.

Research question: Are there objective groups of pedons based on soil color, DCB-extractable Fe, and clay content change that could be used to support criteria for a new “wet soil” order in Soil Taxonomy?

Method: Gather pedon lab data and morphologic data from KSSL MSAccess export and NASIS, respectively.  Use R to format and perform quality control on the raw data including aggregating pedon horizon-level data to the pedon-level property summaries.  Use Principle Components Analysis, clustering, ordination, and other methods of analysis to answer the research question.

 
Selected pedon-level properties:

1.      average chroma in upper 50 cm
2.      depth to a gleyed horizon [author’s note: this property was dropped from the analysis after it was determined that too few pedons contained a non-null value]
3.      average DCB extractable Fe in upper 50 cm;
4.      difference in clay content between upper-most horizon of pedon with measured clay and upper-most horizon with a 'B', 'BC', 'CB',  or 'C' master horizon designation
5.      average hue in upper 50 cm by assigning hue a number as follows:

hue      hue_num
5R	9
7.5R	8
10R	7
2.5YR	6
5YR	5
7.5YR	4
10YR	3
2.5Y	2
5Y	1
10Y	0
5GY	0
10GY	0
5G	0
10G	0
5BG	0
10BG	0
5B	0
10B	0
5PB	0
N	0

6.      carbon content at 30 cm
7.      depth to a depleted matrix (i.e., horizon with matrix color (>=50% color percentage) with high value (>=4) and low chroma (<=2))

Excluded pedons:

1.      Pedons meeting general histosols order criteria were excluded from the dataset (i.e., pedons with >=40cm of O master horizon thickness within 130cm)

++++++++++++++++++++++++++++

Discussion

The PCA Biplot (Figure 3) illustrates general relationships of drainage class groupings (visible using Normal probability ellipses) to the first two principal components and individual variable eigenvectors.  The plot shows that there is quite a bit of overlap between neighboring drainage classes aside from the subaqueous class, whose ellipse appears distinct from the others along the PC1 (i.e., x-) axis.  The range of values on the PC2 (i.e., y-) axis for the Somewhat Poorly, Poorly, Very Poorly, and Subaqueous are also interesting.  Poorly and Subaqueous values have a similar PC2 range, while Very Poorly has a much wider range for PC2 than any other drainage class.

Using different methods of evaluating the silhouette widths of clustering (Figures 4-7) yields that 2 cohesive clusters of data exist in this dataset.  Figures 8 is a plot of K-medoids clustering with 2 clusters.  This plot shows that one of the clusters occupies space that corresponds to Poorly, Very Poorly, and Subaqueous drainage ellipses in the PCA biplot.  This result suggests that given the selected soil properties used in this analysis, these three drainage classes are members of a single group of data.  Figures 11 and 12 summarize the distribution of cluster assignments by drainage class.  These agree with the observation from Figure 8 that Poorly, Very Poorly, and Subaqueous drainage classes cohere to a single cluster.  Applying 3+ clusters was explored but Figures 13 through 15 illustrate how greater number of clusters produce groups that lack cohesion.

Further analysis is suggested using a larger, more geographically varied dataset.  Also, it may be interesting to subset the dataset by only Somewhat Poorly and wetter drainage classes, to explore relationships between only these “off-drained” pedons.

Update 02/24/2018: A review by Dyland Beaudette suggests exploring use of CIE LAB coordinates (coverting color from Munsell), KSSL+morphology, and slice(), slab(), and related functions for weighted averages over depth intervals.  These functions will be explored in future iterations of this analysis.

 