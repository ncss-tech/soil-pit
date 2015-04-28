test <- 1:100
n <- length(test)
interval <- 4
x <- n/interval

for (i in 0:(x-1)){
  print(test[c(1, i*interval+(2:5))])
}
