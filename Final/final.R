install.packages(c("dplyr", "tidyverse", "sf", "sp", "readr", "readxl", "mapview", "tmap"))

library(dplyr) # Data manipulation
library(tidyverse) # Comprehensive data science package (includes ggplot2, dplyr, etc.)
library(sf) # Simple features for spatial data
library(sp) # Spatial data analysis
library(readr) # Reading flat files (CSV, TSV, etc.)
require(readxl) # Reading Excel files (.xlsx)
require(mapview) # Interactive map visualization
require(tmap) # Thematic maps and visualization

#작업공간 설정
setwd('/Users/pangin/Documents/INU/Data Science for Urban Scientists/Final')
base = '/Users/pangin/Documents/INU/Data Science for Urban Scientists/Final'
b_base = '/Users/pangin/Documents/INU/Data Science for Urban Scientists/Final/BUS/'
a_base = '/Users/pangin/Documents/INU/Data Science for Urban Scientists/Final/Airport'
s_base = '/Users/pangin/Documents/INU/Data Science for Urban Scientists/Final/Metro'



#지하철
SubwayData <- read.csv('/Users/pangin/Documents/INU/Data Science for Urban Scientists/Final/Metro/gimpo_metro_data.csv', fileEncoding = 'euc-kr',encoding = 'utf-8')
#2024년으로 필터링
SubwayData_23 <-
  SubwayData %>% filter(grepl('2023', 사용월))

SubwayData_23$지하철역<-NULL

write.csv(SubwayData_23, file = 'SubwayData_2023.csv', fileEncoding = 'euc-kr') #엑셀로 일부 전처리

SubwayData_2023 <- read.csv('/Users/pangin/Documents/INU/Data Science for Urban Scientists/Final/Metro/SubwayData_2023.csv', fileEncoding = 'euc-kr',encoding = 'utf-8')

# 열 이름 지정
names(SubwayData_2023) <- c("month", paste0("time_", sprintf("%02d", rep(4:23, each = 2)), c("_board", "_exit")))

sum_sub_data <- 
  SubwayData_2023 %>%
  group_by(month) %>%
  summarise(
    across(starts_with("time_"), sum, na.rm = TRUE))

#수정필요(어딘가 이상함)
data_long <- sum_sub_data %>%
  pivot_longer(
    cols = starts_with("time_"),  # 'time_'로 시작하는 모든 컬럼을 선택
    names_to = c("time", ".value"),  # `time` 열로 시간대를 추출하고 `.value`로 승하차 구분
    names_sep = "_"  # '_'를 기준으로 분리
  )





#버스
#버스데이터 합치기, 김포공항 포함하는 데이터만 재분류
filenames <- list.files(path=b_base, pattern="*.csv", full.names=TRUE)

MergedData <- 
  do.call(rbind, lapply(filenames, read.csv, fileEncoding = "euc-kr", encoding = 'utf-8'))

AirportBusData <-
  MergedData %>% filter(grepl('김포공항', 역명))

#필요없는 데이터 삭제
AirportBusData$표준버스정류장ID<-NULL
AirportBusData$버스정류장ARS번호<-NULL
AirportBusData$교통수단타입코드<-NULL
AirportBusData$등록일자<-NULL

#정류장별로 세분화해서 분리
Busdata_gimpo_domestic <-
  AirportBusData %>% filter(grepl('김포공항국내선', 역명))
Busdata_gimpo_int <-
  AirportBusData %>% filter(grepl('김포공항국제선', 역명))

#필요없는 데이터 삭제
Busdata_gimpo_domestic$노선번호<-NULL
Busdata_gimpo_domestic$노선명<-NULL
Busdata_gimpo_int$노선번호<-NULL
Busdata_gimpo_int$노선명<-NULL

#엑셀로 일부 전처리
write.csv(Busdata_gimpo_domestic, file = 'Busdata_gimpo_domestic.csv', fileEncoding = 'euc-kr')
write.csv(Busdata_gimpo_int, file = 'Busdata_gimpo_int.csv', fileEncoding = 'euc-kr')

#전처리한 데이터 불러오기
B_data_int <- read.csv('/Users/pangin/Documents/INU/Data Science for Urban Scientists/Final/b_data/Busdata_gimpo_int.csv', fileEncoding = "euc-kr", encoding = 'utf-8')
B_data_dom <- read.csv('/Users/pangin/Documents/INU/Data Science for Urban Scientists/Final/b_data/Busdata_gimpo_domestic.csv', fileEncoding = "euc-kr", encoding = 'utf-8')

# 열 이름 지정
names(B_data_int) <- c("month", paste0("time_", sprintf("%02d", rep(4:23, each = 2)), c("_board", "_exit")))
names(B_data_dom) <- c("month", paste0("time_", sprintf("%02d", rep(4:23, each = 2)), c("_board", "_exit")))


sum_B_data_int <- 
  B_data_int %>%
  group_by(month) %>%
  summarise(
    across(starts_with("time_"), sum, na.rm = TRUE))

sum_B_data_dom <- 
  B_data_dom %>%
  group_by(month) %>%
  summarise(
    across(starts_with("time_"), sum, na.rm = TRUE))








#공항
Airportdata <- read.csv('/Users/pangin/Documents/INU/Data Science for Urban Scientists/Final/Airport/gimpo_airport_people_data.csv', fileEncoding = 'euc-kr',encoding = 'utf-8')


