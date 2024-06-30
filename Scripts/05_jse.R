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

assets_tbl <-
  paths %>% 
  set_names(assets) %>%
  map(~ read_excel(path = ., skip = 6) %>% 
        dplyr::select(-PX_VOLUME) %>%
        rename(`Price` = PX_LAST) %>% 
        arrange(Date)
  ) %>% 
  bind_rows(.id = "Asset") %>%
  mutate(Date = as.Date(Date)) %>% 
  relocate(Asset, .after = Date)

# Graphing ---------------------------------------------------------------
assets_gg <- 
  assets_tbl %>% 
  mutate(Asset = str_replace_all(Asset, "_", " ")) %>% 
  mutate(Asset = str_to_title(Asset)) %>%
  mutate(Asset = str_replace_all(Asset, "Jse", "JSE")) %>% 
  mutate(Asset = str_replace_all(Asset, "All Share", "JSE All Share")) %>%
  mutate(Asset = str_replace_all(Asset, "JSEt40", "JSE Top 40")) %>%
  ggplot(aes(x = Date, y = Price, color = Asset)) +
  geom_line() +
  theme_minimal() +
  labs(title = "JSE Indices",
       x = "",
       y = "Index") +
  theme(legend.position = "none") +
  facet_wrap(~Asset, scales = "free_y") +
  scale_color_manual(values = pnw_palette("Shuksan2", 3))
  

# Export ---------------------------------------------------------------
artifacts_assets <- list (
  assets_tbl = assets_tbl,
  assets_gg = assets_gg
)

write_rds(artifacts_assets, file = here("Outputs", "artifacts_assets.rds"))


