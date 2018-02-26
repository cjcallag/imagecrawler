# HEADER ====
header <- dashboardHeader(title = "Deep Learning Image Classifier", 
                          titleWidth = 500,
                          tags$li(strong("Brendan Knapp"),
                                  style = "color:white;padding-top:15px; padding-bottom:5px;",
                                  height = "30px",
                                  class = "dropdown"),
                          tags$li(a(href = "https://twitter.com/syknapptic",
                                    target = "_blank",
                                    img(src = "twitter_logo.png",
                                        title = "Twitter",
                                        height = "30px"),
                                    style = "padding-top:10px; padding-bottom:10px;"),
                                  class = "dropdown")
                          )

sidebar <- dashboardSidebar(width = 500,
                            sidebarMenu(
                              id = "tabs",
                             #* home ====
                             menuItem("Home", 
                                      tabName = "home", 
                                      icon = icon("home", lib = "font-awesome")),
                             textInput(inputId = "text_input1", width = "100%",
                                       label = "Input Image URL:",
                                       value = "https://s3-us-west-2.amazonaws.com/warisboring.com/images/ZTQ-Light-Tank-3.jpg"
                             ),
                             textInput(inputId = "text_input2", width = "100%",
                                       label = "Input Image URL:",
                                       value = "https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/08/28/22/north-korea-missile-hwasong14.jpg"
                             ),
                             textInput(inputId = "text_input3", width = "100%",
                                       label = "Input Image URL:",
                                       value = "https://cdn.cnn.com/cnnnext/dam/assets/140224213401-a-10-warthog-jet-super-169.jpg"
                             ),
                             actionButton("submit", "Submit")
                             )
                           )

# BODY ====
body <- dashboardBody(
  tabItems(
    #* home ====
    tabItem(tabName = "home",
            fluidRow(column(width = 12,
                            DT::dataTableOutput(outputId = "image_df")
                            ))
            )
    )
  )
    
  


# PAGE ====
dashboardPage(
  header,
  sidebar,
  body
)