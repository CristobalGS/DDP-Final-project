#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
data("iris")

shinyServer(function(input, output) {
  
  output$acc <- renderText({
    
    index <- c(input$Sepal.Length,
               input$Sepal.Width, 
               input$Petal.Length,
               input$Petal.Width,
               TRUE)
    dataset <- iris[ , index]
    inTrain <- createDataPartition(y = iris$Species, p = 0.75, list = FALSE)
    training <- dataset[inTrain, ]
    test <- dataset[-inTrain, ]
    fit <- train(Species ~ ., data = training, method = "rf")
    pred <- predict(fit, test)
    confusionMatrix(pred, test$Species)$overall[1]
  })
  
})
