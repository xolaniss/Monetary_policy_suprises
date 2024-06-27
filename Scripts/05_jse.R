# Description
# Cleaning up assets data - Xolani Sibande on 27 July 2024
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
assets <- c(
  "all_share",
  "jset40",
  "jse_equity"
)

paths = map(assets, ~here("Data", paste0(.x, ".xlsx")))

assets_list <-
  paths %>% 
  set_names(assets) %>%
  map(~ read_excel(path = ., skip = 6) %>% 
        dplyr::select(-PX_VOLUME) %>%
        rename(`Price` = PX_LAST) %>% 
        arrange(Date)
  )

# Cleaning -----------------------------------------------------------------


# Transformations --------------------------------------------------------


# EDA ---------------------------------------------------------------


# Graphing ---------------------------------------------------------------


# Export ---------------------------------------------------------------
artifacts_ <- list (

)

write_rds(artifacts_, file = here("Outputs", "artifacts_.rds"))


