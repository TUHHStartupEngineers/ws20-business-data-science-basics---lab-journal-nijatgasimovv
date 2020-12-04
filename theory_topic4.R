
library(readxl)
library(tidyverse)


bikes_tbl <- read_excel("data-science/00_data/01_bike_sales/01_raw_data/bikes.xlsx") %>%
  #Separating 1 column into 3 columns:
  separate(col    = category,
           into   = c("category.1", "category.2", "category.3"),
           sep    = " - ") %>%
  
  # Renaming columns - replacing dot with underlines
  set_names(names(.) %>% str_replace_all("\\.", "_"))

bikes_tbl %>%
  select(category_1:category_3, everything())

bikes_tbl %>%
  distinct(category_1)

bikes_tbl %>%
  distinct(category_1, category_2, category_3)


bike_orderlines_tbl <- read_rds("data-science/00_data/01_bike_sales/02_wrangled_data/bike_orderlines.rds")


bikeshop_revenue_tbl <- bike_orderlines_tbl %>%
  select(bikeshop, category_1, total_price) %>%
  
  group_by(bikeshop, category_1) %>%
  summarise(sales = sum(total_price)) %>%
  ungroup() %>%
  arrange(desc(sales))

bikeshop_revenue_formatted_tbl <- bikeshop_revenue_tbl %>%
  pivot_wider(names_from  = category_1,
              values_from = sales) %>%
  mutate(
    Mountain = scales::dollar(Mountain, big.mark = ".", decimal.mark = ",", prefix = "", suffix = " €"),
    Gravel = scales::dollar(Gravel, big.mark = ".", decimal.mark = ",", prefix = "", suffix = " €"),
    Road     = scales::dollar(Road, big.mark = ".", decimal.mark = ",", prefix = "", suffix = " €"),
    `Hybrid / City` = scales::dollar(`Hybrid / City`, big.mark = ".", decimal.mark = ",", prefix = "", suffix = " €"),
    `E-Bikes` = scales::dollar(`E-Bikes`, big.mark = ".", decimal.mark = ",", prefix = "", suffix = " €")
  )

order_dates_tbl <- bike_orderlines_tbl %>% select(1:3)
order_items_tbl  <- bike_orderlines_tbl %>% select(1:2,4:8)


order_dates_tbl %>%
  
  # By argument not necessary, because both tibbles share the same column names
  left_join(y = order_items_tbl, by = c("order_id" = "order_id", "order_line" = "order_line"))



train_tbl <- bike_orderlines_tbl %>%
  slice(1:(nrow(.)/2))

test_tbl <- bike_orderlines_tbl %>%
  slice((nrow(.)/2 + 1):nrow(.))



train_tbl <- train_tbl %>%
  bind_rows(test_tbl)











































