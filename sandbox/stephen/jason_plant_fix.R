# existing veg
q.veg <- "SELECT siteiid, s plot_plant_inventory_View_1.seqnum, plantsym, plantsciname, plantnatvernm, vegetationstratalevel, orderofdominance
	FROM
	(((
	vegetation_plot_View_1 INNER JOIN plot_plant_inventory_View_1 ON vegetation_plot_View_1.siteiid = plot_plant_inventory_View_1.siteiidref) 
	INNER JOIN siteexistveg_View_1 ON siteexistveg_View_1.siteobsiidref = siteobs_View_1.siteobsiid)
	INNER JOIN localplant ON siteexistveg_View_1.lplantiidref = localplant.lplantiid)
	INNER JOIN plant ON localplant.plantiidref = plant.plantiid
	ORDER BY site_View_1.siteiid;"

q.veg <- "SELECT vegplotid, plantiidref, plantsym
FROM site
INNER JOIN siteobs ON siteobs.siteiidref=site.siteiid
inner join vegplot on vegplot.siteobsiidref=siteobs.siteobsiid
INNER JOIN plotplantinventory ON plotplantinventory.vegplotiidref=vegplot.vegplotiid
INNER JOIN plant ON plant.plantiid=plotplantinventory.plantiidref;"

# setup connection local NASIS
channel <- RODBC::odbcDriverConnect(connection="DSN=nasis_local;UID=NasisSqlRO;PWD=nasisRe@d0n1y")
# exec queries
d.veg <- RODBC::sqlQuery(channel, q.veg, stringsAsFactors=FALSE)
# close connection
 RODBC::odbcClose(channel)