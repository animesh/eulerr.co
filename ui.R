shinyUI(
  navbarPage(
    "venn",
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
                textInput("combo_1", NULL, "AG"),
                textAreaInput("size_1", NULL, "IDH1,IDH2")),
              splitLayout(
                cellWidths = c("20%", "80%"),
                textInput("combo_2", NULL, "BG"),
                textAreaInput("size_2", NULL, "UBE2,IDH1")),
              splitLayout(
                cellWidths = c("20%", "80%"),
                textInput("combo_3", NULL, "CG"),
                textAreaInput("size_3", NULL, "IDH1,IDH2,UBE2")),
              splitLayout(
                cellWidths = c("20%", "80%"),
                textInput("combo_4", NULL, "DG"),
                textAreaInput("size_4", NULL, "IDH1,IDH2,UBE2,UBE1")),
              splitLayout(
                cellWidths = c("20%", "80%"),
                textInput("combo_5", NULL, ""),
                textAreaInput("size_5", NULL, "")),
              splitLayout(
                cellWidths = c("20%", "80%"),
                textInput("combo_6", NULL, ""),
                textAreaInput("size_6", NULL, "")),
              tags$div(id = "placeholder"),
              br(),
              radioButtons("shape","Shape",c("Ellipse" = "ellipse","Circle" = "circle"),inline = TRUE,selected = "circle"),
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
                plotOutput("euler_diagram", height = "800px")
              ),
              tabPanel(
                "Overlaps",
                tableOutput("table")
              ),
              tabPanel(
                "IDs",
                tableOutput("ids")
              )
            )
          ),
          column(
            3,
(p("code:",
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




