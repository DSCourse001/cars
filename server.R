library(shiny)
data(cars)
attach(cars)

mphFactor = 1.609344
ftFactor = 0.3048

# Create New Data For Metric System
speedm <- speed*mphFactor
distm <- dist*ftFactor

# Create Two Linear Models
fitm <- lm(distm~speedm)
fiti <- lm(dist~speed)

shinyServer(
  function(input, output) {
  plotV<-NULL
    
  output$speed <- renderUI({
    value=input$system
    maxv<-NULL
    label<-NULL
    if (value=="Metric") {maxv<-round(max(speedm))
                          label="Kilometers per hour"}
    else if (value=="Imperial") {
                          maxv<-round(max(speed))
                          label="Miles per hour"}
    sliderInput("speed", label, min = 1, max = maxv, value = 1)
  })

  plotV<-function(){
    # Getting Input Value
    value=input$system
    # Choose Output
    if (value=="Metric") {
      plot(speedm,distm,col = 'darkgray', border = 'white',
           xlab="Speed, kmh",ylab="Distance, m",main=paste("Cars Stopping Distance\nMetric System\n",
                                                           round(predict(fitm,data.frame(speedm=input$speed)),2)," m"
           )
      )
      abline(fitm,col="blue")
    } else if (value=="Imperial") {
      plot(speed,dist,col = 'darkgray', border = 'white',
           xlab="Speed, mph",ylab="Distance, ft",main=paste("Cars Stopping Distance\nImperial System\n",
                                                            round(predict(fiti,data.frame(speed=input$speed)),2)," ft"
           )
      )
      abline(fiti,col="blue")
    }
    # Add Red Line
    abline(v=input$speed,col="red")
  }
  

  output$displayPlot <- renderPlot({
    plotV()
    png("image.png")
    plotV()
    dev.off()
  })
  

  output$savePNG <- downloadHandler(
    filename = function() {
      "image.png"
    },
    content = function(file) {
      file.copy("image.png", file, overwrite=TRUE)
    }
  )
  
  }
)