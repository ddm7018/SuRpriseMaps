library(usmap)
library(ggplot2)

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
print(plot_geo(data, locationmode = 'USA-states') %>%
  add_trace(
    z = eval(parse(text=paste0("data$",ele))), locations = as.character(bb2state(data$State, convert = T)),
    color = eval(parse(text=paste0("data$",ele))), colors = 'Reds') %>%
  layout(
    title = ele,
    geo = g
  ))
}
surpriseData <- c()
startYear <- 1981

pMs = c(.333,.333,.333)
pMDs = c()
pDMs = c()
diffs = c()
sumDiffs = c()


overallSurprise <- matrix(17,50)
boomYear <- data$X1998 
bustYear <- data$X1981
for(i in 0:17) {
  val <- c()
  year <- startYear + i
  yearMean <- mean(eval(parse(text=paste0("data$X",year))))
  yearSum  <- sum(eval(parse(text=paste0("data$X",year))))
  yearData <- eval(parse(text=paste0("data$X",year)))
  
  for(prop in 1:nrow(data)){
    state <- eval(parse(text=paste0("data[prop,]$X",year)))
    diffs[1] <- (state/yearSum) - (yearMean/yearSum)
    pDMs[1] = 1 - abs(diffs[1])
    
    diffs[2] =  (state/yearSum) - (boomYear[prop]/yearSum)
    pDMs[2] = 1 - abs(diffs[2])
    
    diffs[3] =  (state/yearSum) - (bustYear[prop]/yearSum)
    pDMs[3] = 1 - abs(diffs[3])
    
    pMDs[1] = pMs[1]*pDMs[1]
    pMDs[2] = pMs[2]*pDMs[2]
    pMDs[3] = pMs[3]*pDMs[3]
    
    kl = 0
    voteSum = 0;
    for(j in 1:length(pMDs)){
      kl <-  kl + (pMDs[j] * (log( pMDs[j] / pMs[j]) / log(2)));
      voteSum  = voteSum + (diffs[j]*pMs[j])
      sumDiffs[j] = sumDiffs[j] + (abs(diffs[j]))
    }
    stateName <- data[prop,]$State
    stateAbb <- state.abb[grep(stateName, state.name)]
    if (stateName == 'District of Columbia'){
      stateAbb <- 'DC'
    }
    if (stateName == 'Puerto Rico'){
      stateAbb <- 'PC'
    }
   
    if(voteSum >= 0 ){
      val <- c(val,abs(kl))
      
    }
    else{
      val <- c(val, (-1* abs(kl)))
    }
    
  }
  overallSurprise[i] <- list(val)
  
}

for(val in 0:17){
eval(parse(text=paste0("statepop$X",val+1981," <- overallSurprise[",val+1,"][[1]][1:51]")))
}

map <- usmap::plot_usmap(data = statepop, values = "X1981") + 
  scale_fill_gradient2(low="navy", mid="white", high="red", 
                       midpoint=0, limits=range(-.01,.01)) +
  theme(legend.position = "right")
  

  
