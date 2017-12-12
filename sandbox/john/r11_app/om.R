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
library(plotly)

om_selectInput <- function(id) {
  ns <- NS(id)
  
tagList(

selectInput(ns("choice"), "Choose a query method -", c("Mapunit Key"="mukey","National Mapunit Symbol"="nationalmusym","Mapunit Name"="muname"), selected="mukey",multiple=FALSE),
textInput(ns("query"), label="Enter query -", 406338),
actionButton(ns("submit"), "Submit"), br(),p()
)
}

om_tabItem <- function(id){
  ns <- NS(id)
  
  tagList(
    infoBox("Mapunit Name:",
            uiOutput(ns("muname"), inline= TRUE, container=span),
            width=12, icon=icon("map"), color="blue"),
    fluidRow(
      box(plotlyOutput(ns("result")), width=12)),
    verticalLayout(
    box("This application was developed by John Hammerly and Stephen Roecker.", width=12)
  ))
}

om_tabItem2 <- function(id){
  ns<- NS(id)
  
  tagList(
    infoBox("Mapunit Name:",
            uiOutput(ns("muname2"), inline= TRUE, container=span), width=12, icon=icon("map"), color="blue"),
    fluidRow(
      box(tags$div(DT::dataTableOutput(ns("omdatatab")), style="width:100%; overflow-x: scroll"), width=12),
      box("This application was developed by John Hammerly and Stephen Roecker.", width=12))
  )
}

om <- function(input, output, session){
  
  #mapunit name render for organic matter plot tab
  output$muname<-renderText({   input$submit 
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$choice),"='", isolate(input$query), "'"), duplicates = TRUE)
    
    wtlevels$muname[1]})
  
  #mapunit name render for organic matter data tab
  output$muname2<-renderText({   input$submit 
    wtlevels <- get_cosoilmoist_from_SDA(WHERE = paste0(isolate(input$choice),"='", isolate(input$query), "'"), duplicates = TRUE)
    
    wtlevels$muname[1]})
 
  #render organic matter plot
  output$result<-renderPlotly({ input$submit
    # import soil data using the fetchSDA_component() function
    omdata = fetchSDA_component(WHERE = paste0(isolate(input$choice),"='", isolate(input$query), "'"), duplicates= TRUE)
    
    # Convert the data for plotting
    omdata_slice <- aqp::slice(omdata$spc, 0:200 ~ om_l + om_r + om_h)
    h = horizons(omdata_slice)
    h = merge(h, site(omdata$spc)[c("cokey", "compname", "comppct_r")], by = "cokey", all.x = TRUE)
    
    # plot clay content
    om_plot<-ggplot(h) +
      geom_line(aes(y = om_r, x = hzdept_r)) +
      geom_ribbon(aes(ymin = om_l, ymax = om_h, x = hzdept_r), alpha = 0.2) +
      xlim(200, 0) +
      xlab("depth (cm)") + ylab("organic matter (%)") +
      ggtitle("Depth Plots of Organic Matter by Soil Component") +
      facet_wrap(~ paste(compname, comppct_r, "%")) +
      coord_flip()
    ggplotly(om_plot)
    })
  
  output$omdatatab<- DT::renderDataTable({input$submit
    omdata <- fetchSDA_component(WHERE = paste0(isolate(input$choice),"='", isolate(input$query), "'"), duplicates= TRUE);    omdata_slice <- aqp::slice(omdata$spc, 0:200 ~ om_l + om_r + om_h)
    h = horizons(omdata_slice)
    h = merge(h, site(omdata$spc)[c("cokey", "compname", "comppct_r")], by = "cokey", all.x = TRUE)}, options = list(paging=FALSE))
  
  
   
}