# Create and inspect some visualizations for our hypotheses ----

# Load packages: -----
library(dplyr)
library(ggplot2)

# Read/load the joined dataset: -----
url <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/MoviesJoined.csv"
MoviesJoined <- read.csv(url, header = TRUE)
view(MoviesJoined)

# Define global elements ----
psuPalette <- c("#1E407C", "#BC204B", "#3EA39E", "#E98300",
                "#999999", "#AC8DCE", "#F2665E", "#99CC00")


## Bar Chart -----
# Which of the top 10 movie Stars have the most movies in the list?
# Find top 10 Stars 
SatrCount <- MoviesJoined %>%
  count(Star, sort = TRUE) %>%
  slice_max(order_by = n, n = 10)   # Keep top 10 Star

# Plot: Bar chart of number of movies by stars
StarCount %>%
  ggplot(aes(x = reorder(Star, n), y = n)) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs(
    title = "Top 10 Stars by Number of Movies",
    x = "Star",
    y = "Number of Movies"
  ) +
  theme_minimal()




## Box Plot -----
# Do the Top 5 most common genres show differences in their average ratings?
# Find the top 5 genres by count
TopGenres <- MoviesJoined %>%
  count(Genre, sort = TRUE) %>%
  slice_max(order_by = n, n = 5) %>%
  pull(Genre)

# Filter data for only the Top 5 genres
MoviesJoined %>%
  filter(Genre %in% TopGenres) %>%
  # Create the box plot
  ggplot(aes(x = Genre,
             y = Rating)) +
  geom_boxplot(fill = "lightpink") +
  coord_flip() +
  labs(
    title = "Distribution of Ratings for Top 5 Genres",
    x = "Top Genres",
    y = "Rating"
  ) +
  theme_minimal()


# Plot Chart -------
# Do movies with higher RunTime tend to receive higher audience ratings?
  ggplot(MoviesJoined, aes(x = RunTime, y = Rating)) +
  geom_point(alpha=0.7) +
  labs(
    title = "Relationship Between Movie Runtime and Audience Rating",
    x = "Runtime (minutes)",
    y = "Rating"
  ) +
  theme_minimal()

# RatingCount and Rating
ggplot(MoviesJoined, aes(x = RatingCount, y = Rating)) +
  geom_point(alpha = 0.8, size = 1.5) +
  labs(
    title = "Relationship Between Rating Count and Audience Rating",
    x = "Number of Ratings (in Thousands)",
    y = "Audience Rating"
  ) +
  theme_minimal()




#Which production companies have the highest average profit.
# Bar Chart with Profit
#Calculate Profit per Company
CompanyProfit <- MoviesJoined %>%
  group_by(Company) %>%
  summarize(AverageProfit = mean(Profit, na.rm = TRUE)) %>%
  ungroup()
# Get top 15 companies by number of movies
top_companies <- MoviesJoined %>%
  count(Company, sort = TRUE) %>%
  slice_max(n, n = 15) %>%
  pull(Company)
#Filter to top companies and plot
CompanyProfit %>%
  filter(Company %in% top_companies) %>%
  ggplot(aes(x = reorder(Company, AverageProfit), y = AverageProfit)) +
  geom_col(fill = "dodgerblue") +
  coord_flip() +
  labs(
    title = "Profit of the 15 Most Active Production Companies",
    x = "Production Company",
    y = " Profit (USD)"
  ) +
  theme_minimal() +
  theme(
    axis.title = element_text(face = "bold"),  # Make axis titles bold
    axis.text = element_text(face = "bold")    # Make axis tick labels bold
  )+
  theme_minimal()



# Production Companies Making Kid Movies Profit 
TopMovies <- MoviesJoined%>%
  filter(Company %in% c("Walt Disney Pictures",
                        "Warner Bros.",
                        "Universal Pictures",
                        "Columbia Pictures",
                        "DreamWorks Animation"))
#view(TopMovies)
ggplot(data = TopMovies, 
       mapping = aes(
         x = Budget, 
         y = Profit, 
         color = Company
         )
       ) +
  geom_point(size = 3) +
  labs(
    title = "Profit per Movie by Company (G & PG Rated)",
    x = "Budget",
    y = "Profit (USD)",
    color = "Company"
    ) +
  scale_color_manual(
    values = psuPalette
    )+
  theme_bw() +
  theme(
    legend.position = "right"
    )

# Bar Chart with Profit
#Calculate Average Budget per Company
CompanyBudget <- MoviesJoined %>%
  group_by(Company) %>%
  summarize(AverageBudget = mean(Budget, na.rm = TRUE)) %>%
  ungroup()
#Filter to top companies and plot
CompanyBudget %>%
  filter(Company %in% top_companies) %>%
  ggplot(aes(x = reorder(Company, AverageBudget), y = AverageBudget)) +
  geom_col(fill = "darkorange") +
  coord_flip() +
  labs(
    title = "Budget of the 15 Most Active Production Companies",
    x = "Production Company",
    y = "Budget (USD)"
  ) +
  theme_minimal() +
  theme(
    axis.title = element_text(size = 14, face = "bold"),
    axis.text = element_text(size = 10, face = "bold"),
    plot.title = element_text(size = 16, face = "bold")
  )



CompanySummary <- MoviesJoined %>%
  filter(Company %in% top_companies) %>%
  group_by(Company) %>%
  summarize(
    AverageBudget = mean(Budget, na.rm = TRUE),
    AverageProfit = mean(Profit, na.rm = TRUE)
  ) %>%
  ungroup()
ggplot(CompanySummary, aes(x = AverageBudget, y = AverageProfit)) +
  geom_point(color = "steelblue", size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "red", size = 1.2) +
  labs(
    title = "Relationship Between Budget and Profit of the Top 15 Companies",
    x = "Budget (USD)",
    y = "Profit (USD)"
  ) +
  theme_minimal() +
  theme(
    axis.title = element_text(size = 14, face = "bold"),
    axis.text = element_text(size = 10),
    plot.title = element_text(size = 16, face = "bold")
  )














# LOLLIPOP

# Count movies
MovieCounts <- MoviesJoined %>%
  filter(Company %in% top_companies) %>%
  count(Company, name = "MovieCount")

# Lollipop chart
ggplot(MovieCounts, 
       aes(x = reorder(Company, MovieCount), y = MovieCount)) +
  geom_segment(
    aes(xend = Company, y = 0, yend = MovieCount), 
    color = "gray") +
  geom_point(size = 5, 
             color = "steelblue") +
  coord_flip() +
  labs(
    title = "Number of Movies by Top 5 Most Profitable Companies",
    x = "Company",
    y = "Movie Count"
  ) +
  theme_minimal()


# PIE CHART

MovieCounts <- MoviesJoined %>%
  filter(Company %in% top_companies) %>%
  count(Company, name = "MovieCount") %>%
  arrange(desc(Company)) %>%
  mutate(
    Fraction = MovieCount / sum(MovieCount),
    Ypos = cumsum(Fraction) - 0.5 * Fraction,
    Label = paste0(MovieCount)
  )

# Step 3: Pie chart with counts inside
ggplot(MovieCounts, aes(x = "", y = Fraction, fill = Company)) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  geom_text(data = MovieCounts, aes(x = 1, y = Ypos, label = Label), 
            color = "white", fontface = "bold", size = 5) +
  labs(
    title = "Proportion of Movies by Top 5 Most Profitable Companies",
    fill = "Company"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    legend.title = element_text(face = "bold")
  )


# LINE CHART
top_companies <- MoviesJoined %>%
  count(Company, sort = TRUE) %>%
  slice_max(n, n = 5) %>%
  pull(Company)

#Filter dataset and prepare average ratings by year and company
MoviesJoined %>%
  filter(!is.na(Year), !is.na(Profit), Company %in% top_companies) %>%
  group_by(Company, Year) %>%
  summarize(YearlyProfit = sum(Profit, na.rm = TRUE), .groups = "drop") %>%
  arrange(Company, Year) %>%
  group_by(Company) %>%
  mutate(CumulativeProfit = cumsum(YearlyProfit)) %>%
  ggplot(aes(x = Year, y = CumulativeProfit, color = Company, linetype = Company)) +
  geom_line(size = 1.2) +
  labs(
    title = "Cumulative Profit Over Time for Top 5 Production Companies",
    x = "Year",
    y = "Cumulative Profit (USD)",
    color = "Company",
    linetype = "Company"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    axis.title = element_text(size = 13, face = "bold"),
    axis.text = element_text(size = 11)
  )







# WORK IN PROGRESS:
# Rating of the top stars over times
TopStars <- c("Nicolas Cage",
              "Adam Sandler",
              "Denzel Washington",
              "Dwayne Johnson",
              "Tom Cruise",
              "Tom Hanks")

StarMovies <- MoviesJoined%>%
  filter(Star %in% TopStars)
view(StarMovies)

RatingYear <- StarMovies%>%
  group_by(Star,Year)%>%
  summarise(AverageRating = mean(Rating, na.rm = TRUE)) %>%
  ungroup()

all_years <- data.frame(Star = rep(TopStars, each = length(unique(RatingYear$Year))),
                        Year = rep(unique(RatingYear$Year), times = length(TopStars)))

StarRatingsByYearFull <- all_years %>%
  left_join(RatingYear, by = c("Star", "Year")) %>%
  replace_na(list(AverageRating = 0))  # Replace missing ratings with 0

# 4. Plot with a smoother line and handle missing years
ggplot(StarRatingsByYearFull, aes(x = Year, y = AverageRating, color = Star)) +
  geom_line(size = 1) +
  geom_smooth(method = "loess", se = FALSE, linetype = "dashed", size = 1) +  # Smoothed line
  labs(title = "Actor Ratings Over Time", 
       x = "Year", 
       y = "Average Rating",
       color = "Actor") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels

