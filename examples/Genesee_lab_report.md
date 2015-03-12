<h1>Lab pedon report</h1>

<pre><code class="r enter soil series name"># Set soil series
series &lt;- &quot;Genesee&quot;
</code></pre>

<pre><code class="r load packages, include=FALSE"># load libraries
library(aqp)
library(soilDB)
library(reshape)
library(plyr)
library(lattice)
library(maps)
library(xtable)
library(RODBC)
</code></pre>

<pre><code class="r fetch and format, load-data, echo=FALSE, warning=FALSE"># source custom R functions
source(paste0(&quot;./genhz_rules/&quot;, series, &quot;_rules.R&quot;))

p &lt;- c(0, 0.10, 0.5, 0.90, 1)

# load NASIS data
l &lt;- fetchNASISLabData()
lh &lt;- horizons(l)
lp &lt;- site(l)
f &lt;- fetchNASIS()
h &lt;- horizons(f)
s &lt;- site(f)

names(lh) &lt;- unlist(strsplit(names(lh), &quot;measured&quot;))
lh$cec7Clay &lt;- lh$cec7/lh$claytot

for(i in seq(nrow(lh))){
  if(is.na(lh$hzname[i])) {lh$hzname[i] &lt;-lh$hznameoriginal[i]}
}

lh$hzname[is.na(lh$hzname)] &lt;- &quot;NA&quot;
lh$genhz &lt;- generalize.hz(lh$hzname, ghr[[series]]$n, ghr[[series]]$p)

h$hzname[is.na(h$hzname)] &lt;- &quot;NA&quot;
h$genhz &lt;- generalize.hz(h$hzname, ghr[[series]]$n, ghr[[series]]$p)

naReplace &lt;- function(x){
  l &lt;- list()
  for(i in seq(names(x))){
    if(class(x[,i])==&quot;character&quot;) {l[[i]] &lt;- replace(x[,i], is.na(x[,i]), &quot;NA&quot;)} else(l[[i]] &lt;-  x[,i])
  }
  l &lt;- data.frame(l, stringsAsFactors=FALSE)
  names(l) &lt;- names(x)
  return(l)
}

h &lt;- naReplace(h)

# Function
sum5n &lt;- function(x) {
  variable &lt;- unique(x$variable)
  precision.vars &lt;- c(&#39;phfield&#39;, &#39;ph1to1h2o&#39;, &#39;ph01mcacl2&#39;, &#39;phoxidized&#39;, &#39;ph2osoluble&#39;, &#39;ecec&#39;, &#39;cec7&#39;, &#39;cecsumcations&#39;, &#39;sumbases&#39;, &#39;extracid&#39;, &#39;dbthirdbar&#39;, &#39;dbovendry&#39;, &#39;wthirdbarclod&#39;, &#39;wfifteenbar&#39;, &#39;wretentiondiffws&#39;, &#39;wfifteenbartoclay&#39;, &#39;cec7Clay&#39;)
  precision.table &lt;- c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 2)
  v &lt;- na.omit(x$value) # extract column, from long-formatted input data
  precision &lt;- if(variable %in% precision.vars) precision.table[match(variable, precision.vars)] else 0
  n &lt;- length(v)
  ci &lt;- quantile(v, na.rm=TRUE, probs=p) 
  d &lt;- data.frame(min=ci[1], low=ci[2], rv=ci[3], high=ci[4], max=ci[5], n=n, stringsAsFactors=FALSE) # combine into DF
  d$range &lt;- with(d, paste0(&quot;(&quot;, paste0(round(c(min, low, rv, high, max), precision), collapse=&quot;, &quot;), &quot;)&quot;, &quot;(&quot;, n, &quot;)&quot;)) # add &#39;range&#39; column for pretty-printing
  return(d[7])
}
</code></pre>

<h2>Plot of all pedons in selected set</h2>

<p>Pedons that do not have their Std_Latitude and Std_Longitude columns populated in the NASIS Site table are currently not ploted on the map.</p>

<pre><code class="r plot of pedons and locations, echo=FALSE">if(dim(s)[1] != 0) {
  s.sub &lt;- s[complete.cases(s[, c(&#39;x_std&#39;, &#39;y_std&#39;)]),]
  coordinates(s.sub) &lt;- ~x_std+y_std
  plot(s.sub, pch=16)
  map(&quot;county&quot;, lwd=0.5, add=T)
  map(&quot;state&quot;,lwd=2, add=T)
  map.axes()
  } else(&quot;no coordinates&quot;)
</code></pre>

<h2>Soil profile plots (depth, color, horizonation, and user pedon id)</h2>

<pre><code class="r Soil plots, echo=FALSE">plot(l, label=&quot;labpeiid&quot;)
</code></pre>

<h1>Summary of NCSS Pedon Lab Data</h1>

<pre><code class="r format site data, echo=FALSE, results=&#39;asis&#39;"># Site information
print(xtable(subset(s, select=c(&quot;pedon_id&quot;, &quot;taxonname&quot;, &quot;tax_subgroup&quot;, &quot;part_size_class&quot;, &quot;pedon_type&quot;, &quot;describer&quot;))), type=&quot;html&quot;)
</code></pre>

<h2>Range in characteristics of NCSS Pedon Lab Data</h2>

<p>Five number summary (min, 25th, median, 75th, max)(percentiles)</p>

<pre><code class="r, echo=FALSE, results=&#39;asis&#39;"># Summarize site data
lp.sub &lt;- subset(lp, select=c(&quot;noncarbclaywtavg&quot;, &quot;claytotwtavg&quot;, &quot;le0to100&quot;, &quot;wf0175wtavgpsc&quot;, &quot;volfractgt2wtavg&quot;, &quot;cec7clayratiowtavg&quot;))
lp.lo &lt;- melt(lp.sub, measure.vars=c(&quot;noncarbclaywtavg&quot;, &quot;claytotwtavg&quot;, &quot;le0to100&quot;, &quot;wf0175wtavgpsc&quot;, &quot;volfractgt2wtavg&quot;, &quot;cec7clayratiowtavg&quot;))
lp.5n &lt;- ddply(lp.lo, .(variable), .fun=sum5n)

print(xtable(cast(lp.5n, ~variable, value=&#39;range&#39;)), type=&quot;html&quot;)
</code></pre>

<h2>Box plots of NCSS Pedon Lab Data</h2>

<p>Graphical five number summary (outliers, 5th, 25th, median, 75th, 95th, outliers)</p>

<pre><code class="r bwplot for pedon lab data, echo=FALSE">if(any(!is.na(lp.lo$value))) {
  bwplot(variable ~ value, data=lp.lo, scales=list(x=&quot;free&quot;), xlab=&quot;percent&quot;)
  } else(&quot;no pedon lab data have been populated&quot;)         
</code></pre>

<h1>Summary of NCSS Layer Lab Data</h1>

<h2>Horizon designations by generic horizon</h2>

<p>Contingency table (counts) </p>

<pre><code class="r, echo=FALSE, results=&#39;asis&#39;">print(xtable(addmargins(table(lh$genhz, lh$hzname)), digits=0, align=rep(&quot;c&quot;, 2+length(unique(lh$hzname)))), type=&quot;html&quot;) 
</code></pre>

<h2>Range in characteristics for generic horizons</h2>

<p>Five number summary (min, 25th, median, 75th, max)(percentiles)</p>

<pre><code class="r, echo=FALSE"># Summarize numeric variables by generic horizon
lh.num &lt;- lh[, c(12:(ncol(lh)-4), ncol(lh)-1, ncol(lh))]
lh.num &lt;- Filter(f=function(x) !all(is.na(x)), x=lh.num)
lh.lo &lt;- melt(lh.num, id.vars=&quot;genhz&quot;, measure.vars=names(lh.num)[c(1:(ncol(lh.num)-1))])
lh.5n &lt;- ddply(lh.lo, .(variable, genhz), .fun=sum5n)
lh.c &lt;- cast(lh.5n, genhz~variable, value=&#39;range&#39;)

format(lh.c, justify=&quot;centre&quot;)

nh &lt;- ncol(lh.num)/2.5
</code></pre>

<h2>Box plots of numeric variables by generic horizon</h2>

<p>Graphical five number summary (outliers, 5th, 25th, median, 75th, 95th, outliers)</p>

<pre><code class="r, echo=FALSE, fig.height=nh">bwplot(factor(genhz, levels=levels(lh$genhz)[length(levels(lh$genhz)):1]) ~ value|variable, data=rbind(lh.lo), scales=list(x=&quot;free&quot;))          
</code></pre>

<h2>Texture by generic horizon</h2>

<p>Contigency table (counts) </p>

<pre><code class="r, echo=FALSE, results=&#39;asis&#39;">print(xtable(addmargins(table(lh$genhz, lh$lab_texcl)), digits=0, align=rep(&quot;c&quot;, 1+length(unique(lh$lab_texcl)))), type=&quot;html&quot;)
</code></pre>

<h2>Stratified flag by generic horizon</h2>

<p>Contingency table (counts) </p>

<pre><code class="r, echo=FALSE, results=&#39;asis&#39;">print(xtable(addmargins(table(lh$genhz, lh$stratextsflag)), digits=0), type=&quot;html&quot;) 
</code></pre>

<h2>Depths and thickness of generic horizons</h2>

<p>Five number summary (min, 25th, median, 75th, max)(percentiles)</p>

<pre><code class="r, echo=FALSE, results=&#39;asis&#39;">genhz.thk &lt;- ddply(lh, .(labpeiid, genhz), summarize, thickness=sum(hzdepb-hzdept))
genhz.lo &lt;- melt(genhz.thk, id.vars=&quot;genhz&quot;, measure.vars=&quot;thickness&quot;)

lh.lo &lt;- melt(lh, id.vars=&quot;genhz&quot;, measure.vars=c(&quot;hzdept&quot;, &quot;hzdepb&quot;))

lp.lo1 &lt;- melt(lp, id.vars=&quot;labpeiid&quot;, measure.vars=c(&quot;psctopdepth&quot;, &quot;pscbotdepth&quot;))
lp.thk &lt;- ddply(lp, .(labpeiid), summarize, thickness=sum(pscbotdepth-psctopdepth))
lp.lo2 &lt;- melt(lp.thk, id.vars=&quot;labpeiid&quot;, measure.vars=&quot;thickness&quot;)

lh.lo &lt;- rbind(lh.lo, genhz.lo)
lp.lo &lt;- rbind(lp.lo1, lp.lo2)

lh.5n &lt;- ddply(lh.lo, .(variable, genhz), .fun=sum5n)
lh.c &lt;- cast(lh.5n, genhz ~ variable, value=&#39;range&#39;)
lp.5n &lt;- ddply(lp.lo, .(variable), .fun=sum5n)
print(xtable(lh.c, digits=0, align=rep(&quot;c&quot;, 1+ncol(lh.c))), type=&quot;html&quot;)
print(xtable(lp.5n, digits=0, align=rep(&quot;c&quot;, 1+ncol(lp.5n))), type=&quot;html&quot;)
</code></pre>

<h2>Boxplot of generic horizon thicknesses</h2>

<p>Graphical five number summary (outliers, 5th, 25th, median, 75th, 95th, outliers)(percentiles)</p>

<pre><code class="r, echo=FALSE">bwplot(factor(genhz, levels=levels(lh$genhz)[length(levels(lh$genhz)):1]) ~ value|variable, data=lh.lo, scales=list(x=&quot;free&quot;), xlab=&quot;cm&quot;, horizontal=T)          

bwplot(factor(variable, levels=levels(lp.lo$variable)[length(levels(lp.lo$variable)):1]) ~ value|variable, data=lp.lo, scales=list(x=&quot;free&quot;), xlab=&quot;cm&quot;, horizontal=T)          
</code></pre>
