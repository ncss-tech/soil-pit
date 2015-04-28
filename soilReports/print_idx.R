test <- 1:100
n <- length(test)
x <- n/4

for (i in 0:(x-1)){
  print(test[c(1, i*4+(2:5))])
}
