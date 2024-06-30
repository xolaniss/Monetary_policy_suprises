# Description
# Cleaning up exchange rate data - Xolani Sibande on 27 July 2024
# Preliminaries -----------------------------------------------------------
# core
library(tidyverse)
library(readr)
library(readxl)
library(here)
library(lubridate)
library(xts)
library(broom)
library(glue)
library(scales)
library(kableExtra)
library(pins)
library(timetk)
library(uniqtag)
library(quantmod)

# graphs
library(PNWColors)
library(patchwork)

# eda
library(psych)
library(DataExplorer)
library(skimr)

# econometrics
library(tseries)
library(strucchange)
library(vars)
library(urca)
library(mFilter)
library(car)

# Functions ---------------------------------------------------------------
source(here("Functions", "fx_plot.R"))

# Import -------------------------------------------------------------
sheets <- excel_sheets(here("Data", "exchange_rates.xlsx"))
sheet_list <- as.list(sheets)

exchange_rate_tbl <- 
  sheet_list %>% 
  set_names(sheets) %>% 
  map(
    ~ read_excel(here("Data", "exchange_rates.xlsx"), skip = 3, sheet = .)  %>% 
      mutate(Date = as.Date(Date)) %>% 
      arrange(Date) %>% 
      rename(Price = Value)
  ) %>% 
  bind_rows(.id = "Exchange_rate") %>%
  relocate(Exchange_rate, .after = Date)

exchange_rate_tbl

# Graphing ---------------------------------------------------------------
exchange_rate_gg <- 
  exchange_rate_tbl %>% 
  ggplot(aes(x = Date, y = Price, color = Exchange_rate)) +
  geom_line() +
  theme_minimal() +
  labs(
    title = " ",
    x = "",
    y = "Rate"
  ) +
  theme(legend.position = "none") +
  facet_wrap(~Exchange_rate, scales = "free_y") +
  scale_color_manual(values = pnw_palette("Shuksan2", 4))
  
  

# Export ---------------------------------------------------------------
artifacts_exchange_rates <- list (
  exchange_rate_tbl = exchange_rate_tbl,
  exchange_rate_gg = exchange_rate_gg
)

write_rds(artifacts_exchange_rates, file = here("Outputs", "artifacts_exchange_rates.rds"))


