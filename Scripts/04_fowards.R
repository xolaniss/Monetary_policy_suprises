# Description
# Cleaning up fowards data - Xolani Sibande on 27 July 2024
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
forwards <- c(
  "ZAR1M",
  "ZAR2M",
  "ZAR3M",
  "ZAR6M",
  "ZAR9M",
  "ZAR1Y"
)

paths = map(forwards, ~here("Data", paste0(.x, ".xlsx")))

forwards_tbl <-
  paths %>% 
  set_names(fowards) %>%
  map(~ read_excel(path = ., skip = 6) %>% 
        rename(`Price` = PX_LAST) %>% 
        arrange(Date)
  ) %>% 
  bind_rows(.id = "Foward") %>%
  mutate(Date = as.Date(Date)) %>%
  relocate(Foward, .after = Date)
        
# Graphing ---------------------------------------------------------------
forwards_gg <- 
  forwards_tbl %>%
  ggplot(aes(x = Date, y = Price, color = Foward)) +
  geom_line() +
  labs(title = "Foward Rates",
       x = "",
       y = "Rates") +
  theme_minimal() +
  theme(legend.position = "none") +
  facet_wrap(~Foward, scales = "free_y") +
  scale_color_manual(values = pnw_palette("Shuksan2", 6))
  

# Export ---------------------------------------------------------------
artifacts_forwards <- list (
  forwards_tbl = forwards_tbl,
  forwards_gg = forwards_gg
)

write_rds(artifacts_forwards, file = here("Outputs", "artifacts_forwards.rds"))


