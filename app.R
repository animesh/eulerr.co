library(shiny)
#install.packages("eulerr")
library(eulerr)
#git clone https://github.com/animesh/eulerr.co
#ln -s /opt/shiny-server/samples/sample-apps/eulerr.co /srv/shiny-server/.
#https://ivabudimir.github.io/visProteomics/articles/explore-venn.html
#proteins_A <- c("B4DPP6", "B7WNR0", "E5RH81", "P00915", "P01857", "P02768", "Q56G89", "Q5EFE6")
#proteins_B <- c("B7WNR0", "E5RHP7", "F6KPG5", "H6VRG0", "P00915", "P13646", "Q56G89", "Q6P5S8")
#proteins_C <- c("B4DPP6", "B7WNR0", "E5RHP7", "H6VRG0", "P02768", "P13646", "P31944", "Q56G89")
#proteins_D <- c("B4DPP6", "B7WNR0", "E5RHP7", "H6VRG0", "P02768", "P13646", "P31944")
#proteins_E <- c("B4DPP6", "B7WNR0", "E5RHP7", "H6VRG0", "P02768", "P13646")
#plot(venn(list(A=proteins_A, B=proteins_B, C=proteins_C, E=proteins_E, D=proteins_D)), quantities=TRUE)
shinyApp(ui = shinyServer, server = shinyUI)


