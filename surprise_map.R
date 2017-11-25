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
surpriseData <- data
startYear <- 1981

pMs = c(.333,.333,.333)
pMDs = c()
pDMs = c()

boomYear <- data$X1998 
bustYear <- data$X1981
for(i in 0:17) {
  year <- startYear + i
  yearMean <- mean(eval(parse(text=paste0("data$X",year))))
  yearSum  <- sum(eval(parse(text=paste0("data$X",year))))
  yearData <- eval(parse(text=paste0("data$X",year)))
  
  for(i in 1:nrow(data)){
    state <- eval(parse(text=paste0("data[i,]$X",year)))
    diff1 <- (state/yearSum) - (yearMean/yearSum)
    pDMs[1] = 1 - abs(diff1)
    
    diff2 =  (state/yearSum) - (boomYear[i]/yearSum)
    pDMs[1] = 1 - abs(diff2)
    
    diff3 =  (state/yearSum) - (bustYear[i]/yearSum)
    pDMs[1] = 1 - abs(diff3)
    
    pMDs[1] = pMs[1]*pDMs1
    pMDs[2] = pMs[2]*pDMs2
    pMDs[3] = pMs[3]*pDMs3
    
    kl = 0
    voteSum = 0;
    for(j in 1:length(pMDs)){
      kl = kl + (pMDs[j] * (log( pMDs[j] / pMs[0])/log(2)))
      voteSum  = voteSum + (diffs[j]*pMs[j])
      sumDiffs[j] = sumDiffs[j] + (abs(diffs[j]))
    }
    #supriseData assignment is incorrect!
    if(voteSum >= 0){
      surpriseData[prop][i] <- abs(kl)
    }
    else{
      surpriseData[prop][i] <- (-1* abs(kl))
    }
    
  }
  
  }

  
