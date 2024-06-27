# Description
# Cleaning bond data - Xolani Sibande 27 June 2024
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
bonds <- c(
  "R186",
  "R209",
  "R213",
  "R214",
  "2030",
  "2032",
  "2035",
  "2037",
  "2040",
  "2044",
  "2048",
  "2053"
)

paths <- map(bonds, ~here("Data", paste0(.x, ".xlsx")))

bonds_list <-
  paths %>% 
  set_names(bonds) %>%
  map(~ read_excel(path = ., skip = 6) %>% 
        dplyr::select(-YLD_CNV_LAST) %>% 
        rename(`Price` = PX_LAST) %>% 
        mutate(`Price` = as.numeric(`Price`)) %>% 
        mutate(Date = as.Date(Date)) %>% 
        arrange(Date) %>%
        filter(Date >= "2010-01-01") 
        )

# Cleaning -----------------------------------------------------------------


# Transformations --------------------------------------------------------


# EDA ---------------------------------------------------------------


# Graphing ---------------------------------------------------------------


# Export ---------------------------------------------------------------
artifacts_ <- list (

)

write_rds(artifacts_, file = here("Outputs", "artifacts_.rds"))


