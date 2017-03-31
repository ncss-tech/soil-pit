q.phlab <- "
    SELECT phiidref, sampledepthtop, sampledepthbottom, claytotmeasured, sandtotmeasured, 
        textureclfieldlab, ph1to1h2o, ph01mcacl2, caco3equivmeasured, sar
    FROM phlabresults_View_1
    ORDER BY phiidref, sampledepthtop
    ;"

channel <- RODBC::odbcDriverConnect(connection="DSN=nasis_local;UID=NasisSqlRO;PWD=nasisRe@d0n1y")

d.phlab <- RODBC::sqlQuery(channel, q.phlabresults, stringsAsFactors = FALSE)


# recode metadata domains
d.phlab <- .metadata_replace(d.phlab)


# relabel names
names(d.phlab) <- gsub("measured|lab$", "", names(d.phlab))

vars <- c("phiidref", "sampledepthtop", "sampledepthbottom")
idx <- ! names(d.phlab) %in% vars
names(d.phlab)[!idx] <- c("phiid", "hzdept", "hzdepb")

idx[2:3] <- TRUE
names(d.phlab)[idx] <- paste0(names(d.phlab)[idx], "_lab")


# compute thickness
d.phlab <- within(d.phlab, 
                  {hzthk_lab = hzdepb_lab - hzdept_lab}
                  )
  

# identify horizons with duplicate phiid
idx <- which(duplicated(d.phlab$phiid))
dup <- d.phlab[idx, "phiid"]


# aggregate dup phiid
idx <- which(d.phlab$phiid %in% dup)
test <- d.phlab[idx, ]

num_vars <- names(test)[! grepl("^ph", names(test)) &
                          sapply(test, is.numeric)]
test_num <- test[num_vars]
test_num <- plyr::ddply(test_num, .(phiid), function(x) {
  apply(x, 2, function(x2) Hmisc::wtd.mean(x2, weights = x$hzthk_lab, na.rm = TRUE))
  }
  )

char_vars <- names(test)[names(test) %in% c("phiid", "hzthk_lab") |
                         sapply(test, function(x) is.character(x) | is.factor(x))]
test_char <- test[char_vars]
test_char <- plyr::ddply(test_char, .(phiid), function(x) {
  apply(x, 2, function(x2) x2[which.max(x$hzthk_lab)])
  }
  )
test_char$hzthk_lab <- NULL

test <- join(test_num, test_char, by  = "phiid")
