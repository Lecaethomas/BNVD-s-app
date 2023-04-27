library(RPostgres)
library(dbplyr)
library(dplyr)
library(DT)
library(shinycssloaders)
library(stringr)
library(shiny)
library(bslib)
library(shinyhelper)
library(plotly)
library(sf)
library(leaflet)
source("R/input_selector.R")

####### RPostgres#########
Sys.setenv(PGGSSENCMODE = "disable")
con <- dbConnect(
  RPostgres::Postgres(),
  dbname = 'postgres',
  host = 'localhost',
  port = 5432,
  user = 'postgres',
  password = 'admin'
)

# create fonctions table
query_fonc <- 'SELECT * FROM "bnvds"."unique_fonction_qsa_2020"'
u_fonc <- data.frame(dplyr::tbl(con, dplyr::sql(query_fonc)))

# create classification table
query_class <-
  'SELECT * FROM "bnvds"."unique_classification_qsa_2020"'
u_class <- data.frame(dplyr::tbl(con, dplyr::sql(query_class)))

# create substance table
query_subs <- 'SELECT * FROM "bnvds"."unique_substance_qsa_2020"'
u_subs <- data.frame(dplyr::tbl(con, dplyr::sql(query_subs)))

# create landcover table
query_ocs <- 'SELECT * FROM "bnvds"."unique_ocs_qsa_2020"'
u_ocs <- data.frame(dplyr::tbl(con, dplyr::sql(query_ocs)))