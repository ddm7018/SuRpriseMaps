library(shiny)
library(datasets)
library(ggplot2) # load ggplot
library(ggplot2)
# for melt
library(maps)


surprise_data <- read.csv("data.csv")
surprise_data <- surprise_data[-9,]
surprise_data <- surprise_data[1:50,]
# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  # Compute the forumla text in a reactive function since it is 
  # shared by the output$caption and output$mpgPlot functions
  formulaText <- reactive(function() {
    paste("mpg ~", input$variable)
  })
  
  # Return the formula text for printing as a caption

  
  # Generate a plot of the requested variable against mpg and only 
  # include outliers if requested
  # ggplot version
  
  output$mpgPlot <- reactivePlot(function() {
    # check for the input variable
    
    x = eval(parse(text = paste0("surprise_data$X",input$variable)))
    
    p <- ggplot(surprise_data, aes(map_id = tolower(State))) + geom_map(aes(fill = x), map = states_map) + expand_limits(x = states_map$long, y = states_map$lat)
    
    print(p)
  })
  
})
