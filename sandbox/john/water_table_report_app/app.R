library(shinydashboard)

header<-dashboardHeader(
  title="Region 11 SDA Web Application", titleWidth= 450
    )

sidebar<-dashboardSidebar(
  sidebarMenu(
    menuItem("Water Table", selected=TRUE, icon=icon("tint"),startExpanded=TRUE,
             menuSubItem("Plot", tabName="WTPlots", selected=TRUE, icon=icon("area-chart")),
             menuSubItem("Data", tabName="Data", icon=icon("table")), 
      selectInput("wtchoice", "Choose a query method -", c("Mapunit Key"="mukey","National Mapunit Symbol"="nationalmusym","Mapunit Name"="muname"), selected="mukey",multiple=FALSE),
      textInput(
        inputId="inmukey",
        label="Enter query -",
        406339),
        actionButton("submukey", "Submit"),
        radioButtons(inputId="filltype", "Choose fill:", c("flooding","ponding")), br()
),
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
    menuItem("Project", icon=icon("stack-overflow"),
              menuSubItem("Report", tabName="projectreport", icon=icon("file-text")),
              textInput(
                inputId="projectreport",
                label="Enter Project Name", "SDJR - MLRA 111A - Ross silt loam, 0 to 2 percent slopes, frequently flooded"),
              actionButton("reportsubmit", "Submit"), br(),p()
              ),
    menuItem("Source Code", icon=icon("file-code-o"), href="https://github.com/ncss-tech/soil-pit/blob/master/sandbox/john/water_table_report_app/app.R"),
    menuItem("Help", tabName="help", icon=icon("question"))
 )
)

body<-dashboardBody(
  tabItems(
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
    tabItem(
      tabName="projectreport",
      verticalLayout(
        fluidRow(
            box(uiOutput("projectreport", inline=TRUE, container=span), width=12),
            box("This application was developed by John Hammerly and Stephen Roecker.", width=12))
        )),
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
            tabItem(tabName="help",
                    titlePanel("Help"),
                    fluidRow(
                    infoBox("About", box("This site is a set web applications which use",
                                                   a(href="https://www.r-project.org/", "R"), "to query information from",
                                                   a(href="https://sdmdataaccess.nrcs.usda.gov/", "Soil Data Access"),
                                                   "and assembles the data into a table or plots it graphically.",width=12),width=12, icon=icon("info"), color="yellow"),
                    infoBox("How to Use", box(
                      p("1.  Choose a data type by clicking on the corresponding menu item in the list on the sidebar to the left.  Currently there are 2 data types available to explore:  Water Table and Organic Matter."),
                      p("2.  Choose how to view the data.  You can view either a plot or data table."),
                      p("3.  Choose a query method.  You can query using any one of 3 methods:  Mapunit Key, National Mapunit Symbol, or Mapunit Name.  A choice list is provided."),
                      p("4.  Enter your query.  Be sure to enter the proper format.  Each of the previously mentioned methods has a unique set of criteria in order to return data without error."),
                      p("5.  Click the Submit button.  The query will not execute until this button is clicked."),width=12),width=12, icon=icon("life-ring"), color="purple"
                      )),
                    fluidRow(
                      infoBox("Water Table",
                            box("Use this data to learn more about the moisture the soil.  The plot shows depths at which different moisture status typically occur throughout the year.  You also have the option of viewing either flooding frequency or ponding frequency in the plot by clicking the radio buttons.", width=12),
                            width=12, icon=icon("tint"), color="blue"),
                      infoBox("Organic Matter",
                              box("Use this data to learn more about the organic matter in the soil.  The plot shows how organic matter changes with depth.  There are no additional options for viewing this data.", width=12),
                            icon=icon("leaf"), color="green", width=12),
                      infoBox("Source Code",
                              box("This menu item provides a link to a GitHub repository containing the computer code used in this application", width=12),
                              width=12, icon=icon("file-code-o"), color="red")
                      )
                    ),
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

ui <- dashboardPage(header, sidebar, body)


server <- function(input, output){
  
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
  
  output$muname<-renderText({    input$submukey
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$wtchoice),"='", isolate(input$inmukey), "'"), duplicates = TRUE)
    
    wtlevels$muname[1]})
  
  output$muname2<-renderText({   input$submukey 
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$wtchoice),"='", isolate(input$inmukey), "'"), duplicates = TRUE)
    
    wtlevels$muname[1]})
  
  output$muname3<-renderText({   input$omsubmukey 
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$omchoice),"='", isolate(input$ominmukey), "'"), duplicates = TRUE)
    
    wtlevels$muname[1]})
  
  output$muname4<-renderText({   input$omsubmukey 
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$omchoice),"='", isolate(input$ominmukey), "'"), duplicates = TRUE)
    
    wtlevels$muname[1]})
  
  output$shdatatab<- DT::renderDataTable({input$submukey
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$wtchoice),"='", isolate(input$inmukey), "'"), duplicates = TRUE)}, options = list(paging=FALSE))

  output$projectreport<-renderUI({includeMarkdown(knit("G:/workspace/report.Rmd"))})
    
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
shinyApp(ui = ui, server = server)