

#1.0 LIBRARIES ----
  
library(tidyverse) # Main Package - Loads dplyr, purrr, etc.
library(rvest)     # HTML Hacking & Web Scraping
library(xopen)     # Quickly opening URLs
library(jsonlite)  # converts JSON files to R objects
library(glue)      # concatenate strings
library(stringi)   # character string/text processing

# 2. Collect product families

url_homepage <- "https://www.rosebikes.de/"
#xopen(url_homepage)
html_homepage <- read_html(url_homepage)

rosebike_family <- html_homepage %>%
  
  #Get nodes for the families
  html_nodes(css = ":nth-child(10) .catalog-categories-item__title , :nth-child(9) .catalog-categories-item__title, :nth-child(8) .catalog-categories-item__title, :nth-child(7) .catalog-categories-item__title, :nth-child(6) .catalog-categories-item__title, :nth-child(5) .catalog-categories-item__title, :nth-child(4) .catalog-categories-item__title, .mediumlarge-4:nth-child(3) .catalog-categories-item__title, .mediumlarge-4:nth-child(2) .catalog-categories-item__title, .mediumlarge-4:nth-child(1) .catalog-categories-item__title")


