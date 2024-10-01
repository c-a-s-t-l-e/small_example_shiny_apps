#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(pdftools)

server <- function(input, output, session) {
  observeEvent(input$savePdf, {
    # Get the Quill content
    session$sendCustomMessage("getQuillContent")
    quillContent <- isolate(input$quillContent)
    
    # Create a temporary HTML file
    tempHtmlFile <- tempfile(fileext = ".html")
    writeLines(quillContent, con = tempHtmlFile)
    
    # Convert the HTML file to PDF
    pdfFile <- paste0(tools::file_path_sans_ext(tempHtmlFile), ".pdf")
    system(paste0("wkhtmltopdf ", tempHtmlFile, " ", pdfFile))
    
    # Download the PDF file
    downloadHandler(
      filename = "document.pdf",
      content = function(file) {
        file.copy(pdfFile, file)
      }
    )
  })
  
  observeEvent(input$saveWord, {
    # Get the Quill content
    session$sendCustomMessage("getQuillContent")
    quillContent <- isolate(input$quillContent)
    
    # Create a temporary HTML file
    tempHtmlFile <- tempfile(fileext = ".html")
    writeLines(quillContent, con = tempHtmlFile)
    
    # Convert the HTML file to Word
    wordFile <- paste0(tools::file_path_sans_ext(tempHtmlFile), ".docx")
    system(paste0("pandoc -o ", wordFile, " ", tempHtmlFile))
    
    # Download the Word file
    downloadHandler(
      filename = "document.docx",
      content = function(file) {
        file.copy(wordFile, file)
      }
    )
    
    output$downloadWord <- downloadHandler(
      filename = "document.docx",
      content = function(file) {
        # Send the custom message to get the Quill content
        session$sendCustomMessage("getQuillContent", "getQuillContent")
        
        # Get the Quill content
        quillContent <- isolate(input$quillContent)
        
        # Create a temporary HTML file
        tempHtmlFile <- tempfile(fileext = ".html")
        writeLines(quillContent, con = tempHtmlFile)
        
        # Convert the HTML file to Word
        wordFile <- paste0(tools::file_path_sans_ext(tempHtmlFile), ".docx")
        system(paste0("pandoc -o ", wordFile, " ", tempHtmlFile))
        
        # Copy the Word file to the download location
        file.copy(wordFile, file)
      }
    )
  })
}