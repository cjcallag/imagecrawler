function(input, output, session){
  
  get_data <- eventReactive(input$in_file, {
    readRDS(input$in_file$datapath) 
  })
  
  output$dynamic_status <- renderUI({
    if (!is.null(get_data())) {
      
      df <- get_data()
      
      fluidRow(
        column(width = 12,
               valueBox(value    = NROW(df),
                        subtitle = "Records Ingested",
                        icon     = icon("info"),
                        color    = "light-blue",
                        width    = 12
                        ),
               valueBox(value    = NROW(preprocess_df(df, "screen_name", "created_at", "ext_media_url")),
                        subtitle = "Images Processed",
                        icon     = icon("images"),
                        color    = "blue",
                        width    = 12
               )
               )
      )
    }
    })
  
  output$image_df <- DT::renderDataTable({
    raw <- get_data() %>%
      preprocess_df(., "screen_name", "created_at", "ext_media_url")
    
    df <- build_df(raw$screen_name, raw$created_at, raw$ext_media_url)
    
    DT::datatable(df, escape = FALSE, rownames = FALSE,
                  filter = "top",
                  extensions = 'Buttons', options = list(
                    dom = 'Bfrtip',
                    buttons = c('copy', 'print')
                  )
                  )
  })

}

