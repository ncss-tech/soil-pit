#load required library for creating a dashboard in shiny

library(shinydashboard)
library(leaflet)
library(rmarkdown)

source("wt.R")
source("om.R")
#source("c:/workspace2/pr.R")
jsfile<- "https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"


#create a dashboard header

header<-dashboardHeader(
  title= span(tagList(img(src="logo.png"), "Region 11 Web App")), titleWidth=250)

#create a sidebar and menu structure

sidebar<-dashboardSidebar( width = 250,
  sidebarMenu(id="tabs",
            
              #Home Page Menu    
              menuItem("Home", tabName="Home", selected=TRUE, icon=icon("home")),
              
              
              menuItem("LIMS Reports", tabName="LIMS", icon=icon("flask")),
              
              #Water Table Menu
              menuItem("Water Table", icon=icon("tint"),
                       menuSubItem("Plot", tabName="WTPlots", icon=icon("area-chart")),
                       menuSubItem("Data", tabName="Data", icon=icon("table")), 
                       wt_selectInput("wt_query")
              ),
              
              #Organic Matter Menu
              
              menuItem("Organic Matter", icon=icon("leaf"),
                       menuSubItem("Plot", tabName="OMPlots", icon=icon("area-chart")),
                       menuSubItem("Data", tabName="omdata", icon=icon("table")),
                       om_selectInput("om_query")
              ),
              
              #Project Report Menu
              
              # menuItem("Project Report", icon=icon("stack-overflow"),
                       # menuSubItem("Report", tabName="projectreport", icon=icon("file-text")),
                        # pr_textAreaInput("pr_query")
                       # ),

              menuItem("Project Report", icon=icon("stack-overflow"),
                       menuSubItem("Report", tabName="projectreport", icon=icon("file-text")),
                       textAreaInput(
                         inputId="projectreport",
                         label="Enter Project Name(s) -", "EVAL - MLRA 111A - Ross silt loam, 0 to 2 percent slopes, frequently flooded",
                         resize="none",
                         rows=5),
                       actionButton("reportsubmit", "Submit"), p(downloadLink("projectreportdownload", "Save a copy of this Report")), br(),p()),
              
                            
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
                       actionButton("extentsubmit", "Submit"), p(downloadLink("projectextentdownload", "Save spatial data")), br(),p()
              ),
              
              #Long Range Plan
              
              menuItem("Long Range Plan", icon=icon("plane"),
                       menuSubItem("Report", tabName="lrp", icon=icon("calendar")),
                       textInput(inputId="lrpinput", label="Enter SSO Symbol -", "11"),
                       actionButton("lrpsubmit", "Submit"), br(),p()
              ),
              
              #Interpretations
              
              menuItem("Interpretations", icon=icon("archive"),
                       menuSubItem("Report", tabName="ir", icon=icon("file-text")),
                       textInput(inputId="irinput", label="Enter NATSYM -", "2xbld"),
                       actionButton("irsubmit", "Submit"), br(),p()
              ),
              #Source Code Menu
              
              menuItem("Source Code", icon=icon("file-code-o"), href="https://github.com/ncss-tech/soil-pit/blob/master/sandbox/john/r11_app/"),
              
              # Submit Issues on GitHub
              menuItem("Submit App Issues", icon=icon("bug"), href="https://github.com/ncss-tech/soil-pit/issues"),
              
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
  tags$head(tags$script(src = jsfile),tags$link(rel="stylesheet", type="text/css",href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css")),
  
  #create tabs to match the menu items
  tabItems(
    #Home tab
    tabItem(tabName="Home",
            titlePanel("Welcome to the Region 11 Web App"),
            verticalLayout(
              infoBox("About this App", "The Region 11 Web App is a tool for soil scientists, geographers, and ecologists to get soils information on the web.", width=12, icon=icon("users"), color="blue"),
              box(p(tags$b("Get started using the Region 11 Web App by selecting a menu item on the left.")),
                  p("If a menu has multiple sub-menu items, remember to choose a sub-menu item in order to view the results of a query.  The Water Table and Organic Matter have both plots and tables in separate sub-menu items."),
                  p("Once the sub-menu item is active it will begin loading an example query unless you have already changed the query inputs."),
                  p("The submit button can be used to submit another query after the sub-menu item has already been selected."),
                  p("This application is viewed best in a browser such as Google Chrome or Mozilla Firefox"),
                  p("Wildcards can be used in the project extent query.  Use a percent symbol % for office.  Use an asterisk * for the project name."),
                  p("Maximum number of records returned from Soil Data Access is 100,000."),
                  p("Project Extent query uses pattern matching.  Anchors (^ or $) may be needed if exact results are needed"),
                  p("The Project Report can accept multiple projects.  Use the semicolon (;) as a separator."), width=12),
              box("This application was developed by John Hammerly, Stephen Roecker, and Dylan Beaudette.", width=12)
            )),
    
    #LIMS Reports
    
    tabItem(tabName="LIMS",
            includeHTML("lims.html")),
    
    
    #water table plot tab   
    tabItem(tabName="WTPlots", class="active",
            titlePanel("Water Table Plots"),
            wt_tabItem("wt_query")
    ),
    
    #water table data tab
    tabItem(tabName="Data",
      titlePanel("Water Table Data"),
        wt_tabItem2("wt_query"),
      verticalLayout(        
          box("This application was developed by John Hammerly and Stephen Roecker.", width=12))
      ),
    
    #project report tab
    # tabItem(
    #   tabName="projectreport",
    #   titlePanel("Component Report from LIMS"),
    #   pr_tabItem("pr_query")
    #   ),
    
    tabItem(
      tabName="projectreport",
      titlePanel("Project Report"),
      verticalLayout(
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
    
    #Interpretation Report tab
    tabItem(
      tabName="ir",
      titlePanel("Interpretation Report"),
      verticalLayout(
        fluidRow(
          box(tags$div(uiOutput("ir", inline=TRUE, container=span), style="width:100%; overflow-x: scroll"), width=12),
          box("This application was developed by John Hammerly and Stephen Roecker.", width=12)))
    ),
    
    #Organic Matter Plot Tab
    tabItem(
      tabName="OMPlots",
      titlePanel("Organic Matter Plots"),
      om_tabItem("om_query")
    ),
    #organic matter data tab
    tabItem(tabName="omdata",
            titlePanel("Organic Matter Data"),
            om_tabItem2("om_query")),
    
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
                      width=12, icon=icon("file-code-o"), color="red"),
              infoBox("Submit App Issues",
                      box("This menu item provides a link to the GitHub Repository issues page of the web app.  Submit an issue if one does not already exist by clicking the the green new issue button.  You can also submit an issue by sending an email to john.hammerly@in.usda.gov.", width=12), width=12, icon=icon("bug"))
              )
              )

  ))

#combine the header, sidebar, and body into a complete page for the user interface
ui <- dashboardPage(header, sidebar, body, title = "Region 11 Web App")

#create a function for the server
server <- function(input, output, session){

  #water table plot render

wt_plot <- callModule(wt, "wt_query")

om_plot <- callModule(om, "om_query")

# pr <- callModule(pr, "pr_query")

library(knitr)
  #render project report markdown

observeEvent(input$reportsubmit,{
  updateTabItems(session, "tabs", "projectreport")
})

  output$projectreport<-renderUI({ input$reportsubmit

    
    withProgress(message="Generating Report", detail="Please Wait", value=1, {
      
      params<- list(projectname = isolate(input$projectreport))
      
      includeHTML(rmarkdown::render("report.Rmd", html_fragment(number_sections=TRUE, params = params, pandoc_args = "--toc")))
      
      })
    })
  
  output$projectreportdownload<- downloadHandler(      
    filename = function() {input$reportsubmit
      paste("projectreport", Sys.Date(), ".html", sep="")
    },
    content= function(file) {
      tempReport <-file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite=TRUE)

      withProgress(message="Preparing Report for Saving", detail="Please Wait", value=1, {
      params<- list(projectname = isolate(input$projectreport))
      rmarkdown::render(tempReport, output_file=file, html_document(number_sections=TRUE, toc=TRUE, toc_float=TRUE, params = params))
      }
    )}
  )
  
  #render long range plan report markdown
  
  observeEvent(input$lrpsubmit,{
    updateTabItems(session, "tabs", "lrp")
  })
  output$lrp<-renderUI({ input$lrpsubmit
    withProgress(message="Generating Report", detail="Please Wait", value=1, {includeHTML(rmarkdown::render("r11_long_range_plan.Rmd", html_fragment(number_sections=TRUE, toc=TRUE)))})
  })
  
  #render interpretation report markdown
  
  observeEvent(input$irsubmit,{
    updateTabItems(session, "tabs", "ir")
  })
  output$ir<-renderUI({ input$irsubmit
    withProgress(message="Generating Report", detail="Please Wait", value=1, {includeHTML(rmarkdown::render("interp_report.Rmd", html_fragment(number_sections=TRUE, toc=TRUE)))})
  })

  #render project extent map
  
  observeEvent(input$extentsubmit,{
    updateTabItems(session, "tabs", "projectextent")
  })
  
  extentdata <- reactive({ input$extentsubmit
    
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
    
      ##### The following code is mostly from Dylan Beaudette #####
      
      # NASIS WebReport
      # get argument names from report HTML source
      url <- 'https://nasis.sc.egov.usda.gov/NasisReportsWebSite/limsreport.aspx?report_name=WEB-PROJECT_MUKEY_BY_GOAL_YEAR'
      
      ##### swap comment marks on the next 2 lines when testing the app locally#####
      args <- list(msso=paste0(isolate(input$office)), fy=paste0(isolate(input$fyinput)), asym='%', proj='0')
      # args <- list(msso="11-WAV", fy=2018, asym='%', proj='0')

      
      # this is now implemented in soilDB
      # get first table
      d <- parseWebReport(url, args, index=1)

      
      # make names legal
      names(d) <- make.names(names(d))
      
      # remove Description column
      d$Description <- NULL

      
      # check: OK
      str(d)
      
      # # pre-filter projects so that they only include MLRA / SDJR
      
      ##### swap comment marks on the next 2 lines when testing the app locally#####
      idx <- grep(paste0(isolate(input$projectextent)), d$Project.Name)
      # idx <- grep(paste0('MLRA 104 - Readlyn soils texture and slope phases'), d$Project.Name)
      
      d <- d[idx, ]

      
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

      
      sp <- dlply(d, 'Project.Name', getFeatures, .progress='text')

      
      # remove NULL features
      idx <- which(! sapply(sp, is.null))
      sp <- sp[idx]
      
      # convert into single SPDF
      sp.final <- do.call('rbind', sp)
      
      # sanity check: any projects missing from the results?
      # no, they are all there
      setdiff(unique(sp.final$projectiid), unique(d$projectiid))

      ##### End of Dylan's code #####
      
      return(sp.final)
  })
  
  output$projectextentmap<-renderLeaflet({ input$extentsubmit
    
    withProgress(message="Preparing Extent viewing", detail="Please Wait", value=1, {
    
      sp.final <- extentdata()
      
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

  output$projectextentdownload<- downloadHandler(      
    filename = function() {input$extentsubmit
      paste("projectextent", Sys.Date(), ".zip", sep="")
    },
    content= function(file) {

      withProgress(message="Preparing Extent for Saving", detail="Please Wait", value=1, {
        sp.final <- extentdata()
        writeOGR(sp.final, ".", "extent", driver = "ESRI Shapefile", overwrite_layer=TRUE)
        
        tempExtentzip <-file.path(tempdir(), "extent.zip")
        file.copy("extent.zip", tempExtentzip, overwrite=TRUE)
        
        # zip(file, c("extent.dbf","extent.prj","extent.shp","extent.shx"), zip = "C:/RBuildTools/3.4/bin/zip.exe")
        zip(file, c("extent.dbf","extent.prj","extent.shp","extent.shx"))
      }
      )}
  )
  
}

#combine the user interface and server to generate the shiny app
shinyApp(ui = ui, server = server)