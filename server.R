# server.R
# Limit Upload Data Size to 5Mb
options(shiny.maxRequestSize=5*1024^2)
shinyServer(
	function(input, output, session) {
	  
	  output$dataone <- renderUI({
	    includeHTML("./www/one_stage_dat.html")})
	  
	  output$orc <- renderUI({
	    includeHTML("./www/outcome_regress_case.html")})
	  
	  #-----------------------
	  # Read uploaded csv file
	  #-----------------------
	  data <- callModule(csvFile, "datafile",
	                         stringsAsFactors = FALSE)
	  #-----------------
	  # Datatable Output
	  #-----------------
	  output$table <- renderDataTable({
	    data()
	  })
	  
	  #-----------------------------
	  # Scatter plots with Go button
	  #-----------------------------
	  output$plot0 <- renderPlot({
	    if (is.null(data())) return(NULL)
	    df <-data()
	    if (input$getplot == 0) return(NULL)
	    pairs(df)
	  })
	  
	  #---------------------
	  # Specify treatment
	  #---------------------
	  output$varTrt <- renderUI({
	    if (is.null(data())) return(NULL)
	    df <-data()
	    
	    items=names(df)
	    names(items)=items
	    selectInput("varTrt", "Treatment:",items)
	  })
	  
	  #-----------------
	  # Specify response
	  #-----------------
	  output$varResponse <- renderUI({
	    if (is.null(data())) return(NULL)
	    df <-data()
	    
	    items=names(df)
	    names(items)=items
	    selectInput("varResponse", "Response:",items)
	  })
	  
	  #-------------
	  # Build moMain
	  #-------------
	  output$varMain <- renderUI({
	    if (is.null(data())) return(NULL)
	    df <-data()
	    
	    varName <- names(df)
	    varName <- varName[!(varName %in% c(input$varTrt, input$varResponse)) ]
	    checkboxGroupInput("varMain", 
	                       "Choose variables to be included in the main effect model", 
	                       varName)
	  })
	  
	  #-------------
	  # Build moCont
	  #-------------
	  output$varCont <- renderUI({
	    if (is.null(data())) return(NULL)
	    df <-data()
	    
	    varName <- names(df)
	    varName <- varName[!(varName %in% c(input$varTrt, input$varResponse)) ]
	    checkboxGroupInput("varCont", 
	                       "Choose variables to be included in the contrast model", 
	                       varName)
	  })
	  
	  #-------------
	  # Build moCont
	  #-------------  
	  observe({
	    if (is.null(data())) return(NULL)
	    df <-data()
	    
	    # check if all the inputs are ready  
	    if(is.null(input$varResponse)) return(NULL)
	    if(is.null(input$varTrt)) return(NULL)
	    
	    if (is.null(input$varMain)) return(NULL)
	    if (is.null(input$varCont)) return(NULL)
	    
	    # fit model when user request 
	    if (input$getmodel == 0) return(NULL)
	    
	    # build moMain and moCont
	    varMainVector <- as.vector(input$varMain)
	    varContVector <- as.vector(input$varCont)
	    myMain <- paste("~", paste(varMainVector, collapse=" + "))
	    myCont <- paste("~", paste(varContVector, collapse=" + "))
	    output$myMain <- renderText({paste("moMain <- buildModelObj(model =",  
	                                       myMain, ",  solver.method='lm')")})
	    output$myCont <- renderText({paste("moCont <- buildModelObj(model =",  
	                                       myCont, ",  solver.method='lm')")})
	    moMain <- buildModelObj(model = as.formula(myMain), solver.method='lm')
	    moCont <- buildModelObj(model = as.formula(myCont), solver.method='lm')
	    
	    # extract the response
	    y <- df[names(df) == input$varResponse]
	    
	    # fit QLearn
	    output$myFitQ1 <- renderText({paste("fitQ1 <- qLearn(moMain = moMain, 
	                                        moCont = moCont, response =",  input$varResponse, ",",
	                                        "data = df, txName = ", input$varTrt, ")")})
	    fitQ1 <- qLearn(moMain = moMain, moCont = moCont,  
	                    response = as.matrix(df[names(df) == input$varResponse]), 
	                    data = df, txName = input$varTrt)
	    # coeff into data frame
	    coeffTbl <- as.data.frame(coef(fitQ1)$Combined)
	    names(coeffTbl) <- c("Coefficients")
	    
	    # output coef
	    output$coeffTbl = renderTable({
	      if (input$getmodel == 0) return(NULL)
	      coeffTbl})
	    output$res <- renderText({head(residuals(fitQ1))})
	    output$plot1 <- renderPlot({plot(fitQ1, which=1)})
	    output$plot2 <- renderPlot({plot(fitQ1, which=2)})
	    output$plot3 <- renderPlot({plot(fitQ1, which=3)})
	    output$plot4 <- renderPlot({plot(fitQ1, which=5)})
	  })  
	}
)