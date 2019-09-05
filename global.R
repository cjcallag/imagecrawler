library(shinydashboard)
library(htmlwidgets)
library(htmltools)
library(tidyverse)
library(DT)
library(keras)
library(rtweet)
library(shinycssloaders)

valid_path_regex <- "/[A-z0-9-_]+\\.(jpe*g|JPE*G|png|PNG)$" 

invalid_path_message <- "One of your URLs is not a valid image. Please submit image URLs ending in .jpg or .png."

safe_download <- safely(download.file)
safe_image_load <- safely(image_load)

model <- load_model_hdf5("sample_models/test_mod.h5") # swap to other models

query_tweets <- function(query, n) {
  
  if (!is.numeric(n)) {
    stop("n given is not a number.",
         call. = FALSE)
  }
  if (!is.character(query)) {
    stop("query is not a character.",
         call. = FALSE)
  }
  
  raw_query <- rtweet::search_tweets(q = query,
                                     n = n)
  raw_query
} 

process_image <- function(url_text) {
  
  temp_dir <- tempdir()
  temp_path <- paste0(temp_dir, str_extract(url_text, valid_path_regex))
  
  safe_download(url_text,
                temp_path, 
                mode = "wb")
  # load the image
  img <- safe_image_load(temp_path, target_size = c(224,224))
  
  if (is.null(img$result)) {
    guess <- "No image to guess."
    return(guess)
  }

  x <- image_to_array(img$result)
  # 4d tensor with single element in batch dim
  x <- array_reshape(x, c(1, dim(x)))
  x <- imagenet_preprocess_input(x)
  
  # make predictions and decode
  preds <- model %>% predict(x)
  
  guess <- imagenet_decode_predictions(preds, top = 1)[[1]]$class_description
  return(guess)
  
  rm(temp_dir)
  rm(temp_path)
}

preprocess_df <- function(df, screen_name, created_at, url_list_column) {
  
  out_cols <- syms(c(screen_name, created_at, url_list_column))
  
  processed_df <- df %>%
    select(!!!out_cols) %>%
    unnest() %>%
    drop_na()
  
  processed_df
}

build_df <- function(screen_name, created_at, url_text) {
  
  temp_dir <- tempdir()
  
  temp_path <- paste0(temp_dir, str_extract(url_text, valid_path_regex))
  
  safe_download(url_text,
                temp_path, 
                mode = "wb")
  
  url_image <- paste0('<a href = "', url_text, '" target="_blank">',
                      '<img src = "', url_text, '" height="300">', '</a>')
  
  df <- tibble(Source = screen_name,
               Date   = created_at,
               Image  = url_image,
               `TensorFlow Prediction` = lapply(url_text, process_image)
  ) %>%
    unnest()
  
  return(df)
}