function (WHERE = NULL,
          duplicates = FALSE,
          stringsAsFactors = default.stringsAsFactors())
{
  q.interp <-
    paste(
      "\n  SELECT saversion, saverest, l.areasymbol, l.areaname, l.lkey, musym, nationalmusym, muname, museq, mu.mukey, comppct_r, compname, localphase, slope_r, c.cokey, mrulename, ruledesign, ruledepth, ci.seqnum, interpll, interpllc, interplr, interplrc, interphh, interphr, interphrc\n\n  FROM sacatalog sac INNER JOIN\n legend l ON l.areasymbol = sac.areasymbol INNER JOIN\n mapunit mu ON mu.lkey = l.lkey LEFT OUTER JOIN\n  component c ON c.mukey = mu.mukey LEFT OUTER JOIN\n  cointerp ci ON ci.cokey = c.cokey\n  \n  WHERE",
      WHERE,
      "ORDER BY c.cokey ASC;"
    )
  
  d.interp <- SDA_query(q.interp)
  metadata <- NULL
  load(system.file("data/metadata.rda", package = "soilDB")[1])
  return(d.interp)
}