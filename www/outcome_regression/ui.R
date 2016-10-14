library(shiny)
library(DT)
library(markdown)
shinyUI(fluidPage(
  headerPanel("Outcome Regression Method for 
               Estimating a Single-stage Optimal Treatment Regime"),
  navlistPanel(
    tabPanel("Outcome Regression Method",uiOutput("report1")),

    tabPanel("Case Study",uiOutput("report2")),
    
    tabPanel("Hands-on",
      tabsetPanel(type = "tabs", 
        tabPanel("Upload Data",
          fluidPage(
            h4("Upload Your Data:"),
            p("Here, you may load a small sized csv/text file (less 
               that 5Mb) to interactiely learn about the outcome regression 
               method. Please check the example file provided for the format."),
               #----------------
               # Upload csv file
               #----------------
               sidebarLayout(
                sidebarPanel(
                  fileInput('file1', 'Choose CSV File', accept=c('text/csv', 
                           'text/comma-separated-values,text/plain', 
                           '.csv')
                           ),
                   tags$hr(),
                   checkboxInput('header', 'Header', TRUE),
                   radioButtons('sep', 'Separator',
                                 c(Comma=',',
                                 Semicolon=';',
                                 Tab='\t'),
                                 ','),
                  radioButtons('quote', 'Quote',
                                c(None='',
                                'Double Quote'='"',
                                'Single Quote'="'"),
                               '"')
                  ),
                  mainPanel(DT::dataTableOutput('tbl'))
                ))), 
        tabPanel("Data Explore", 
          fluidPage( 
          h4("Data Explore with Scatter Plots"),
          p("You may use scatter plots to visualize your uploaded dataset."),
          code("pairs(df)")),
          actionButton("getplot", "Go"),
          plotOutput("plot0")
        ), 
        tabPanel("Build and Fit Models", 
          fluidPage(
            h4("Build your model objects for main effect and contrast and fit"),
            p("Next step is to build model objects for main effect (moMain) and
            contrast (moCont). You may specify your treatment variable and response
            varible below. You may also choose the covariates to include in and 
            solver for each model. Here, we choose the solver to be lm. Yet, 
            other methods, such as glm, can be used for each model independently.
            This step can be achieved using the function buildModelObj(), followed by
            call the qLearn() function to fit the models together."),
            #interaction not included yet
            sidebarLayout(
              sidebarPanel(
                uiOutput("varTrt"),
                uiOutput("varResponse"),
                uiOutput("varMain"),
                uiOutput("solverMain"),
                uiOutput("varCont"),
                uiOutput("solverCont")
              ),
              mainPanel(
                fluidPage(
                  h6("Fit the model specified"),
                  actionButton("getmodel", "GO"),
                  code(textOutput("myMain")),
                  code(textOutput("myCont")),
                  code(textOutput("myFitQ1")),
                  h6("We may extract the coefficient estimated value by  function coeff()"),
                  code("coef(fitQ1)"),
                  tableOutput("coeffTbl")
                )
              )
            )
          )
        ),
        tabPanel("Diagnostic Plots",
          fluidPage(
            h6("We may use the function plot() to obtain the diagnostic plots for fitted model"),
            code("plot(fitQ1)"),  
            plotOutput("plot1"),
            plotOutput("plot2"),
            plotOutput("plot3"),
            plotOutput("plot4")
          )
        )
      )
    )
   )
 )
)             


 
