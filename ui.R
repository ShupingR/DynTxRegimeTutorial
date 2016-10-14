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
                menuSubItem(text = "Necessary Assumptions", tabName = "na2")
              )
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
            withMathJax(includeMarkdown("./www/assumption2.Rmd")))
    



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
  
  