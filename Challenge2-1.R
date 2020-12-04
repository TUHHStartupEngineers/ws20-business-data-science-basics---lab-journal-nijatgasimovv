
# For this task, I will access to Deezer (music streaming platform) API and extract my Retro music playlist which I created in 2014.

# 1. Load the libraries

library(httr)
library(tidyverse)
library(jsonlite)
library(purrr)

# 2. Make request from API

resp <- GET("https://api.deezer.com/playlist/1000960231")
resp_content <- content(resp, as = "parsed")

# 3. Wrangle the obtained data

a <- resp_content[["tracks"]][["data"]] #Extract the list containing song information

#Extract song titles from the list
Titels <- a %>%
  map(purrr::pluck,"title") %>% 
  as_tibble("titel") %>% #save as tibble
  t() #list is given in rows, transverse it to column
  
#Extract album names from the list
Albums <- a %>%
  map(purrr::pluck, "album") %>%
  map(purrr::pluck, "title") %>%
  as_tibble("Album") %>%
  t()

#Extract the artist names from the list
Artists <- a %>%
  map(purrr::pluck, "artist") %>%
  map(purrr::pluck, "name") %>%
  as_tibble("Artist") %>%
  t()

#Extract links to individual songs
Links <- a %>%
  map(purrr::pluck, "link") %>%
  as_tibble("Link") %>%
  t()
   
#Finally, bind columns into a table and name them
Playlist <- bind_cols("Song"=Titels, "Album"= Albums, "Artist"=Artists, "Link"=Links)

