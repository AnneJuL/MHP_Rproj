library(readr)
library(dplyr)
library(ggplot2)
library(sf)
library(janitor)

data_all <- list.files(path = "E:\\MHP\\Data\\MHP\\ActiveCD_data",
                       pattern = "*.csv", full.names = TRUE)
colnames(den_data)

df <- readr::read_csv2("E:\\MHP\\Data\\MHP\\ActiveCD_data.csv")

head(df)


den_data <- read_delim("E:\\MHP\\Data\\MHP\\ActiveCD_data.csv")

# Inspect structure
str(den_data)
den_data <- den_data %>%
  janitor::clean_names() %>%    # standardizes names (lowercase, no spaces)
  mutate(
    utme  = as.numeric(gsub(",", "", utme)),
    utmn  = as.numeric(gsub(",", "", utmn)),
    year  = as.integer(year),
    month = as.factor(month),
    clan  = as.factor(clan)     # will now work
  )

den_summary <- den_data %>%
  group_by(landmark_id, utme, utmn, clan) %>%
  summarise(total_sessions = n(), .groups = "drop")

ggplot(den_summary, aes(x = utme, y = utmn, 
                        size = total_sessions, 
                        color = clan)) +
  geom_point(alpha = 0.7) +
  coord_equal() +
  theme_minimal() +
  labs(title = "Hyena Den Activity",
       x = "Easting (UTM)", 
       y = "Northing (UTM)",
       size = "Total Sessions")
