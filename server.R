library(ggplot2)
library(RWeka)
library(tm)
library(openNLP)
library(shiny)
library(data.table)
library(SnowballC)

#############################################################################################################################################
unigramDF <- fread("data/unigramDF.csv")
bigramDF <- fread("data/bigramDF.csv")
trigramDF <- fread("data/trigramDF.csv")
quadrigramDF <- fread("data/quadrigramDF.csv")

unigramDF$term <- as.character(unigramDF$term)
bigramDF$term <- as.character(bigramDF$term)
trigramDF$term <- as.character(trigramDF$term)
quadrigramDF$term <- as.character(quadrigramDF$term)

Qw123 <- readRDS("data/Qindex.Robj")
Tw12 <- readRDS("data/Tindex.Robj")
Bw1 <- readRDS("data/Bindex.Robj")

###################################################################################################################################

shinyServer(function(input, output) {
   
  output$predicted <- renderText({
    
    input <- input$text
    
    if(input != ""){
      sample <- Corpus(VectorSource(input))

      removeSpecialChars <- function(x) gsub("[^a-zA-Z0-9 ]", "", x)

      cleanSample <- tm_map(sample, removePunctuation)
      cleanSample <- tm_map(cleanSample, removeNumbers)
      cleanSample <- tm_map(cleanSample, stripWhitespace)
      cleanSample <- tm_map(cleanSample, content_transformer(tolower))
      cleanSample <- tm_map(cleanSample, removeSpecialChars)

      cleanSample1 <- cleanSample[[1]]

      nWords <- sum(sapply(gregexpr("\\S+", cleanSample1), length))
      if(nWords >= 3){
        w1 <- unlist(lapply(strsplit(cleanSample1," "), function(x) x[nWords - 2]))
        w2 <- unlist(lapply(strsplit(cleanSample1," "), function(x) x[nWords - 1]))
        w3 <- unlist(lapply(strsplit(cleanSample1," "), function(x) x[nWords]))
        cleanInput <- paste(w1, w2, w3)
      } else if (nWords == 2){
        w1 <- unlist(lapply(strsplit(cleanSample1," "), function(x) x[nWords - 1]))
        w2 <- unlist(lapply(strsplit(cleanSample1," "), function(x) x[nWords]))
        cleanInput <- paste(w1, w2)
      } else if (nWords == 1){
        w1 <- unlist(lapply(strsplit(cleanSample1," "), function(x) x[nWords]))
        cleanInput <- w1
      }

      text <- cleanInput
      nText <- sum(sapply(gregexpr("\\S+", text), length))
      w1 <- unlist(lapply(strsplit(text," "), function(x) x[1]))
      w2 <- unlist(lapply(strsplit(text," "), function(x) x[2]))
      w3 <- unlist(lapply(strsplit(text," "), function(x) x[3]))

      if(nText == 3){
        wordIndex <- Qw123 == text
        if(sum(wordIndex) > 0){
          wordF <- quadrigramDF[wordIndex, ]
          wordF <- wordF[order(wordF$ProbQG, decreasing = TRUE), ]
          predicted <- as.character(wordF[1, 1])
          predicted <- unlist(lapply(strsplit(predicted," "), function(x) x[4]))
          predicted
        } else {
          text <- paste(w2, w3)
          wordIndex <- Tw12 == text
          if(sum(wordIndex) > 0){
            wordF <- trigramDF[wordIndex, ]
            wordF <- wordF[order(wordF$ProbTG, decreasing = TRUE), ]
            predicted <- as.character(wordF[1, 1])
            predicted <- unlist(lapply(strsplit(predicted," "), function(x) x[3]))
            predicted
          } else {
            text <- w3
            wordIndex <- Bw1 == text
            if(sum(wordIndex) > 0){
              wordF <- bigramDF[wordIndex, ]
              wordF <- wordF[order(wordF$ProbBG, decreasing = TRUE), ]
              predicted <- as.character(wordF[1, 1])
              predicted <- unlist(lapply(strsplit(predicted," "), function(x) x[2]))
              predicted
            } else {
              unigramDF <- unigramDF[order(unigramDF$PcontB, decreasing = TRUE), ]
              as.character(unigramDF[1, 1])
            }
          }
        }
      } else if (nText == 2){
        wordIndex <- Tw12 == text
        if(sum(wordIndex) > 0){
          wordF <- trigramDF[wordIndex, ]
          wordF <- wordF[order(wordF$ProbTG, decreasing = TRUE), ]
          predicted <- as.character(wordF[1, 1])
          predicted <- unlist(lapply(strsplit(predicted," "), function(x) x[3]))
          predicted
        } else {
          text <- w3
          wordIndex <- Bw1 == text
          if(sum(wordIndex) > 0){
            wordF <- bigramDF[wordIndex, ]
            wordF <- wordF[order(wordF$ProbBG, decreasing = TRUE), ]
            predicted <- as.character(wordF[1, 1])
            predicted <- unlist(lapply(strsplit(predicted," "), function(x) x[2]))
            predicted
          } else {
            unigramDF <- unigramDF[order(unigramDF$PcontB, decreasing = TRUE), ]
            as.character(unigramDF[1, 1])
          }
        }
      } else if(nText == 1){
        wordIndex <- Bw1 == text
        if(sum(wordIndex) > 0){
          wordF <- bigramDF[wordIndex, ]
          wordF <- wordF[order(wordF$ProbBG, decreasing = TRUE), ]
          predicted <- as.character(wordF[1, 1])
          predicted <- unlist(lapply(strsplit(predicted," "), function(x) x[2]))
          predicted
        } else {
          unigramDF <- unigramDF[order(unigramDF$PcontB, decreasing = TRUE), ]
          as.character(unigramDF[1, 1])
        }
      }
      } else {
      print("Your predicted word will appear here")
    }
  })
})
