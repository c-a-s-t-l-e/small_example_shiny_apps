#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(crosstalk)
# library(leaflet)
library(DT)
library(plotly)
library(bslib)
library(tidyverse)
library(pdftools)

# Wrap data frame in SharedData
# Use SharedData like a dataframe with Crosstalk-enabled widgets

# sd <- SharedData$new(quakes[sample(nrow(quakes), 100),])

# patient_data <- read_csv("fake_patient_data.csv")
# patient_data$Gender <- factor(patient_data$Gender)
# patient_data$BloodType <- factor(patient_data$BloodType)
# patient_data$Allergies <- factor(patient_data$Allergies)
# patient_data$Diagnosis <- factor(patient_data$Diagnosis)

# Define a function to create a SharedData object from a dataset
createSharedData <- function(data) {
  # Check if the input is a data frame
  if (!is.data.frame(data)) {
    stop("Input must be a data frame.")
  }
  
  # Create and return a SharedData object
  sd <- SharedData$new(data)
  return(sd)
}

ui <- fluidPage(
  tags$head(
    tags$link(href = "/styles.css", rel = "stylesheet"),
    tags$link(href = "https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css", rel = "stylesheet"),
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"),
    tags$script(src = "https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"),
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/atom-one-dark.min.css"),
    tags$script(src = "https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"),
    tags$link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css")
  ),
  tags$div(id = "toolbar-container",
           tags$span(class = "ql-formats",
                     tags$select(class = "ql-font"),
                     tags$select(class = "ql-size")
           ),
           tags$span(class = "ql-formats",
                     tags$button(class = "ql-bold"),
                     tags$button(class = "ql-italic"),
                     tags$button(class = "ql-underline"),
                     tags$button(class = "ql-strike")
           ),
           tags$span(class = "ql-formats",
                     tags$select(class = "ql-color"),
                     tags$select(class = "ql-background")
           ),
           tags$span(class = "ql-formats",
                     tags$button(class = "ql-script", value = "sub"),
                     tags$button(class = "ql-script", value = "super")
           ),
           tags$span(class = "ql-formats",
                     tags$button(class = "ql-header", value = "1"),
                     tags$button(class = "ql-header", value = "2"),
                     tags$button(class = "ql-blockquote"),
                     tags$button(class = "ql-code-block")
           ),
           tags$span(class = "ql-formats",
                     tags$button(class = "ql-list", value = "ordered"),
                     tags$button(class = "ql-list", value = "bullet"),
                     tags$button(class = "ql-indent", value = "-1"),
                     tags$button(class = "ql-indent", value = "+1")
           ),
           tags$span(class = "ql-formats",
                     tags$button(class = "ql-direction", value = "rtl"),
                     tags$select(class = "ql-align")
           ),
           tags$span(class = "ql-formats",
                     tags$button(class = "ql-link"),
                     tags$button(class = "ql-image"),
                     tags$button(class = "ql-video"),
                     tags$button(class = "ql-formula")
           ),
           tags$span(class = "ql-formats",
                     tags$button(class = "ql-clean")
           )
  ),
  tags$div(id = "editor"),
  tags$script(
    "const quill = new Quill('#editor', {",
    "  modules: {",
    "    syntax: true,",
    "    toolbar: '#toolbar-container',",
    "  },",
    "  placeholder: 'Compose an epic...',",
    "  theme: 'snow',",
    "});"
  ),
  downloadButton("savePdf", "Save as PDF"),
  downloadButton("downloadWord", "Save as Word Document")
)

# ui <- page_sidebar(
#   title = "Data Viewer",
#   sidebar = sidebar(
#     title = "Filters",
#   ),
#   tags$script(src = "quill.js")
  # bscols(
  #   datatable(createSharedData(patient_data), filter="top")
  # )

#)
  
  
  
  
  # shared_quakes <- SharedData$new(quakes[sample(nrow(quakes), 100),]),
  #   leaflet(shared_quakes, width = "100%", height = 300) %>%
  #     addTiles() %>%
  #     addMarkers()
# )