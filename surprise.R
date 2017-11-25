for(prop in data$State){
  surpriseData$prop = c()
  for(i in 1:18) {
    surpriseData$prop <- append(surpriseData$prop, 0)
  }
}
pMs <- c(1/3,1/3,1/3)

uniform.surprise = c()
boom.surprise = c()
bust.surprise = c()

uniform.pM = c(pMs[0])
boom.pM = c(pMs[1])
bust.pM = c(pMs[2])

pDMs = c()
pMDs = c()
