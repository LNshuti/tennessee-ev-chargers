library(shiny)
library(shinydashboard)
library(DT)
library(leaflet)
library(tigris)
library(leaflegend)
library(htmltools)
library(RColorBrewer)
library(data.table)
library(tidyverse)

set.seed(1234)

# Function to map charger types to colors
getColor <- function(ev_stations_davidson_) {
  sapply(ev_stations_davidson_$charger_type, function(charger_type) {
    switch(charger_type,
           "Airport" = "darkgreen",
           "Apartment complex" = "gray",
           "Car dealer" = "green",
           "Grocery store" = "orange",
           "Hospital" = "red",
           "Metro" = "chocolate",
           "Tesla" = "azure",
           "Paid Parking" = "cornflowerblue",
           "darkred")
  })
}

# Create icon set for markers
icons <- awesomeIcons(
  icon = "ios-close",
  lib = "ion",
  iconColor = "#FFFFFF",
  markerColor = getColor(ev_stations_davidson_)
)

# UI Components
header <- dashboardHeader(title="Find EV Chargers Tennesse")
body <- dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("mymap", height=400)),
           box(width = NULL,
               dataTableOutput("boroughTable")),
           box(width = NULL,
               dataTableOutput("incomeTable")) # Added this line for the income table
    ),
    column(width = 3,
           box(width = NULL,
               uiOutput("yearSelect"),
               radioButtons("meas", "Measure", c("Mean" = "Mean", "Median" = "Median")),
               checkboxInput("city", "Include City of London?", TRUE)
           )
    )
  )
)

# Full dashboard layout
ui <- dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)

# Server logic
server <- function(input, output, session) {
  output$mymap <- renderLeaflet({
    leaflet(davidson.metro) %>%
      addTiles() %>%
      addAwesomeMarkers(
        data = ev_stations_davidson_,
        ~longitude,
        ~latitude,
        icon = icons,
        popup = ~paste(street_address, "<br>", station_name, "<br>", "Number of Outlets = ", num_outlets)
      )
  })

  # Placeholder for median income by county table. Replace with actual data.
  output$incomeTable <- renderDataTable({
    data.frame(davidson.metro)
  })
}

# Run the application
shinyApp(ui, server)
