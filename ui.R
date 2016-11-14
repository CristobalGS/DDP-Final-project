#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Choose features to predict"),
  
  sidebarLayout(
    sidebarPanel(
      h3("This app buils up a predictive random forest model using the iris dataset. 
         It builds the model on a trainting set and predict the species using the
         test set and the below features you choose as predcitors. Prediction accuracy
         is then displayed."),
       checkboxInput("Sepal.Length", "Include sepal length", TRUE),
       checkboxInput("Sepal.Width", "Include sepal width", FALSE),
       checkboxInput("Petal.Length", "Include petal length", FALSE),
       checkboxInput("Petal.Width", "Include petal width", FALSE)
    ),
    
    mainPanel(
       h3("Prediction Accuracy:"),
       textOutput("acc")
    )
  )
))
