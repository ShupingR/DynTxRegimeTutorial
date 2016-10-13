library(markdown)
library(shiny)
library(shinydashboard)

header <- dashboardHeader(title = "Dynamic Treatment Regimes", disable = FALSE)

sidebar <- dashboardSidebar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$script(src = "custom.js")
  ),
  sidebarMenu(
    menuItem(text = "KPIs",
             menuItem(text = "Beginning", tabName = "beginning"),
             menuItem(text = "Point Exposure Studies", tabName = "pes"),
             menuItem(text = "Causal Effect", tabName = "ce"),
             menuItem(text = "Necessary Assumptions", tabName = "na"),
             menuSubItem("SUTVA", tabName = "sutva")
    )
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "beginning",
            withMathJax(includeMarkdown("./www/1_begin.Rmd"))
    ),
    tabItem(tabName = "pes",
            withMathJax(includeMarkdown("./www/2_point.Rmd"))),
    
    tabItem(tabName = "ce",
            withMathJax(includeMarkdown("./www/3_effect.Rmd"))),
    
    tabItem(tabName = "opt",
            withMathJax(includeMarkdown("./www/9_optimal.Rmd")),
            
            tabItem(tabName = "na",
                    withMathJax(includeMarkdown("./www/4_assumption.Rmd"))),
            
            tabItem(tabName = "sutva",
                    withMathJax(includeMarkdown("./www/5_sutva.Rmd")))
            #tabsetPanel(  tabPanel("SUTVA",
            #withMathJax(includeMarkdown("./www/5_sutva.Rmd"))),
            #tabPanel("NUC",
            #withMathJax(includeMarkdown("./www/6_nuc.Rmd"))),
            #tabPanel("Positivity",
            #withMathJax(includeMarkdown("./www/7_positivity.Rmd")))
            #"Methods",
            #tabPanel("Q-learning in point exposure studies",
            #withMathJax(includeMarkdown("./www/10_qlearning.Rmd"))#,
    )
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
  
  