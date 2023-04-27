
fluidPage(
  theme = bs_theme(version = 4, bootswatch = "minty"),
  # Application title
  titlePanel("Spatialisation des ventes de pesticides", windowTitle = "BNVD-s"),
  tabsetPanel(
    tabPanel("Sélection des données", br(),
      input_selecter('years', "Sélectionnez vos années :", my_choices = NULL),
      fluidRow(
        br(),
        column(
          3,
          h4("Paramètres de sélection :"),
          radioButtons(
            "input_type",
            "Selectionnez le type de selecteur :",
            choices = list("Liste" = "select", "Texte" = "text")
          ) %>%
            helper(
              type = "inline",
              title = "Inline Help",
              content = "Drop-down = liste,
                        Text = entrée manuelle",
              buttonLabel = "Got it!",
              easyClose = FALSE,
              fade = TRUE,
              size = "s"
            )
        ),
        column(3,
               #Render selectInput or textInput depending on checkbox choice:
               uiOutput("my_input"), ),
        column(
          3,
          input_selecter(
            id = 'ocs',
            label = "Choisissez vos occupation du sol : ",
            my_choices = u_ocs
          )
        ),
        column(
          3,
          input_selecter(
            id = 'fonc' ,
            label = "Choisissez les fonctions : ",
            my_choices = u_fonc
          )
        ),
        column(3,
               ),
        column(
          3,
          input_selecter(
            id = 'class' ,
            label = "Choisissez les classifications : ",
            my_choices = u_class
          )
        )
      ),
      br()
      ,
      fluidRow(
        column(3,
               h4("Paramètres de sortie :")),
        column(
          3,
          input_selecter(
            id = 'outScales' ,
            label = "Choisissez les échelles : ",
            my_choices = ""
          )
        ),
        column(
          3,
          selectInput(
            inputId = "detailled",
            label = "Détaillé par : ",
            choices = NULL
          )
        ),
        column(
          3,
          selectInput(
            inputId = "formats",
            label = "Formats d'export : ",
            choices = c(".csv", ".xlsx")
          )
        ),
        br()
      ),
      # Add an action button
      fluidRow(column(
        2,
        actionButton(inputId = "run_query_limited", label = "Run query")
      ),
      column(
        2,
        downloadButton("download", "Download")
      )),
      br(),
      # Display the result of the query
      withSpinner(
        DT::dataTableOutput("mytable"),
                  type = 4
      )
      ),#END #1 tabPanel
    tabPanel("Cartographie",
             fluidPage(
               br(),
               fluidRow(
                 column(3,
                        
                        selectInput(inputId = "plotvar_sel_x", label =  "Choisissez la variable à représenter en abscisse :", choices = NULL),
                        selectInput(inputId = "plotvar_sel_y", label =  "Choisissez la variable à représenter en ordonnée :", choices = NULL)
                        
                        
                        ),
                 column(9,
               withSpinner(
               leafletOutput("map"),
               type = 4),
               br(),
               plotlyOutput("plot")
               )
               )
             )
    )
    )##End tabsetPanel
  )#END fluidpage

  
  