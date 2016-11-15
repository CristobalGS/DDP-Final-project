library(shiny)
library(caret)
data("mtcars")
ss_mtcars <- mtcars[ , c(1, 2, 3, 4, 6)]

shinyServer(function(input, output) {
  
  output$acc <- renderText({
    
    index <- c(TRUE, 
               input$cyl,
               input$disp, 
               input$hp,
               input$wt)
    dataset <- ss_mtcars[ , index]
    fit <- train(mpg ~ ., data = dataset, method = "lm")
    summary(fit)$r.squared
    
  })
  
})
