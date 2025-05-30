# Exploring Factors Influencing Movie Success

This repository includes the datasets, code, and visualizations for our STAT 184 final project, where we explored various factors that influence a movie’s success using Exploratory Data Analysis (EDA). The project examined elements such as genres, stars, and production companies, and through our analysis, we discovered several interesting patterns and results.


## Overview

Building on that analysis, the goal of our project was to uncover deeper insights into what drives both critical and financial success in the film industry. We focused on identifying measurable patterns across different dimensions of movie data, guided by three key research questions:

1) How do audience ratings compare across the five most common movie genres?

2) Which top studios have the best return on investment, and is there a relationship between movie budget and profit?

3) Which stars appear most frequently in successful movies, and does the presence of specific stars tend to be linked to higher movie success?

By exploring these questions, we aimed to better understand how different attributes, such as creative decisions, casting, and production investment, shape a film’s performance. This project offers a data-driven perspective for anyone interested in the intersection of storytelling, business strategy, and audience response within the movie industry.

### Interesting Insight

An interesting key insight we found was that drama films consistently outperformed other genres in terms of audience ratings. As shown in the box plot below, dramas had the highest median rating and the most consistent performance. In contrast, horror films tended to receive lower and more variable ratings, indicating that some people loved them, others really didn’t. We also observed that comedy, while moderately rated on average, had a notably high number of outliers, both high and low, showing that audience reactions to comedy can be much more mixed.

![e2f4cbea-a6c7-4f66-b6de-80f79535c935](https://github.com/user-attachments/assets/f7446c08-9d80-424f-98a2-e2a9109fb875)

## Repo Structure

Here's an overview of key files and folders in this repository:

-Data File: Contains the raw CSV files used in the project:

  - Budget_Revenue.csv : contains financial and studio data
  - Movie.csv : contains descriptive and rating data
  - MoviesJoined.csv : Our cleaned and merged dataset
  - Old_JoinedIMDB.csv : Old dataset that we didn't use
  - OLD_imdb.csv : Old dataset that we didn't use

-Code Files:  Contains our R code files from our analysis:

  - FreqSumtables.R : Contains code for generating frequency tables and summary tables
  - OLD_TidyingData.R : Initial version of the data cleaning script (archived).
  - Tidying_DataNew.R : Updated and finalized script for tidying and merging the datasets.
  - Visualizations.R : Contains all plotting code for line graphs, scatter plots, box plots, and bar charts used throughout the report. Also includes aesthetic customizations.

-Final_Report.qmd: The full Quarto report including code, figures, and analysis.

-Final_Report.pdf : The full report displayed in pdf format.

-README.md: This file that gives breif overview about our repositoary and data.

-InitialPlan: This our intial plan for the project

## Data Sources and Acknowledgements

- The Primary Dataset is sourced from Github repository created by the authors Tran Hieu Le, Totyana Hill, Fahim Ishrak and Zhilin Wang.
  [(Movie Box Office Prediction)](https://github.com/hieu2695/Movie-Industry?tab=readme-ov-file)
- The Secondary Dataset is sourced from Kaggel published by Daniel Grijalva.
  [(Movie Industry)](https://www.kaggle.com/datasets/danielgrijalvas/movies)
- Our Older Dataset was from Kaggle published by Deepanshu Chhikara.
  [(IMDb Top250 Movies)](https://doi.org/10.34740/KAGGLE/DSV/7990386)

## Authors

- Layan Al Busaidi - lma5769@psu.edu
- Sara Al Riyami - ssa5596@psu.edu
