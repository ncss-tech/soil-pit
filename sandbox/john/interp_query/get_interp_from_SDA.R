function (WHERE = NULL, duplicates = FALSE, stringsAsFactors = default.stringsAsFactors()) 
{
  q.interp <- paste("\n  SELECT", if (duplicates == FALSE) {
    "DISTINCT"
  }, "saversion, saverest, l.areasymbol, l.areaname, l.lkey, musym, muname, museq, mu.mukey, comppct_r, compname, localphase, slope_r, c.cokey, mrulename, ruledesign, ruledepth, ci.seqnum, interpll, interpllc, interplr, interplrc, interphh, interphr, interphrc\n\n  FROM sacatalog sac INNER JOIN\n legend l ON l.areasymbol = sac.areasymbol INNER JOIN\n mapunit mu ON mu.lkey = l.lkey INNER JOIN", 
  if (duplicates == FALSE) {
    paste("\n  (SELECT MIN(nationalmusym) nationalmusym2, MIN(mukey) AS mukey2 \n  FROM mapunit\n  GROUP BY nationalmusym) AS \n  mu2 ON mu2.nationalmusym2 = mu.nationalmusym")
  }
  else {
    paste("\n    (SELECT compname, comppct_r, cokey, mukey AS mukey2 FROM component) AS c ON c.mukey2 = mu.mukey")
  }, "LEFT OUTER JOIN\n  component c ON c.mukey = mu.mukey LEFT OUTER JOIN\n  cointerp ci ON ci.cokey = c.cokey\n  \n  WHERE", 
  WHERE, "ORDER BY c.cokey ASC;")
  d.interp <- SDA_query(q.interp)
  metadata <- NULL
  load(system.file("data/metadata.rda", package = "soilDB")[1])
  d.interp <- within(d.interp, {
    nationalmusym = NULL
  })
  return(d.interp)
}
