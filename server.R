#' Server function of BNV-DS shiny application
#'
#'
#' This application aims at allowing the user to extract specific subset of BNV-DS data stored
#' as postgres database
#'
#'
#' @param input Only for fun
#' @param output  Only for fun
#' @param session  Only for fun (but necessary to update selectors)
#'
#' @return Server functionnalities
#' @export
#'
#' @examples  function(input, output, session)
function(input, output, session) {
  # Line for helper
  observe_helpers(withMathJax = TRUE)

  # depending of radio button (defined in ui) switch from drop-down to list
  output$my_input <- renderUI({
    if (input$input_type == "select") {
      # si on check "list":
      input_selecter(
        id ="subs",
        label = "Sélectionnez une substance",
        my_choices = c("Tout", u_subs)
      )
    } else {
      textAreaInput("subs", "Renseignez une liste de substances :")
    }
  }) # END renderui

  area_text <- reactive({
    if (input$input_type == "text") {
    parsed_data <- unlist(strsplit(subs, ";"))
    }
    else{
      #nothing
    }
  })
  result <- eventReactive(input$run_query_limited, {
    # input selecter must have entries
    validate(need(!is.null(input$subs) &
                    !is.null(input$ocs) &
                    !is.null(input$fonc) &
                    !is.null(input$class),
                  "Tous les paramètres de sélection doivent être renseignés"))
    # Build the SQL query using the selected values
    query <- "SELECT * FROM bnvds.com_occsol_qsa2020 WHERE 1=1"
    query <-
      #FONCTION
      paste0(query, ifelse(
        all(input$fonc != "Tout"),
        paste0(
          " AND fonction IN ('",
          paste0(input$fonc, collapse = "','"),
          "')"
        ),
        ""
      ))
    #CLASSIFICATION
    query <-
      paste0(query, ifelse(
        all(input$class != "Tout"),
        paste0(
          " AND classification IN ('",
          paste0(input$class, collapse = "','"),
          "')"
        ),
        ""
      ))
    #SUBSTANCE
    # Si la liste est passée par le textAreaInput :
    if (input$input_type == "text") {
      area_text <- unlist(strsplit(input$subs, ";"))
      area_text <- gsub("'", "''", area_text) # gestion du cas où il y a des single quotes
      query <- paste0(query, ifelse(
        all(input$subs != "Tout"),
        paste0(
          " AND substance IN ('",
          paste0(area_text, collapse = "','"),
          "')"
        ),
        ""
      ))
      # Si la liste est passée par le textAreaInput :
    } else {
      query <- paste0(query, ifelse(

        all(input$subs != "Tout"),
        paste0(
          " AND substance IN ('",
          paste0(gsub("'", "''", input$subs), collapse = "','"),# gestion du cas où il y a des single quotes (nested)
          "')"
        ),
        ""
      ))
    }
    #OCS
    query <- paste0(query, ifelse(
      all(input$ocs != "Tout"),
      paste0(" AND occ_sol IN ('",
             paste0(input$ocs, collapse = "','"),
             "')"),
      ""
    ))
    query_limited <- query
    result_limited <- dbGetQuery(con, query_limited)

    # Print the resulting SQL query
    print(query_limited)
    # Return
    result_limited
  })
  # Render table output
  output$mytable <- DT::renderDataTable(result(),
                                        options = list(scrollX = TRUE),
                                        rownames = FALSE)

  # Define the download handler
  output$download <- downloadHandler(
    filename = function() {
      paste("data_", Sys.Date(), input$formats, sep = "")
    },
    content = function(file) {
      write.csv(result(), file, row.names = FALSE)
    }
  )


  #---------- MAP PART ------------#


  # Read the shapefile using sf package
  shapefile <-
    st_read("data/ign_admin_com_202002_4326_simplified_limited_.geojson")
  # Create the leaflet map
  output$map <- renderLeaflet({
    validate(
      need(input$run_query_limited, 'Réalisez votre requête d\'abord!'),
    )
    leaflet() %>%
      addTiles() %>%
      addPolygons(
        data = shapefile,
        layerId = ~ INSEE_COM,
        weight = 1,
        #option pour changer le contour au survol
        highlightOptions = highlightOptions(color = "yellow",
                                            weight = 2,
                                            fillColor = 'yellow',
                                            bringToFront = TRUE),
        color = "black",
        opacity = 1,
        fillColor = "transparent"

    )
  })

  #---------- CHART PART ------------#

  # Create drop-down lists from "results" columns
  observe({
    #On osrt les noms des colones numériques ou les noms des colones de type string
    col_names_num <- colnames(result())[sapply(result(), is.numeric)]
    non_numeric_cols <- dplyr::select_if(result(), function(x) !is.numeric(x))
    non_numeric_colnames <- names(non_numeric_cols)

    updateSelectInput(session, "plotvar_sel_x",  choices = non_numeric_colnames)
    updateSelectInput(session, "plotvar_sel_y",  choices = col_names_num)
  })


  # Filter data based on clicked shape and create plot
  output$plot <- renderPlotly({
    if (!is.null(input$map_shape_click)) {
      # Get the value of the clicked shape's INSEE_COM property
      clicked_shape_id <- input$map_shape_click$id
      # Filter the data based on the clicked shape's INSEE_COM property
      filtered_data <-
        result() %>% filter(com_adm == clicked_shape_id)
      print(filtered_data)
      validate(need(nrow(filtered_data) > 0, "Il n'y a pas de données sur cette commune"))
      # Create a plot based on the filtered data
      plot_ly(
        filtered_data,
        # Data from drop-down lists
        x =  ~get(input$plotvar_sel_x),
        y =  ~get(input$plotvar_sel_y),
        type = "bar"
      ) %>%
        layout(
               title = paste0("Données pour la commune ",  clicked_shape_id),
               plot_bgcolor = "#e5ecf6",
               # axis names from drop-down lists
               xaxis = list(title = input$plotvar_sel_x),
               yaxis = list(title = input$plotvar_sel_y))

    }
  })
}

