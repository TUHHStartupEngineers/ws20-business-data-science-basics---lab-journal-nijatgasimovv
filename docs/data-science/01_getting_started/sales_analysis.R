# Data Science at TUHH ------------------------------------------------------
# SALES ANALYSIS ----

# 1.0 Load libraries ----

library(tidyverse)
library(readxl)
library(lubridate)

# 2.0 Importing Files ----

bikes_tbl <- read_excel(path = "00_data/01_bike_sales/01_raw_data/bikes.xlsx")
orderlines_tbl <- read_excel(path = "00_data/01_bike_sales/01_raw_data/orderlines.xlsx")
bikeshops_tbl  <- read_excel(path = "00_data/01_bike_sales/01_raw_data/bikeshops.xlsx")


# 3.0 Examining Data ----

orderlines_tbl
glimpse(orderlines_tbl)

# 4.0 Joining Data ----

left_join(orderlines_tbl, bikes_tbl, by = c("product.id" = "bike.id"))


bike_orderlines_joined_tbl <- orderlines_tbl %>%
  left_join(bikes_tbl, by = c("product.id" = "bike.id")) %>%
  left_join(bikeshops_tbl, by = c("customer.id" = "bikeshop.id"))

# 5.0 Wrangling Data ----
# All actions are chained with the pipe already. You can perform each step separately and use glimpse() or View() to validate your code. Store the result in a variable at the end of the steps.

#create new data in which you wrangle combined data
bike_orderlines_wrangled_tbl <- bike_orderlines_joined_tbl %>%

#separate category (they contain 3 names, each will have its own column now)  
  separate(col    = category,
           into   = c("category.1", "category.2", "category.3"),
           sep    = " - ") %>%
  
#add new column to show total price  
  mutate(total.price = price * quantity) %>%

#erase unneeded columns    
  select(-...1, -gender, -url, -lat, -lng) %>%
  
#re-order the columns  
  select(order.id, contains("order"), contains("model"), contains("category"),
         price, quantity, total.price,
         everything()) %>%
  
#rename dot character in column names with underscore.
  rename(bikeshop = name) %>%
  set_names(names(.) %>% str_replace_all("\\.", "_"))



# 6.0 Business Insights ----
# 6.1 Sales by Year ----

# Step 1 - Manipulate


sales_by_year_tbl <- bike_orderlines_wrangled_tbl %>%  #create the new database
  
  select(order_date, total_price) %>% #select the columns you'll use
  mutate(year = year(order_date)) %>% #add year column using lubridate
  group_by(year) %>% #groups the rows from 2015 to 2019
  summarize(sales = sum(total_price)) %>% #adds all 2015 rows and sums them up
  mutate(sales_text = scales::dollar(sales, big.mark = ".", 
                                     decimal.mark = ",", 
                                     prefix = "", 
                                     suffix = " €")) #turn the numbers to money format

  
# Step 2 - Visualize

sales_by_year_tbl %>%
  # Setup canvas with the columns year (x-axis) and sales (y-axis)
  ggplot(aes(x = year, y = sales)) +
  geom_col(fill = "#2DC6D6") + # Use geom_col for a bar plot
  geom_label(aes(label = sales_text)) + # Adding labels to the bars
  geom_smooth(method = "lm", se = FALSE) +  # Adding a trendline
  scale_y_continuous(labels = scales::dollar_format(big.mark = ".", 
                                                    decimal.mark = ",", 
                                                    prefix = "", 
                                                    suffix = " €")) +
  labs(
    title    = "Revenue by year",
    subtitle = "Upward Trend",
    x = "", # Override defaults for x and y
    y = "Revenue"
  )

  
  

# 6.2 Sales by Year and Category 2 ----

# Step 1 - Manipulate

sales_by_year_cat_1_tbl <- bike_orderlines_wrangled_tbl %>% #create database for visualisation
  select(order_date, total_price, category_1) %>% #select only given columns from original combined database
  
  mutate(year = year(order_date)) %>% #add a year column using lubridate
  
  group_by(year, category_1) %>%
  summarise(sales = sum(total_price)) %>%
  ungroup() %>%
  
  mutate(sales_text = scales::dollar(sales, big.mark = ".", 
                                     decimal.mark = ",", 
                                     prefix = "", 
                                     suffix = " €")) #formatting the money


# Step 2 - Visualize

sales_by_year_cat_1_tbl %>%
  ggplot(aes(x = year, y = sales, fill = category_1))+ #create the plot
  geom_col() + #define plot type
  facet_wrap(~ category_1)+ #to form a different plot for each bike category
  
  scale_y_continuous(labels = scales::dollar_format(big.mark = ".", 
                                                    decimal.mark = ",", 
                                                    prefix = "", 
                                                    suffix = " €")) + #formatting
  geom_smooth(method = "lm", se = FALSE) + # Adding a trendline
  
  
  labs(
    title = "Revenue by year and main category",
    subtitle = "Each product category has an upward trend",
    fill = "Main category" # Changes the legend name  #formatting
  )
  
  
  
# 7.0 Writing Files ----

# 7.1 Excel ----

install.packages("writexl")
library("writexl")
bike_orderlines_wrangled_tbl %>%
  write_xlsx("00_data/01_bike_sales/02_wrangled_data/bike_orderlines.xlsx")

# 7.2 CSV ----
bike_orderlines_wrangled_tbl %>% 
  write_csv("00_data/01_bike_sales/02_wrangled_data/bike_orderlines.csv")

# 7.3 RDS ----
bike_orderlines_wrangled_tbl %>% 
  write_rds("00_data/01_bike_sales/02_wrangled_data/bike_orderlines.rds")
