unifiedRatios <- function(x){
  x <- c(100, x, 0)
  ssm <- c(10, 4.8, 2, 0.42, 0.074, 0.0001)
  ppd <- c(10, 30, 60)
  
  test.df <- data.frame(ssm, x)
  test.lm <- lm(ssm ~ bs(x, knots=quantile(seq(0.1, 1, 0.1))), data=test.df)
  test.p <- predict(test.lm, data.frame(x=ppd))
  test.p[1] <- if(test.p[1] < 0.5) 0.5
  
  plot(x~ssm, type="l", xlab="Sieve size", ylab="Percent passing", ylim=c(0,100), xlim=c(10,0))
  points(x~ssm)
  points(ppd~test.p, pch=19)
  
  Cu <- test.p[3]/test.p[1]
  Cc <- test.p[2]/c(test.p[1]*test.p[3])
  return(list(x=x, Ds=round(test.p,2), Cu=Cu, Cc=Cc))
  }