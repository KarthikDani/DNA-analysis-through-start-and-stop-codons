library(shiny)

# Define user interface
fluidPage(
  titlePanel("DNA Sequence Analyzer"),
  
  sidebarLayout(
    sidebarPanel(
      textAreaInput("dnaInput", "Enter DNA Sequence"),
      actionButton("analyzeButton", "Analyze")
    ),
    
    mainPanel(
      plotOutput("codonPlot")
    )
  )
)
