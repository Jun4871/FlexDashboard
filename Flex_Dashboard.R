library(flexdashboard)
library(readr)
library(tidyverse)
library(leaflet)
library(httr)
library(jsonlite)




corona_haspital <- read_csv("Covid_hospital.csv",locale=locale('ko',encoding='euc-kr'))


# 지리정보 api를 사용한 정보추출

Lat_lon_fun <- function(addr) {
  data_list <-
    GET(url = 'https://dapi.kakao.com/v2/local/search/address.json',
        query = list(query = addr),
        add_headers(Authorization = paste0("KakaoAK ", "e76343071712563647f2c52e8c0b86e6"))) %>%
    content(as = 'text') %>%
    fromJSON()
  lon_lat_df <- tibble(주소 = addr,
                         long = as.numeric(data_list$documents$x),
                         lat = as.numeric(data_list$documents$y))
  return(lon_lat_df)
}

# Lat_lon_fun("경기도 성남시 수정구 단대동 190-4")

# corona_haspital
# 
# for(i in 1:nrow(corona_haspital)) {
#   Lat_lon_fun(corona_haspital$주소[i]) %>% print()
# }

# Lat_lon_fun(corona_haspital$주소[3])

corona_haspital_long_lat <- map_dfr(corona_haspital$주소, function(x) {
  Lat_lon_fun(x)
})



## leaflet
leaflet(data = corona_haspital_long_lat) %>% 
  addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(주소), label = ~as.character(주소))



### 숙제 
corona_haspital_total <- corona_haspital %>% 
  left_join(corona_haspital_long_lat) %>% 
  drop_na()

# corona_haspital_total

## 지역별로 몇개가 있는지
## 지역별로 있는거 ggplot (bar)



# asdfasdfasdfa
