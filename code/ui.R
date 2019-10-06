library(shiny)
library(shinythemes)

ui <- fluidPage(
  
  #shinythemes::themeSelector(),
  theme = shinytheme("darkly"),
  includeCSS("style.css"),
  
  # App title ----
  headerPanel("Bodyfat Calculator"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      # A short description of how the app works
      helpText("This app can estimate your body fat percentage
               based on your inputs."),   
      br(),
      
      numericInput("abs", "Abdomen (cm)", 80, min = 13, max = 150),
      br(), 
      
      numericInput("wrist", "Wrist (cm)", 17, min = 5, max = 25, step=0.1),
      br(),
      br(),
      
      helpText("Contact us: tsai45@wisc.edu")
      
      ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      htmlOutput("bodyfat")
      #textOutput("bodyfat")
    )
  )
)