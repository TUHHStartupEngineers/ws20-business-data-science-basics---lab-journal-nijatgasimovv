library(tidyverse)
library(RSQLite)
con <- RSQLite::dbConnect(drv    = SQLite(), 
                          dbname = "data-science/00_data/02_chinook/Chinook_Sqlite.sqlite")
library(httr)

album_tbl <- tbl(con, "Album") %>% collect()


dbDisconnect(con)
con

resp <- GET("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=WDI.DE")

library(glue)
token <- "ICHISJDBEWTZXJOU"
response <- GET(glue("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=WDI.DE&apikey={token}"))




url <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
library(rvest)
sp_500 <- url %>%
  read_html() %>%
  html_nodes(css = "#constituents") %>%
  html_table() %>%
  .[[1]] %>% 
  as_tibble()
  


#url2 <- "https://www.imdb.com/chart/top/?ref_=nv_mv_250"
library(rvest)

resp2 <- GET(url = "https://www.imdb.com/chart/top/?ref_=nv_mv_250",  
             add_headers('Accept-Language' = "en-US, en;q=0.5")) 
url2 <- content(resp2)

titles <- url2 %>%
  read_html() %>%
  html_nodes(".titleColumn > a") %>%
  html_text() #%>%
  #.[[1]] %>% 
  #as_tibble()




rank <- url2 %>%
  read_html() %>%
  html_nodes(".titleColumn") %>%
  html_text() %>%
  stringr::str_extract("(?<= )[0-9]*(?=\\.\\n)")%>% 
  as.numeric()

year <- url2 %>%
  read_html() %>%
  html_nodes(".titleColumn .secondaryInfo") %>%
  html_text() %>%
  stringr::str_extract(pattern = "[0-9]+") %>% 
  as.numeric()

people <- url2 %>%
  read_html() %>%
  html_nodes(".titleColumn >a") %>%
  #html_text() %>% #it's not written in the text, it's attributed.
  html_attr("title") %>%
  as_tibble()

ratings <- url2 %>%
  read_html() %>%
  html_nodes(css = ".imdbRating >strong") %>%
  html_text() %>%
  as.numeric()

num_ratings <- url2 %>%
  read_html() %>%
  html_nodes(css = ".imdbRating >strong") %>%
  html_attr("title") %>%
  stringr::str_extract("(?<=based on ).*(?=\ user ratings)" ) %>%
  stringr::str_replace_all(pattern = ",", replacement = "") %>% 
  as.numeric()

imdb_tbl <- tibble(rank, titles, year, people, ratings, num_ratings)



library(jsonlite)
bike_data_lst <- fromJSON("bike_data.json")
