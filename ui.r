library(shiny)

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"),
    tags$script(src = "https://code.jquery.com/jquery-3.6.0.min.js"),
    tags$script(HTML("
      $(document).ready(function() {
        $('.sidebar').hover(function() {
          $(this).addClass('animate__animated animate__rubberBand');
        }, function() {
          $(this).removeClass('animate__animated animate__rubberBand');
        });

        $('.nav-tabs > li > a').hover(function() {
          $(this).addClass('animate__animated animate__pulse');
        }, function() {
          $(this).removeClass('animate__animated animate__pulse');
        });

        $('#tabs').hover(function() {
          $(this).addClass('animate__animated animate__headShake');
        }, function() {
          $(this).removeClass('animate__animated animate__headShake');
        });

        $('#tabs').on('click', 'a', function() {
          $(this).addClass('animate__animated animate__heartBeat');
          var that = this;
          setTimeout(function() {
            $(that).removeClass('animate__animated animate__heartBeat');
          }, 1000);
        });
      });
    "))
  ),
  
  titlePanel(HTML("<h2 style='text-align: center;'>DNA Analysis</h2>")),
  
  sidebarLayout(
    sidebarPanel(
      class = "sidebar",
      textInput("dnaInput", label = "Enter DNA Sequence:", value = ""),
      actionButton("analyseButton", label = "Analyse")
    ),
    
    mainPanel(
      tabsetPanel(
        id = "tabs",
        tabPanel(
          "GC and AT Content",
          plotOutput("gcContentPlot")
        ),
        tabPanel(
          "Nucleotide Frequency",
          plotOutput("nucleotideFrequencyPlot")
        ),
        tabPanel(
          "Start and Stop Codon Positions",
          fluidRow(
            column(12, verbatimTextOutput("startStopCodonCounts")),
            column(12, plotOutput("codonPlot")),
          )
        ),
        tabPanel(
          "Codon Usage Analysis",
          fluidRow(
            column(12, verbatimTextOutput("codonCounts")),
            column(12, plotOutput("codonUsagePlot"))
          )
        )
      )
    )
  )
)
