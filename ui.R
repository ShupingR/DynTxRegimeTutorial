library(markdown)
shinyUI(fluidPage(
  
  titlePanel("Dynamic Treatment Regimes"),
  
  navlistPanel(well = TRUE, fluid = TRUE, widths = c(3, 8),
    "Contents",
    "Introduction",
     tabPanel("Motivation",
            withMathJax(includeMarkdown("./www/1_begin.Rmd"))
    ),
    tabPanel("Point Exposure Studies",
             withMathJax(includeMarkdown("./www/2_point.Rmd"))
    ),
   # tabPanel("Causal Effect",
   #         withMathJax(includeMarkdown("./www/3_effect.Rmd"))
   # ),
   # tabPanel("Causal Effect (Cont'd)",
   #          withMathJax(includeMarkdown("./www/3.5_effect.Rmd"))
   # ),
    tabPanel("Optimal Treatment Regimes in Point Exposure Studies",
             #h3("This is the fourth panel")
             withMathJax(includeMarkdown("./www/9_optimal.Rmd"))
    ),
    tabPanel("Three Necessary Assumptions",
             withMathJax(includeMarkdown("./www/4_assumption.Rmd")),
             tabsetPanel(  tabPanel("SUTVA",
                                    withMathJax(includeMarkdown("./www/5_sutva.Rmd"))),
                           tabPanel("NUC", 
                                    withMathJax(includeMarkdown("./www/6_nuc.Rmd"))),
                           tabPanel("Positivity",
                                    withMathJax(includeMarkdown("./www/7_positivity.Rmd")))
            )),
    #tabPanel("Estimating Average Causal Effect",
             #h3("This is the fourth panel")
    #         withMathJax(includeMarkdown("./www/8_assumption2.Rmd"))
    #),

    "Methods",
    tabPanel("Q-learning in point exposure studies",
             withMathJax(includeMarkdown("./www/10_qlearning.Rmd"))#,
   # tabsetPanel(tabPanel("Q functions", 
  #                       withMathJax(includeMarkdown("./www/qfunction.Rmd"))),
   #             tabPanel("One-stage Q-learning",
  #                       withMathJax(includeMarkdown("./www/qlearning2.Rmd"))),
   #             tabPanel("One-stage Q-learning (Con't)",
  #                       withMathJax(includeMarkdown("./www/qlearning3.Rmd")))
               # )
    ),
  tabPanel("Q-learning in point exposure studies",
           withMathJax(includeMarkdown("./www/10_qlearning.Rmd"))#,
  ))
))
