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

exchange_rate_list <- 
  sheet_list %>% 
  set_names(sheets) %>% 
  map(
    ~ read_excel(here("Data", "exchange_rates.xlsx"), skip = 3, sheet = .)  %>% 
      mutate(Date = as.Date(Date)) %>% 
      arrange(Date) %>% 
      rename(Price = Value)
  )

exchange_rate_list
# Cleaning -----------------------------------------------------------------


# Transformations --------------------------------------------------------


# EDA ---------------------------------------------------------------


# Graphing ---------------------------------------------------------------


# Export ---------------------------------------------------------------
artifacts_ <- list (

)

write_rds(artifacts_, file = here("Outputs", "artifacts_.rds"))


