library(shiny)
library(caret)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Choose features to include in the model"),
  
  sidebarLayout(
    sidebarPanel(
      h3("This app buils up a linear model using part of the mtcars dataset. 
         It builds the model using the features you choose as predcitors. Adjustment of the model
         is then displayed."),
       checkboxInput("cyl", "Include number of cylinders", TRUE),
       checkboxInput("disp", "Include disp", FALSE),
       checkboxInput("hp", "Include hourse power", FALSE),
       checkboxInput("wt", "Include weight", FALSE)
    ),
    
    mainPanel(
       h3("R-squared:"),
       textOutput("acc")
    )
  )
))
