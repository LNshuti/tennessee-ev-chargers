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

# cb_tn <- core_based_statistical_areas(year = 2018, cb = TRUE)
# davidson.metro <- filter(cb_tn, grepl("Davidson", NAME))

load("data/shiny/ev_stations_davidson_.rda")
load("data/shiny/davidson.metro.rda")

# n <- 9
# factorPal <- colorFactor('Set1', ev_stations_davidson_$charger_type)

getColor <-
  function(ev_stations_davidson_) {
    sapply(ev_stations_davidson_$charger_type, function(charger_type) {
      if(charger_type == "Airport"){"darkgreen"}
      else if(charger_type == "Apartment complex"){"gray"}
      else if(charger_type == "Car dealer"){"green"}
      else if(charger_type == "Grocery store"){"orange"}
      else if(charger_type == "Hospital"){"red"}
      else if(charger_type == "Metro"){"chocolate"}
      else if(charger_type == "Tesla"){"azure"}
      else if(charger_type == "Paid Parking"){"cornflowerblue"}
      else {"darkred"}
    })
  }

# 9 possible colors
pal <- c("red", "darkred", "lightred", "orange", "beige",
         "green", "darkgreen", "lightgreen","darkblue")

icons <- 
  awesomeIcons(
    icon = "ios-close", 
    lib = "ion",
    iconColor = "#FFFFFF",
    markerColor = pal[1:9]
    )

header<-dashboardHeader(title="Find EV Chargers Tennesse")

body<-dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("londonMap", height=400)
           ),
           box(width=NULL,
               dataTableOutput("boroughTable")
           )
    ),
    column(width=3,
           box(width=NULL, 
               uiOutput("yearSelect"),
               radioButtons("meas", "Measure",c("Mean"="Mean", "Median"="Median")),
               checkboxInput("city", "Include City of London?",TRUE)
               
           )
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)

ui <- fluidPage(leafletOutput("mymap"), tags$head(includeHTML(("google-analytics.html"))), p()) 
        
server <- function(input, output, session) { 
  
  output$mymap <- renderLeaflet({ 
    leaflet(davidson.metro) %>% 
      addTiles() %>% 
      addAwesomeMarkers(data = ev_stations_davidson_, ~longitude, ~latitude, 
                        icon = icons,
                        #label = ~charger_type,
                        popup = ~paste(street_address, "<br>",
                                       station_name, "<br>",
                                       "Number of Outlets = ", num_outlets)
                        ) 
    }
      )
}

shinyApp(ui, server) 
