library(shiny)
library(Biostrings)

# Define server logic
function(input, output) {
  analyzeSequence <- function(sequence) {
    # Remove non-DNA characters and convert to uppercase
    sequence <- gsub("[^ACGTacgt]", "", sequence)
    
    if (nchar(sequence) == 0) {
      return(list(start_positions = NULL, stop_positions = NULL))  # Return empty lists if sequence is invalid
    }
    
    dna_sequence <- DNAString(sequence)
    
    # Find start and stop codons
    start_codon <- "ATG"  # Start codon is 'ATG'
    stop_codons <- c("TAA", "TAG", "TGA")  # Stop codons are 'TAA', 'TAG', 'TGA'
    
    # Find positions of start and stop codons
    start_positions <- c()
    stop_positions <- c()
    
    for (i in 1:(nchar(sequence) - 2)) {
      codon <- substring(sequence, i, i + 2)
      
      if (codon == start_codon) {
        start_positions <- c(start_positions, i)
      } else if (codon %in% stop_codons) {
        stop_positions <- c(stop_positions, i)
      }
    }
    
    list(start_positions = start_positions, stop_positions = stop_positions)
  }
  
  observeEvent(input$analyzeButton, {
    sequence <- input$dnaInput
    
    # Analyze the input DNA sequence for start and stop codons
    result <- analyzeSequence(sequence)
    
    # Plotting start and stop codons
    output$codonPlot <- renderPlot({
      plot(1, xlim = c(1, nchar(sequence)), ylim = c(0, 1), type = "n",
           xlab = "Position", ylab = "", main = "Start and Stop Codon Positions")
      
      if (length(result$start_positions) > 0) {
        segments(result$start_positions, 0, result$start_positions, 1, col = "green")
      }
      
      if (length(result$stop_positions) > 0) {
        segments(result$stop_positions, 0, result$stop_positions, 1, col = "red")
      }
    })
  })
}
