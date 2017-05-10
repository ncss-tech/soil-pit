ui <- fluidPage(
  titlePanel("Water Table Plots", windowTitle = "Water Table Plots"),
      p("This is a web application which uses R to query component month soil moisture data
      from Soil Data Access and plots it graphically.  You will need to determine the mapunit key
      (mukey) of the mapunit of interest to view the data.  You also have the option of viewing either
      flooding frequency or ponding frequency in the plot by clicking the radio buttons below."),
          sidebarLayout(
            sidebarPanel(
              textInput(
                inputId="inmukey",
                label="Enter mukey to plot",
                406339),
              uiOutput("choicelist"),
              p("This application was developed by John Hammerly and Stephen Roecker.")
          ),
             mainPanel(
               tabsetPanel(
                 type="tabs",
                 tabPanel("Plot",
                   fluidRow(
                      tags$b("Mapunit Name:"),uiOutput("muname", container= tags$span)),
                   fluidRow(tags$p()),
                   fluidRow(
                     column(width=1, radioButtons(inputId="filltype", "Choose fill:", c("flooding","ponding"))),
                     column(width=11, offset=0, plotOutput("result")))
                   ),
                  tabPanel("Interactive Plot",
                    fluidRow(
                      tags$b("Mapunit Name:"),uiOutput("muname2", container= tags$span)),
                    fluidRow(tags$p()),
                    fluidRow(
                      column(width=1, radioButtons(inputId="statustype", "Choose status:", c("Dry","Moist","Wet"), "Wet")),
                      column(width=11, offset=0, htmlOutput("gviswt")))
                   ),
                  tabPanel("Data", dataTableOutput("shdatatab"))
                    )
                   )
                  )
                 )

server <- function(input, output){
  
  output$result <- renderPlot({ 
    library(soilDB)
    library(dplyr)
    library(ggplot2)
    library(googleVis)

    wtlevels <- get_cosoilmoist_from_SDA_db(c(input$inmukey))

    if (input$filltype=="flooding") {ggplot(wtlevels, aes(x = as.integer(month), y = dept_r, lty = status))+
        geom_rect(aes(xmin = as.integer(month), xmax = as.integer(month)+
                        1, ymin = 0, ymax = max(wtlevels$depb_r),fill = flodfreqcl)) +
        geom_line(cex = 1) +
        geom_point() +
        geom_ribbon(aes(ymin = dept_l, ymax = dept_h), alpha = 0.2) +
        ylim(max(wtlevels$depb_r), 0) +xlab("month") + ylab("depth (cm)") +
        scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month")+
        facet_wrap(~ paste(compname, comppct_r, "pct", mukey, sep = "-")) +
        ggtitle("Water Table Levels from Component Soil Moisture Month Data")}
    
    else if (input$filltype=="ponding") {ggplot(wtlevels, aes(x = as.integer(month), y = dept_r, lty = status))+
        geom_rect(aes(xmin = as.integer(month), xmax = as.integer(month)+
                        1, ymin = 0, ymax = max(wtlevels$depb_r),fill = pondfreqcl)) +
        geom_line(cex = 1) +
        geom_point() +
        geom_ribbon(aes(ymin = dept_l, ymax = dept_h), alpha = 0.2) +
        ylim(max(wtlevels$depb_r), 0) +xlab("month") + ylab("depth (cm)") +
        scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month")+
        facet_wrap(~ paste(compname, comppct_r, "pct", mukey, sep = "-")) +
        ggtitle("Water Table Levels from Component Soil Moisture Month Data")}})

  output$muname<-renderText({    
    wtlevels <- get_cosoilmoist_from_SDA_db(input$inmukey)
    
    wtlevels$muname[1]})
  
  output$muname2<-renderText({    
    wtlevels <- get_cosoilmoist_from_SDA_db(input$inmukey)
    
    wtlevels$muname[1]})

  output$shdatatab<- renderDataTable({
    wtlevels <- get_cosoilmoist_from_SDA_db(input$inmukey)})
  
  output$choicelist<- renderUI(
    selectInput("comp","Choose component for interactive plot", {
      wtlevels <- get_cosoilmoist_from_SDA_db(input$inmukey); as.list(unique(wtlevels$compname))}))

  output$gviswt <- renderGvis({
    wtlevels <- get_cosoilmoist_from_SDA_db(input$inmukey)
    gvisComboChart(
      wtlevelsdf<-wtlevels %>%
        filter(status==input$statustype, compname==input$comp) %>%
        select(month,
               top_depth.interval.1=dept_l,
               top_depth=dept_r,
               top_depth.interval.2=dept_h,
               bottom_depth.interval.1=depb_l,
               bottom_depth=depb_r,
               bottom_depth.interval.2=depb_h),
                  xvar='month',
                  yvar=c('top_depth',
                         'top_depth.interval.1',
                         'top_depth.interval.2',
                         'bottom_depth',
                         'bottom_depth.interval.1',
                         'bottom_depth.interval.2'),
                  options=list(
                    title='Water Table Levels from Component Soil Moisture Month Data',
                    width="100%",
                    height="500px",
                    series="[{color:'blue'}]",
                    seriesType="line",
                    curveType="function",
                    intervals="{ 'style':'area' }",
                    vAxis="{title:'Depth (cm)', direction: '-1', maxValue:200}",
                    hAxis="{title:'Month', slantedText:1}"))
    })
  }
shinyApp(ui = ui, server = server)