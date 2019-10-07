server <- function(input, output) {
  
  #renderText
  output$bodyfat  <- renderUI({ 
    
    #check if the input value is numeric
    validate(
      need(mode(input$abs) == "numeric" & mode(input$wrist) == "numeric", "Please input a number.")
    )
    
    formula = round(-11.2 + input$abs * 0.73 + input$wrist * (-2.03),1)
    
    #check if the body fat percnetage is under 50%.
    validate(
      need(formula < 50 & formula > 0, "Plear input an appropriate number.")
    )
    
    #color
    if(formula > 25){
      HTML(sprintf('<p><font size="5">Your body fat percentage = <font color="%s">%s</font></font><p>',"red",formula),
           '<font size="5">You are classified as <b>obese</b>.</font>')
    }
    else if(formula<= 25 & formula > 18){
      HTML(sprintf('<p><font size="5">Your body fat percentage = <font color="%s">%s</font></font><p>',"yellow",formula),
           '<font size="5">You are classified as <b>average</b></font>.')
    }
    else if(formula<= 18 & formula > 14){
      HTML(sprintf('<p><font size="5">Your body fat percentage = <font color="%s">%s</font></font><p>',"#006600",formula),
           '<font size="5">You are classified as <b>fitness</b>.</font>')
    }
    else if(formula<= 14 & formula > 6){
      HTML(sprintf('<p><font size="5">Your body fat percentage = <font color="%s">%s</font><p>',"#66ff66",formula),
           '</font><font size="5">You are classified as <b>athletes</b>.</font>')
    }
    else if(formula <=6){
      HTML(sprintf('<p><font size="5">Your body fat percentage = <font color="%s">%s</font><p>',"yellow",formula),
           '</font><font size="5">You are classified as <b>essential fat</b>.</font>')
    }
  })
  
}
