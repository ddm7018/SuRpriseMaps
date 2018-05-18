library(ggplot2)
crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
library(reshape2) # for melt
crimesm <- melt(crimes, id = 1)
library(maps)


surprise_data <- read.csv("data.csv")
surprise_data <- surprise_data[-9,]
surprise_data <- surprise_data[1:50,]


states <- map_data("state")

ggplot(surprise_data, aes(map_id = tolower(State))) + geom_map(aes(fill = surprise_data$X1987), map = states_map) + expand_limits(x = states_map$long, y = states_map$lat)
