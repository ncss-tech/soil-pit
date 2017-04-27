library(shiny)
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
              radioButtons(inputId="filltype", "Choose fill:", c("flooding","ponding")),
              submitButton(text="Apply Changes")),
                
             mainPanel(
               tabsetPanel(
                 type="tabs",tabPanel(
                   "Plot",tags$b("Mapunit Name:"),uiOutput("muname", container= tags$span),plotOutput("result"),
                                       p("This application was developed by John Hammerly and Stephen Roecker.")),
                              tabPanel("Data",tableOutput("table")
                                       )
                          )
                      )
                      )
  )

server <- function(input, output){
  output$result <- renderPlot({ input$search
    library(soilDB)
    library(httr)
    library(jsonlite)
    
    test <- get_cosoilmoist_from_SDA_db(c(input$inmukey))
    
    # remove depths with NA
    test <- subset(test, !is.na(dept_r))
    
    # plot annual water table
    library(ggplot2)
    
    if (input$filltype=="flooding") {ggplot(test) +
        geom_rect(aes(xmin = as.integer(month), xmax = as.integer(month) + 1,
                      ymin = 0, ymax = max(test$depb_r),
                      fill = flodfreqcl)) +
        geom_line(aes(x = as.integer(month), y = dept_r, 
                      lty = status), cex = 1) +
        geom_pointrange(aes(x = as.integer(month), 
                            ymin = dept_l, y = dept_r, ymax = dept_h)) +
        ylim(max(test$depb_r), 0) +
        ylab("depth (cm)") + scale_x_continuous(breaks = 1:12, labels = c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), name="Month") +
        facet_wrap(~ paste(compname, comppct_r, "pct", mukey, sep = "-"))}
    else if (input$filltype=="ponding") {ggplot(test) +
        geom_rect(aes(xmin = as.integer(month), xmax = as.integer(month) + 1,
                      ymin = 0, ymax = max(test$depb_r),
                      fill = pondfreqcl)) +
        geom_line(aes(x = as.integer(month), y = dept_r, 
                      lty = status), cex = 1) +
        geom_pointrange(aes(x = as.integer(month), 
                            ymin = dept_l, y = dept_r, ymax = dept_h)) +
        ylim(max(test$depb_r), 0) +
        ylab("depth (cm)")  +  scale_x_continuous(breaks = 1:12, labels = c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), name="Month") +
        facet_wrap(~ paste(compname, comppct_r, "pct", mukey, sep = "-"))}})
  output$table<-renderTable({    
    
    test <- get_cosoilmoist_from_SDA_db(input$inmukey)
    
    # remove depths with NA
    test <- subset(test, !is.na(dept_r))})
  output$muname<-renderText({    
    
    test <- get_cosoilmoist_from_SDA_db(input$inmukey)
    test$muname[1]})
}
shinyApp(ui = ui, server = server)