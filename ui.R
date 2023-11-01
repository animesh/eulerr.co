library(shiny)
library(eulerr)

shinyUI(
  navbarPage(
    "eulerr",
    inverse = TRUE,
    tabPanel(
      "App",
      fluidPage(
        fluidRow(
          column(
            3,
            wellPanel(
              strong("Provide *names* and *list* of IDs in Box representing respective groups"),
              splitLayout(
                cellWidths = c("20%", "80%"),
                textInput("combo_1", NULL, "A"),
                textAreaInput("size_1", NULL, "P13051,P01857,P02768,Q56G89,Q5EFE6,Q56G8")),
              splitLayout(
                cellWidths = c("20%", "80%"),
                textInput("combo_2", NULL, "B"),
                textAreaInput("size_2", NULL, "P13051,B7WNR0,E5RH81,P0091,Q56G8,P01857")),
              splitLayout(
                cellWidths = c("20%", "80%"),
                textInput("combo_3", NULL, "C"),
                textAreaInput("size_3", NULL, "P13051,E5RH1, Q5EFE6")),
              splitLayout(
                cellWidths = c("20%", "80%"),
                textInput("combo_4", NULL, "D"),
                textAreaInput("size_4", NULL, "P13051,E5RH81, P0185")),
              splitLayout(
                cellWidths = c("20%", "80%"),
                textInput("combo_5", NULL, "E"),
                textAreaInput("size_5", NULL, "P13051,P0091,Q56G8")),
              tags$div(id = "placeholder"),
              br(),
              radioButtons("shape","Shape",c("Ellipse" = "ellipse","Circle" = "circle"),inline = TRUE),
              numericInput("seed","Random Seed",value = 42,min = 1),
              p("")
            ),
          ),
          column(
            6,
            tabsetPanel(
              type = "tabs",
              tabPanel(
                "Plot",
                plotOutput("euler_diagram", height = "600px")
              ),
            )
          ),
          column(
            3,
            strong("Cite"),
            em(p("To cite eulerr in publications, please use ",
                 a(href = "https://cran.r-project.org/web/packages/eulerr/citation.html",
                   "Larsson J (2022). eulerr: Area-Proportional Euler and Venn Diagrams with Ellipses. R package version 7.0.0, https://CRAN.R-project.org/package=eulerr."),
            )),            (p("code:",
                                a(href = "https://github.com/animesh/eulerr.co",
                                  "https://github.com/animesh/eulerr.co"),
            )),
            textInput(inputId = "fill",label = NULL,value = "",placeholder = timestamp(),width = "100%"),
            #radioButtons("borders","Borders",list("Solid"),inline = TRUE),

            hr(),
            fluidRow(
            )
          )
        )
      )
    )
 )
)




