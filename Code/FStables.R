# Load packages:
library(dplyr)
library(janitor)
library(knitr)
library(kableExtra)

# Creating summary and frequency tables ------
url <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/JoinedIMDB.csv"
JoinedIMDB <- read.csv(url, header = TRUE)
view(JoinedIMDB)


# Inspecting a frequency table ----
# Find the most popular genres
TopGenres <- JoinedIMDB %>%
  count(main_genre, sort = TRUE) %>%
  slice_head(n = 4) %>%
  pull(main_genre)

# Create a new Decade column
JoinedIMDB <- JoinedIMDB %>%
  mutate(Decade = (Year %/% 10) * 10)

IMDBTable <- JoinedIMDB %>%
  filter(main_genre %in% TopGenres) %>%
  tabyl(main_genre, Decade) %>% #make freq using TopGenres and Decades
  adorn_totals(where = c("row", "col")) %>% #add total col and row
  adorn_percentages(denominator = "all") %>% #make sure the deno is all female
  adorn_pct_formatting(digits = 2) %>%
  #get the row/column title
  adorn_title(
    placement = "combined",
    row_name = "Top Genres",
    col_name = "Decade"
  ) %>%
  adorn_ns(position = "front")
# Display the small table
IMDBTable %>%
  kable(
    caption = "The Top Genres over the decades",
    booktabs = TRUE,
    align = c("l", rep("c", 6))
  ) %>%
  kableExtra::kable_styling(
    bootstrap_options = c("striped", "condensed"),
    font_size =  12
  ) %>%
  row_spec(0, bold=TRUE, background = "lightblue" )




