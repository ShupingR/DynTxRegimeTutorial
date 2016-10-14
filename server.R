# server.R
shinyServer(
	function(input, output, session) {
	  
	  output$dataone <- renderUI({
	    includeHTML("./www/one_stage_dat.html")})
	  
	  output$orc <- renderUI({
	    includeHTML("./www/outcome_regress_case.html")})
	  
	  datafile <- callModule(csvFile, "datafile",
	                         stringsAsFactors = FALSE)
	  
	  output$table <- renderDataTable({
	    datafile()
	  })
 #   output$text1 <- renderText({ 
 #    	paste("You have choose a range", input$range)
#    })
      
	}
)