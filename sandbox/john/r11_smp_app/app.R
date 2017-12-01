library(shinydashboard)
library(shiny)

header<-dashboardHeader(
  title="Soil Moisture Load Data App")

sidebar<-dashboardSidebar(
  sidebarMenu(id="tabs",
              menuItem("Home", tabName="Home", selected=TRUE, icon=icon("home")),
              menuItem("Instructions", tabName="Instructions", icon=icon("info")),
              menuItem("Soil Moisture Data", tabName="loaddata", icon=icon("map-pin"))

  )
)

body<-dashboardBody(
  
  #styling for the progress bar position
  tags$style(type="text/css", ".shiny-notification{position: fixed; top:33%;left:33%;right:33%;}"),
  
  tabItems(
    #Home tab
    tabItem(tabName="Home",
            titlePanel("Welcome to the Soil Moisture Data Processing App"),
            verticalLayout(
              infoBox("About this App", "The Soil Moisture Data Processing App is a tool for USDA soil scientists to process soil moisture monitoring data for upload into NASIS.", width=12, icon=icon("globe"), color="blue"),
              box(p(tags$b("Instructions for Using the Soil Moisture Data Load App")),
                  p("Before you get started working with this app, you should first consider the following assumptions taken in creating this app:"),

                  p("1. The monitoring data is an accurate representation of a wet soil moisture condition"),
                    p("2. Data collection has completed and it is ready to archive in NASIS and analyzed in R"),
                      p("3. NASIS is installed and you have sufficient privileges to edit the database"),
                    
                  p("If your situation does not meet the assumptions above, you will need to tailor the instructions to fit your needs.  This could involve additional data manipulations in Excel or R, performing ground truth activities, and/or changing functions and before loading into Excel or NASIS."),
                    
                  p("The instructions were tested and confirmed functional using NASIS data model 7.3.3."),

                  p("This Application is viewed best in a browser such as Google Chrome or Mozilla Firefox"), width=12),
              box("This application was developed by John Hammerly.", width=12)
            )),
    
    tabItem(tabName="Instructions",
            titlePanel("Instructions for Processing Soil Monitoring Data"),
            verticalLayout(
              infoBox("Process Soil Moisture Monitoring data for upload to NASIS", "This app is designed to process soil moisture monitoring data and properly format it for upload into NASIS.", width=12, icon=icon("info"), color="green"),
              box(p(tags$b("Instructions for Using the Soil Moisture Data Load App")),
                  p("There is a multitude of variability in monitoring data throughout
                    the soil science discipline.  Differences in installation, instrumentation, 
                    and collection frequency are just a few examples.  This document provides 
                    guidance for loading monitoring data into the National Soil Information 
                    System (NASIS).  Although there are many different ways to accomplish this task,
                    the repeatability and versatility of R works well for this purpose."))   
              )),    
    
    
    #Analysis Report tab   
    tabItem(tabName="loaddata", class="active",
            titlePanel("Soil Moisture Data"),
            verticalLayout(
              fluidRow(
                box(uiOutput("sm_inputs"),
                    uiOutput("sm_office"),
                    uiOutput("sm_usiteid"),
                    uiOutput("sm_project"),
                    uiOutput("sm_projectid"),
                    uiOutput("sm_sensor"),
                    uiOutput("sm_bottomdepth"),
                    uiOutput("sm_sensordepth"),
                    actionButton("submit","Submit"),
                 
                    status = "primary", title="Inputs", solidHeader=TRUE, collapsible=TRUE, width=6),
                box(DT::dataTableOutput("mon_data"), status="primary", title="Monitoring Data", solidHeader=TRUE, collapsible=TRUE, width=6),
                box(p("Click  download to save processed file for NASIS upload -"), uiOutput("sm_xlsfile"),  status = "primary", title="Download File", solidHeader=TRUE, collapsible=TRUE, width=6),
                box("This application was developed by John Hammerly.", width=12)
              ))
    )
  )
)

ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session){
  
  output$sm_inputs <-renderUI({
    
    fileInput("mdatainput", "Monitoring Data File", multiple=TRUE, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv"), buttonLabel="Browse...", placeholder="No file selected")
    
  })
    
  output$sm_office <- renderUI({
    
    textInput("office", "Data Collector", value="", placeholder="11-ATL")
    
  })
  
  output$sm_usiteid <- renderUI({
    
    textInput("usiteid", "User Site ID", value="", placeholder="2013IA001001")
    
  })
  
  output$sm_project <- renderUI({
    
    textInput("project", "Project Name", value="", placeholder="DSP - MLRA 108D - Shelby, clay loam")
    
  })
  
  output$sm_projectid <- renderUI({
    
    textInput("projectid", "User Project ID", value="", placeholder="201711ATL999")
    
  })
  
  output$sm_sensor <- renderUI({
    
    selectInput("sensor", "Sensor Type", selected="", choices=c("",
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
                                                                 "global water data logger wl15x-015"), multiple=FALSE)
    
  })
  
  output$sm_bottomdepth <- renderUI({
    
    textInput("bottomdepth", "Bottom Depth", value="", placeholder="210")
    
  })
  
  output$sm_sensordepth <- renderUI({
    
    textInput("sensordepth", "Sensor Depth", value="", placeholder="210")
    
  })

  
  mon_data<-reactive({
    
    input$submit
    
    if(is.null(isolate(input$mdatainput)))
      return(NULL)
    
    mdata<-isolate(input$mdatainput)
    
    
    monitor_data<-read.csv(isolate(mdata$datapath), header=FALSE, skip=1, #skip the rows without observation data 
                           col.names=c("date","time","depth","units"), as.is=TRUE) #assign column names
    return(monitor_data)
  })
  
  output$mon_data<- DT::renderDataTable({ monitor_data<-mon_data()
  
  })
  output$daily_data<-DT::renderDataTable({
    monitor_data<-mon_data()
    
  monitor_data_daily<-aggregate(cbind(depth)~date,data=monitor_data,FUN=mean)
  
  # convert date column to date type
  monitor_data_daily_convert<-data.frame(as.Date(monitor_data_daily$date, format="%m/%d/%Y"), round(monitor_data_daily$depth*-1*2.54)) # convert depths to positive centimeters
  
  # rename columns to match NASIS
  names(monitor_data_daily_convert)<-list("obsdate","soimoistdept")
  
  # Replace values less than zero
  monitor_data_daily_convert$soimoistdept[monitor_data_daily_convert$soimoistdept<0]<-0
  
  # Order by date
  monitor_data_daily_convert<-monitor_data_daily_convert[order(monitor_data_daily_convert$obsdate),]
  
  # Reassign row names based on new ordering
  row.names(monitor_data_daily_convert) <- 1:nrow(monitor_data_daily_convert)
  monitor_data_daily_convert$seqnum<-seq.int(nrow(monitor_data_daily_convert))
  
  # Reorder columns
  monitor_data_daily_convert<-monitor_data_daily_convert[,c(3,1,2)]
  
  # Rename data.frame
  sitesoilmoist_table<-monitor_data_daily_convert
  
  sitesoilmoist_table
})
  
  sitesmoist<-reactive({
  
  monitor_data<-mon_data()
  
  monitor_data_daily<-aggregate(cbind(depth)~date,data=monitor_data,FUN=mean)
  
  # convert date column to date type
  monitor_data_daily_convert<-data.frame(as.Date(monitor_data_daily$date, format="%m/%d/%Y"), round(monitor_data_daily$depth*-1*2.54)) # convert depths to positive centimeters
  
  # rename columns to match NASIS
  names(monitor_data_daily_convert)<-list("obsdate","soimoistdept")
  
  # Replace values less than zero
  monitor_data_daily_convert$soimoistdept[monitor_data_daily_convert$soimoistdept<0]<-0
  
  # Order by date
  monitor_data_daily_convert<-monitor_data_daily_convert[order(monitor_data_daily_convert$obsdate),]
  
  # Reassign row names based on new ordering
  row.names(monitor_data_daily_convert) <- 1:nrow(monitor_data_daily_convert)
  monitor_data_daily_convert$seqnum<-seq.int(nrow(monitor_data_daily_convert))
  
  # Reorder columns
  monitor_data_daily_convert<-monitor_data_daily_convert[,c(3,1,2)]
  
  # Rename data.frame
  sitesoilmoist_table<-monitor_data_daily_convert
  
  return(sitesoilmoist_table)
  })
  
  finalsitesmoist<-reactive({
  
  sitesoilmoist_table<-sitesmoist()
  
  # Create bottom depth, for this sensor, the bottom depth is the lowest the sensor will register a reading
  sitesoilmoist_table$soimoistdepb<-as.integer(input$bottomdepth)
  
  # Create sensor depth, this is also the lowest the sensor will register a reading
  sitesoilmoist_table$soilmoistsensordepth<-as.numeric(input$sensordepth)
  
  # If the top depth, bottom depth and sensor depth are equal, leave the moisture status NA, otherwise assign a wet status.
  
  sitesoilmoist_table<- transform(sitesoilmoist_table, obssoimoiststat=ifelse(soimoistdept==soimoistdepb & soimoistdepb==soilmoistsensordepth, NA, "wet"))
  
  # Add a usiteid column
  sitesoilmoist_table$usiteid<-input$usiteid
  
  # Add an observation date kind column
  sitesoilmoist_table$obsdatekind<-"actual site observation date"
  
  # Add a datacollecter column
  sitesoilmoist_table$datacollector<-input$office
  
  # Add ProjectName
  sitesoilmoist_table$projectname<-input$project
  
  # Add projectid
  sitesoilmoist_table$uprojectid<-input$projectid
  
  # Add sensorkind
  sitesoilmoist_table$soilmoistsensorkind<-input$sensor
  
  # Reorder columns
  sitesoilmoist_table<-sitesoilmoist_table[,c(7,2,8,9,10,11,3,4,5,12,6)]
  
  # Convert dates to characters
  sitesoilmoist_table$obsdate<-as.character(sitesoilmoist_table$obsdate)
  
  return(sitesoilmoist_table)
  
  })
  
  output$exporttable<-DT::renderDataTable({
    
   sitesoiltable<- finalsitesmoist()
   
   sitesoiltable
  })
  
output$file<-downloadHandler(
  
  filename= function() {
    paste0("SiteSoilMoisture", Sys.Date(),".xlsx")
  },
  content= function(file) { 
  
  library(xlsx)
  
  sitesoilmoist_table<-finalsitesmoist()
  
  # Create an empty workbook
  wb<-createWorkbook()
  
  # Create a sheet within the workbook
  sheet<-createSheet(wb, sheetName="SiteSoilMoisture")
  
  # Add monitoring data
  addDataFrame(sitesoilmoist_table, sheet, startRow=3, startColumn=3, row.names=F)
  
  # Create a data.frame with the name and version of the workbook required for NASIS
  wbnamecell<-data.frame("SiteSoilMoisture","1.0")
  
  # Add the required NASIS data.frame to the workbook
  addDataFrame(wbnamecell, sheet, startRow=1, startColumn=1, col.names=F,row.names=F)
  
  # Save the workbook
  saveWorkbook(wb, file)
  })


output$sm_xlsfile<-renderUI({
  
  downloadButton("file", "Download")
  
})

}

shinyApp(ui = ui, server = server)