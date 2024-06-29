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
daily_repo <- 
  read_excel(here("Data", "repo_rate.xlsx"), skip = 4) %>% 
  dplyr::select(-starts_with("BN")) %>% 
  rename(`Repo Rate` = PX_LAST)

# Cleaning ----------------------------------------------------------------
daily_repo_tbl <- 
  daily_repo %>%
  filter(Date >= "2010-01-01") %>% 
  filter(`Repo Rate` != "Closed") %>%
  filter(`Repo Rate` != 0) %>%
  mutate(`Repo Rate` = as.numeric(`Repo Rate`))

# Repo Changes ------------------------------------------------------------
daily_repo_changes_tbl <- daily_repo_tbl %>%
  mutate(Date = as.Date(Date)) %>% 
  arrange(Date) %>%
  mutate(`Change in Repo Rate` = `Repo Rate` - lag(`Repo Rate`, n = 1))
daily_repo_changes_tbl %>% tail(10)

# Announcement Days -------------------------------------------------------

announcement_days_vec <- 
  c(
    "2010-01-26", "2010-03-25", "2010-05-13", "2010-07-22", "2010-09-09", "2010-11-18",
    "2011-01-20", "2011-03-24", "2011-05-12", "2011-07-21", "2011-09-22", "2011-11-10",
    "2012-01-19", "2012-03-29", "2012-05-24", "2012-07-19", "2012-09-20", "2012-11-22",
    "2013-01-31", "2013-03-20", "2013-05-23", "2013-07-18", "2013-09-19", "2013-11-21",
    "2014-01-24", "2014-03-20", "2014-05-22", "2014-07-17", "2014-09-18", "2014-11-20",
    "2015-01-29", "2015-03-19", "2015-05-21", "2015-07-23", "2015-09-23", "2015-11-19",
    "2016-01-28", "2016-03-17", "2016-05-19", "2016-07-21", "2016-09-26", "2016-11-24",
    "2017-01-24", "2017-03-30", "2017-05-25", "2017-07-20", "2017-09-21", "2017-11-23",
    "2018-01-18", "2018-03-28", "2018-05-24", "2018-07-19", "2018-09-20", "2018-11-22",
    "2019-01-17", "2019-03-28", "2019-05-23", "2019-07-18", "2019-09-19", "2019-11-21",
    "2020-01-16", "2020-03-19", "2020-04-14", "2020-05-21", "2020-07-23", "2020-09-17", "2020-11-19",
    "2021-01-21", "2021-03-25", "2021-05-20", "2021-07-22", "2021-09-23", "2021-11-18",
    "2022-01-27", "2022-03-24", "2022-05-19", "2022-07-21", "2022-09-22", "2022-11-24",
    "2023-01-26", "2023-03-30", "2023-05-25", "2023-07-20", "2023-09-21", "2023-11-23",
    "2024-01-25", "2024-03-27", "2024-05-30"
  ) 


decision_vec <- announcement_days_vec %+time% "1 days"

decision_tbl <- 
  daily_repo_changes_tbl %>%
  dplyr::select(Date, `Change in Repo Rate`) %>%
  mutate(Decision = ifelse(`Change in Repo Rate` > 0, "Increase", "Decrease")) %>% 
  mutate(Decision = ifelse(`Change in Repo Rate` == 0, "No Change", Decision)) %>% 
  filter(Date %in% decision_vec) %>% 
  mutate(Date = Date %-time% "1 day") # to edit the next day holiday days manually

announcement_days_tbl <- daily_repo_changes_tbl %>% 
  dplyr::select(Date, `Repo Rate`) %>%
  filter(Date %in% announcement_days_vec) %>% 
  left_join(decision_tbl, by =  c("Date" = "Date"))

announcement_days_tbl

# Plotting ---------------------------------------------------------------
daily_repo_gg <- 
  daily_repo_tbl %>% 
  ggplot(aes(x = Date, y = `Repo Rate`)) +
  geom_line(color = "black") +
  labs(title = "Daily Repo Rate",
       x = " ",
       y = "Repo Rate") +
  theme_minimal() +
  theme(legend.position = "none")

repo_changes_gg <- 
  daily_repo_changes_tbl %>% 
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
    daily_repo_gg = daily_repo_gg,
    repo_changes_gg = repo_changes_gg,
    repo_changes_gg = repo_changes_gg,
    combined_gg = combined_gg
  )
)

write_rds(artifacts_announcement_days, here("Outputs", "artifacts_announcement_days.rds"))

