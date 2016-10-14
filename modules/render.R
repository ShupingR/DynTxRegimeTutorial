columnChooserUI <- function(id) {
  ns <- NS(id)
  uiOutput(ns("controls"))
}

columnChooser <- function(input, output, session, data) {
  output$controls <- renderUI({
    ns <- session$ns
    selectInput(ns("col"), "Columns", names(data), multiple = TRUE)
  })
  
  return(reactive({
    validate(need(input$col, FALSE))
    data[,input$col]
  }))
}