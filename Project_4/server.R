library(shiny)
#install.packages('ISLR')
library(ISLR)
#install.packages('ggplot2')
library(ggplot2)
#install.packages('plyr')
library(plyr)
#install.packages("magrittr")
#library(magrittr)

shinyServer(function(input, output) {
  #loading data
  CreditCard<-data.frame(Default)
  
  #data cleansing
  #convert default and Student into 1 and 0
  CreditCard$default <- factor(CreditCard$default, levels=c("No", "Yes"), labels=c(0,1))
  CreditCard$student <- factor(CreditCard$student, levels=c("No", "Yes"), labels=c(0,1))
  CreditCard$default <- as.numeric(CreditCard$default)-1
  CreditCard$student <- as.numeric(CreditCard$student)-1
  #add balance income ratio
  CreditCard$BalIncRatio<-CreditCard$balance / CreditCard$income
  
  model1pred <- eventReactive(input$goButton, {
    BalIncInput <- input$balance/input$income
    
    if(input$student){
      model1 <- glm(default ~ BalIncRatio, family = binomial, data = subset(CreditCard, student==1))
    } else {
      model1 <- glm(default ~ BalIncRatio, family = binomial, data = subset(CreditCard, student==0))
    }
    
    ypredict <- predict(model1, list(BalIncRatio = BalIncInput),type="response")
    
    print(paste0("Probability of Default based on model = ",ypredict))
    
  })
  
  output$plot1 <- renderPlot({
    plot(CreditCard$BalIncRatio, CreditCard$default, xlab = "Balance/Income Ratio", 
         ylab = "P(D)", bty = "n", pch = 16)
    
    if(input$student){
      model1 <- glm(default ~ BalIncRatio, family = binomial, data = subset(CreditCard, student==1))
    } else {
      model1 <- glm(default ~ BalIncRatio, family = binomial, data = subset(CreditCard, student==0))
    }
    
    xweight <- seq(0, 4, 0.01)
    yweight <- predict(model1, list(BalIncRatio = xweight),type="response")
    lines(xweight, yweight)
    
  })
  
  output$input1 <- renderText({
    BalIncInput <- input$balance/input$income
    print(paste0("Balance to Income Ratio = ", BalIncInput))
  })
  
  output$pred1 <- renderText({
    
    model1pred()
  })
  
})
