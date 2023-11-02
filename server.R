library(shiny)
library(eulerr)

shinyServer(function(input, output, session) {
  inserted <- c()

 observeEvent(input$insert_set, {
    btn <- input$insert_set
    id <- paste0("txt", btn)
    insertUI(
      selector = "#placeholder",
      ui = tags$div(
        splitLayout(
          cellWidths = c("10%", "90%"),
          textInput(paste0("combo_", id), NULL, NULL),
          textAreaInput(paste0("size_", id), NULL, NULL),
          id = id
        )
      )
    )
    inserted <<- c(inserted, id)
  })

  observeEvent(input$remove_set, {
    removeUI(
      selector = paste0("#", inserted[length(inserted)])
    )
    updateTextInput(
      session,
      paste0("combo_", inserted[length(inserted)]),
      NULL,
      NA
    )
    updateNumericInput(
      session,
      paste0("size_", inserted[length(inserted)]),
      NULL,
      NA
    )

    inserted <<- inserted[-length(inserted)]
  })

  # Set up set relationships
  get_combinations <- reactive({
    sets <- sapply(
      grep("combo_", x = names(input), value = TRUE),
      function(x) input[[x]]
    )
    #print(sets)
    size <- sapply(
      grep("size_", x = names(input), value = TRUE),
      function(x) input[[x]]
    )
    splitProteins <- function(proteins) {
      proteins <- na.omit(proteins)
      proteins <- toupper(proteins)
      proteins <- gsub(",", " ", proteins)
      proteins <- gsub("[\t\r\n]", " ", proteins)
      proteins <- trimws(gsub("\\s+", " ", proteins))
      proteins <- strsplit(proteins, " ")
      return(proteins)
    }
    combinations <- list()
    combinationsC <- list()
    for(i in 1:5){
      proteinL <- splitProteins(size[paste0("size_",i)])
      if(proteinL=="character(0)"){next}
      else{
        proteinS <- data.frame(table(proteinL))[2]
        combinationsC<-c(combinationsC,list(t(proteinS)))
        proteinL=list(t(data.frame(table(proteinL))[1]))
        names(proteinL)=paste0(sets[paste0("combo_",i)],"#",sum(proteinS))
        combinations<-c(combinations,proteinL)
      }
    }
    combinationsA <- list()
    for(i in 1:length(combinationsC)){
      combinationsT<-combinations[i]
      for(j in 1:length(combinationsC)){
        if(i<j){
          print(names(combinations[i]))
          print(names(combinations[j]))
          print(intersect(unlist(combinations[i]),unlist(combinations[j])))
          combinationsT<-setdiff(unlist(combinationsT),unlist(combinations[j]))
        }
      }
      combinationsT
      names(combinationsT)=names(combinations[i])
      combinationsA<-c(combinationsA,combinationsT)
      }
    print(combinationsA)
    n_sets <- length(combinations)
    #print(n_sets)
    validate(
      need(
        n_sets <= 5,
        paste0(
          "This Shiny app only allows combinations with five or fewer sets. ",
          "Please use the R package if you need more sets."
        )
      )
    )
    na.omit(combinations)
  })

  euler_fit <- reactive({
    proteinList <- get_combinations()
    set.seed(input$seed)
    plot(euler(proteinList,shape=input$shape), quantities=TRUE)
  })

  output$table <- renderTable({
    f <- euler_fit()
    df <- with(
      f,
      data.frame(
        Input = original.values,
        Fit = fitted.values,
        Error = regionError
      )
    )
    colnames(df) <- c("Input", "Fit", "regionError")
    df
  }, rownames = TRUE, width = "100%")

  output$stress <- renderText({
    round(euler_fit()$stress, 2)
  })

  output$diagError <- renderText({
    round(euler_fit()$diagError, 2)
  })

  euler_plot <- reactive({
    ll <- list()

    ll$x <- euler_fit()

    if (!(input$fill == ""))
      ll$fills$fill <- gsub("^\\s+|\\s+$", "", unlist(strsplit(input$fill, ",")))
    ll$quantities <- input$quantities
    ll$fills$alpha <- input$alpha
    #ll$edges$lty <- switch(input$borders, Solid = 1, Varying = 1:6, None = 0)
    eulerr_options(pointsize = input$pointsize)

    do.call(plot, ll)
  })

  output$euler_diagram <- renderPlot({
    euler_plot()
  })

  # Download the plot
  output$download_plot <- downloadHandler(
    filename = function(){
      paste0("euler-", Sys.Date(), ".", input$savetype)
    },
    content = function(file) {

      print(euler_plot())
      dev.off()
    }
  )
})
