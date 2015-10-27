library(RCurl)
library(XML)
library(RJSONIO)

options(stringsAsFactors = FALSE)

URL  <- "http://nassgeodata.gmu.edu:8080/axis2/services/CDLService/GetCDLValue"
year <- "2000"
x <- "1551459.363"
y <- "1909201.537"

cdl <- function(URL, year, x, y){
  f <- postForm(URL, year = year, x = x, y = y)
  p <- fromJSON(xmlToList(xmlParse(f))$Result)
  df <- do.call(data.frame, p)
  names(df) <- c("x", "y", "value", "category", "color")
  return(df)
}

cdl(URL, year, x, y)
