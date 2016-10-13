library(markdown)
library(shiny)
library(shinydashboard)

header <- dashboardHeader(title = "Dynamic Treatment Regimes",titleWidth = 350, disable = FALSE)

sidebar <- dashboardSidebar(
  width = 350,
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$script(src = "custom.js")
  ),
  sidebarMenu(
    menuItem(text = "Content",
             menuItem(text = "Motivation", tabName = "mot"),
             menuItem(text = "Causal Effect", 
                      menuSubItem(text = "Individual Causal Effect", tabName = "ice"),
                      menuSubItem(text = "Average Causal Effect", tabName = "ace")),
             menuItem(text = "Point Exposure Studies", tabName = "pes"),
             menuItem(text = "Assumptions", 
                menuSubItem(text = "Necessary Assumptions", tabName = "na"),
                menuSubItem(text = "SUTVA", tabName = "subItemOne"),
                menuSubItem(text = "NUC", tabName = "subItemTwo"))
             # menuSubItem(icon = NULL,
              # sliderInput("inputTest2", "Input test 2", min=0, max=10, value=5,
              #            width = '95%'))
                     
             # menuSubItem(text = "NUC", tabName = "nuc")
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
    tabItem(tabName = "opt",
            withMathJax(includeMarkdown("./www/optimal.Rmd")),
    tabItem(tabName = "pes",
            withMathJax(includeMarkdown("./www/point.Rmd"))),
    tabItem(tabName = "mot",
            withMathJax(includeMarkdown("./www/begin.Rmd")))),
    tabItem(tabName = "na",
            withMathJax(includeMarkdown("./www/assumption.Rmd"))),
    tabItem(tabName = 'subItemOne',
             withMathJax(includeMarkdown("./www/optimal.Rmd"))),
    tabItem(tabName = 'subItemTwo',
             withMathJax(includeMarkdown("./www/begin.Rmd")))
    # tabItem(tabName = 'subItemThree',
    #         h2('Selected Sub-Item Three')
    # ),
    # tabItem(tabName = "nuc",
    #         withMathJax(includeMarkdown("./www/2_point.Rmd")))


            #tabsetPanel(  tabPanel("SUTVA",
            #withMathJax(includeMarkdown("./www/5_sutva.Rmd"))),
            #tabPanel("NUC",
            #withMathJax(includeMarkdown("./www/6_nuc.Rmd"))),
            #tabPanel("Positivity",
            #withMathJax(includeMarkdown("./www/7_positivity.Rmd")))
            #"Methods",
            #tabPanel("Q-learning in point exposure studies",
            #withMathJax(includeMarkdown("./www/10_qlearning.Rmd"))#,
#   tabItem(tabName = 'subItemTwo',
 #          h2('Selected Sub-Item Two')
#   ),
  )
)

  
  dashboardPage(header, sidebar, body, tags$head(tags$style(HTML('
                                                                 .skin-blue .main-sidebar {
                                                                 background-color: #666666;
                                                                 }
                                                                 .skin-blue .sidebar-menu>li.active>a, .skin-blue .sidebar-menu>li:hover>a {
                                                                 background-color: #444444;
                                                                 }
                                                                 '))))
  
  