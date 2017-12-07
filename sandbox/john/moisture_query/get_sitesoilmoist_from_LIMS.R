
get_sitesoilmoist_from_LIMS <- function(usiteid) {

  url<- "https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=get_sitesoilmoist_from_LIMS"
  
  args<- list(user_site_id=usiteid)
  
  d.site<-parseWebReport(url,args)
  
  d.site <-uncode(d.site, db="LIMS")
  
  return(d.component)
  
}