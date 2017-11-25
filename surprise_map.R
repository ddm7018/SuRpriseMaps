bb2state <- function(name, convert = F, strict = F){
  data(state)
  # state data doesn't include DC
  state = list()
  state[['name']] = c(state.name,"District Of Columbia")
  state[['abb']] = c(state.abb,"DC")
  
  if(convert) state[c(1,2)] = state[c(2,1)]
  
  single.a2s <- function(s){
    if(strict){
      is.in = tolower(state[['abb']]) %in% tolower(s)
      ifelse(any(is.in), state[['name']][is.in], NA)
    }else{
      # To check if input is in state full name or abb
      is.in = rapply(state, function(x) tolower(x) %in% tolower(s), how="list")
      state[['name']][is.in[[ifelse(any(is.in[['name']]), 'name', 'abb')]]]
    }
  }
  sapply(name, single.a2s)
}

setwd("~/Documents/Projects/SuRpriseMaps")
data <- read.csv("data.csv")
library(plotly)
df <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2011_us_ag_exports.csv")
#df$hover <- with(df, paste(state, '<br>', "Beef", beef, "Dairy", dairy, "<br>",
#                           "Fruits", total.fruits, "Veggies", total.veggies,
#                           "<br>", "Wheat", wheat, "Corn", corn))
# give state boundaries a white border
l <- list(color = toRGB("white"), width = 2)
# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)
for (ele in colnames(data)){
p <- plot_geo(data, locationmode = 'USA-states') %>%
  add_trace(
    z = eval(parse(text= paste0("data$",ele))), locations = as.character(bb2state(data$State, convert = T)),
    color = eval(parse(text= paste0("data$",ele))), colors = 'Reds'
  ) %>%
  colorbar(title = "Millions USD") %>%
  layout(
    title = ele,
    geo = g
  )
print(p)
}


