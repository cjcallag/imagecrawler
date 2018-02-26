function(input, output, session){
  
  text_input <- eventReactive(input$submit, {
    validate(need(str_detect(input$text_input1, valid_path_regex),
                  invalid_path_message))
    validate(need(str_detect(input$text_input2, valid_path_regex),
                  invalid_path_message))
    validate(need(str_detect(input$text_input3, valid_path_regex),
                  invalid_path_message))
    
    url_text <- c(input$text_input1, input$text_input2, input$text_input3)
    

    df <- map_df(url_text, build_df) %>%
      select(`TensorFlow Prediction`, Image)
    
    return(df)
    
  }, ignoreNULL = FALSE)
  
  
  output$image_df <- DT::renderDataTable({
    DT::datatable(text_input(), escape = FALSE, options = list(dom = 't'))
  })

}

