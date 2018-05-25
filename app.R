
library(shiny)
library(shiny)
library(shinythemes)      # Bootswatch color themes for shiny
library(choroplethr)      # Creating Choropleth Maps in R
library(choroplethrMaps)  # Maps used by the choroplethr package

# load the data set from the choroplethrMaps package

setwd("~/Documents/Projects/SuRpriseMaps")
map_data <- readRDS("surprise_map_data.RDS")

ui <- fluidPage(title = 'My First App!',
                theme = shinythemes::shinytheme('flatly'),
                titlePanel("Surprise Maps"),
                sidebarLayout(
                  sidebarPanel(width = 3,
                               sliderInput("select_year",
                                           label = "Select Year:",
                                           min = 1981,
                                           max = 1998,
                                           value = 1981)
                               ),
                  
                  mainPanel(width = 9, 
                            tabsetPanel( 
                              tabPanel(title = 'Output Map', 
                                       plotOutput(outputId = "map")),
                              tabPanel(title = 'Data Table', 
                                       dataTableOutput(outputId = 'table'))))))

server <- function(input, output) {
  
  output$map <- renderPlot({
    
    year <- paste0("X",input$select_year)
    eval(parse(text = paste0("map_data$value <- map_data$",year)))
    
    state_choropleth(map_data,
                     num_colors = 9)
  })
  
  output$table <- renderDataTable({
    
    map_data
  })
}

shinyApp(ui,server)
