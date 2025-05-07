# Goal: Create and inspect some visualizations for our hypotheses ----
# Load packages: -----
library(dplyr)
library(tidyr)
library(ggplot2)

# Read/load the joined dataset: -----
basePart <- "https://raw.githubusercontent.com/Stat184-Spring2025/"
mainPart <- "Sec4_FP_Layan_Sara/main/Data/MoviesJoined.csv"
url <- paste0(basePart,mainPart)
MoviesJoined <- read.csv(url, header = TRUE)
#View(MoviesJoined)


# Define global elements ----
psuPalette <- c("#1E407C", "#BC204B", "#3EA39E", "#E98300",
                "#999999", "#AC8DCE", "#F2665E", "#99CC00")


#-------------------------------------------------------------------------------

#1. How do audience ratings compare across the five most common movie genres?----

##1: Box Plot for the top 5 genres by count
TopGenres <- MoviesJoined %>%
  count(Genre, sort = TRUE) %>%  # Counts num of movies per genre and sorts them
  slice_max(order_by = n, n = 5) %>%  # Selects top 5 genres w most movies 
  pull(Genre)

# Filter data for only the Top 5 genres
MoviesJoined %>%
  filter(Genre %in% TopGenres) %>%  # Filter movies of only the top 5 genres
# Create the box plot
  ggplot(aes(x = Rating,   # Set the x-axis to represent Rating
             y = Genre)) +   # Set the y-axis to represent Genre
  geom_boxplot(fill = "lightpink") + # Creates box plot with pink boxes
  labs(      #labels the x and y axis
    title = "Distribution of Ratings for Top 5 Genres",
    y = "Top Genres",
    x = "Rating"
  ) +
  theme_minimal()+
  theme(
    text = element_text(size = 12),
    axis.title.x = element_text(face = "bold",   # Make the x-axis title bold
                                size = 14,    # Set font size to 14
                                margin = margin(t = 15)),
    axis.title.y = element_text(face = "bold", 
                                size = 14, 
                                margin = margin(r = 15))
  ) # margin pushes title away from axis

# ------------------------------------------------------------------------------

#2. Which top studios have the best return on investment, 
#and is there a relationship between movie budget and profit?----

##1: Bar Chart calculating Profit per Company
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


##2: Bar Chart for calculating Budget per Company 
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


##3: Scatter Plot for Profit/Budget relationship
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


##4: lollipop Chart for movie count per Company
MovieCounts <- MoviesJoined %>%
  filter(Company %in% top_companies) %>%
  count(Company, name = "MovieCount")

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


##5: Pie Chart for movie count per company
MovieCounts <- MoviesJoined %>%
  filter(Company %in% top_companies) %>%
  count(Company, name = "MovieCount") %>%
  arrange(desc(Company)) %>%
  mutate(
    Fraction = MovieCount / sum(MovieCount),
    Ypos = cumsum(Fraction) - 0.5 * Fraction,
    Label = paste0(MovieCount)
  )
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


##6: Line Chart for Cumulative profit for Companies
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

#-------------------------------------------------------------------------------

#3. Who are the most frequently featured stars in the movie data set?

##1:Bar chart of number of movies by stars
# Find top 10 Stars 
StarCount <- MoviesJoined %>%
  count(Star, sort = TRUE) %>%
  slice_max(order_by = n, n = 10)   # Keep top 10 Star

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

##2: ScatterPlot of the Rating for Top Stars
# Identify Top 5 Stars by number of movies
top5_stars <- MoviesJoined %>%
  count(Star, sort = TRUE) %>%
  slice_head(n = 5) %>%
  pull(Star)

# Filter movies for those stars
top_star_movies <- MoviesJoined %>%
  filter(Star %in% top5_stars)

# Plot
ggplot(top_star_movies, aes(x = Star, 
                            y = Rating,
                            color = Star)) +
  geom_jitter(width = 0.2, size = 3) +
  scale_color_manual(values = psuPalette) +
  labs(
    title = "Movie Ratings of Top 5 Most Frequent Stars",
    x = "Star",
    y = "Movie Rating"
  ) +
  theme_minimal() +
  theme(legend.title = element_blank())

#----------------------------------------------------------

#4. Other Plots
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

