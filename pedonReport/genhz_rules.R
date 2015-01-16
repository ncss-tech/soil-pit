## generalized horizon designations
gen.hz.rules <- list(
  'carrizo'=list(
    n=c('C', 'A', '2Bk', '2Ckq', '2Btkqb', 'Bk'),
    p=c('C', '^A', 'BA|^Bk|^2Bk', 'C1$|C2$|^BCk|^2BCk|^Ck|^2Ck|^Cq|^2Cq', 'Bt|^2Bkqb')
  ),
  'cajon'=list(
    n=c('A', 'Bk', 'Ck'),
    p=c('^A', '^BA|^Bk|^Bw', '^C|BC')
  ),
  "genesee"=list(
    n=c("Ap", "A", "Bw", "C", "Cg", "Ab", "2Bt", "NA"),
    p=c("Ap|Ap1|Ap2|AP", "^A$|A1|A2|A3", "^B", "C|C1|C10|C2|C3|C4|C5|C6|C7|C8|C9", "^Cg", "Ab", "^2Bt","NA")
    )
)
ghr <- gen.hz.rules

# summary(factor(f$genhz))
# f$genhz <- as.character(f$genhz)
# f$genhz <- ifelse(is.na(f@horizons$genhz), generalize.hz(f$hzname, 
# gen.hz.rules$carrizo$n, gen.hz.rules$carrizo$p), f@horizons$genhz)
# f$genhz <- factor(f$genhz, levels=gen.hz.rules$carrizo$n, ordered=T) 
# summary(factor(f$genhz))