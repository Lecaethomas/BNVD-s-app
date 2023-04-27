#' Selecteur d'input (drop-down list)
#'
#' @param id character. The id of the div
#' @param label character. The label to be displayed above the selecter
#' @param my_choices vector. The list of choices
#'
#' @return a ui element corresponding to selectInput using pre-defined parameters
#' @export
#'
#' @examples input_selecter(id ="subs",label = "Sélectionnez une substance", my_choices = c("Tout", u_subs))
input_selecter <- function(id, label, my_choices) {
  selectInput(
    id, label, choices= c("Tout", my_choices) , multiple = TRUE
  )
}
