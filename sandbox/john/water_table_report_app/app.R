ui <- fluidPage(
  titlePanel("Water Table Plots", windowTitle = "Water Table Plots"),
  p("This is a web application which uses R to query component month soil moisture data
    from Soil Data Access and plots it graphically.  You will need to determine the mapunit key
    (mukey) of the mapunit of interest to view the data on the plot tab.  You also have the option of viewing either
    flooding frequency or ponding frequency in the plot by clicking the radio buttons below.  
    To view the data table used to create the graphic, select the data tab."),
  sidebarLayout(
    sidebarPanel(width=2,
    
      textInput(
        inputId="inmukey",
        label="Enter mukey to plot -",
        406339), actionButton("submukey", "Submit"), br(), p(), tags$b("CURRENT SELECTION:"), br(), p(), tags$b("Mapunit Name - "), br(), uiOutput("muname", container= tags$span), br(), p(), radioButtons(inputId="filltype", "Choose fill:", c("flooding","ponding"))),

      mainPanel(tabsetPanel(
        type="pills",
        tabPanel("Plot",
                 fluidRow(
                   plotOutput("result")),      p("This application was developed by John Hammerly and Stephen Roecker.")
                   
        ),
        tabPanel("Data", dataTableOutput("shdatatab"),p("This application was developed by John Hammerly and Stephen Roecker."))
      )
      )
  )
  )

server <- function(input, output){
  
  library(soilDB)
  library(dplyr)
  library(ggplot2)
  library(googleVis)
  
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