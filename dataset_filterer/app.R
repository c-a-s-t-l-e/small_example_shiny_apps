#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
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
library(shinyWidgets)

# Wrap data frame in SharedData
# Use SharedData like a dataframe with Crosstalk-enabled widgets

# sd <- SharedData$new(quakes[sample(nrow(quakes), 100),])

insurance_data <- read_csv("fake_insurance_data.csv")
patient_data <- read_csv("fake_patient_data.csv")
appointment_data <- read_csv("fake_appointment_data.csv")
patient_data$Gender <- factor(patient_data$Gender)
patient_data$BloodType <- factor(patient_data$BloodType)
patient_data$Allergies <- factor(patient_data$Allergies)
patient_data$Diagnosis <- factor(patient_data$Diagnosis)

entity_options <- c("Patient", "Insurance", "Appointments")

# Define a function to create a SharedData object from a dataset
create_Shared_Data <- function(data) {
  # Check if the input is a data frame
  if (!is.data.frame(data)) {
    stop("Input must be a data frame.")
  }
  
  # Create and return a SharedData object
  sd <- SharedData$new(data)
  return(sd)
}

# Define a function to create a datatable object
create_Filtered_Datatable <- function(data) {
  datatable(create_Shared_Data(data), filter="top")
}

 ui <- page_sidebar(
   title = "Data Viewer",
   sidebar = sidebar(
     title = "Filters",
     pickerInput(
       inputId = "id", 
       label = "Select Entity:", 
       choices = entity_options, 
       options = pickerOptions(
         actionsBox = TRUE, 
         size = 10,
         selectedTextFormat = "count > 3"
       ), 
       multiple = FALSE
     ),
     ),
 bscols(
   create_Filtered_Datatable(patient_data)
)

)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$Table <- renderDT(
      create_Filtered_Datatable(input$id)
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
