setwd('/Users/pangin/Documents/INU/Data Science for Urban Scientists/Lab 4')
base = '/Users/pangin/Documents/INU/Data Science for Urban Scientists/Lab 4'

install.packages("sf")
install.packages("mapview")

library(sf)
library(mapview)

boundary <- st_read('/Users/pangin/Documents/INU/Data Science for Urban Scientists/Lab 4/Lab04_datafiles/LARD_ADM_SECT_SGG_seoul/LARD_ADM_SECT_SGG_11_202405.shp')
pop = st_read('/Users/pangin/Documents/INU/Data Science for Urban Scientists/Lab 4/Lab04_datafiles/Population_202010/nlsp_003001001.shp')
emp = st_read('/Users/pangin/Documents/INU/Data Science for Urban Scientists/Lab 4/Lab04_datafiles/Employment_202010/nlsp_003001007.shp')

install.packages("tidyverse")
library(tidyverse)
library(sf)

boundary %>% st_crs()
pop %>% st_crs()
emp %>% st_crs()

boundary.sf = boundary %>% st_transform(crs=5179)
pop.sf = pop %>% st_transform(crs=5179)
emp.sf = emp %>% st_transform(crs=5179)

pop.sf = pop.sf %>%
  rename(pop = val) %>%
  select(-lbl)

emp.sf = emp.sf %>%
  rename(emp = val) %>%
  select(-lbl)

pop.joined = boundary.sf %>%
  st_join(pop.sf, join = st_intersects) %>%
  group_by(ADM_SECT_C) %>%
  summarise(pop = sum(pop, na.rm = TRUE)) %>%
  mutate(area = st_area(geometry))

emp.joined = boundary.sf %>%
  st_join(emp.sf, join = st_intersects) %>%
  group_by(ADM_SECT_C) %>%
  summarise(emp = sum(emp, na.rm = TRUE))

emp.joined = emp.joined %>% st_drop_geometry()  
popemp.joined = pop.joined %>%
  left_join(emp.joined, by = "ADM_SECT_C") %>%
  mutate(popden = as.numeric(pop/area)) %>%
  mutate(empden = as.numeric(emp/area))

ggplot(popemp.joined) +
  geom_sf(aes(fill=popden))

ggplot(popemp.joined) +
  geom_sf(aes(fill = empden)) +
  scale_fill_viridis_c(option = "plasma")

  
  
