function(input, output, session){
  
  # url_text <- c("https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/08/28/22/north-korea-missile-hwasong14.jpg",
  #               "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Challenger_2_Main_Battle_Tank_patrolling_outside_Basra%2C_Iraq_MOD_45148325-_Grey_Background.png/1200px-Challenger_2_Main_Battle_Tank_patrolling_outside_Basra%2C_Iraq_MOD_45148325-_Grey_Background.png",
  #               "http://nationalinterest.org/files/styles/main_image_on_posts/public/main_images/f22_mizokami.jpg?itok=Mt9xHhSt",
  #               "http://auto.ferrari.com/en_US/wp-content/uploads/sites/7/2016/09/ferrari-laferrari-aperta-2016-gallery-prew-1-tr.jpg")
  
  text_input <- eventReactive(input$submit, {
    validate(need(str_detect(input$text_input1, valid_path_regex),
                  invalid_path_message))
    validate(need(str_detect(input$text_input2, valid_path_regex),
                  invalid_path_message))
    validate(need(str_detect(input$text_input3, valid_path_regex),
                  invalid_path_message))
    
    url_text <- c(input$text_input1, input$text_input2, input$text_input3)
    

    df <- map_df(url_text, build_df) %>%
      select(prediction, image)
    
    return(df)
  }, ignoreNULL = FALSE)
  
  
  output$image_df <- DT::renderDataTable({
    DT::datatable(text_input(), escape = FALSE, options = list(dom = 't'))
  })

}

