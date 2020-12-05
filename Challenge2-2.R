

#1.0 LIBRARIES ----
  
library(tidyverse) # Main Package - Loads dplyr, purrr, etc.
library(rvest)     # HTML Hacking & Web Scraping
library(xopen)     # Quickly opening URLs
library(jsonlite)  # converts JSON files to R objects
library(glue)      # concatenate strings
library(stringi)   # character string/text processing
library(RSQLite)   # working with databases

# 2. Open category page 

# Arbitrarily chosen E-bike family, Mountainbike category

url_homepage <- "https://www.radon-bikes.de/e-bike/mountainbike/bikegrid/"
#xopen(url_homepage)
html_homepage <- read_html(url_homepage)


# 3. Scraping product ID's and prices

#Extract the product ID names
product_id_tbl <- html_homepage %>%
  #Get the nodes for the product names ...
  html_nodes(css = ".m-bikegrid__info .a-heading--small") %>%
  # ...and extract the text of the html attribute
  html_text() %>%
  # Delete the unnecessary formatting
  #str_replace_all("[\t\n\r\v\f]" , "") %>%
  # Delete whitespace
  trimws("both") %>%
  # Convert vector to tibble
  enframe(name = "position", value = "product_id")

#Extract the product prices
product_prices_tbl <- html_homepage %>%
  #Get the nodes for the product prices
  html_nodes(css = ".currency_eur> .m-bikegrid__price--active") %>%
  # ...and extract the information of the span attribute
  html_text("span") %>%
  # Convert vector to tibble
  enframe(name = "position", value = "product_prices")

#Bind two columns
mountainbike_list_tbl <- product_id_tbl %>%
  bind_cols(product_prices_tbl %>% select("product_prices"))

# 4. Creating database

con <- RSQLite::dbConnect(drv    = SQLite(), 
                           dbname = "data-science/00_data/Mountain_bikes.sqlite")

dbWriteTable(con, "product_id", product_id_tbl, overwrite=TRUE)
dbWriteTable(con, "product_prices", product_prices_tbl, overwrite=TRUE)

# 5. Call database

# Return the name of tables
dbListTables(con)

tbl(con, "product_id")

tbl(con, "product_prices")


dbDisconnect(con)
con


