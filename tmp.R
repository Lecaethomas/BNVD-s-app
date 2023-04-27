library(shiny)
library(leaflet)
library(sp)

# library(raster)

SpPDF <- st_read("C:/_FORMATIONS/R/shiny/formation_2023/bnvds_app/data/ign_admin_com_202002_4326_simplified_limited.shp")

## UI ##########
ui <- fluidPage(
  selectInput("col", label = "Select a color", choices = c("Blues", "viridis", "magma")),
  leafletOutput("mymap")
)

## SERVER ##########
server <- function(input, output) {
  output$mymap <- renderLeaflet({
    leaflet()  %>% 
      addTiles() #%>% 
      # fitBounds(lng1 = Extent[1],lat1 = Extent[3], lng2 = Extent[2], lat2 = Extent[4])
  })
  
  observe({
    req(input$col)
    click <- input$mymap_shape_click
    print(click)
    pal = colorFactor(input$col, domain = factor(SpPDF$POPULATION))
    leafletProxy("mymap") %>%
      addPolygons(data = SpPDF, color = ~pal(factor(SpPDF$POPULATION)))
  })
}

shinyApp(ui, server)