# Description
# Cleaning up commodities data - Xolani Sibande on 27 July 2024
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
commodities <- c(
  "alluminium", 
  "copper", 
  "gold_spot", 
  "coal", 
  "platinum_spot", 
  "silver_spot", 
  "zinc",
  "lead",
  "nickel",
  "palladium_spot")

paths <- map(commodities, ~here("Data", paste0(.x, ".xlsx")))

commodities_tbl <-
  paths %>% 
  set_names(commodities) %>%
  map(~ read_excel(path = ., skip = 6) %>% 
        dplyr::select(-PX_VOLUME) %>% 
        rename(`Price` = PX_LAST) %>% 
        mutate(`Date` = as.Date(`Date`)) %>% 
        arrange(Date) %>% 
        filter(Date >= "2010-01-01")
      ) %>%
  bind_rows(.id = "Commodity") %>% 
  relocate(Commodity, .after = Date) 


# Graphing ---------------------------------------------------------------
commodities_gg <- 
  commodities_tbl %>% 
  mutate(Commodity = str_replace_all(Commodity, "_spot", "")) %>%
  mutate(Commodity = str_to_title(Commodity)) %>%
  ggplot(aes(Date, Price, color = Commodity)) +
  geom_line() +
  theme_minimal() +
  theme(legend.position = "none") +
  labs(title = "Commodities Prices",
       x = "",
       y = "Price",
       ) +
  facet_wrap(~Commodity, scales = "free_y") +
  scale_color_manual(values = pnw_palette("Shuksan2", 10))


# Export ---------------------------------------------------------------
artifacts_commodities <- list (
  commodities_tbl = commodities_tbl,
  commodities_gg = commodities_gg
)

write_rds(artifacts_commodities, file = here("Outputs", "artifacts_commodities.rds"))


