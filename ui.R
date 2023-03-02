library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Text Predictor App"),
  h3("By Cristobal Gallegos S."),
  h2("\n"),
  h2("\n"),
  h4("This app will predict a proper word to follow the sentence you write.
         It will take about 10 seconds to load initially, afterwards it will work fast.
        You can find the project slide deck here: http://rpubs.com/Cris_GS/SwiftkeyCapAppP"),
  h2("\n"),
  h2("\n"),
  
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "text", placeholder = "Write some text here", value = NULL, label = NULL)
    ),
    
    mainPanel(
      h3("Your predicted next word:"),
       textOutput("predicted")
    )
  )
))
