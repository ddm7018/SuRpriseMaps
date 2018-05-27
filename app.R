library(shiny)
library(leaflet)
library(rgdal)
setwd("~/Documents/Projects/SuRpriseMaps")
states   <- readOGR("cb_2017_us_state_20m/cb_2017_us_state_20m.shp", layer = "cb_2017_us_state_20m", GDAL1_integer64_policy = TRUE)
map_data <- readRDS("surprise_map_data.RDS")
states$region <- tolower(states$NAME)
combo <- merge(states,map_data, on = "region")

ui <- fluidPage(
  titlePanel("Surprise Maps"),
  sidebarLayout(
    
    sidebarPanel(
      sliderInput("select_year",
                  label = "Select Year:",
                  min = 1981,
                  max = 1998,
                  value = 1981)
    ),
    
    mainPanel(
      leafletOutput("map")
    )
  )
  
  
  
)

server <- function(input, output, session) {

  output$map <- renderLeaflet({
    
    leaflet() %>% addTiles()
  })
  
  observe({
    binpal <- colorBin("Blues", states$X1981, 6, pretty = FALSE)
    eval(parse(text = paste0("leafletProxy('map') %>%",
                             "addPolygons(data = combo, layerId = ~GEOID, color = '#444444', weight = 1, smoothFactor = 0.5, opacity = 1.0,",
                             "fillOpacity = 0.5, fillColor = ~binpal(X",input$select_year,"),",
                             "highlightOptions = highlightOptions(color = 'white', weight = 2, bringToFront = TRUE)) %>%",
                              " setView(lat = 41.489281, lng = -99.890151 , zoom = 4)")))
  })
  
  observeEvent(input$map_shape_click, {
    click <- input$map_shape_click
      
    if(is.null(click))
      
      return()   
    
    
    #pulls lat and lon from shiny click event
    lat <- click$lat
    lng <- click$lng
    print(click)
    selectedCircle <- combo[combo$GEOID == click$id,]
    print(click$object_id)
    popupTagList <- tagList(
      tags$h4(input$select_year, eval(parse(text=paste0("selectedCircle$X",input$select_year))))
    )
    
    
    
    content <- as.character(popupTagList)    
    leafletProxy("map") %>% addPopups(lng, lat, content)
    
    
    
  })
  
}


shinyApp(ui, server)