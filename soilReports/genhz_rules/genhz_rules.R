## generalized horizon designations
gen.hz.rules <- list(
  "Cincinnati"=list(
    n=c("Ap", "Bt", "Btx", "2Bt", "3Bt", "3B't", "3C", "NA"),
    p=c("^A", "^Bt1|^Bt2|^B21t|^B22T|BT", "^BX|Bx2|^2Btx|^2Bx|^Btx", "^IIB", "^3Btb|^3B t|Bt3|^IIIB", "3B't", "3C|^C|IIIC", "^2C|^4B|^4C|^5|BA|E|R")
  )
)

ghr <- gen.hz.rules

# summary(factor(f$genhz))
# f$genhz <- as.character(f$genhz)
# f$genhz <- ifelse(is.na(f@horizons$genhz), generalize.hz(f$hzname, 
# gen.hz.rules$carrizo$n, gen.hz.rules$carrizo$p), f@horizons$genhz)
# f$genhz <- factor(f$genhz, levels=gen.hz.rules$carrizo$n, ordered=T) 
# summary(factor(f$genhz))