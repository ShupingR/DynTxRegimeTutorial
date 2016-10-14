library(markdown)
library(shiny)
library(shinydashboard)
library(DynTxRegime)
library(DT)
header <- dashboardHeader(title = "Dynamic Treatment Regimes",titleWidth = 350, disable = FALSE)

sidebar <- dashboardSidebar(
  width = 350,
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$script(src = "custom.js")
  ),
  sidebarMenu(
    menuItem(text = "Causal Inference Background",
             menuItem(text = "Motivation", tabName = "mot"),
             menuItem(text = "Causal Effect", 
                      menuSubItem(text = "Individual Causal Effect", tabName = "ice"),
                      menuSubItem(text = "Average Causal Effect", tabName = "ace"),
                      menuSubItem(text = "Summary", tabName = "sce")),
             menuItem(text = "Point Exposure Studies",
                      menuSubItem(text = "Randomized Studies", tabName = "rs"),
                      menuSubItem(text = "Observational studies", tabName = "os"),
                      menuSubItem(text = "Notation", tabName = "not")),
             menuItem(text = "Three Necessary Assumptions", 
                menuSubItem(text = "Necessary Assumptions", tabName = "na1"),
                menuSubItem(text = "SUTVA", tabName = "sutva"),
                menuSubItem(text = "NUC", tabName = "nuc"),
                menuSubItem(text = "Positivity", tabName = "pos"),
                menuSubItem(text = "Necessary Assumptions (Cont'd)", tabName = "na2")
              ),
             menuItem(text = "Optimal Treatment Regimes", tabName = "otr")
             ),
    
    menuItem(text = "Dataset", 
        menuSubItem(text = "Dataset: bmiDataOne", tabName = "dataone"),
        menuSubItem(text = "Dataset Exploration", tabName = "dat1explore")),
    
    menuItem(text = "Single Stage Methods",
             menuItem(text = "Outcome Regression", 
                      menuSubItem(text = "Outcome Regression", tabName = "or"),
                      menuSubItem(text = "Case Study", tabName = "orc"),
                      menuSubItem(text = "Summary", tabName = "sce"))
           #  menuItem(text = "Point Exposure Studies",
          #            menuSubItem(text = "Randomized Studies", tabName = "rs"),
          #            menuSubItem(text = "Observational studies", tabName = "os"),
          #            menuSubItem(text = "Notation", tabName = "not")),
          #   menuItem(text = "Three Necessary Assumptions", 
           #           menuSubItem(text = "Necessary Assumptions", tabName = "na1"),
            #          menuSubItem(text = "SUTVA", tabName = "sutva"),
             #         menuSubItem(text = "NUC", tabName = "nuc"),
              #        menuSubItem(text = "Positivity", tabName = "pos"),
               #       menuSubItem(text = "Necessary Assumptions (Cont'd)", tabName = "na2")
    )
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "mot",
            withMathJax(includeMarkdown("./www/begin.Rmd"))),
    tabItem(tabName = "ice",
            withMathJax(includeMarkdown("./www/effect_1.Rmd"))),
    tabItem(tabName = "ace",
            withMathJax(includeMarkdown("./www/effect_2.Rmd"))),
    tabItem(tabName = "sce",
            withMathJax(includeMarkdown("./www/effect_3.Rmd"))),
    tabItem(tabName = "rs",
            withMathJax(includeMarkdown("./www/point_1.Rmd"))),
    tabItem(tabName = "os",
            withMathJax(includeMarkdown("./www/point_2.Rmd"))),
    tabItem(tabName = "not",
            withMathJax(includeMarkdown("./www/notation.Rmd"))),
    tabItem(tabName = "na1",
            withMathJax(includeMarkdown("./www/assumption1.Rmd"))),
    tabItem(tabName = "sutva",
            withMathJax(includeMarkdown("./www/sutva.Rmd"))),
    tabItem(tabName = 'nuc',
             withMathJax(includeMarkdown("./www/nuc.Rmd"))),
    tabItem(tabName = 'pos',
             withMathJax(includeMarkdown("./www/positivity.Rmd"))),
    tabItem(tabName = "na2",
            withMathJax(includeMarkdown("./www/assumption2.Rmd"))),
    tabItem(tabName = "otr",
            withMathJax(includeMarkdown("./www/optimal.Rmd"))),
    tabItem(tabName = "or",
            withMathJax(includeMarkdown("./www/outcome_regress.Rmd"))),
    tabItem(tabName = "orc",
            withMathJax(includeMarkdown("./www/outcome_regress_case.Rmd"))),
    tabItem(tabName = "dataone",
            withMathJax(includeMarkdown("./www/one_stage_dat.Rmd"))),
    tabItem(tabName = "dat1explore",
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
    ))))
            #"Methods",
            #tabPanel("Q-learning in point exposure studies",
            #withMathJax(includeMarkdown("./www/10_qlearning.Rmd"))#,
#   ),
  


  
  dashboardPage(header, sidebar, body, tags$head(tags$style(HTML('
                                                                 .skin-blue .main-sidebar {
                                                                 background-color: #666666;
                                                                 }
                                                                 .skin-blue .sidebar-menu>li.active>a, .skin-blue .sidebar-menu>li:hover>a {
                                                                 background-color: #444444;
                                                                 }
                                                                 '))))
  
  