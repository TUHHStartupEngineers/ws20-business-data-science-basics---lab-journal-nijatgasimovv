# BUSINESS & MANAGEMENT / DATA SCIENCE CHALLENGE 1

# 1. Load libraries

library(tidyverse)
library(readxl)

# 2. Importing Excel data


bikes_c1_tbl <- read_excel(path = "00_data/01_bike_sales/01_raw_data/bikes.xlsx")
orderlines_c1_tbl <- read_excel(path = "00_data/01_bike_sales/01_raw_data/orderlines.xlsx")
bikeshops_c1_tbl  <- read_excel(path = "00_data/01_bike_sales/01_raw_data/bikeshops.xlsx")

# 3. Joining data


left_join(orderlines_tbl, bikes_tbl, by = c("product.id" = "bike.id"))


bike_orderlines_joined_c1_tbl <- orderlines_c1_tbl %>%
  left_join(bikes_c1_tbl, by = c("product.id" = "bike.id")) %>%
  left_join(bikeshops_c1_tbl, by = c("customer.id" = "bikeshop.id"))


# 4. Wrangling data

#create new data in which you wrangle combined data
bike_orderlines_wrangled_c1_tbl <- bike_orderlines_joined_c1_tbl %>%
  
  #separating into city and state categories
  separate(col    = location,
           into   = c("city", "state"),
           sep    = ", ") %>%
  
  #add new column to show total price  
  mutate(total.price = price * quantity) %>%
  
  #erase unneeded columns    
  select(-...1, -gender, -url, -lat, -lng, -frame.material, -weight)


# 5. Take out needed data

sales_by_state_c1_tbl <- bike_orderlines_wrangled_c1_tbl %>%
  select(state, total.price) %>% #select the columns you'll use
  group_by(state) %>% #group the rows based on common states
  summarize(sales = sum(total.price)) %>% #sum up the sales by state
  mutate(sales_text = scales::dollar(sales, big.mark = ".", 
                                     decimal.mark = ",", 
                                     prefix = "", 
                                     suffix = " €")) #turn the numbers to money format


# 6. Plot the graph

sales_by_state_c1_tbl %>%
  
  # Setup canvas with the columns state (x-axis) and sales (y-axis)
  ggplot(aes(x = state, y = sales)) + 
  geom_col(fill = "#2DC6D6") + # Use geom_col for a bar plot
  geom_label(aes(label = sales_text)) + # Adding labels to the bars
  scale_y_continuous(labels = scales::dollar_format(big.mark = ".", 
                                                    decimal.mark = ",", 
                                                    prefix = "", 
                                                    suffix = " €")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) #rotate the x-axis label







