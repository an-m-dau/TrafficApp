library(shiny)
library(leaflet)
library(data.table)
#library(htmltools)

traffic.data = read.csv("Traffic_Volume.csv")
traffic.data = data.table(traffic.data)
traffic.data[, custom.label := paste(sep = "<br/>", 
                                     paste0("Two Way: ", TWO_WAY_AADT),
                                     paste0("Growth:", GROWTH_RATE),
                                     paste0("Truck: ", round(TRUCKS_AADT/ALLVEHS_AADT*TWO_WAY_AADT)),
                                     HMGNS_LNK_DESC, FLOW)]
#traffic.data = traffic.data[TWO_WAY_AADT >= 55000]

pal <- colorNumeric(
  palette = "Blues",
  domain = traffic.data$TWO_WAY_AADT)

ui <- fluidPage(
  title="Traffic Volume in Victoria 2017",
  fluidRow(
    column(
      10,
      div(style = "height:400px;background-color: yellow;",
                 leafletOutput("mymap",width="100%",height="600px")))
  )
)

server <- function(input, output, session) {
  
  
  
  
  
  output$mymap <- renderLeaflet({
    leaf = leaflet() %>%
      
      addTiles()%>%

      addCircleMarkers(
        traffic.data$MIDPNT_LON, traffic.data$MIDPNT_LAT,
        color =  pal(traffic.data$TWO_WAY_AADT),
        stroke = FALSE, fillOpacity = 0.3,
        popup = traffic.data$custom.label
      ) %>%
      
      addMeasure(primaryLengthUnit="meters", secondaryLengthUnit="kilometers")
   
    
  })
  
  session$onSessionEnded(stopApp)

  }

shinyApp(ui, server)

