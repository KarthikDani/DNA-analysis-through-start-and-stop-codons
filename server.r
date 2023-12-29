library(shiny)
library(ggplot2)
library(Biostrings)

extract_codons <- function(dna_sequence) {
  n <- nchar(dna_sequence)
  codons <- substring(dna_sequence, seq(1, n, by = 3), seq(3, n, by = 3))
  return(codons)
}

calculate_codon_frequencies <- function(codons) {
  codon_frequency <- table(codons)
  codon_data <- data.frame(Codon = names(codon_frequency), Frequency = as.numeric(codon_frequency))
  return(codon_data)
}

function(input, output) {
  observeEvent(input$analyseButton, {
    dna_sequence <- toupper(input$dnaInput)
    
    gc_content <- (sum(strsplit(dna_sequence, "")[[1]] %in% c("G", "C")) / nchar(dna_sequence)) * 100
    at_content <- (sum(strsplit(dna_sequence, "")[[1]] %in% c("A", "T")) / nchar(dna_sequence)) * 100
    
    nucleotide_freq <- table(strsplit(dna_sequence, "")[[1]])
    data <- data.frame(Nucleotide = names(nucleotide_freq), Frequency = as.numeric(nucleotide_freq))
    
    start_codon <- "ATG"
    stop_codons <- c("TAA", "TAG", "TGA")
    
    start_positions <- gregexpr(start_codon, dna_sequence)[[1]]
    stop_positions <- unlist(sapply(stop_codons, function(stop_codon) {
      gregexpr(stop_codon, dna_sequence)[[1]]
    }))
    
    output$gcContentPlot <- renderPlot({
      data <- data.frame(Content = c("GC Content", "AT Content"), Percentage = c(gc_content, at_content))
      ggplot(data, aes(x = "", y = Percentage, fill = Content)) +
        geom_bar(stat = "identity", width = 1, color = "white") +
        geom_text(aes(label = paste0(round(Percentage, 2), "%")), position = position_stack(vjust = 0.5)) +
        coord_polar("y", start = 0) +
        labs(title = "GC and AT Content") +
        theme_void() +
        theme(plot.title = element_text(size = 20, hjust = 0.5))
    })
    
    output$nucleotideFrequencyPlot <- renderPlot({
      plot_title <- paste("Nucleotide Frequency (Bar Plot)", "\nTotal Nucleotides:", nchar(dna_sequence))
      
      ggplot(data, aes(x = Nucleotide, y = Frequency, fill = Nucleotide)) +
        geom_bar(stat = "identity", position = "dodge", color = "white") +
        geom_text(aes(label = Frequency), position = position_dodge(width = 0.9), vjust = -0.5, size = 3) +
        labs(title = plot_title) +
        theme_minimal() +
        theme(plot.title = element_text(size = 20, hjust = 0.5))
    })
    
    
    # Count start codons
    start_codon_count <- length(start_positions)
    
    # Extracting unique positions of stop codons
    unique_stop_positions <- unique(unlist(lapply(stop_positions, function(x) x[!is.na(x)])))
    stop_codon_count <- length(unique_stop_positions)
    
    output$startStopCodonCounts <- renderText({
      paste("Start Codon Count:", start_codon_count, " | ",
            "Stop Codon Count:", stop_codon_count)
    })
    
    output$codonPlot <- renderPlot({
      plot(1, xlim = c(1, nchar(dna_sequence)), ylim = c(0, 1), type = "n",
           xlab = "Position", ylab = "", main = "Start and Stop Codon Positions")
      
      if (length(start_positions) > 0) {
        segments(start_positions, 0, start_positions, 1, col = "green")
      }
      
      if (length(stop_positions) > 0) {
        segments(stop_positions, 0, stop_positions, 1, col = "red")
      }
    })
    
    codons <- extract_codons(dna_sequence)
    codon_data <- calculate_codon_frequencies(codons)
    
    output$codonCounts <- renderText({
      paste("Total unique codons used:", length(unique(codons)), "/", 64)
    })
    
    output$codonUsagePlot <- renderPlot({
      ggplot(codon_data, aes(x = reorder(Codon, -Frequency), y = Frequency)) +
        geom_bar(stat = "identity", fill = "skyblue", color = "black") +
        labs(title = "Codon Usage Analysis", x = "Codon", y = "Frequency") +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    })
    
  })
}
