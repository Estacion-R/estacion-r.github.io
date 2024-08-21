library(shiny)
library(bslib)
library(brackets)

source(global.R")

ui <- page_fluid(
  title = "Brackets Viewer",
  theme = bs_theme(
    primary = "#E69F00",
    secondary = "#0072B2",
    success = "#009E73",
    base_font = font_google("Barlow Condensed")
  ),
  navset_underline(
    nav_panel(
      nav_panel(title = "Soccer",
              br(),
              br(),
              bracketsViewerOutput("soccer"),
              br(),
              textOutput("clicked_match2")
    )
  )
)
)
server <- function(input, output, session) {
  
  output$soccer <- renderBracketsViewer({
    bracketsViewer(
      data = df_copa_america
    )
  })
  
  output$clicked_match2 <- renderText({
    input$soccer_match_click
  })

}

shinyApp(ui = ui, server = server)
