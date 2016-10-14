library(markdown)
library(shiny)
library(shinydashboard)
library(DynTxRegime)
library(DT)
source("./modules/uploadDat.R")
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
    
    menuItem(text = "Dataset", tabName = "dataone"),
    
    menuItem(text = "Single Stage Methods",
             menuItem(text = "Outcome Regression", 
                      menuSubItem(text = "Outcome Regression", tabName = "or"),
                      menuSubItem(text = "Case Study", tabName = "orc"),
                      menuSubItem(text = "Hands on", tabName = "orh"))
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
            withMathJax(includeMarkdown("./www/background/begin.Rmd"))),
    tabItem(tabName = "ice",
            withMathJax(includeMarkdown("./www/background/effect_1.Rmd"))),
    tabItem(tabName = "ace",
            withMathJax(includeMarkdown("./www/background/effect_2.Rmd"))),
    tabItem(tabName = "sce",
            withMathJax(includeMarkdown("./www/background/effect_3.Rmd"))),
    tabItem(tabName = "rs",
            withMathJax(includeMarkdown("./www/background/point_1.Rmd"))),
    tabItem(tabName = "os",
            withMathJax(includeMarkdown("./www/background/point_2.Rmd"))),
    tabItem(tabName = "not",
            withMathJax(includeMarkdown("./www/background/notation.Rmd"))),
    tabItem(tabName = "na1",
            withMathJax(includeMarkdown("./www/background/assumption1.Rmd"))),
    tabItem(tabName = "sutva",
            withMathJax(includeMarkdown("./www/background/sutva.Rmd"))),
    tabItem(tabName = 'nuc',
             withMathJax(includeMarkdown("./www/background/nuc.Rmd"))),
    tabItem(tabName = 'pos',
             withMathJax(includeMarkdown("./www/background/positivity.Rmd"))),
    tabItem(tabName = "na2",
            withMathJax(includeMarkdown("./www/background/assumption2.Rmd"))),
    tabItem(tabName = "otr",
            withMathJax(includeMarkdown("./www/background/optimal.Rmd"))),
    tabItem(tabName = "dataone",
            uiOutput("dataone")),
    tabItem(tabName = "or",
            withMathJax(includeMarkdown("./www/outcome_regress.Rmd"))),
    tabItem(tabName = "orc",
            uiOutput("orc")),
    tabItem(tabName = "orh",
        tabsetPanel(type = "tabs", 
          tabPanel("Upload Data",
              sidebarLayout(
                sidebarPanel(
                  h3("Upload Your Data:"),
                  p("You may load a small sized csv/text file (less 
                    that 5Mb) to interactiely learn about the outcome regression 
                    method."),
                  csvFileInput("datafile", "User data (.csv format)")
                ),
                mainPanel(
                  dataTableOutput("table")
                )
              )), 
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
                     plotOutput("plot4")))
          
          ))))

     #     uiOutput("orc")))
  #  tabItem(tabName = "dat1explore",

   # ))
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
  
  