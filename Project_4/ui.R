library(shiny)
shinyUI(fluidPage(
  
  titlePanel("Estimate Probability of Default based on Credit Card User Profile"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("balance", "select credit card balance",0, 100000, value=30),
      sliderInput("income", "select income",0, 100000, value = 3000),
      checkboxInput("student", "Check if the credit card is owned by a student"),
      actionButton("goButton", "Go!"),
      p("Click the button to update plot and P(D) estimate in the main panel")
    ),
    mainPanel(
      h3("Balance/Income Ratio vs. Probability of default"),
      plotOutput("plot1"),
      verbatimTextOutput("input1"),
      verbatimTextOutput("pred1")
    )
  )
))

