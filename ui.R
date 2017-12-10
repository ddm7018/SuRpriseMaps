library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Surprise Maps"),
  
  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  sidebarPanel(
    selectInput("variable", "Variable:",
                list("1981" = "1981",
                     "1982" = "1982",
                     "1983" = "1983",
                     "1984" = "1984",
                     "1985" = "1985",
                     "1986" = "1986",
                     "1987" = "1987",
                     "1988" = "1988",
                     "1989" = "1989",
                     "1990" = "1990",
                     "1991" = "1991",
                     "1992" = "1992",
                     "1993" = "1993",
                     "1994" = "1994",
                     "1995" = "1995",
                     "1996" = "1996",
                     "1997" = "1997",
                     "1998" = "1998"
                     )),
    
    checkboxInput("outliers", "Show outliers", FALSE)
  ),
  
  # Show the caption and plot of the requested variable against mpg
  mainPanel(

    
    plotOutput("mpgPlot")
  )
))