5+9
log(3)
sqrt(4)

setwd('/Users/pangin/Documents/INU/Data Science for Urban Scientists/Lab2')

# CSV 파일 오픈
penguin <- read.csv("penguins.csv")

#변수로 데이터 확인 가능함
class(penguin)
names(penguin)
str(penguin)

penguin$bill_length_mm

#행열 조건
penguin[ ,4]
penguin[10, ]

penguin[ ,1:4]
penguin[1:10, ]
penguin[1:50, 1:2]

#연산자
penguin$bill_length_mm[penguin$bill_length_mm > 40]
penguin[penguin$bill_length_mm > 40, ]
penguin$bill_length_mm[(penguin$species == 'Adelie')]
penguin[(penguin$species == 'Adelie'), ]
penguin[(penguin$species == 'Adelie') & (penguin$bill_length_mm > 40), ]

#tidyverse lib
install.packages("tidyverse")
library(tidyverse)

penguin %>%
  filter(bill_length_mm > 40)

penguin %>%
  filter(bill_depth_mm > 20)

penguin %>%
  filter(species == 'Adelie')

penguin %>%
  filter(species == 'Adelie' | species == 'Gentoo')

penguin %>%
  filter(species %in% c('Adelie', 'Gentoo')) # ==랑 같

penguin %>%
  filter(species == 'Adelie', bill_length_mm > 40) %>%
  select(species, bill_length_mm) %>%
  mutate(Adelie40 == 1) %>% #컬럼 새로 생성
  select(-species) #빼버리는 것

penguin$species <- as.factor(penguin$species)
class(penguin$species)  

plot(penguin$bill_length_mm, type = 'p') #그래픽화

install.packages('ggplot2')
library(ggplot2)

ggplot(penguin, aes(x = 1:nrow(penguin), y = bill_length_mm)) + 
  geom_point() +
  labs(x = "Index", y = "Bill Length(nm)", title = "Scatter Plot of Bill Lengths")

ggplot(penguin, aes(x = 1:nrow(penguin), y = bill_length_mm)) +
  geom_point() + geom_line() +
  labs(x = "Index", y = "Bill Length (mm)", title = "Scatter Plot of Bill Lengths")

ggplot(penguin, aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point(size = 3) +
  labs(title = "Penguin size measurements (Palmer Archipelago)",
       x = "Bill length (mm)",
       y = "Bill depth (mm)") +
  scale_color_manual(values = c("Adelie" = "black", "Chinstrap" = "red", "Gentoo" =
                                  "blue")) +
  theme_minimal()
