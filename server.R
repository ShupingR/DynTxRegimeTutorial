library(shiny)
library(markdown)
library(shinydashboard)
library(DynTxRegime)
library(DT)
library(rgenoud)

# server.R
# Limit Upload Data Size to 5Mb
options(shiny.maxRequestSize=5*1024^2)
shinyServer(
	function(input, output, session) {

	  output$dataone <- renderUI({
	    includeHTML("./www/one_stage_dat.html")})
	  
	  output$orc <- renderUI({
	    includeHTML("./www/outcome_regress_case.html")})
	 	output$ac <- renderUI({
	    includeHTML("./www/aipwe_case.html")})
	  output$cc <- renderUI({
	    includeHTML("./www/class_case.html")})


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
	  
	  ##--------------------------- outcome regression ---------------------------------------#
	  #---------------------
	  # Specify treatment
	  #---------------------
	  output$varTrtR <- renderUI({
	    if (is.null(data())) return(NULL)
	    df <-data()
	    
	    items=names(df)
	    names(items)=items
	    selectInput("varTrtR", "Treatment:",items)
	  })
	  
	  #-----------------
	  # Specify response
	  #-----------------
	  output$varResponseR <- renderUI({
	    if (is.null(data())) return(NULL)
	    df <-data()
	    
	    items=names(df)
	    names(items)=items
	    selectInput("varResponseR", "Response:",items)
	  })
	  
	  #-------------
	  # Build moMain
	  #-------------
	  output$varMainR <- renderUI({
	    if (is.null(data())) return(NULL)
	    df <-data()
	    
	    varName <- names(df)
	    varName <- varName[!(varName %in% c(input$varTrtR, input$varResponseR)) ]
	    checkboxGroupInput("varMainR", 
	                       "Choose variables to be included in the main effect model", 
	                       varName)
	  })
	  
	  #-------------
	  # Build moCont
	  #-------------
	  output$varContR <- renderUI({
	    if (is.null(data())) return(NULL)
	    df <-data()
	    
	    varName <- names(df)
	    varName <- varName[!(varName %in% c(input$varTrtR, input$varResponseR)) ]
	    checkboxGroupInput("varContR", 
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
	    if(is.null(input$varResponseR)) return(NULL)
	    if(is.null(input$varTrtR)) return(NULL)
	    
	    if (is.null(input$varMainR)) return(NULL)
	    if (is.null(input$varContR)) return(NULL)
	    
	    # fit model when user request 
	    if (input$getmodelR == 0) return(NULL)
	    
	    # build moMain and moCont
	    varMainVectorR <- as.vector(input$varMainR)
	    varContVectorR <- as.vector(input$varContR)
	    myMainR <- paste("~", paste(varMainVectorR, collapse=" + "))
	    myContR <- paste("~", paste(varContVectorR, collapse=" + "))
	    output$myMainR <- renderText({paste("moMain <- buildModelObj(model =",  
	                                        myMainR, ",  solver.method='lm')")})
	    output$myContR <- renderText({paste("moCont <- buildModelObj(model =",  
	                                        myContR, ",  solver.method='lm')")})
	    moMainR <- buildModelObj(model = as.formula(myMainR), solver.method='lm')
	    moContR <- buildModelObj(model = as.formula(myContR), solver.method='lm')
	    
	    # extract the response
	    # yR <- df[names(df) == input$varResponseR]
	    
	    # fit QLearn
	    output$myFitQ1 <- renderText({paste("fitQ1 <- qLearn(moMain = moMain, 
	                                        moCont = moCont, response =",  input$varResponseR, ",",
	                                        "data = df, txName = ", input$varTrtR, ")")})
	    fitQ1 <- qLearn(moMain = moMainR, moCont = moContR,  
	                    response = as.matrix(df[names(df) == input$varResponseR]), 
	                    data = df, txName = input$varTrtR)
	    # coeff into data frame
	    coeffTbl <- as.data.frame(coef(fitQ1)$Combined)
	    names(coeffTbl) <- c("Coefficients")
	    
	    # output coef
	    output$coeffTbl = renderTable({
	      if (input$getmodelR == 0) return(NULL)
	      coeffTbl})
	    output$res <- renderText({head(residuals(fitQ1))})
	    output$plot1 <- renderPlot({plot(fitQ1, which=1)})
	    output$plot2 <- renderPlot({plot(fitQ1, which=2)})
	    output$plot3 <- renderPlot({plot(fitQ1, which=3)})
	    output$plot4 <- renderPlot({plot(fitQ1, which=5)})
	    

	    ##--------------------------- classification --------------------------------------#
	    #------------------
	    # Specify treatment
	    #------------------
	    output$varTrtC <- renderUI({
	      if (is.null(data())) return(NULL)
	      df <-data()
	      
	      items=names(df)
	      names(items)=items
	      selectInput("varTrtC", "Treatment:",items)
	    })
	    
	    #-----------------
	    # Specify response
	    #-----------------
	    output$varResponseC <- renderUI({
	      if (is.null(data())) return(NULL)
	      df <-data()
	      
	      items=names(df)
	      names(items)=items
	      selectInput("varResponseC", "Response:",items)
	    })
	    
	    #-------------
	    # Build moProp
	    #-------------
	    output$varPropC <- renderUI({
	      if (is.null(data())) return(NULL)
	      df <-data()
	      
	      varName <- names(df)
	      varName <- varName[!(varName %in% c(input$varTrtC, input$varResponseC)) ]
	      checkboxGroupInput("varPropC", 
	                         "Choose variables to be included in the propensity model", 
	                         varName)
	    })
	    #-------------
	    # Build moMain
	    #-------------
	    output$varMainC <- renderUI({
	      if (is.null(data())) return(NULL)
	      df <-data()
	      
	      varName <- names(df)
	      varName <- varName[!(varName %in% c(input$varTrtC, input$varResponseC)) ]
	      checkboxGroupInput("varMainC", 
	                         "Choose variables to be included in the main effect model", 
	                         varName)
	    })
	    
	    #-------------
	    # Build moCont
	    #-------------
	    output$varContC <- renderUI({
	      if (is.null(data())) return(NULL)
	      df <-data()
	      
	      varName <- names(df)
	      varName <- varName[!(varName %in% c(input$varTrtC, input$varResponseC)) ]
	      checkboxGroupInput("varContC", 
	                         "Choose variables to be included in the contrast model", 
	                         varName)
	    })
	    
	    #----------------------------------------
	    # Specify the class of the decision rules/classification model
	    #----------------------------------------
	    output$varClass <- renderUI({
	      if (is.null(data())) return(NULL)
	      df <-data()
	      varName <- names(df)
	      varName <- varName[!(varName %in% c(input$varTrtC, input$varResponseC)) ]
	      checkboxGroupInput("varClass", 
	                         "Choose variables to specify the class of regimes. 
	                         For simplicity, we are restrict to linear decision rule with the form
	                         a + b x1 + c x2", 
	                         varName)
	    })
	    
	    observe({

	      if (is.null(data())) return(NULL)
	      df <-data()
	      
	      # check if all the inputs are ready  
	      if(is.null(input$varResponseC)) return(NULL)
	      if(is.null(input$varTrtC)) return(NULL)
	      
	      if (is.null(input$varMainC)) return(NULL)
	      if (is.null(input$varContC)) return(NULL)
	     # browser()	      
	      # fit model when user request 
	      if (input$getmodelC == 0) return(NULL)

	      # build moProp
	      varPropVectorC <- as.vector(input$varPropC)
	      myPropC <- paste("~", paste(varPropVectorC, collapse=" + "))
	      output$myPropC <- renderText({paste("moMain <- buildModelObj(model =",  
	                                         myPropC, ",  solver.method = 'glm', 
	                                         solver.args = list( 'family' = 'binomial' ),  
	                                         predict.method = 'predict.glm', 
	                                         predict.args = list( 'type' = 'response')")})
	      moPropC <- buildModelObj(model = as.formula(myPropC), solver.method = 'glm', 
	                              solver.args = list( 'family' = 'binomial' ),  
	                              predict.method = 'predict.glm', 
	                              predict.args = list( 'type' = 'response'))
	      
	      # build moMain
	      varMainVectorC <- as.vector(input$varMainC)
	      myMainC <- paste("~", paste(varMainVectorC, collapse=" + "))
	      output$myMainC <- renderText({paste("moMain <- buildModelObj(model =",  
	                                         myMainC, ",  solver.method='lm')")})
	      moMainC <- buildModelObj(model = as.formula(myMainC), solver.method='lm')
	      
	      # build moCont
	      varContVectorC <- as.vector(input$varContC)
	      myContC <- paste("~", paste(varContVectorC, collapse=" + "))
	      output$myContC <- renderText({paste("moCont <- buildModelObj(model =",  
	                                         myContC, ",  solver.method='lm')")})
	      moContC <- buildModelObj(model = as.formula(myContC), solver.method='lm')
	      
	      # extract the response
	      yC <- as.numeric(unlist(df[names(df) == input$varResponseC]))
	      
	      # extract the treatment variable
	      tx.varsC <- input$varTrtC
	
	      #---------------------------------   
	      # Define the classification model 
	      #---------------------------------
	      varClassVector <- as.vector(input$varClass)
	      myClass <- paste("~", paste(varClassVector, collapse=" + "))
	      output$myClass <- renderText({paste("moClass <- buildModelObj(model =",  
	                                          myClass, ",  solver.method='lm')")})
	      
	      class <- buildModelObj(model = as.formula(myClass), 
	                             solver.method =  'rpart' , 
	                             solver.args = list(method = 'class'), 
	                             predict.args = list(type= 'class'))
	      
	      
	      # classification solve
	      estAIPWE <- optimalClass(moPropen = moPropC,
	                               moMain = moMainC,
	                               moCont = moContC,
	                               moClass = class,
	                               data = df,
	                               response = yC,
	                               txName = tx.varsC,
	                               iter=0)
	      
	      # coeff into data frame
	      output$optClass <- renderText({ print(estimator(estAIPWE)) })
	      
	      # output coef
	      #output$coeffTbl = renderTable({
	      #  if (input$getmodel == 0) return(NULL)
	      #  coeffTbl})
	      #output$res <- renderText({head(residuals(fitQ1))})
	      #output$plot1 <- renderPlot({plot(fitQ1, which=1)})
	      #output$plot2 <- renderPlot({plot(fitQ1, which=2)})
	      #output$plot3 <- renderPlot({plot(fitQ1, which=3)})
	      #output$plot4 <- renderPlot({plot(fitQ1, which=5)})
	      })  
	  })
	})