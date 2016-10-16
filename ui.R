library(shiny)
library(markdown)
library(shinydashboard)
library(DynTxRegime)
library(DT)
library(rgenoud)

source("./modules/uploadDat.R")

header <-
  dashboardHeader(title = "Dynamic Treatment Regimes",titleWidth = 350, disable = FALSE)

sidebar <- dashboardSidebar(
  width = 350,
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$script(src = "custom.js")
  ),
  sidebarMenu(
    menuItem(
      text = "Causal Inference Background",
      menuItem(text = "Motivation", tabName = "mot"),
      menuItem(
        text = "Causal Effect",
        menuSubItem(text = "Individual Causal Effect", tabName = "ice"),
        menuSubItem(text = "Average Causal Effect", tabName = "ace"),
        menuSubItem(text = "Summary", tabName = "sce")
      ),
      menuItem(
        text = "Point Exposure Studies",
        menuSubItem(text = "Randomized Studies", tabName = "rs"),
        menuSubItem(text = "Observational studies", tabName = "os"),
        menuSubItem(text = "Notation", tabName = "not")
      ),
      menuItem(
        text = "Three Necessary Assumptions",
        menuSubItem(text = "Necessary Assumptions", tabName = "na1"),
        menuSubItem(text = "SUTVA", tabName = "sutva"),
        menuSubItem(text = "NUC", tabName = "nuc"),
        menuSubItem(text = "Positivity", tabName = "pos"),
        menuSubItem(text = "Necessary Assumptions (Cont'd)", tabName = "na2")
      ),
      menuItem(text = "Optimal Treatment Regimes", tabName = "otr")
    ),
    
    menuItem(text = "Dataset", tabName = "dataone"),
    
    menuItem(
      text = "Single Stage Methods",
      menuItem(
        text = "Outcome Regression",
        menuSubItem(text = "Outcome Regression", tabName = "or"),
        menuSubItem(text = "Case Study", tabName = "orc")
      ),
      menuItem(
        text = "Augmented Inverse Probability Weighted Estimator",
        menuSubItem(text = "AIPWE", tabName = "aipwe"),
        menuSubItem(text = "Case study", tabName = "ac")
      ),
      menuItem(
        text = "Classification Method",
        menuSubItem(text = "Classification Method", tabName = "class"),
        menuSubItem(text = "Case Study", tabName = "cc")
      ),
      menuItem(text = "Hands-on", tabName = "handson")
    )
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "mot",
            withMathJax(
              includeMarkdown("./www/background/begin.Rmd")
            )),
    tabItem(tabName = "ice",
            withMathJax(
              includeMarkdown("./www/background/effect_1.Rmd")
            )),
    tabItem(tabName = "ace",
            withMathJax(
              includeMarkdown("./www/background/effect_2.Rmd")
            )),
    tabItem(tabName = "sce",
            withMathJax(
              includeMarkdown("./www/background/effect_3.Rmd")
            )),
    tabItem(tabName = "rs",
            withMathJax(
              includeMarkdown("./www/background/point_1.Rmd")
            )),
    tabItem(tabName = "os",
            withMathJax(
              includeMarkdown("./www/background/point_2.Rmd")
            )),
    tabItem(tabName = "not",
            withMathJax(
              includeMarkdown("./www/background/notation.Rmd")
            )),
    tabItem(tabName = "na1",
            withMathJax(
              includeMarkdown("./www/background/assumption1.Rmd")
            )),
    tabItem(tabName = "sutva",
            withMathJax(
              includeMarkdown("./www/background/sutva.Rmd")
            )),
    tabItem(tabName = 'nuc',
            withMathJax(
              includeMarkdown("./www/background/nuc.Rmd")
            )),
    tabItem(tabName = 'pos',
            withMathJax(
              includeMarkdown("./www/background/positivity.Rmd")
            )),
    tabItem(tabName = "na2",
            withMathJax(
              includeMarkdown("./www/background/assumption2.Rmd")
            )),
    tabItem(tabName = "otr",
            withMathJax(
              includeMarkdown("./www/background/optimal.Rmd")
            )),
    tabItem(tabName = "dataone",
            uiOutput("dataone")),
    tabItem(tabName = "or",
            withMathJax(includeMarkdown("./www/outcome_regress.Rmd"))),
    tabItem(tabName = "orc",
            uiOutput("orc")),
    tabItem(tabName = "aipwe",
            withMathJax(includeMarkdown("./www/aipwe.Rmd"))),
    tabItem(tabName = "ac",
            uiOutput("ac")),
    tabItem(tabName = "class",
            withMathJax(includeMarkdown("./www/class.Rmd"))),
    tabItem(tabName = "cc",
            uiOutput("cc")),
    tabItem(
      tabName = "handson",
      tabsetPanel(
        type = "tabs",
        tabPanel("Upload Data",
          sidebarLayout(
            sidebarPanel(
              h3("Upload Your Data:"),
                p("You may load a small sized csv/text file (less
                  that 5Mb) to interactiely learn about the outcome regression
                  method."),
                  csvFileInput("datafile", "User data (.csv format)")),
                  mainPanel(dataTableOutput("table"))
            )
          ),
        tabPanel(
          "Data Explore",
          fluidPage(
            h4("Data Explore with Scatter Plots"),
            p("You may use scatter plots to visualize your uploaded dataset."),
            code("pairs(df)")
          ),
          actionButton("getplot", "Go"),
          plotOutput("plot0")
        ),
        tabPanel("Outcome Regression",
          fluidPage(
            sidebarLayout(
              sidebarPanel(
                uiOutput("varTrtR"),
                uiOutput("varResponseR"),
                uiOutput("varMainR"),
                uiOutput("solverMainR"),
                uiOutput("varContR"),
                uiOutput("solverContR")
                ),
              mainPanel(
                fluidPage(
                  h4("Build your model objects for main effect and contrast and fit"),
                  p("To build model objects for main effect (moMain) and
                    contrast (moCont). You may specify your treatment variable and response
                    varible below. You may also choose the covariates to include in and
                    solver for each model. Here, we choose the solver to be lm. Yet,
                    other methods, such as glm, can be used for each model independently.
                    This step can be achieved using the function buildModelObj(), followed by
                    call the qLearn() function to fit the models together."),
                  h6("Fit the model specified"),
                    actionButton("getmodelR", "GO"),
                    code(textOutput("myMainR")),
                    code(textOutput("myContR")),
                    code(textOutput("myFitQ1")),
                  h6("We may extract the coefficient estimated value by  function coeff()"),
                  code("coef(fitQ1)"),
                  tableOutput("coeffTbl"),
                  h6("We may use the function plot() to obtain the diagnostic plots for fitted model"),
                  code("plot(fitQ1)"),
                  fluidRow(
                    column(6, plotOutput("plot1")),
                    column(6, plotOutput("plot2"))
                  ),
                  fluidRow(
                    column(6, plotOutput("plot3")),
                    column(6, plotOutput("plot4"))
                  )
                )
              )
            )
           )
          ),
        tabPanel("Classification Method", 
                 fluidPage(
                   h4("Specify treatment variable and build your modeling objects."),
                   p("Before running the optimalSeq function, we need to for the 
                     treatment variable. This tells optimalSeq 'optimalSeq' which 
                     columns of data correspond to treatments, and build the modeling 
                     objects for propensity score (moPropen) and conditional expectations
                     (expec.main and expec.cont), You may specify your treatment variable 
                     and response varible below. You may also choose the covariates to include
                     in and solver for each model. Here, we choose the solver to be glm for 
                     modeling propensity score and gl for conditional expectations."),
                   
                   sidebarLayout(
                     sidebarPanel(
                       uiOutput("varTrtC"),
                       uiOutput("varResponseC"),
                       uiOutput("varPropC"),
                       uiOutput("varMainC"),
                       uiOutput("varContC"),
                       uiOutput("varClass")
                       ),
                     mainPanel(
                       fluidPage(
                         h6("Estimate the optimal regime"),
                         actionButton("getmodelC", "GO"),
                         uiOutput("optClass")
                       )
                    )
             )
        )
        )
      )
    )
))

    








dashboardPage(header, sidebar, body, tags$head(tags$style(
  HTML(
    '
    .skin-blue .main-sidebar {
    background-color: #666666;
    }
    .skin-blue .sidebar-menu>li.active>a, .skin-blue .sidebar-menu>li:hover>a {
    background-color: #444444;
    }
    '
  )
  )))

