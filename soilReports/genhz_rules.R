## generalized horizon designations
gen.hz.rules <- list(
  'Carrizo'=list(
    n=c('C', 'A', '2Bk', '2Ckq', '2Btkqb', 'Bk'),
    p=c('C', '^A', 'BA|^Bk|^2Bk', 'C1$|C2$|^BCk|^2BCk|^Ck|^2Ck|^Cq|^2Cq', 'Bt|^2Bkqb')
  ),
  'Cajon'=list(
    n=c('A', 'Bk', 'Ck'),
    p=c('^A', '^BA|^Bk|^Bw', '^C|BC')
  ),
  "Genesee"=list(
    n=c("Ap", "A", "Bw", "C", "Cg", "Ab", "2Bt", "NA"),
    p=c("Ap|Ap1|Ap2|AP", "^A$|A1|A2|A3", "^B", "C|C1|C10|C2|C3|C4|C5|C6|C7|C8|C9", "^Cg", "Ab", "^2Bt","NA")
    ),
  "Miamian"=list(
    n=c("Ap", "A", "E", "Bt", "BC", "C", "Cd", "NA"),
    p=c("Ap|AP|1A|A1|A2|A p", "^A$", "E", "BE", "Bt|BT|1B|B2|B3|BA|B1|B t1|B t2", "BC", "^B$", "C", "Cd","NA")
  ),
  "Crosby"=list(
    n=c("Ap", "A", "BE", "E", "Bt", "Btg", "CB", "2BCt", "2CB", "Cd", "2Cd", "NA"),
    p=c("Ap|AP|1A|A1|A2|A p", "^A$", "E", "BE", "Bt|BT|1B|B2|B3|BA|B1|B t1|B t2|2B t3|2B t4", "BC", "^B$", "C", "Cd","NA")
  ),
  "Miami"=list(
    n=c("Ap", "A", "Bt", "BCt", "CB", "2BCt", "2CB", "Cd", "2Cd", "NA"),
    p=c("Ap|AP|1A|A1|A2|A3|A p|AB|A&B", "^A$", "E", "BE", "Bt|BT|1B|B2|B3|B4|BA|B1|B t1|B t2|2B t3|2B t4|2Bk|BW|B&A|Bt3|Btk", "BC", "^B$", "C", "Cd", "2H3|2H4|2H5d|2R|3H4|3H5|3H6d|H1|H2|H3|H4|H5|H6|H7", "^H$", "Oi", "R", "NA")
  ),
  "Mahalasville"=list(
    n=c("Ap", "A", "Bt", "BCt", "CB", "2BCt", "2CB", "Cd", "2Cd", "NA"),
    p=c("Ap|AP|1A|A1|A2|A3|A p|AB|A&B", "^A$", "E", "BE", "Bt|BT|1B|B2|B3|B4|BA|B1|B t1|B t2|2B t3|2B t4|2Bk|BW|B&A|Bt3|Btk", "BC", "^B$", "C", "Cd", "2H2|2H3|2H4|2H5d|2R|3H3|3H4|3H5|3H6d|H1|H2|H3|H4|H5|H6|H7", "^H$", "Oi", "R", "NA")
  ),
  "Xenia"=list(
    n=c("Ap", "A", "E", "Bt", "2Bt", "BCt", "CB", "2BCt", "2CB", "Cd", "2Cd", "NA"),
    p=c("Ap|AP|1A|A1|A2|A3|A p|AB|A&B|Ab", "^A$", "E", "BE", "Bt|BT|1B|B2|B3|B4|BA|B1|B t1|B t2|2B t3|2B t4|2Bk|BW|B&A|Bt3|Btk|2B5|B t3|B t4|B t5|2Bd3", "BC|Bc2", "^B$", "C", "Cd", "2H2|2H3|2H4|2H5d|2R|3R|3H3|3H4|3H5|3H6d|H1|H2|H3|H4|H5|H6|H7", "^H$", "Oi", "R", "NA")
  )
)
ghr <- gen.hz.rules

# summary(factor(f$genhz))
# f$genhz <- as.character(f$genhz)
# f$genhz <- ifelse(is.na(f@horizons$genhz), generalize.hz(f$hzname, 
# gen.hz.rules$carrizo$n, gen.hz.rules$carrizo$p), f@horizons$genhz)
# f$genhz <- factor(f$genhz, levels=gen.hz.rules$carrizo$n, ordered=T) 
# summary(factor(f$genhz))