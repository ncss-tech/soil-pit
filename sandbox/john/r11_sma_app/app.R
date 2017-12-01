library(shinydashboard)
library(plotly)
library(leaflet)

header<-dashboardHeader(
  title="Soil Moisture Data App")

sidebar<-dashboardSidebar(
  sidebarMenu(id="tabs",
              menuItem("Home", tabName="Home", selected=TRUE, icon=icon("home")),
              menuItem("Soil Moisture Data", tabName="rawdata", icon=icon("map-pin")),
              menuItem("Weather Data", tabName="nearby_stations", icon=icon("tint"),
                       menuSubItem("Nearby Stations", tabName="weather", icon=icon("map-marker")),
                       sliderInput("station_number", "# of weather stations to use:", min=1, max=25, value=3, step=1),
                       sliderInput("search_radius", "Max search distance (km):", min=5, max=500, value=50, step=5),
                       actionButton("submit", "Submit"), br(),p(),
              menuSubItem("Station Inventory", tabName="station_inventory", icon=icon("list-alt"))),
              menuItem("Normal Data", tabName="normaldata", icon=icon("area-chart"))
              )
)
  
body<-dashboardBody(
  
  #styling for the progress bar position
  tags$style(type="text/css", ".shiny-notification{position: fixed; top:33%;left:33%;right:33%;}"),
  
  tabItems(
    #Home tab
    tabItem(tabName="Home",
            titlePanel("Welcome to the Soil Moisture Data App"),
            verticalLayout(
              infoBox("About this App", "The Soil Moisture Data App is a tool for USDA soil scientists to analyze soil moisture monitoring data.", width=12, icon=icon("globe"), color="blue"),
              box(p(tags$b("Get started using the Soil Moisture Data App by selecting a menu item on the left.")),
                  p("Remember to click on a sub-menu item in order to view the results of a query."),
                  p("Once the sub-menu item is active it will begin loading an example query unless you have already changed the query inputs."),
                  p("The submit button can be used to submit another query after the sub-menu item has already been selected."),
                  p("This Application is viewed best in a browser such as Google Chrome or Mozilla Firefox"), width=12),
              box("This application was developed by John Hammerly.", width=12)
            )),
    #Analysis Report tab   
    tabItem(tabName="rawdata", class="active",
            titlePanel("Soil Moisture Observations"),
            verticalLayout(
              fluidRow(
                box(leafletOutput("sm_site"), status = "primary", title="Site Map", solidHeader=TRUE, collapsible=TRUE, width=12),
                box(plotlyOutput("iniplot"), status = "primary", title="Plot (all data)", solidHeader=TRUE, collapsible=TRUE, width=6),
                box(plotlyOutput("inimonthplot"), status = "primary", title="Plot (month summary)", solidHeader=TRUE, collapsible=TRUE, width=6),        
                box(DT::dataTableOutput("sitetable"), status = "primary", title="Soil Moisture Observations", solidHeader=TRUE, collapsible=TRUE, width=12), 
                box(DT::dataTableOutput("inimonthtable"), status = "primary", title="Month Summary", solidHeader=TRUE, collapsible=TRUE, width=12), 

              box("This application was developed by John Hammerly.", width=12)
            ))
    ),
    tabItem(tabName="station_inventory",
            titlePanel("Weather Analysis"),
            verticalLayout(
              fluidRow(
                box(DT::dataTableOutput("stationtable"), width=12)),
              box("This application was developed by John Hammerly.", width=12)
            )),
    tabItem(tabName="weather",
            titlePanel("Weather Analysis"),
            verticalLayout(
              fluidRow(
                box(leafletOutput("w_site"), status="primary", title="Weather Station Map", solidHeader=TRUE, collapsible=TRUE, width=6),
                box(plotlyOutput("annualprecip"), status = "primary", title="Plot", solidHeader=TRUE, collapsible=TRUE, width=6),
                box(DT::dataTableOutput("neareststation"), status = "primary", title="Stations", solidHeader=TRUE, collapsible=TRUE, width=12),
                box(DT::dataTableOutput("stationfilter"), status = "primary", title="Station Data", solidHeader=TRUE, collapsible=TRUE, width=12)),
              box("This application was developed by John Hammerly.", width=12)
    )),
    tabItem(tabName="normaldata",
            titlePanel("Normal Data"),
            verticalLayout(
              fluidRow(
                box(plotlyOutput("allnormalplot"), status="primary", title="Plot (Normal Observations)", solidHeader=TRUE, collapsible=TRUE, width=6),
                box(plotlyOutput("allnormalrainplot"), status="primary", title="Plot (Normal Precipitation)", solidHeader=TRUE, collapsible=TRUE, width=6),
                box(DT::dataTableOutput("normalobs"), status="primary", title="Normal Observations", solidHeader=TRUE, collapsible=TRUE, collapsed=TRUE, width=6),
                box(DT::dataTableOutput("normalprecip"), status="primary", title="Normal Precipitation", solidHeader=TRUE, collapsible=TRUE, collapsed=TRUE, width=6)
                ))
              )
)
)
ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session){

  observeEvent(input$submit,{
    updateTabItems(session, "tabs", "weather")
  })
  
  
  library(RODBC)
  library(soilDB)
  library(ggplot2)
  library(dplyr)
  library(lubridate)
  library(rnoaa)
  library(plyr)
  library(knitr)
  library(plotly)

sitedata <- reactive({
  source("https://github.com/ncss-tech/soil-pit/raw/master/sandbox/john/moisture_query/get_site_soilmoist_from_NASIS_db.R")
  s<-get_site_soilmoist_from_NASIS_db()
  return(s)
})
  
  
output$sitetable <- DT::renderDataTable({s <- sitedata()
}
, options = list(pageLength=10, scrollX="100%"))

output$iniplot <- renderPlotly({
  s<-sitedata()
  # Plot all data
  rsmmd<-ggplot(s, aes(x= as.Date(obs_date),y= t_sm_d, color=site_id)) + scale_colour_grey() +
    geom_line(cex=0.5)+scale_y_reverse()+scale_x_date() +
    labs(x="Date (year)", y="Depth to wetness (cm)", title="Raw Soil Moisture Monitoring Data")
  ggplotly(rsmmd)
}
)

smonth <- reactive({
  s <- sitedata()
  s_by_month<- aggregate(cbind(t_sm_d)~month(obs_date),data=s,FUN=mean)
  return(s_by_month)
})

output$inimonthtable <- DT::renderDataTable({
s_by_month <- smonth()
}, options = list(paging=FALSE, scrollX="100%"))



output$inimonthplot <- renderPlotly({
  
  s_by_month <- smonth()
  
mdwbm<-ggplot(s_by_month, aes(x= `month(obs_date)`,y= t_sm_d)) +
  geom_line(cex=1) +
  scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month") +
  ylim(max(s_by_month$t_sm_d), 0) +
  labs(y="Depth to Wetness (cm)", title="Mean Depth to Wetness by Month (all years)")
ggplotly(mdwbm)

})

stationdata <- reactive({
  s<- sitedata()
  station_data<-read.csv("station_data.csv")
  if(max(year(as.Date(s$obs_date)))>max(station_data$last_year, na.rm=TRUE)) {station_data<-ghcnd_stations()}
  return(station_data)
})

output$stationtable <-  DT::renderDataTable({withProgress(message="Loading weather station data", detail="Please Wait", value=1, {
  station_data <- stationdata()
  station_data
})
}, options = list(pageLength=10, scrollX="100%"))

near_station <- reactive({ input$submit
  s <- sitedata()
  station_data <- stationdata()
  # rename column to "id" so rnoaa understands
  s_ids<-plyr::rename(s, c("site_id"="id"))
  
  # Find nearby NOAA weather station  
  nearest_station<-as.data.frame(meteo_nearby_stations(lat_lon_df=s_ids, lat_colname= "y_std", lon_colname="x_std", limit=isolate(input$station_number), radius=isolate(input$search_radius), station_data= station_data), col.names=NULL)
  return(nearest_station)
  
})

output$neareststation <- DT::renderDataTable({withProgress(message="Finding nearest station", detail="Please Wait", value=0.5, {
nearest_station <-near_station()
})
}, options = list(pageLength=10, scrollX="100%"))

stationsdat<-reactive({
  s<- sitedata()
  nearest_station <-near_station()
  stations<-meteo_pull_monitors(nearest_station[,1])
  return(stations)
})

stationfilt<-reactive({
  s<- sitedata()
  stations<-stationsdat()
  # Filter the dates of interest
  station_filter<-stations %>% filter(date>= min(s$obs_date)) %>% filter(date<= max(s$obs_date))
return(station_filter)
})

output$stationfilter <- DT::renderDataTable({withProgress(message="Downloading Data", detail="Please Wait", value=1, {
station_filter<-stationfilt()
})
}, options = list(pageLength=10, scrollX="100%"))

output$annualprecip <- renderPlotly({
 s<-sitedata()
 station_filter<-stationfilt()
 
# Plot daily rainfall and soil moisture data
rsmmdrrd<-ggplot() +
  geom_path(data= station_filter, aes(x= as.Date(date),y= prcp/100, color=id)) +
  ylim(0, max(station_filter$prcp)/100) +
  labs(y="Precipitation (cm)", x="Date (year)", title="Raw Precipitation Data", color="Station ID")

ggplotly(rsmmdrrd)

})

all_years_l<-reactive({
  stations<-stationsdat()
  s<-sitedata()
  station_filter<-stationfilt()
  
  station_annual_precip<-aggregate(cbind(prcp)~ id + year(date),data=stations,FUN=sum)
  
  filter_annual_precip<-aggregate(cbind(prcp)~ `year(date)`, data=station_annual_precip, FUN=mean)
  min_normal_precip<-mean(filter_annual_precip$prcp)-sd(filter_annual_precip$prcp)
  max_normal_precip<-mean(filter_annual_precip$prcp)+sd(filter_annual_precip$prcp)
  
  # Sum the monthly data
  stations_by_month_and_year<-aggregate(cbind(prcp)~month(date)+year(date),data=stations,FUN=sum)
  
  #find means by month
  month_means<-aggregate(stations_by_month_and_year, by=list(stations_by_month_and_year$`month(date`), mean)
  
  #Find Normal Years
  
  normal_yrs_station_annual_precip<-station_annual_precip %>% filter(prcp<max_normal_precip & prcp>min_normal_precip)
  
  #Filter only normal years
  
  #create lookup
  
  years_list<-paste(normal_yrs_station_annual_precip$`year(date)`, collapse="|")
  
  #Use only normal years
  s_normal_years<-s %>%
    filter(grepl(years_list, obs_date))
  
  # Aggregate normal years by month
  s_normals_by_month<- aggregate(cbind(t_sm_d)~month(obs_date),data=s_normal_years,FUN=mean)
  
  # Plot Results
  # mdwywnap<-ggplot(s_normals_by_month, aes(x= `month(obs_date)`,y= t_sm_d))+geom_line(cex=1)+scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month")+ylim(max(s_normals_by_month$t_sm_d), 0) +
  #   labs(y="Depth to Wetness", title="Mean Depth to Wetness in Years With Normal Annual Precipitation")
  # ggplotly(mdwywnap)
  
  # Select normal rainfall data
  
  normal_station_filter<-station_filter %>%
    filter(grepl(years_list, date))
  
  # Aggregate normal rainfall
  normal_station_filter_by_month<-aggregate(cbind(prcp)~month(date),data=normal_station_filter,FUN=sum)

  # Filter normal precip
  filter_normal_annual_precip<-filter_annual_precip %>% filter(prcp>min_normal_precip) %>% filter(prcp<max_normal_precip)
  
  sd(month_means$prcp)
  
  month_st_dev<-aggregate(stations_by_month_and_year, by=list(stations_by_month_and_year$`month(date)`), sd)
  
  month_means$min<-month_means$prcp-month_st_dev$prcp
  month_means$max<-month_means$prcp+month_st_dev$prcp
  
  copy_stations_by_month_and_year<-stations_by_month_and_year
  
  
  copy_stations_by_month_and_year$full<-plyr::join(stations_by_month_and_year, month_means, by="month(date)", type="full")
  
  months_within_sd<-copy_stations_by_month_and_year[,4]
  
  months_within_sd_filter<- months_within_sd %>%
    filter(prcp>min & prcp<max)
  
  years_with_enough_months<- months_within_sd_filter %>%
    group_by(`year(date)`) %>%
    filter(n() >= 8)
  
  
  years_normal_months<-distinct(years_with_enough_months[,2])
  
  years_normal_months_matched<- years_normal_months %>%
    filter(grepl(years_list, `year(date)`))
  
  
  all_years_list<-paste(years_normal_months_matched$`year(date)`, collapse="|")
  return(all_years_list)
})

# output$normalyearsmonthplot
# 
# output$normalrainmonthplot
# 
output$allnormalplot <- renderPlotly({

  stations<-stationsdat()
  s<-sitedata()
  station_filter<-stationfilt()
  all_years_list<-all_years_l()

  all_s_normal_years<-s %>%
    filter(grepl(all_years_list, obs_date))
  
  # Aggregate all normal years by month
  all_s_normals_by_month<- aggregate(cbind(t_sm_d)~month(obs_date),data=all_s_normal_years,FUN=mean)
  
  
  all_s_normals_by_month_min<- aggregate(cbind(t_sm_d)~month(obs_date),data=all_s_normal_years,FUN=quantile, probs=0.05)
  
  all_s_normals_by_month_max<- aggregate(cbind(t_sm_d)~month(obs_date),data=all_s_normal_years,FUN=quantile, probs=0.95)
  
  all_s_normals_by_month$min<-all_s_normals_by_month_min[,2]
  
  all_s_normals_by_month$max<-all_s_normals_by_month_max[,2]
  
  # Plot Results
  wbmwlrh<-ggplot(all_s_normals_by_month, aes(x= `month(obs_date)`,y= t_sm_d))+
    geom_line(cex=1)+
    scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month")+
    ylim(max(all_s_normals_by_month$max), 0)+
    geom_ribbon(aes(ymin = min, ymax = max), alpha = 0.2) +
    labs(y="Depth (cm)", title="Wetness by Month with Low, RV, and High Depths")
  ggplotly(wbmwlrh)
})

output$allnormalrainplot <-renderPlotly({
  station_filter<-stationfilt()
  all_years_list<-all_years_l()
  # Select normal rainfall data
  
  all_normal_station_filter<-station_filter %>%
    filter(grepl(all_years_list, date))
  
  # Aggregate normal rainfall
  all_normal_station_filter_by_month<-aggregate(cbind(prcp)~month(date),data=all_normal_station_filter,FUN=sum)
  
  # Plot rainfall and water table by month
  mdwbmmrbm<-ggplot() +
    geom_line(data= all_normal_station_filter_by_month, aes(x= `month(date)`,y= prcp/100), color='blue') +
    scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month") +
    ylim(0, max(all_normal_station_filter_by_month$prcp)/100) +
    labs(y="Depth (cm)", title="Mean Normal Precip by Month", subtitle="Years with a Normal Annual Precip and a Normal Monthly Precip in at least 8 months of the year")
  ggplotly(mdwbmmrbm)
  
})

output$sm_site<-renderLeaflet({ 
  
  #load required libraries  

  library(leaflet)
  library(leaflet.esri)
  library(leaflet.extras)
  
  withProgress(message="Generating Map", value=0,{
    
    s<-sitedata()
    
    incProgress(1/10, detail =paste("Reading Coordinates")) 
    site_icons <-awesomeIcons(
      icon="circle",
      iconColor = 'black',
      library="fa",
      markerColor="red"
    )   
    incProgress(1/10, detail =paste("Please Wait")) 

    incProgress(1/10, detail =paste("Please Wait"))
    
    incProgress(1/10, detail =paste("Please Wait"))

    m<-leaflet()
    m<-addTiles(m, group="Open Street Map")
    
    
    incProgress(1/10, detail =paste("Adding Data to Map"))
    
    m<-addProviderTiles(m, providers$Esri.WorldImagery, group="ESRI Imagery")
    m<-addProviderTiles(m, providers$OpenMapSurfer.AdminBounds, group="Admin Boundaries")
    m<-hideGroup(m, c("Admin Boundaries","MLRA", "Soil Polygons"))
    m<-addEasyButton(m, easyButton(icon="fa-globe", title="Zoom to CONUS", onClick=JS("function(btn, map){map.setZoom(4);}")))
    m<-addEsriFeatureLayer(map=m, url='https://services.arcgis.com/SXbDpmb7xQkk44JV/arcgis/rest/services/US_MLRA/FeatureServer/0/',
                           group="MLRA", useServiceSymbology = TRUE, popupProperty =propsToHTML(props=c("MLRARSYM","MLRA_NAME")), smoothFactor=1, options=featureLayerOptions(renderer='L.canvas'))
    m<-addProviderTiles(m, providers$Esri.WorldStreetMap, group="ESRI Street")
    m<-addProviderTiles(m, providers$Esri.WorldTopoMap, group="ESRI Topo")
    m<-addProviderTiles(m, providers$Stamen.Terrain, group="Stamen Terrain")
    m<-addProviderTiles(m, providers$Stamen.TonerLite, group="Stamen TonerLite")
    m<-addWMSTiles(m, "https://SDMDataAccess.sc.egov.usda.gov/Spatial/SDM.wms?", options= WMSTileOptions(version="1.1.1", transparent=TRUE, format="image/png"), layers="mapunitpoly", group="Soil Polygons")
    m<-addAwesomeMarkers(m, data=s, lng=unique(s$x_std), lat=unique(s$y_std), label=unique(s$site_id), icon=site_icons, group="Monitoring Sites")
    m<-addLayersControl(m, baseGroups=c("Stamen TonerLite", "ESRI Street", "ESRI Topo", "ESRI Imagery","Open Street Map", "Stamen Terrain"),overlayGroups=c("Soil Polygons", "MLRA", "Admin Boundaries", "Monitoring Sites"))
    m<-setView(m, lat=mean(s$y_std), lng=mean(s$x_std), zoom=12)
    incProgress(1/10, detail =paste("Adding Data to Map"))
  })
  m
})
  
output$w_site<-renderLeaflet({ 
  
  #load required libraries  
  
  library(leaflet)
  library(leaflet.esri)
  library(leaflet.extras)
  
  withProgress(message="Generating Map", value=0,{
    
    nearest_station<-near_station()
    s<-sitedata()
    
    incProgress(1/10, detail =paste("Reading Coordinates")) 
    
    incProgress(1/10, detail =paste("Please Wait")) 
    site_icons <-awesomeIcons(
      icon="circle",
      iconColor = 'black',
      library="fa",
      markerColor="red"
    )
    incProgress(1/10, detail =paste("Please Wait"))
    station_icons <-awesomeIcons(
      icon="circle",
      iconColor = 'black',
      library="fa",
      markerColor="blue"
    )
    incProgress(1/10, detail =paste("Please Wait"))
    
    m<-leaflet()
    m<-addTiles(m, group="Open Street Map")
    
    
    incProgress(1/10, detail =paste("Adding Data to Map"))
    
    m<-addProviderTiles(m, providers$Esri.WorldImagery, group="ESRI Imagery")
    m<-addProviderTiles(m, providers$OpenMapSurfer.AdminBounds, group="Admin Boundaries")
    m<-hideGroup(m, c("Admin Boundaries","MLRA", "Soil Polygons"))
    m<-addEasyButton(m, easyButton(icon="fa-globe", title="Zoom to CONUS", onClick=JS("function(btn, map){map.setZoom(4);}")))
    m<-addEsriFeatureLayer(map=m, url='https://services.arcgis.com/SXbDpmb7xQkk44JV/arcgis/rest/services/US_MLRA/FeatureServer/0/',
                           group="MLRA", useServiceSymbology = TRUE, popupProperty =propsToHTML(props=c("MLRARSYM","MLRA_NAME")), smoothFactor=1, options=featureLayerOptions(renderer='L.canvas'))
    m<-addProviderTiles(m, providers$Esri.WorldStreetMap, group="ESRI Street")
    m<-addProviderTiles(m, providers$Esri.WorldTopoMap, group="ESRI Topo")
    m<-addProviderTiles(m, providers$Stamen.Terrain, group="Stamen Terrain")
    m<-addProviderTiles(m, providers$Stamen.TonerLite, group="Stamen TonerLite")
    m<-addWMSTiles(m, "https://SDMDataAccess.sc.egov.usda.gov/Spatial/SDM.wms?", options= WMSTileOptions(version="1.1.1", transparent=TRUE, format="image/png"), layers="mapunitpoly", group="Soil Polygons")
    m<-addAwesomeMarkers(m, data=nearest_station, label=nearest_station$id, icon=station_icons, group="Weather Stations")
    m<-addAwesomeMarkers(m, data=s, lng=unique(s$x_std), lat=unique(s$y_std), label=unique(s$site_id), icon=site_icons, group="Monitoring Sites")
    m<-addLayersControl(m, baseGroups=c("Stamen TonerLite", "ESRI Street", "ESRI Topo", "ESRI Imagery","Open Street Map", "Stamen Terrain"),overlayGroups=c("Soil Polygons", "MLRA", "Admin Boundaries", "Monitoring Sites", "Weather Stations"))
    incProgress(1/10, detail =paste("Adding Data to Map"))
  })
  m
})

output$normalobs<-DT::renderDataTable({
 
  stations<-stationsdat()
  s<-sitedata()
  station_filter<-stationfilt()
  all_years_list<-all_years_l()
  
  all_s_normal_years<-s %>%
    filter(grepl(all_years_list, obs_date))
  
  # Aggregate all normal years by month
  all_s_normals_by_month<- aggregate(cbind(t_sm_d)~month(obs_date),data=all_s_normal_years,FUN=mean)
  
  
  all_s_normals_by_month_min<- aggregate(cbind(t_sm_d)~month(obs_date),data=all_s_normal_years,FUN=quantile, probs=0.05)
  
  all_s_normals_by_month_max<- aggregate(cbind(t_sm_d)~month(obs_date),data=all_s_normal_years,FUN=quantile, probs=0.95)
  
  all_s_normals_by_month$min<-all_s_normals_by_month_min[,2]
  
  all_s_normals_by_month$max<-all_s_normals_by_month_max[,2]
  
  all_s_normals_by_month
  
   
}, options = list(pageLength=12, scrollX="100%"))

output$normalprecip<-DT::renderDataTable({
  station_filter<-stationfilt()
  all_years_list<-all_years_l()
  # Select normal rainfall data
  
  all_normal_station_filter<-station_filter %>%
    filter(grepl(all_years_list, date))
  
  # Aggregate normal rainfall
  all_normal_station_filter_by_month<-aggregate(cbind(prcp)~month(date),data=all_normal_station_filter,FUN=sum)
  all_normal_station_filter_by_month
}, options = list(pageLength=12, scrollX="100%"))

}

shinyApp(ui = ui, server = server)