scatterUI <- function(id) {
  ns <- NS(id)
  
  fluidRow(
    plotOutput(ns("plot1"))
  )
}

scatter <- function(input, output,  data ) {
  # Yields the data frame with an additional column "selected_"
  dataWithSelection <- reactive({
    data()
  })
  
  output$plot1 <- renderPlot({
    pairs(dataWithSelection())
  })
  
  
  return(dataWithSelection)
}

