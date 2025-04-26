# Install and load all packages 
library(tidyverse)
library(dplyr)
library(janitor)
library(knitr)
library(kableExtra)
library(dcData)
library(ggplot2)


# Read the data 
url1 <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/IMDB%20Gross.csv"
IMDB_Gross <- read.csv(url1, header = TRUE)

url2 <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/imdb_top_250_cost.csv"
IMDB_Rating <- read.csv(url2, header = TRUE)

# View and inspect the data
#view(IMDB_Gross)
#view(IMDB_Rating)
#print(colnames(IMDB_Gross))
print(colnames(IMDB_Rating))

# Remove unwanted columns/rows
IMDB_Gross <- IMDB_Gross %>%
  select(-c("Release.Date", "Domestic.Weekend.Gross", "Domestic.Weekend",
            "Domestic.Weekend.Gross.Date"))

IMDB_Rating <-IMDB_Rating %>%
  select(-c("X", "IMDB.link"))




