library(shiny)
shinyUI(fluidPage(

  titlePanel("Cars Stopping Distance"),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput("system", "System of Measurement:", c("Metric","Imperial")),
      uiOutput("speed"),
      downloadButton("savePNG", "Save to PNG")
    ),
    
    mainPanel(
      plotOutput("displayPlot")
    )
  )
))
