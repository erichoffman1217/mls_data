# For Loop Script
library(readxl)
library(tidyverse)
library(rvest)
library(lubridate)
team_key <- read_excel("team_key.xlsx")
schedule_raw <- read_excel("2013_2018_schedule.xlsx")

pre_merge_key <- select(team_key, schedule_name, url, team_no)

schedule_raw %>%
        mutate(t = as.character(str_sub(Time, -8,-1)),
               d = ymd_hms(paste(Date, t),tz='UTC'),
               local_time = d - dhours(10))-> test 
               
               
               locale = d - hour(10:00)) 


first_merge <- merge(schedule_raw, pre_merge_key, all.x = TRUE, by.x = 'Home', by.y = 'schedule_name')
second_merge <- merge(first_merge, pre_merge_key, all.x = TRUE, by.x = 'Away', by.y = 'schedule_name')

second_merge %>%
        rename(home_url = url.x, away_url = url.y, home_team_no = team_no.x, away_team_no = team_no.y) %>%
        mutate( Time = as.character(str_sub(Time, -8,-1)),
                datetime = ymd_hms(paste(Date, Time),tz='UTC'),
                local_time = datetime - dhours(8),
                url_input = paste0('https://matchcenter.mlssoccer.com/matchcenter/',as.character(date(local_time)),
                                  '-', home_url,'-vs-',away_url,'/boxscore'),
               game_no = paste0(home_team_no, away_team_no,format(second_merge$Date,"%y%m%d"))) %>%
        select(url_input, Date, Time, local_time, Home, Away, home_team_no, away_team_no, game_no, HG, AG) -> scrape_input






game_db <- as.data.frame(matrix(nrow = 0, ncol = 10))
team_db <- as.data.frame(matrix(nrow = 0, ncol = 17))
players_db <- as.data.frame(matrix(nrow = 0, ncol = 12))
goalie_db <- as.data.frame(matrix(nrow = 0, ncol = 12))

for (i in 1:nrow(scrape_input)){
        data_selected <- scrape_input[i,]
        info_webpage <- read_html(data_selected$url_input)
        
        print(scrape_input[i,])
}

schedule_input[1,]
rm(i)


i <-60
i <- 21

