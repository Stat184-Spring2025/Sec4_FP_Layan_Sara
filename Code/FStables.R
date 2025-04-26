#Load Packages
library(kableExtra)
library(knitr)
library(tidyverse)
library(dplyr)

# Creating summary and frequency tables ------

url <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/JoinedIMDB.csv"
JoinedIMDB <- read.csv(url, header = TRUE)

# Inspecting a frequency table ----








#Creating a summary table ----

budget_summary <- JoinedIMDB%>%
  group_by(company)%>%  #groups the data by company name
  summarise(   #summarises the data by the 8 statistics
    film_count = n(),
    min_budget = min(budget, na.rm = TRUE),
    Q1_budget = quantile(budget, 0.25, na.rm = TRUE),
    median_budget = median(budget, na.rm = TRUE),
    Q3_budget = quantile(budget, 0.75, na.rm = TRUE),
    mean_budget = mean(budget, na.rm = TRUE),
    max_budget = max(budget, na.rm = TRUE),
    sd_budget = sd(budget, na.rm = TRUE)
  ) %>%
  arrange(desc(film_count))%>%  #arranges data by film count
  slice_head(n=4)%>%
  select(-film_count)

#Styling the summary table----
budget_summary%>%
  kable(
    caption = "Budget Summary By Company",
    booktabs = TRUE,
    align = c("l", rep("c",8))
  )%>%
  kableExtra::kable_styling(
    bootstrap_options = c("striped","hover"),
    font_size = 16
  )%>%
  row_spec(0, bold = TRUE, background = "lightyellow")%>%
  column_spec(1, italic = TRUE, background = "lightgrey")

