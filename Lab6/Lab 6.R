library(tidyverse)
setwd('/Users/pangin/Documents/INU/Data Science for Urban Scientists')
base = '/Users/pangin/Documents/INU/Data Science for Urban Scientists'
hashtag <- read.csv('/Users/pangin/Documents/INU/Data Science for Urban Scientists/Lab6/conflicts_hashtag_search.csv')

head(hashtag)
hashtag %>% str()

#Group By
hashtag_aggr = hashtag %>%
  group_by(fromSocial) %>%
  summarise(likesCount = sum(likesCount))

hashtag$fromSocial = as.factor(hashtag$fromSocial)

hashtag_aggr = hashtag %>%
  group_by(fromSocial) %>%
  summarise(likesCount = sum(likesCount, na.rm = TRUE))

ggplot(hashtag_aggr) +
  geom_bar(aes(x = factor(fromSocial), y = likesCount), stat = "identity")

hashtag = hashtag %>%
  mutate(year = as.numeric(substr(creationDate, 1, 4)))
racters (the year)

hashtag_aggr2 = hashtag %>%
  group_by(year, fromSocial) %>%
  summarise(likesCount = sum(likesCount, na.rm = TRUE))

#Filter
hashtag_aggr2 = hashtag_aggr2 %>% filter(!is.na(year))
ggplot(hashtag_aggr2) +
  geom_bar(aes(x = factor(year), y = likesCount, fill = fromSocial), stat = "identity", position = "dodge") +
  labs(x = "Year", y = "Total Likes Count", fill = "Social Media Platform") +
  theme_minimal()

#2023-only Subset
hashtag_aggr2023 = hashtag_aggr2 %>%
  filter(year == 2023)

hashtag_aggr3= hashtag %>%
  group_by(year, fromSocial, commentsCount) %>%
  summarize(likesCount = sum(likesCount, na.rm = TRUE),
            commentsCount = sum(commentsCount, na.rm = TRUE))

ggplot(hashtag_aggr3, aes(x = likesCount, y = commentsCount)) +
  geom_point() + # Add points
  geom_smooth(method = "lm", se = FALSE, color = "blue")

