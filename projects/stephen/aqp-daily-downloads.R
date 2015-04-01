library(Cairo)
library(plyr)

start <- as.Date('2012-10-01')
today <- as.Date('2014-02-01')
all_days <- seq(start, today, by = 'day')
year <- as.POSIXlt(all_days)$year + 1900

urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')
file <- basename(urls)


## this would be much faster with zcat | grep
l <- list()

for (i in 1:length(urls)) {
  # download.file(urls[i], file[i])
  tmp <- read.table(gzfile(file[i]),sep=",",header=TRUE)
  tmp <- tmp[tmp$package=="soilDB",]
  l[[i]] <- tmp
}

df <- ldply(l)
df <- na.omit(df)
df$d <- as.Date(df$date)


d <- tapply(data$date, data$date, length)
d <- data.frame(date=as.Date(names(d)), n=d) 




CairoPNG(file='soilDB-daily-downloads.png', height=300, width=900)
par(mar=c(3,3,2,0))
plot(n ~ date, data=d, type='n', xlab='', ylab='', axes=FALSE, main='soilDB Downloads per Day')
grid()
lines(n ~ date, data=d, type='h')
axis.Date(side=1, at=seq(from=min(d$date), to=max(d$date), by='months'), format="%b\n%Y", cex.axis=0.7)
axis(side=2, las=1, cex.axis=0.7)
dev.off()
