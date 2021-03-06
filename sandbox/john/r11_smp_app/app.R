#Load required libraries

library(RODBC)
library(shinydashboard)
library(shiny)
library(data.table)
library(plotly)
library(soilDB)
library(rnoaa)
library(lubridate)
library(ggplot2)
library(plyr)
library(dplyr)

# Create a dashboard header

header <- dashboardHeader(
  title = "Soil Moisture Data Processing App", titleWidth = 350
  )

# Create a dashboard sidebar with menu items

sidebar <- dashboardSidebar(
  sidebarMenu(
  id = "tabs",
  menuItem(
    "Home",
    tabName = "Home",
    selected = TRUE,
    icon = icon("home")
  ),
  menuItem(
    "Instructions",
    tabName = "Instructions",
    icon = icon("info")
  ),
  menuItem(
    "Soil Moisture Data",
    tabName = "loaddata",
    icon = icon("map-pin")
  ),
  menuItem(
    "Example",
    tabName = "example",
    icon = icon("map-pin")
  ),
  menuItem(
    "Soil Moisture Data Analysis",
    icon = icon("fighter-jet"),
    href = "https://hammerly.shinyapps.io/r11_sma_app/"
  ),
  menuItem(
    "Source Code",
    icon = icon("file-code-o"),
    href = "https://github.com/ncss-tech/soil-pit/blob/master/sandbox/john/r11_smp_app/app.R/"
  )
 )
)

# Create a dashboard body

body <- dashboardBody(
  
  #styling for the progress bar position
  
  tags$style(
    type = "text/css",
    ".shiny-notification{position: fixed; top:33%;left:33%;right:33%;}"
  ),
  
  #styling for the validation errors
  
  tags$style(HTML(".shiny-output-error-validation {color: red; padding: 5px;}")),
  
# Tabs items  
  
  tabItems(
    #Home tab
    tabItem(
      tabName = "Home",
      titlePanel("Welcome to the Soil Moisture Data Processing App"),
      verticalLayout(
        infoBox(
          "About this App",
          "The Soil Moisture Data Processing App is a tool for USDA soil scientists to process soil moisture monitoring data for upload into NASIS.",
          width = 12,
          icon = icon("globe"),
          color = "blue"
        ),
        box(
          p(tags$b(
            "Instructions for Using the Soil Moisture Data Load App"
          )),
          p(
            "Before you get started working with this app, you should first consider the following assumptions taken in creating this app:"
          ),
          
          p(
            "1. The monitoring data is an accurate representation of a wet soil moisture condition"
          ),
          p(
            "2. Data collection has completed and it is ready to archive in NASIS and analyzed in R"
          ),
          p(
            "3. NASIS is installed and you have sufficient privileges to edit the database"
          ),
          
          p(
            "If your situation does not meet the assumptions above, you will need to tailor the instructions to fit your needs.  This could involve additional data manipulations in Excel or R, performing ground truth activities, and/or changing functions and before loading into Excel or NASIS."
          ),
          
          p(
            "The instructions were tested and confirmed functional using NASIS data model 7.3.3."
          ),
          
          p(
            "This Application is viewed best in a browser such as Google Chrome or Mozilla Firefox"
          ),
          width = 12
        ),
        box("This application was developed by John Hammerly.", width = 12)
      )
    ),
    
    #Instructions tab 
    
    tabItem(
      tabName = "Instructions",
      titlePanel("Instructions for Processing Soil Monitoring Data"),
      verticalLayout(
        infoBox(
          "Process Soil Moisture Monitoring data for upload to NASIS",
          "This app is designed to process soil moisture monitoring data and properly format it for upload into NASIS.",
          width = 12,
          icon = icon("info"),
          color = "green"
        ),
        box(
          p(tags$b("Instructions for Using the Soil Moisture Data Load App")),
          p("Data should be in a common format for processing.  The data should be a .csv file(s) with 3 columns."),
          p("Column 1: date (mm/dd/YYYY)."),
          p("Column 2: time (all formats accepted)."),
          p("Column 3: measurement depth (m, cm, ft, in)."),
          p(
            "The first row of the data is treated as a header.
            Some monitoring devices measure in reference to the sensor installation depth.
            In these cases, the measurements need to be adjusted to the reference point.
            The calibration point is depth at which the surface of the soil occurs.
            The total length is the length of the well (above and below the soil surface)."
          ),
          width = 12
          )
        )
      ),
    
    #Example tab

    tabItem(tabName="example",
        includeHTML("example.html")
        ),

    #Analysis Report tab
    
    tabItem(
      tabName = "loaddata",
      class = "active",
      titlePanel("Processing Soil Moisture Data is as easy as 1 - 2 - 3"),
      verticalLayout(fluidRow(
        column(
          width = 3,
          tags$h3("1. Load"),
          box(
            p("Inputs marked with an asterisk (*) are required."),
            p("Click submit button to begin processing."),
            uiOutput("sm_inputs"),
            uiOutput("valref_c"),
            uiOutput("sm_units"),
            box(
              solidHeader = TRUE,
              title = "Populate 2 of the 3 variables",
              status = "primary",
              tags$img(src="wells.png", width="100%"),
              uiOutput("pipelength"),
              uiOutput("sm_sensordepth"),
              uiOutput("pipebelow"),
              width = 12
            ),
            uiOutput("sm_office"),
            uiOutput("sm_usiteid"),
            uiOutput("sm_project"),
            uiOutput("sm_projectid"),
            uiOutput("sm_sensor"),
            uiOutput("sm_bottomdepth"),
            actionButton("submit", "Submit"),
            status = "primary",
            title = "Inputs",
            solidHeader = TRUE,
            collapsible = TRUE,
            width = 12
          )
        ),
        column(
          width = 6,
          tags$h3("2. Review"),
          
          tabBox(
            title = "Input Data",
            tabPanel("Plot", plotlyOutput("iniplot")),
            tabPanel("Table", DT::dataTableOutput("mon_data")),
            width = 12
          ),
          tabBox(
            title = "Processed Data",
            tabPanel("Plot", plotlyOutput("exportplot")),
            tabPanel("Table", DT::dataTableOutput("exporttable")),
            width = 12
          ),
          tabBox(
            title = "Precipitation and Water Level Plot",
            tabPanel("Plot", plotlyOutput("doubleplot")),
            width = 12
          )
        ),
        column(
          width = 3,
          tags$h3("3. Download"),
          box(
            uiOutput("downloadtext"),
            uiOutput("sm_xlsfile"),
            status = "primary",
            title = "Download File",
            solidHeader = TRUE,
            collapsible = TRUE,
            width = 12
          )
        ),
        
        box("This application was developed by John Hammerly.", width = 12)
      ))
    )
        )
      )

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session) {
  
  dataModal <- function(failed = FALSE) {
    modalDialog(title="Soil Moisture Data Processing App Message:",

      if (failed)
        div(tags$p("No file(s) selected for processing.  Please upload a dataset.", style = "color: red;")),
      easyClose=TRUE,
      footer = tagList(
        modalButton("Try Again")
      )
    )
  }
  
  observeEvent(input$submit, {
    # Check that data object exists and is data frame.
    if (is.null(isolate(input$mdatainput))) {
      showModal(dataModal(failed = TRUE))
    }
  })
  
  
  
  
  output$sm_inputs <- renderUI({
    fileInput(
      "mdatainput",
      "Monitoring Data File(s)*",
      multiple = TRUE,
      accept = c(
        "text/csv",
        "text/comma-separated-values,text/plain",
        ".csv"
      ),
      buttonLabel = "Browse...",
      placeholder = "No file selected"
    )
    
  })
  
  output$sm_office <- renderUI({
    textInput("office",
              "Data Collector",
              value = "",
              placeholder = "11-ATL")
    
  })
  
  output$sm_usiteid <- renderUI({
    textInput("usiteid",
              "User Site ID*",
              value = "",
              placeholder = "2013IA001001")
    
  })
  
  output$sm_project <- renderUI({
    textInput("project",
              "Project Name",
              value = "",
              placeholder = "DSP - MLRA 108D - Shelby, clay loam")
    
  })
  
  output$sm_projectid <- renderUI({
    textInput("projectid",
              "User Project ID",
              value = "",
              placeholder = "201711ATL999")
    
  })
  
  output$sm_sensor <- renderUI({
    selectInput(
      "sensor",
      "Sensor Type",
      selected = "",
      choices = c(
        "",
        "aquaflex",
        "campbell scientific",
        "coleman",
        "CS650",
        "decagon ec-5",
        "decagon 5tm",
        "dynamax",
        "echo probe",
        "global water data logger wl16s",
        "global water data logger wl16u",
        "global water data logger wl15",
        "global water data logger wl16",
        "hydra probe analog",
        "hydra probe II SDI-12",
        "S-SMC-M005",
        "sentry 200ap",
        "soil moisture equipment",
        "TDR 300",
        "tektronix",
        "theta probe",
        "trime",
        "vitel hydra probe",
        "watermark",
        "infinites usa",
        "solinst 3001 levelogger edge",
        "global water data logger wl15x-015"
      ),
      multiple = FALSE
    )
    
  })
  
  output$sm_bottomdepth <- renderUI({
    textInput("bottomdepth",
              "Bottom Depth (cm)*",
              value = "",
              placeholder = "210")
    
  })
  
  output$sm_sensordepth <- renderUI({
    textInput("sensordepth",
              "b (cm)",
              value = "",
              placeholder = "157")
    
  })
  
  output$sm_units <- renderUI({
    radioButtons(
      "units",
      "Input Data Unit of Measure*",
      choices = c("meters", "centimeters", "feet", "inches"),
      selected = "centimeters",
      inline = TRUE
    )
    
  })
  
  output$valref_c <- renderUI({
    radioButtons(
      "valref",
      "Measurement Values are:*",
      choices = c("positive", "negative"),
      selected = "positive",
      inline = TRUE
    )
    
  })
  
  output$pipebelow <- renderUI({
    textInput("pipeb",
              "c (cm)",
              value = "",
              placeholder = "79")
    
  })
  
  output$pipelength <- renderUI({
    textInput("pipel",
              "a (cm)",
              value = "",
              placeholder = "236")
    
  })

  sitedata <- reactive({
    source("https://github.com/ncss-tech/soil-pit/raw/master/sandbox/john/moisture_query/get_site_soilmoist_from_NASIS_db.R")
    si<-get_site_soilmoist_from_NASIS_db()
    return(si)
  })
  
  stationdata <- reactive({ input$submit
    sited <- sitedata()
    station_data<-read.csv("station_data.csv")
    if(max(year(as.Date(sited$obs_date)))>max(station_data$last_year, na.rm=TRUE)) {station_data<-ghcnd_stations()}
    return(station_data)
  })
  
  output$stationtable <-  DT::renderDataTable({withProgress(message="Loading weather station data", detail="Please Wait", value=1, {
    station_data <- stationdata()
    station_data
  })
  }, options = list(pageLength=10, scrollX="100%"))
  
  near_station <- reactive({ input$submit
    sited <- sitedata()
    station_data <- stationdata()
    # rename column to "id" so rnoaa understands
    s_ids<-plyr::rename(sited, c("site_id"="id"))
    
    # Find nearby NOAA weather station  
    nearest_station<-as.data.frame(meteo_nearby_stations(lat_lon_df=s_ids, lat_colname= "y_std", lon_colname="x_std", limit=1, station_data= station_data), col.names=NULL)
    return(nearest_station)
    
  })
  
  stationsdat<-reactive({
    sited<- sitedata()
    nearest_station <-near_station()
    stations<-meteo_pull_monitors(nearest_station[,1])
    return(stations)
  })
  
  stationfilt<-reactive({
    sited<- sitedata()
    stations<-stationsdat()
    # Filter the dates of interest
    station_filter<-stations %>% filter(date>= min(sited$obs_date)) %>% filter(date<= max(sited$obs_date))
    return(station_filter)
  })
  
  mon_data <- reactive({
    input$submit
    
    withProgress(message="Processing Data", value=1,{
    
    if (is.null(isolate(input$mdatainput)))
      return(NULL)
    
    mdata <- isolate(input$mdatainput)
    
    
    monitor_data <- rbindlist(lapply(isolate(mdata$datapath), fread),
                              use.names = TRUE,
                              fill = TRUE)
    
    subset_m_data <- monitor_data[, 1:3]
    
    colnames(subset_m_data) <- c("date", "time", "depth")
    
    return(subset_m_data)
    })
  })
  
  output$mon_data <- DT::renderDataTable({
    monitor_data <- mon_data()
    
  }, options = list(pageLength = 5, scrollX = "100%"))
  
  
  output$daily_data <- DT::renderDataTable({
    input$submit
    
    withProgress(message="Processing Data", value=1,{
    
    monitor_data <- mon_data()
    
    #check if data is positive or negative reference
    
    if (isolate(input$valref == "positive")) {
      monitor_data$depth <- monitor_data$depth * 1
    }
    else {
      monitor_data$depth <- monitor_data$depth * -1
    }
    
    # Replace values less than zero
    monitor_data$depth[monitor_data$depth < 0] <- 0
    
    monitor_data_daily <-
      aggregate(cbind(depth) ~ date, data = monitor_data, FUN = mean)
    
    # convert date column to date type
    monitor_data_daily_convert <-
      data.frame(
        as.Date(monitor_data_daily$date, format = "%m/%d/%Y"),
        if (isolate(input$units == "inches")) {
          round(monitor_data_daily$depth * 2.54)
        }
        else if (isolate(input$units ==
                         "meters")) {
          round(monitor_data_daily$depth * 100)
        }
        else if (isolate(input$units ==
                         "feet")) {
          round(monitor_data_daily$depth * 30.48)
        }
        else
          (round(monitor_data_daily$depth))
      )
    
    # rename columns to match NASIS
    names(monitor_data_daily_convert) <- list("obsdate", "soimoistdept")
    
    
    # Order by date
    monitor_data_daily_convert <-
      monitor_data_daily_convert[order(monitor_data_daily_convert$obsdate), ]
    
    # Reassign row names based on new ordering
    row.names(monitor_data_daily_convert) <-
      1:nrow(monitor_data_daily_convert)
    monitor_data_daily_convert$seqnum <-
      seq.int(nrow(monitor_data_daily_convert))
    
    # Reorder columns
    monitor_data_daily_convert <- monitor_data_daily_convert[, c(3, 1, 2)]
    
    # Rename data.frame
    sitesoilmoist_table <- monitor_data_daily_convert
    
    sitesoilmoist_table
    
    })
  })
  
  sitesmoist <- reactive({
    input$submit
    
    withProgress(message="Processing Data", value=1,{
    
    monitor_data <- mon_data()
    
    if (isolate(input$valref == "positive")) {
      monitor_data$depth <- monitor_data$depth * 1
    }
    else {
      monitor_data$depth <- monitor_data$depth * -1
    }

    # Replace values less than zero
    monitor_data$depth[monitor_data$depth < 0] <- 0
    
    
    monitor_data_daily <-
      aggregate(cbind(depth) ~ date, data = monitor_data, FUN = mean)
    
    # convert date column to date type
    monitor_data_daily_convert <-
      data.frame(
        as.Date(monitor_data_daily$date, format = "%m/%d/%Y"),
        if (isolate(input$units == "inches")) {
          round(monitor_data_daily$depth * 2.54)
        }
        else if (isolate(input$units ==
                         "meters")) {
          round(monitor_data_daily$depth * 100)
        }
        else if (isolate(input$units ==
                         "feet")) {
          round(monitor_data_daily$depth * 30.48)
        }
        else
          (round(monitor_data_daily$depth))
      )
    
    monitor_data_daily_convert[, 2] <-
      if (isolate(input$pipeb) != "" &
          isolate(input$pipel) != "") {
        as.numeric(isolate(input$pipel)) - as.numeric(isolate(input$pipeb)) - monitor_data_daily_convert[, 2]
      }
    else {
      monitor_data_daily_convert[, 2]
    }
    
    # rename columns to match NASIS
    names(monitor_data_daily_convert) <- list("obsdate", "soimoistdept")
    
    # Order by date
    monitor_data_daily_convert <-
      monitor_data_daily_convert[order(monitor_data_daily_convert$obsdate), ]
    
    # Reassign row names based on new ordering
    row.names(monitor_data_daily_convert) <-
      1:nrow(monitor_data_daily_convert)
    monitor_data_daily_convert$seqnum <-
      seq.int(nrow(monitor_data_daily_convert))
    
    # Reorder columns
    monitor_data_daily_convert <- monitor_data_daily_convert[, c(3, 1, 2)]
    
    # Rename data.frame
    sitesoilmoist_table <- monitor_data_daily_convert
    
    return(sitesoilmoist_table)
    
    })
  })
  
  output$iniplot <- renderPlotly({
    if (input$submit == 0) {
      return()
    }
    
    else if (is.null(isolate(input$mdatainput))) {
      return(NULL)
    }
    
    else
      ({
        
        withProgress(message="Processing Data", value=1,{
        
        s <- mon_data()
        # Plot all data
        rsmmd <-
          ggplot(s, aes(x = as.Date(date, format = "%m/%d/%Y"), y = depth)) + scale_colour_grey() +
          geom_line(cex = 0.5) + scale_x_date() +
          labs(x = "Date (year)", y = "Sensor Measurement", title = "Input Soil Moisture Monitoring Data") +
          theme(plot.margin=unit(c(1,1,1,1),"cm"))
        ggplotly(rsmmd)
        })
      })
  })
  
  finalsitesmoist <- reactive({
    input$submit
    
    withProgress(message="Processing Data", value=1,{
    
    sitesoilmoist_table <- sitesmoist()
    
    # Create bottom depth, for this sensor, the bottom depth is the lowest the sensor will register a reading
    sitesoilmoist_table$soimoistdepb <- as.integer(input$bottomdepth)
    
    # Create sensor depth, this is also the lowest the sensor will register a reading
    sitesoilmoist_table$soilmoistsensordepth <-
      as.numeric(input$sensordepth)
    
    # If the top depth, bottom depth and sensor depth are equal, leave the moisture status NA, otherwise assign a wet status.
    
    sitesoilmoist_table <-
      transform(
        sitesoilmoist_table,
        obssoimoiststat = ifelse(
          soimoistdept == soimoistdepb &
            soimoistdepb == soilmoistsensordepth,
          NA,
          "wet"
        )
      )
    
    # Add a usiteid column
    sitesoilmoist_table$usiteid <- input$usiteid
    
    # Add an observation date kind column
    sitesoilmoist_table$obsdatekind <- "actual site observation date"
    
    # Add a datacollecter column
    sitesoilmoist_table$datacollector <- input$office
    
    # Add ProjectName
    sitesoilmoist_table$projectname <- input$project
    
    # Add projectid
    sitesoilmoist_table$uprojectid <- input$projectid
    
    # Add sensorkind
    sitesoilmoist_table$soilmoistsensorkind <- input$sensor
    
    # Reorder columns
    sitesoilmoist_table <-
      sitesoilmoist_table[, c(7, 2, 8, 9, 10, 11, 3, 4, 5, 12, 6)]
    
    # Convert dates to characters
    sitesoilmoist_table$obsdate <-
      as.character(sitesoilmoist_table$obsdate)
    
    return(sitesoilmoist_table)
    })
  })
  
  output$exporttable <- DT::renderDataTable({
    if (input$submit == 0)
      
      return()
    
    else if (is.null(isolate(input$mdatainput)))
      return(NULL)
    
    shiny::validate(need(input$mdatainput, message = "Please Upload a Dataset."))
    
    sitesoiltable <- finalsitesmoist()
    
    sitesoiltable
  }, options = list(pageLength = 5, scrollX = "100%"))
  
  output$exportplot <- renderPlotly({
    if (input$submit == 0)
      
      return()
    
    else if (is.null(isolate(input$mdatainput)))
      return(NULL)
    
    withProgress(message="Processing Data", value=1,{
    
    sitesoiltable <- finalsitesmoist()
    
    # Plot all data
    sst <-
      ggplot(sitesoiltable, aes(x = as.Date(obsdate, format = "%Y-%m-%d"), y = soimoistdept)) + scale_colour_grey() +
      geom_line(cex = 0.5) + scale_y_reverse() + scale_x_date() +
      labs(x = "Date (year)", y = "Water Level", title = "Processed Soil Moisture Monitoring Data") +
      theme(plot.margin=unit(c(1,1,1,1),"cm"))
    ggplotly(sst)
    })
  })
  
  output$doubleplot <- renderPlotly({
    if (input$submit == 0) {
      return()
    }
    
    else if (is.null(isolate(input$mdatainput))) {
      return(NULL)
    }
    
    else
      ({
        
        withProgress(message="Processing Data", value=1,{ 
          
          sited <-sitedata()
          station_filter<-stationfilt()
          
          s <- mon_data()
          
          sitesoiltable <- finalsitesmoist()

    rsmmd <- plot_ly() %>%
      add_lines(x = as.Date(sitesoiltable$obsdate, format = "%Y-%m-%d"), y = sitesoiltable$soimoistdept, name = sited$site_id) %>%
      add_bars(x = as.Date(station_filter$date, format = "%m/%d/%Y"), y = station_filter$prcp/100, name = station_filter$id, yaxis="y2") %>%
      layout(
        title = "Water Table and Precipitation",
        yaxis2 = list(
          overlaying = "y",
          side = "right",
          title = "Precipitation (cm)",
          autorange= "reversed"),
        # xaxis2 = list(
        #   overlaying = "x",
        #   side = "top",
        #   title = "Date"),
        xaxis = list(title="Date"),
        yaxis = list(autorange = "reversed", title="Water Table Level (cm)"),
        margin = list(l=50,r=0,b=0,t=75,pad=0)
      )
  })
 })
})
  output$file <- downloadHandler(
    filename = function() {
      paste0("SiteSoilMoisture", Sys.Date(), ".xlsx")
    },
    content = function(file) {
      library(xlsx)
      
      sitesoilmoist_table <- finalsitesmoist()
      
      # Create an empty workbook
      wb <- createWorkbook()
      
      # Create a sheet within the workbook
      sheet <- createSheet(wb, sheetName = "SiteSoilMoisture")
      
      # Add monitoring data
      addDataFrame(
        sitesoilmoist_table,
        sheet,
        startRow = 3,
        startColumn = 3,
        row.names = F
      )
      
      # Create a data.frame with the name and version of the workbook required for NASIS
      wbnamecell <- data.frame("SiteSoilMoisture", "1.0")
      
      # Add the required NASIS data.frame to the workbook
      addDataFrame(
        wbnamecell,
        sheet,
        startRow = 1,
        startColumn = 1,
        col.names = F,
        row.names = F
      )
      
      # Save the workbook
      saveWorkbook(wb, file)
    }
  )
  
  output$sm_xlsfile <- renderUI({
    if (input$submit == 0)
      
      return()
    
    downloadButton("file", "Download")
    
  })
  
  output$downloadtext <- renderUI({
    if (input$submit == 0)
      return()

    shiny::validate(
      need(input$mdatainput, message = "No file(s) selected for processing.  Please Upload a Dataset.")
    )
    
    tags$p("Click  download to save processed file for NASIS upload -")
    
  })
}


shinyApp(ui = ui, server = server)