# HEADER =======================================================================
header <- dashboardHeader(title = "Deep Learning Image Classifier", 
                          titleWidth = 400,
                          tags$li(strong("CORE Lab"),
                                  style = "color:white;padding-top:15px; padding-bottom:5px;padding-right:15px",
                                  height = "30px",
                                  class = "dropdown")
                          )

# SIDEBAR ======================================================================
sidebar <- dashboardSidebar(width = 400,
                            sidebarMenu(
                              id = "tabs",
                             # Home --------------------------------------------
                             menuItem("Home", 
                                      tabName = "home", 
                                      icon = icon("home",
                                                  lib = "font-awesome")),
                             fileInput(inputId = "in_file",
                                       label = "Select dataset:",
                                       accept = c(".RDS"),
                                       width = "100%",
                                       buttonLabel = "Import",
                                       placeholder = "Import .RDS files..."),
                             tags$br(),
                             column(12,
                                    uiOutput("dynamic_status")
                             )
                             )
                           )

# BODY =========================================================================
body <- dashboardBody(
  tabItems(
    # Home ---------------------------------------------------------------------
    tabItem(tabName = "home",
            fluidRow(column(width = 12,
                            DT::dataTableOutput(outputId = "image_df") %>% 
                              withSpinner()
                            )
                     )
            )
    )
  )
    
# PAGE =========================================================================
dashboardPage(
  header,
  sidebar,
  body
)