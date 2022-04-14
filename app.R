library(shiny) 
library(leaflet) 
library(tigris)
library(leaflegend)
library(htmltools)
library(RColorBrewer)

cb_tn <- core_based_statistical_areas(year = 2018, cb = TRUE)
davidson.metro <- filter(cb_tn, grepl("Davidson", NAME))

n <- 9
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))

pal <- colorFactor(palette = col_vector, levels = ev_stations_davidson_$charger_type)
 
ev_stations_davidson_ <- 
  read_rds(paste0(repo_path, "/data/shiny/ev_stations_davidson_.rds")) 

ui <- fluidPage(leafletOutput("mymap"), p()) 
        
server <- function(input, output, session) { 

output$mymap <- renderLeaflet({ 
  leaflet(davidson.metro) %>% 
    addTiles() %>% 
    addMarkers(data = ev_stations_davidson_,
               ~longitude, ~latitude, popup = ~htmlEscape(charger_type),
               labelOptions = labelOptions(noHide = T, textOnly = FALSE)
               )
                                     
                     }
    )
  
}
                 
          
shinyApp(ui, server) 