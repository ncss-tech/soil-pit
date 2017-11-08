#load required library for creating a dashboard in shiny

library(shinydashboard)
library(leaflet)

#create a dashboard header

header<-dashboardHeader(
  title="Region 11 Web App")

#create a sidebar and menu structure

sidebar<-dashboardSidebar(
  sidebarMenu(id="tabs",
              
              #Home Page Menu    
              menuItem("Home", tabName="Home", selected=TRUE, icon=icon("home")),
              #Water Table Menu
              menuItem("Water Table", icon=icon("tint"),
                       menuSubItem("Plot", tabName="WTPlots", icon=icon("area-chart")),
                       menuSubItem("Data", tabName="Data", icon=icon("table")), 
                       selectInput("wtchoice", "Choose a query method -", c("Mapunit Key"="mukey","National Mapunit Symbol"="nationalmusym","Mapunit Name"="muname"), selected="mukey",multiple=FALSE),
                       textInput(
                         inputId="inmukey",
                         label="Enter query -",
                         406339),
                       actionButton("submukey", "Submit"),
                       radioButtons(inputId="filltype", "Choose fill:", c("flooding","ponding")), br()
              ),
              
              #Organic Matter Menu
              
              menuItem("Organic Matter", icon=icon("leaf"),
                       menuSubItem("Plot", tabName="OMPlots", icon=icon("area-chart")),
                       menuSubItem("Data", tabName="omdata", icon=icon("table")),
                       selectInput("omchoice", "Choose a query method -", c("Mapunit Key"="mukey","National Mapunit Symbol"="nationalmusym","Mapunit Name"="muname"), selected="mukey",multiple=FALSE),
                       textInput(
                         inputId="ominmukey",
                         label="Enter query -",
                         406338),
                       actionButton("omsubmukey", "Submit"), br(),p()
              ),
              
              #Project Report Menu
              
              menuItem("Project Report", icon=icon("stack-overflow"),
                       menuSubItem("Report", tabName="projectreport", icon=icon("file-text")),
                       textAreaInput(
                         inputId="projectreport",
                         label="Enter Project Name -", "SDJR - MLRA 111A - Ross silt loam, 0 to 2 percent slopes, frequently flooded",
                         resize="none",
                         rows=5),
                       actionButton("reportsubmit", "Submit"), br(),p()),
              
              #Project Extent Menu
              
              menuItem("Project Extent", icon=icon("map-signs"),
                       menuSubItem("Extent", tabName="projectextent", icon=icon("map")),
                       textInput(inputId="fyinput", label="Enter Fiscal Year -", 2018),
                       selectizeInput("office", "Choose an Office -",
                                   c("11-ATL"="11-ATL",
                                     "11-AUR"="11-AUR",
                                     "11-CLI"="11-CLI",
                                     "11-FIN"="11-FIN",
                                     "11-GAL"="11-GAL",
                                     "11-IND"="11-IND",
                                     "11-JUE"="11-JUE",
                                     "11-MAN"="11-MAN",
                                     "11-SPR"="11-SPR",
                                     "11-UNI"="11-UNI",
                                     "11-WAV"="11-WAV"),
                                   selected="11-CLI",multiple=FALSE, options=list(create=TRUE)),
                       textAreaInput(
                         inputId="projectextent",
                         label="Enter Project Name -","EVAL - MLRA 112 - Bates and Dennis soils, 3 to 5 percent slopes, eroded",
                         resize="none",
                         rows=5),
                       actionButton("extentsubmit", "Submit"), br(),p()
              ),
              
              #Long Range Plan
              
              menuItem("Long Range Plan", icon=icon("plane"),
                       menuSubItem("Report", tabName="lrp", icon=icon("calendar")),
                       textInput(inputId="lrpinput", label="Enter SSO Office -", "11-UNI"),
                       actionButton("lrpsubmit", "Submit"), br(),p()
                       ),
              
              #Source Code Menu
              
              menuItem("Source Code", icon=icon("file-code-o"), href="https://github.com/ncss-tech/soil-pit/blob/master/sandbox/john/r11_app/"),
              
              #Help Menu
              
              menuItem("Help", tabName="help", icon=icon("question"))
  )
)

#Create a body for the dashboard

body<-dashboardBody(
  
  #add style tags for customizations  
  
  #styling for the project extent map
  tags$style(type="text/css", "#projectextentmap {height: calc(100vh - 200px) !important;}"),
  #styling for the progress bar position
  tags$style(type="text/css", ".shiny-notification{position: fixed; top:33%;left:33%;right:33%;}"),
  
  
  #create tabs to match the menu items
  tabItems(
    #Home tab
    tabItem(tabName="Home",
            titlePanel("Welcome to the Region 11 Web App"),
            verticalLayout(
              infoBox("About this App", "The Region 11 Web App is a tool for USDA soil scientists to get soils information on the web.", width=12, icon=icon("university"), color="blue"),
              box(p(tags$b("Get started using the Region 11 Web App by selecting a menu item on the left.")),
                  p("Remember to click on a sub-menu item in order to view the results of a query."),
                  p("Once the sub-menu item is active it will begin loading an example query unless you have already changed the query inputs."),
                  p("The submit button can be used to submit another query after the sub-menu item has already been selected."),
                  p("This Application is viewed best in a browser such as Google Chrome or Mozilla Firefox"),
                  p("Wildcards can be used in the project extent query.  Use a percent symbol % for office.  Use an asterisk * for the project name."),
                  p("Maximum number of records returned from Soil Data Access is 100,000."),
                  p("Project Extent query uses pattern matching.  Anchors (^ or $) may be needed if exact results are needed"), width=12),
              box("This application was developed by John Hammerly, Stephen Roecker, and Dylan Beaudette.", width=12)
            )),
    #water table plot tab   
    tabItem(tabName="WTPlots", class="active",
            titlePanel("Water Table Plots"),
            verticalLayout(
              infoBox("Mapunit Name:",
                      uiOutput("muname", inline= TRUE, container=span),
                      width=12, icon=icon("map"), color="blue"),
              fluidRow(
                box(plotOutput("result"), width=12)),
              box("This application was developed by John Hammerly and Stephen Roecker.", width=12)
            )
    ),
    
    #water table data tab
    tabItem(
      tabName="Data",
      titlePanel("Water Table Data"),
      verticalLayout(
        infoBox("Mapunit Name:",
                uiOutput("muname2", inline= TRUE, container=span), width=12, icon=icon("map"), color="blue"),
        fluidRow(
          box(tags$div(DT::dataTableOutput("shdatatab"), style="width:100%; overflow-x: scroll"), width=12),
          box("This application was developed by John Hammerly and Stephen Roecker.", width=12))
      )),
    
    #project report tab
    tabItem(
      tabName="projectreport",
      titlePanel("Component Report from LIMS"),
      verticalLayout(
        infoBox("Project Name:",
                uiOutput("prjname", inline=TRUE, container=span),width=12, icon=icon("map"), color="blue"),
        fluidRow(
          box(tags$div(uiOutput("projectreport", inline=TRUE, container=span), style="width:100%; overflow-x: scroll"), width=12),
          box("This application was developed by John Hammerly and Stephen Roecker.", width=12))
      )),
    
    #project extent tab
    tabItem(
      tabName="projectextent",
      verticalLayout(
        fluidRow(
          box(leafletOutput("projectextentmap"), width=12),
          box("This application was developed by John Hammerly, Stephen Roecker and Dylan Beaudette.", width=12))
      )),
    
    #Long Range Plan tab
    tabItem(
      tabName="lrp",
      titlePanel("Long Range Plan"),
      verticalLayout(
        fluidRow(
        box(tags$div(uiOutput("lrp", inline=TRUE, container=span), style="width:100%; overflow-x: scroll"), width=12),
        box("This application was developed by John Hammerly and Stephen Roecker.", width=12)))
    ),
    
    #Organic Matter Plot Tab
    tabItem(
      tabName="OMPlots",
      titlePanel("Organic Matter Plots"),
      verticalLayout(
        infoBox("Mapunit Name:",
                uiOutput("muname3", inline= TRUE, container=span),
                width=12, icon=icon("map"), color="blue"),
        fluidRow(
          box(plotOutput("omplot"), width=12)),
        box("This application was developed by John Hammerly and Stephen Roecker.", width=12))
    ),
    
    #Help Tab
    tabItem(tabName="help",
            titlePanel("Help"),
            fluidRow(
              infoBox("About", box("This site is a set of web applications which use",
                                   a(href="https://www.r-project.org/", "R"), "to query information from",
                                   a(href="https://sdmdataaccess.nrcs.usda.gov/", "Soil Data Access"),
                                   "or LIMS and assembles the data into a table, plots it graphically, or generates a report.",width=12),width=12, icon=icon("info"), color="yellow"),
              infoBox("How to Use", box(
                p("1.  Choose a data type by clicking on the corresponding menu item in the list on the sidebar to the left.  Currently there are 4 choices available to explore:  Water Table, Organic Matter, Project Report and Project Extent."),
                p("2.  Choose how to view the data.  You can view either a plot or data table for the Water Table and Organic Matter choices.  The Project Report and Project extent only contain one option for each."),
                p("3.  Choose a query method.  This is only needed if you choose the Water Table or Organic Matter choices.  You can query using any one of 3 methods:  Mapunit Key, National Mapunit Symbol, or Mapunit Name.  A choice list is provided."),
                p("4.  Enter your query.  Be sure to enter the proper format.  Each of the previously mentioned methods has a unique set of criteria in order to return data without error."),
                p("5.  Click the Submit button.  The query will not execute until this button is clicked."),width=12),width=12, icon=icon("life-ring"), color="purple"
              )),
            fluidRow(
              infoBox("Water Table",
                      box("Use this data to learn more about the moisture in the soil.  
                          The plot shows depths at which different moisture status typically occur throughout the year.  
                          You also have the option of viewing either flooding frequency or ponding frequency in the plot by clicking the radio buttons.", width=12),
                      width=12, icon=icon("tint"), color="blue"),
              infoBox("Organic Matter",
                      box("Use this data to learn more about the organic matter in the soil.  The plot shows how organic matter changes with depth.  There are no additional options for viewing this data.", width=12),
                      icon=icon("leaf"), color="green", width=12),
              infoBox("Project",
                      box("Use this data to compare project data with previously populated data.  There are no additional options for viewing this data.", width=12),
                      icon=icon("file-text"), color="orange", width=12),
              infoBox("Source Code",
                      box("This menu item provides a link to a GitHub repository containing the computer code used in this application", width=12),
                      width=12, icon=icon("file-code-o"), color="red")
            )
    ),
    #organic matter data tab
    tabItem(tabName="omdata",
            titlePanel("Organic Matter Data"),
            verticalLayout(
              infoBox("Mapunit Name:",
                      uiOutput("muname4", inline= TRUE, container=span), width=12, icon=icon("map"), color="blue"),
              fluidRow(
                box(tags$div(DT::dataTableOutput("omdatatab"), style="width:100%; overflow-x: scroll"), width=12),
                box("This application was developed by John Hammerly and Stephen Roecker.", width=12))
            ))
  )
)

#combine the header, sidebar, and body into a complete page for the user interface
ui <- dashboardPage(header, sidebar, body)

#create a function for the server
server <- function(input, output){
  
  #load required libraries
  library(tidyverse)
  library(soilDB)
  library(dplyr)
  library(ggplot2)
  library(httr)
  library(jsonlite)
  library(DT)
  library(aqp)
  library(soilReports)
  library(knitr)
  
  
  #water table plot render
  output$result <- renderPlot({ input$submukey
    
    
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$wtchoice),"='", isolate(input$inmukey), "'"), duplicates = TRUE)
    
    if (input$filltype=="flooding") {ggplot(wtlevels, aes(x = as.integer(month), y = dept_r, lty = status))+
        geom_rect(aes(xmin = as.integer(month), xmax = as.integer(month)+
                        1, ymin = 0, ymax = max(wtlevels$depb_r),fill = flodfreqcl)) +
        geom_line(cex = 1) +
        geom_point() +
        geom_ribbon(aes(ymin = dept_l, ymax = dept_h), alpha = 0.2) +
        ylim(max(wtlevels$depb_r), 0) +xlab("month") + ylab("depth (cm)") +
        scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month")+
        facet_wrap(~ paste(compname, comppct_r, "pct", nationalmusym, sep = "-")) +
        ggtitle("Water Table Levels from Component Soil Moisture Month Data")}
    
    else if (input$filltype=="ponding") {ggplot(wtlevels, aes(x = as.integer(month), y = dept_r, lty = status))+
        geom_rect(aes(xmin = as.integer(month), xmax = as.integer(month)+
                        1, ymin = 0, ymax = max(wtlevels$depb_r),fill = pondfreqcl)) +
        geom_line(cex = 1) +
        geom_point() +
        geom_ribbon(aes(ymin = dept_l, ymax = dept_h), alpha = 0.2) +
        ylim(max(wtlevels$depb_r), 0) +xlab("month") + ylab("depth (cm)") +
        scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month")+
        facet_wrap(~ paste(compname, comppct_r, "pct", nationalmusym, sep = "-")) +
        ggtitle("Water Table Levels from Component Soil Moisture Month Data")}})
  
  #mapunit name render for water table plot tab
  output$muname<-renderText({    input$submukey
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$wtchoice),"='", isolate(input$inmukey), "'"), duplicates = TRUE)
    
    wtlevels$muname[1]})
  
  #mapunit name render for water table data tab
  output$muname2<-renderText({   input$submukey 
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$wtchoice),"='", isolate(input$inmukey), "'"), duplicates = TRUE)
    
    wtlevels$muname[1]})
  
  #mapunit name render for organic matter plot tab
  output$muname3<-renderText({   input$omsubmukey 
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$omchoice),"='", isolate(input$ominmukey), "'"), duplicates = TRUE)
    
    wtlevels$muname[1]})
  
  #mapunit name render for organic matter data tab
  output$muname4<-renderText({   input$omsubmukey 
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$omchoice),"='", isolate(input$ominmukey), "'"), duplicates = TRUE)
    
    wtlevels$muname[1]})
  
  #render water table data table
  output$shdatatab<- DT::renderDataTable({input$submukey
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$wtchoice),"='", isolate(input$inmukey), "'"), duplicates = TRUE)}, options = list(paging=FALSE))
  
  #render project report markdown
  output$projectreport<-renderUI({
    
    withProgress(message="Generating Report", detail="Please Wait", value=1, {includeMarkdown(knit("report.Rmd"))})})
  
  #render long range plan report markdown
  output$lrp<-renderUI({ input$lrpsubmit
    withProgress(message="Generating Report", detail="Please Wait", value=1, {includeMarkdown(knit("r11_long_range_plan.Rmd"))})
  })
  
  #render project name text for project report tab
  output$prjname<-renderText({input$reportsubmit
    prjname<-fetchLIMS_component(isolate(input$projectreport), fill = TRUE)
    prjname$mapunit[1,3]})
  
  #render project extent map
  output$projectextentmap<-renderLeaflet({ input$extentsubmit
    
    #load required libraries  
    library(rmarkdown)
    library(rvest)
    library(soilDB)
    library(plyr)
    library(sp)
    library(rgdal)
    library(leaflet)
    library(rgeos)
    library(leaflet.esri)
    library(leaflet.extras)
    
    withProgress(message="Generating Map", value=0,{
      
      ##### The following code is mostly from Dylan Beaudette #####
      
      # NASIS WebReport
      # get argument names from report HTML source
      url <- 'https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-PROJECT_MUKEY_BY_GOAL_YEAR'
      
      ##### swap comment marks on the next 2 lines when testing the app locally#####
      args <- list(msso=paste0(isolate(input$office)), fy=paste0(isolate(input$fyinput)), asym='%', proj='0')
      #args <- list(msso="11-WAV", fy=2018, asym='%', proj='0')
      
      incProgress(1/10, detail =paste("Loading Data from Web Report"))
      
      # this is now implemented in soilDB
      # get first table
      d <- parseWebReport(url, args, index=1)
      
      incProgress(1/10, detail =paste("Please Wait"))  
      
      # make names legal
      names(d) <- make.names(names(d))
      
      # remove Description column
      d$Description <- NULL
      
      incProgress(1/10, detail =paste("Please Wait")) 
      
      # check: OK
      str(d)
      
      # # pre-filter projects so that they only include MLRA / SDJR
      
      ##### swap comment marks on the next 2 lines when testing the app locally#####
      idx <- grep(paste0(isolate(input$projectextent)), d$Project.Name)
      #idx <- grep(paste0('MLRA 104 - Readlyn soils texture and slope phases'), d$Project.Name)
      
      d <- d[idx, ]
      
      incProgress(1/10, detail =paste("Please Wait")) 
      
      # get geometry associated with a specific project
      # note: requests for the full geometry will fail when results are too large for JSON serializer
      # solution: use BBOX instead
      getFeatures <- function(i) {
        # get only feature envelopes (BBOX)
        q <- "SELECT 
        mupolygongeo.STEnvelope().STAsText() AS geom, muname, P.mukey
        FROM mupolygon AS P
        INNER JOIN mapunit AS M ON P.mukey = M.mukey
        WHERE P.mukey IN "
        
        # interpolate mukey via IN statement
        q <- paste0(q, format_SQL_in_statement(i$mukey), ';')
        
        # get the results quietly
        res <- suppressMessages(SDA_query(q))
        if(is.null(res))
          return(NULL)
        
        # convert to sp object
        s <- processSDA_WKT(res)
        
        # join relevant original metadata via mukey
        # this only works within a single project ID
        s <- sp::merge(s, unique(i[, c('mukey', 'National.Mapunit.Symbol', 'Project.Name', 'Project.Type.Name', 'Area.Symbol', 'projectiid')]), by='mukey', all.x=TRUE)
        
        return(s)
      }
      
      # get / process features by mapunit
      
      
      incProgress(1/10, detail =paste("Computing Feature Envelope")) 
      
      sp <- dlply(d, 'Project.Name', getFeatures, .progress='text')
      
      incProgress(1/10, detail =paste("Please Wait")) 
      
      # remove NULL features
      idx <- which(! sapply(sp, is.null))
      sp <- sp[idx]
      
      incProgress(1/10, detail =paste("Please Wait"))
      
      # convert into single SPDF
      sp.final <- do.call('rbind', sp)
      
      # sanity check: any projects missing from the results?
      # no, they are all there
      setdiff(unique(sp.final$projectiid), unique(d$projectiid))
      
      incProgress(1/10, detail =paste("Please Wait"))
      ##### End of Dylan's code #####
      
      pal<- colorFactor(palette="viridis", domain=sp.final$muname)
      
      m<-leaflet()
      m<-addTiles(m, group="Open Street Map")

      
      incProgress(1/10, detail =paste("Adding Data to Map"))
      
      m<-addProviderTiles(m, providers$Esri.WorldImagery, group="ESRI Imagery")
      m<-addProviderTiles(m, providers$OpenMapSurfer.AdminBounds, group="Admin Boundaries")
      m<-hideGroup(m, c("Admin Boundaries","MLRA"))
      m<-addEasyButton(m, easyButton(icon="fa-globe", title="Zoom to CONUS", onClick=JS("function(btn, map){map.setZoom(4);}")))
      m<-addEsriFeatureLayer(map=m, url='https://services.arcgis.com/SXbDpmb7xQkk44JV/arcgis/rest/services/US_MLRA/FeatureServer/0/',
                             group="MLRA", useServiceSymbology = TRUE, popupProperty =propsToHTML(props=c("MLRARSYM","MLRA_NAME")), smoothFactor=1, options=featureLayerOptions(renderer='L.canvas'))
      m<-addProviderTiles(m, providers$Esri.WorldStreetMap, group="ESRI Street")
      m<-addProviderTiles(m, providers$Esri.WorldTopoMap, group="ESRI Topo")
      m<-addProviderTiles(m, providers$Stamen.Terrain, group="Stamen Terrain")
      m<-addProviderTiles(m, providers$Stamen.TonerLite, group="Stamen TonerLite")
      m<-addWMSTiles(m, "https://SDMDataAccess.sc.egov.usda.gov/Spatial/SDM.wms?", options= WMSTileOptions(version="1.1.1", transparent=TRUE, format="image/png"), layers="mapunitpoly", group="Soil Polygons")
      m<-addPolygons(m, data=sp.final, stroke=TRUE, color= ~pal(muname), weight=2, popup= paste("<b>MLRA SSO Area Symbol:  </b>", sp.final$Area.Symbol, "<br>",
                                                    "<b>Project Type:  </b>", sp.final$Project.Type.Name, "<br>",
                                                    "<b>Project Name:  </b>", sp.final$Project.Name, "<br>",
                                                    "<b>Mapunit Key:  </b>", sp.final$mukey, "<br>",
                                                    "<b>National Mapunit Symbol:  </b>", sp.final$National.Mapunit.Symbol, "<br>",
                                                    "<b>Mapunit Name:  </b>", sp.final$muname), group="Mapunits")
      m<-addLayersControl(m, baseGroups=c("ESRI Street", "ESRI Topo", "ESRI Imagery","Open Street Map", "Stamen Terrain", "Stamen TonerLite"),overlayGroups=c("Soil Polygons", "MLRA", "Admin Boundaries", "Mapunits"))
      m<-addLegend(m, pal=pal, position="bottomleft", values= sp.final$muname)
     incProgress(1/10, detail =paste("Your Map is on its way!"))
    })
    m
  })
  
  #render organic matter plot
  output$omplot<-renderPlot({ input$omsubmukey
    # import soil data using the fetchSDA_component() function
    omdata = fetchSDA_component(WHERE = paste0(isolate(input$omchoice),"='", isolate(input$ominmukey), "'"), duplicates= TRUE)
    
    # Convert the data for plotting
    omdata_slice <- aqp::slice(omdata$spc, 0:200 ~ om_l + om_r + om_h)
    h = horizons(omdata_slice)
    h = merge(h, site(omdata$spc)[c("cokey", "compname", "comppct_r")], by = "cokey", all.x = TRUE)
    
    # plot clay content
    ggplot(h) +
      geom_line(aes(y = om_r, x = hzdept_r)) +
      geom_ribbon(aes(ymin = om_l, ymax = om_h, x = hzdept_r), alpha = 0.2) +
      xlim(200, 0) +
      xlab("depth (cm)") + ylab("organic matter (%)") +
      ggtitle("Depth Plots of Organic Matter by Soil Component") +
      facet_wrap(~ paste(compname, comppct_r, "%")) +
      coord_flip()})
  
  output$omdatatab<- DT::renderDataTable({input$omsubmukey
    omdata <- fetchSDA_component(WHERE = paste0(isolate(input$omchoice),"='", isolate(input$ominmukey), "'"), duplicates= TRUE);    omdata_slice <- aqp::slice(omdata$spc, 0:200 ~ om_l + om_r + om_h)
    h = horizons(omdata_slice)
    h = merge(h, site(omdata$spc)[c("cokey", "compname", "comppct_r")], by = "cokey", all.x = TRUE)}, options = list(paging=FALSE))
  
  
}

#combine the user interface and server to generate the shiny app
shinyApp(ui = ui, server = server)