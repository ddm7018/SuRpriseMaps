library(shiny)
library(leaflet)
library(rgdal)
setwd("~/Documents/Projects/SuRpriseMaps")
states   <- readOGR("cb_2017_us_state_20m/cb_2017_us_state_20m.shp", layer = "cb_2017_us_state_20m", GDAL1_integer64_policy = TRUE)
map_data <- readRDS("surprise_map_data.RDS")
states$region <- tolower(states$NAME)
combo <- merge(states,map_data, on = "region")

ui <- fluidPage(
  titlePanel("Hello Shiny!"),
  sidebarLayout(
    
    sidebarPanel(
      sliderInput("select_year",
                  label = "Select Year:",
                  min = 1981,
                  max = 1998,
                  value = 1981)
    ),
    
    mainPanel(
      leafletOutput("mymap")
    )
  )
  
  
  
)

server <- function(input, output, session) {

  output$mymap <- renderLeaflet({
    
    leaflet() %>% addTiles()
  })
  
  observe({
    binpal <- colorBin("Blues", states$X1981, 6, pretty = FALSE)
    eval(parse(text = paste0("leafletProxy('mymap', data = combo) %>%",
                             "addPolygons(color = '#444444', weight = 1, smoothFactor = 0.5, opacity = 1.0,",
                             "fillOpacity = 0.5, fillColor = ~binpal(X",input$select_year,"),",
                             "highlightOptions = highlightOptions(color = 'white', weight = 2, bringToFront = TRUE)) %>%",
                              " setView(lat = 41.489281, lng = -99.890151 , zoom = 4)")))
  })
  
  
}


shinyApp(ui, server)