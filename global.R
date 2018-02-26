library(shinydashboard)
library(htmlwidgets)
library(htmltools)
library(tidyverse)
library(rvest)
library(DT)
library(keras); use_condaenv("r-tfgpu")

# crawl images.... need faster solution
# target_site <- "https://www.middlebury.edu/institute"
# crawl_images <- function(target_site){
#   stem_url <- XML::parseURI(target_site)$server
#   
#   raw_img_urls <- target_site %>%
#     read_html() %>%
#     html_nodes("img") %>%
#     html_attr("src") %>%
#     paste0(stem_url, .)
#   
#   clean_img_urls <- raw_img_urls %>%
#     map(~ str_replace(.x, "(\\.(jpe*g|JPE*G|png|PNG)).*$", "\\1"))
# }


valid_path_regex <- "/[A-z0-9-_]+\\.(jpe*g|JPE*G|png|PNG)$" 

invalid_path_message <- "One of your URLs is not a valid image. Please submit image URLs ending in .jpg or .png."

safe_download <- safely(download.file)

model <- load_model_hdf5("sample_models/test_mod.h5")

process_image <- function(img_path){
  # load the image
  img_path <- img_path
  img <- image_load(img_path, target_size = c(224,224))
  x <- image_to_array(img)
  
  # 4d tensor with single an element in batch dim,
  x <- array_reshape(x, c(1, dim(x)))
  x <- imagenet_preprocess_input(x)
  
  # make predictions and decode
  preds <- model %>% predict(x)
  imagenet_decode_predictions(preds, top = 1)[[1]]$class_description
}



build_df <- function(url_text){
  temp_dir <- tempdir()
  
  temp_path <- paste0(temp_dir, str_extract(url_text, valid_path_regex))
  
  safe_download(url_text,
                temp_path, 
                mode = "wb")
  
  url_image <- paste0('<a href = "', url_text, '" target="_blank">',
                      '<img src = "', url_text, '" height="300">', '</a>')
  
  df <- tibble(Image = url_image,
               `TensorFlow Prediction` = process_image(temp_path))
  
  rm(temp_dir)
  rm(temp_path)
  
  return(df)
}