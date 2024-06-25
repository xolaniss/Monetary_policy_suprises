# Description -------------------------------------------------------------
# Data cleaning Daily Repo for herding paper on 28 March 2022 - Xolani Sibande

# Packages ----------------------------------------------------------------
library(tidyverse)
library(readr)
library(readxl)
library(here)
library(lubridate)
library(xts)
library(tseries)
library(broom)
library(glue)
library(vars)
library(PNWColors)
library(patchwork)
library(psych)
library(kableExtra)
library(strucchange)
library(timetk)
library(purrr)
library(pins)
library(fDMA)


# Functions ---------------------------------------------------------------
source(here("Functions", "fx_plot.R"))


# Import ------------------------------------------------------------------
daily_repo <- read_excel(here("Data", "repo_daily.xlsx"), skip = 4) %>% 
  rename( Date = Unit,  `Repo Rate` = Percentage)

# Cleaning ----------------------------------------------------------------
daily_repo_tbl <- 
  daily_repo %>%
  filter(Date > "2010-01-01") %>% 
  filter(`Repo Rate` != "Closed") %>% 
  filter(`Repo Rate` != 0) %>% 
  mutate(`Repo Rate` = as.numeric(`Repo Rate`))

# Repo Changes ------------------------------------------------------------
daily_repo_changes_tbl <- daily_repo_tbl %>%
  mutate(`Change in Repo Rate` = `Repo Rate` - lag(`Repo Rate`)) %>% 
  drop_na() 

# Announcement Days -------------------------------------------------------
announcement_days_tbl <- daily_repo_changes_tbl %>% 
  filter(`Change in Repo Rate` != 0) %>% 
  mutate(Announcement = ifelse(`Change in Repo Rate` > 0, "Increase", "Decrease")) %>% 
  mutate(Announcement = ifelse(`Change in Repo Rate` == 0, "No Change", Announcement)) %>% 
  filter(Announcement != "No Change")

announcement_days_tbl
# Plotting ---------------------------------------------------------------
daily_repo_gg <- daily_repo_tbl %>% 
  ggplot(aes(x = Date, y = `Repo Rate`)) +
  geom_line(color = "black") +
  labs(title = "Daily Repo Rate",
       x = " ",
       y = "Repo Rate") +
  theme_minimal() +
  theme(legend.position = "none")

repo_changes_gg <- daily_repo_changes_tbl %>% 
  ggplot(aes(x = Date, y = `Change in Repo Rate`)) +
  geom_line(color = "black") +
  geom_point(color = "black") +
  labs(title = "Daily Repo Rate Changes",
       x = " ",
       y = "Change in Repo Rate") +
  theme_minimal() +
  theme(legend.position = "none")

combined_gg <- daily_repo_gg + repo_changes_gg
combined_gg

# Export ------------------------------------------------------------------
artifacts_announcement_days <- list(
  data = list(daily_repo_tbl = daily_repo_tbl,
  daily_repo_changes_tbl = daily_repo_changes_tbl,
  daily_repo_gg = daily_repo_gg,
  announcement_days_tbl = announcement_days_tbl
  ),
  plots = list(
    repo_changes_gg = repo_changes_gg,
    combined_gg = combined_gg
  )
)

write_rds(artifacts_announcement_days, here("Outputs", "artifacts_announcement_days.rds"))

