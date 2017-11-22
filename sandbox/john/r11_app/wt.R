library(shiny)
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

wt_selectInput <- function(id) {
  ns <- NS(id)
  
  tagList(
    selectInput(ns("choice"), label= "Choose a query method -", c("Mapunit Key"="mukey","National Mapunit Symbol"="nationalmusym","Mapunit Name"="muname"), selected="mukey",multiple=FALSE),
    textInput(ns("query"), label="Enter query -", 406339),
    actionButton(ns("submit"), "Submit"),
    radioButtons(ns("filltype"), "Choose fill:", c("flooding","ponding")), br()
    )
}
wt_tabItem <- function(id){
  ns <- NS(id)
  
  tagList(
            infoBox("Mapunit Name:",
                    uiOutput(ns("muname"), inline= TRUE, container=span),
                    width=12, icon=icon("map"), color="blue"),
            fluidRow(
              box(plotOutput(ns("result")), width=12)),
            box("This application was developed by John Hammerly and Stephen Roecker.", width=12)
  )
}

wt_tabItem2 <- function(id){
  ns<- NS(id)
  
  tagList(
    infoBox("Mapunit Name:",
            uiOutput(ns("muname2"), inline= TRUE, container=span), width=12, icon=icon("map"), color="blue"),
    fluidRow(
      box(tags$div(DT::dataTableOutput(ns("shdatatab")), style="width:100%; overflow-x: scroll"), width=12)
  )
  )
}

wt <- function(input, output, session){
  output$result <- renderPlot({ input$submit
    
    
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$choice),"='", isolate(input$query), "'"), duplicates = TRUE)
    
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
output$muname<-renderText({    input$submit

  wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$choice),"='", isolate(input$query), "'"), duplicates = TRUE)
  
  wtlevels$muname[1]})

output$muname2<-renderText({    input$submit
  
  wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$choice),"='", isolate(input$query), "'"), duplicates = TRUE)
  
  wtlevels$muname[1]})

output$shdatatab<- DT::renderDataTable({input$submit
  wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$choice),"='", isolate(input$query), "'"), duplicates = TRUE)}, options = list(paging=FALSE))
}