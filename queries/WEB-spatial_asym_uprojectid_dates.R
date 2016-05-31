get_sdjr_NASIS_db <- function(selected_set = TRUE) {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  q <- paste("SELECT DISTINCT SUBSTRING(uprojectid, 1, 4) fy, REPLACE(SUBSTRING(a.areasymbol, 1, 2), '-', '') region, a.areasymbol office, 
projecttypename, uprojectid, projectname, p.projectiid, old_a.areasymbol, old_lmu.musym, old_mu.nationalmusym, 
             old_lmu.lmapunitiid old_mukey, old_mu.muname, old_mu.mutype, old_lmu.muacres old_muacres, 
             CASE WHEN pmu.seqnum = YEAR('10/01/2016') THEN 'TRUE' ELSE 'FALSE' END spatial
             
             FROM 
             project p INNER JOIN  
             projectmapunit pmu ON pmu.projectiidref = p.projectiid LEFT OUTER JOIN  
             projectmappinggoal pmg ON pmg.projectiidref = p.projectiid 
             
             INNER JOIN 
             projectmilestone pm ON pm.projectiidref = p.projectiid
             
             INNER JOIN  
             mapunit old_mu ON old_mu.muiid = pmu.muiidref INNER JOIN  
             lmapunit old_lmu ON old_lmu.muiidref = old_mu.muiid INNER JOIN  
             legend old_l ON old_l.liid = old_lmu.liidref INNER JOIN  
             area old_a ON old_a.areaiid = old_l.areaiidref 
             
             INNER JOIN  
             correlation cor ON cor.muiidref = old_mu.muiid AND cor.repdmu = 1
             
             INNER JOIN  
             area a ON a.areaiid = p.mlrassoareaiidref LEFT OUTER JOIN 
             projecttype pt ON pt.projecttypeiid = p.projecttypeiidref INNER JOIN 
             milestonetype mt ON mt.milestonetypeiid = pm.milestonetypeiidref 
             
LEFT OUTER JOIN
(SELECT lmu.lmapunitiid new_mukey, mu.nationalmusym AS new_nationalmusym, musym AS new_musym, mu.muname new_muname, lmu.muacres new_muacres, p.projectiid, cor.dmuiidref

             FROM
             project p INNER JOIN
             projectmapunit pmu ON pmu.projectiidref = p.projectiid INNER JOIN 
             mapunit mu ON mu.muiid = pmu.muiidref LEFT OUTER JOIN
             lmapunit lmu ON lmu.muiidref = mu.muiid
             
             INNER JOIN
             correlation cor ON cor.muiidref = mu.muiid AND cor.repdmu != 1
             
             WHERE mu.mutype = 1) newmu ON newmu.projectiid = p.projectiid AND newmu.dmuiidref = cor.dmuiidref 

             WHERE old_a.areasymbol LIKE 'IN001' AND
             (pm.seqnum = YEAR('10/01/2016') OR old_mu.mutype != 1 OR old_mu.mutype IS NULL)
             AND 
             (uprojectid LIKE '2016%' OR (milestonetypename LIKE '%Correlation activities%' AND pm.scheduledcompletiondate BETWEEN '10/01/2015' AND '10/01/2016') OR pmg.fiscalyear = YEAR('10/01/2016'))
             AND projectapprovedflag = 1 AND legendsuituse != 1
             
             ORDER BY uprojectid, old_a.areasymbol;")
  
  # setup connection local NASIS
  channel <- RODBC::odbcDriverConnect(connection="DSN=nasis_local;UID=NasisSqlRO;PWD=nasisRe@d0n1y")
  
  # exec query
  d <- RODBC::sqlQuery(channel, q, stringsAsFactors=FALSE)
  
  # close connection
  RODBC::odbcClose(channel)
  
  # done
  return(d)
}

