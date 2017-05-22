# get file names of HOBO temp data
setwd("M:/projects/soilTemperatureMonitoring/dataRaw/rawTxtFilesClean")

p <- getwd()
files <- list.files(path = p)

# temp list to hold data
l <- list()

# read each file into a sequential list element
for(i in seq_along(files))
  {
  fileName <- str_split(files[i], '[.]')[[1]][1]
  siteid <- str_split(files[i], '_')[[1]][1]
  cat(paste("working on", fileName, "\n"))
  f <- paste(p,"/", files[i], sep='')
  f.i  <- read.table(file=f, header=TRUE, sep="\t", stringsAsFactors=FALSE)
  f.i$siteid <- siteid
  names(f.i)[1:3] <- c('date','tempF','tempC')
  f.i$tempF<-as.numeric(f.i$tempF)
  f.i$tempC<-as.numeric(f.i$tempC)
  f.i<-subset(f.i,select=c(date,siteid,tempF,tempC))
  l[[i]] <- f.i
  }

# re-combined into single DF
mastSeries_df <- ldply(l)
mastSeries_df$site<-as.factor(mastSeries_df$site)
rm(l) ; gc()

## save cached copy
save(mastSeries_df, file="M:/projects/soilTemperatureMonitoring/R/mastSeries.Rdata")
