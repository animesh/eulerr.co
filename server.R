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
    for(i in 1:length(sets)){
      proteinL <- splitProteins(size[paste0("size_",i)])
      if(proteinL=="character(0)"){next}
      else{
        proteinS <- data.frame(table(proteinL))[2]
        combinationsC<-c(combinationsC,list(t(proteinS)))
        proteinL=list(t(data.frame(table(proteinL))[1]))
        names(proteinL)=paste0(sets[paste0("combo_",i)],"-",sum(proteinS))
        combinations<-c(combinations,proteinL)
      }
    }
    #combinationsA <- list()
    #for(i in 1:length(combinationsC)){
     # print(names(combinations[i]))
      #combinationsT<-combinations[i]
      #for(j in 1:length(combinationsC)){
        #if(i<j){
          #print(names(combinations[j]))
          #print(intersect(unlist(combinations[i]),unlist(combinations[j])))
          #combinationsT<-setdiff(unlist(combinationsT),unlist(combinations[j]))
        #}
      #}
      #names(combinationsT)=names(combinations[i])
      #print(combinationsT)
      #combinationsA<-c(combinationsA,combinationsT)
      #}
    #print(combinationsA)
    #print(euler(combinations,shape=input$shape))
    n_sets <- length(combinations)
    #print(n_sets)
    validate(
      need(
        n_sets <= 6,
        paste0(
          "This Shiny app only allows combinations with six or fewer sets. ",
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
    #print(pEuler)
  })
  output$euler_table <- renderTable({
    data.frame(pEuler$original, pEuler$fitted, pEuler$regionError)
  }, rownames = TRUE, width = "100%")

  output$table <- renderTable({
    print(round(euler(get_combinations())$original))
  }, rownames = TRUE, width = "100%")

  output$ids <- renderTable({
    proteinLists<-get_combinations()
    #dim(proteinLists)
    proteinOverlap<-data.frame()
    #for(l1 in 1:length(proteinLists)){
      #for(l2 in 1:length(proteinLists)){
        #if(l1<l2 & length(intersect(unlist(proteinLists[l1]),unlist(proteinLists[l2])))>0){
          #proteinOverlap<-rbind(proteinOverlap,data.frame("Group1"=names(proteinLists[l1]),"Group2"=names(proteinLists[l2]),"Overlap"=paste(intersect(unlist(proteinLists[l1]),unlist(proteinLists[l2])),collapse = ";")))
          #print(names(proteinLists[l1]))
          #print(names(proteinLists[l2]))
          #print(intersect(unlist(proteinLists[l1]),unlist(proteinLists[l2])))
          #print("\n")}}}
    for(combo in 2:length(proteinLists)){
      comboList<-combn(names(proteinLists),combo)
      #print(combo)
      #print(ncol(comboList))
      #comIDs<-()
      for(nCol in 1:ncol(comboList)){
        #print(c(proteinLists[comboList[,nCol]]))
        #print(comboList[,nCol])
        comIDs<-c(proteinLists[[comboList[,nCol][1]]])
        #print(comIDs)
        for(nColVal in 2:length(comboList[,nCol])){
          comIDs<-intersect(comIDs,proteinLists[[comboList[,nCol][nColVal]]])
        }
        #print(comIDs)
        proteinOverlap<-rbind(proteinOverlap,data.frame("Group"=paste(comboList[,nCol],collapse = ";"),"Overlap"=paste(comIDs,collapse = ";")))
        #print(Reduce(intersect,list(proteinLists[comboList[,nCol]])))
        #print(intersect(unlist(proteinLists[comboList[,nCol]])))
      }
      #print(paste(comboList,collapse = ";"))
      #Reduce(intersect,list(c("1","2"),c("1","3"),c("1","3")))
    }
    proteinOverlap

  })

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
