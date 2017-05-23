library(shinydashboard)

header<-dashboardHeader(
  title="Region 11 SDA Web Application", titleWidth= 450
    )

sidebar<-dashboardSidebar(
  sidebarMenu(
    menuItem("Water Table", selected=TRUE, icon=icon("tint"),startExpanded=TRUE,
             menuSubItem("Plot", tabName="WTPlots", selected=TRUE, icon=icon("area-chart")),
             menuSubItem("Data", tabName="Data", icon=icon("table")), 
      textInput(
        inputId="inmukey",
        label="Enter mukey to plot -",
        406339),actionButton("submukey", "Submit"), radioButtons(inputId="filltype", "Choose fill:", c("flooding","ponding")), br()
),
    menuItem("Organic Matter", tabName="OMPlots", icon=icon("leaf")),
    menuItem("Source Code", icon=icon("file-code-o"), href="https://github.com/ncss-tech/soil-pit/blob/master/sandbox/john/water_table_report_app/app.R"),
    menuItem("Help", tabName="help", icon=icon("question"))))

body<-dashboardBody(
  tabItems(
    tabItem(tabName="WTPlots", class="active",
            titlePanel("Water Table Plots"),
            verticalLayout(
              mainPanel(infoBox("Mapunit Name:", uiOutput("muname", inline= TRUE, container=span), width=12, icon=icon("map"), color="blue"),
                         fluidRow(
                           box(plotOutput("result"), width=12)),      box("This application was developed by John Hammerly and Stephen Roecker.", width=12)
                         
                ))),

              
              
            
            
    tabItem(tabName="Data",
            titlePanel("Water Table Data"),
            verticalLayout(
              mainPanel(infoBox("Mapunit Name:", uiOutput("muname2", inline= TRUE, container=span), width=12, icon=icon("map"), color="blue"),
                        fluidRow(
            dataTableOutput("shdatatab"),p("This application was developed by John Hammerly and Stephen Roecker."))))),
    tabItem(tabName="OMPlots", titlePanel("Organic Matter"), box("This Plot is currently under development.")),
            tabItem(tabName="help", titlePanel("Help"), box("This site is a set web applications which use",
                                                            a(href="https://www.r-project.org/", "R"), "to query information from",
                                                            a(href="https://sdmdataaccess.nrcs.usda.gov/", "Soil Data Access"),
                                                            "and assembles the data into a table or plots it graphically.",
                                                             width=12),
                    fluidRow(
                    infoBox("Water Table", "You will need to determine the mapunit key (mukey) of the mapunit of interest to view the data tables and plots.  Enter this number in the text input box in the side bar.  You also have the option of viewing either flooding frequency or ponding frequency in the plot by clicking the radio buttons.", width=6, icon=icon("tint"), color="blue"),
                    infoBox("Organic Matter", "This plot is currently still in development.", icon=icon("leaf"), color="green")))
    )
  
            
)

ui <- dashboardPage(header, sidebar, body)


server <- function(input, output){
  
  library(soilDB)
  library(dplyr)
  library(ggplot2)
  library(httr)
  library(jsonlite)
  
  output$result <- renderPlot({ input$submukey
    
    
    wtlevels <- get_cosoilmoist_from_SDA_db(WHERE = paste0("mukey = '", isolate(input$inmukey), "'"), duplicates = TRUE)
    
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
  
  output$muname<-renderText({    input$submukey
    wtlevels <- get_cosoilmoist_from_SDA_db(WHERE = paste0("mukey = '", isolate(input$inmukey), "'"), duplicates = TRUE)
    
    wtlevels$muname[1]})
  
  output$muname2<-renderText({   input$submukey 
    wtlevels <- get_cosoilmoist_from_SDA_db(WHERE = paste0("mukey = '", isolate(input$inmukey), "'"), duplicates = TRUE)
    
    wtlevels$muname[1]})
  
  output$shdatatab<- renderDataTable({input$submukey
    wtlevels <- get_cosoilmoist_from_SDA_db(WHERE = paste0("mukey = '", isolate(input$inmukey), "'"), duplicates = TRUE)}, options = list(pageLength=50))
  
  output$choicelist<- renderUI( 
    selectInput("comp","Choose component for interactive plot", {input$submukey
      wtlevels <- get_cosoilmoist_from_SDA_db(WHERE = paste0("mukey = '", isolate(input$inmukey), "'"), duplicates = TRUE)
      as.list(unique(wtlevels$compname))}))
  
  
  
}
shinyApp(ui = ui, server = server)