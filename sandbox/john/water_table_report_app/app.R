library(shiny)
ui <- fluidPage(titlePanel("Water Table Plots", windowTitle = "Water Table Plots"),
  numericInput(inputId="inmukey",
              label="Enter mukey to plot", 406339
              ),
  radioButtons(inputId="filltype", "Choose fill:", c("flooding","ponding")),
  plotOutput("result")

)

server <- function(input, output){
  output$result <- renderPlot({
    library(soilDB)
    library(httr)
    library(jsonlite)
    
    test <- get_cosoimoist_from_SDA_db(input$inmukey)
    
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
      xlab("month") + ylab("depth (cm)") +
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
          xlab("month") + ylab("depth (cm)")  +
          facet_wrap(~ paste(compname, comppct_r, "pct", mukey, sep = "-"))}

    })
  }
shinyApp(ui = ui, server = server)