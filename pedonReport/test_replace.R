tf <- x[is.na(x)]} <- "NA")))

lapply(h, function(x) x[is.na(x)] <- "NA")

)
test <- replace(h, is.na(h), "NA")


ifelse(h[,i], function(x) class(x)!="character"), NA, sapply(x, function(x) replace(x, is.na(x), "NA")))

naReplace <- function(h){
  l <- list()
  for(i in seq(names(h))){
    if(class(h[,i])=="character") {l[[i]] <- replace(h[,i], is.na(h[,i]), "NA")} else(l[[i]] <-  h[,i])
  }
  l <- data.frame(l)
  names(l) <- names(h)
  return(l)
}

test <- function(h)
  if(class(h == "character") {replace(h, is.na(h), "NA"))} else(h)
