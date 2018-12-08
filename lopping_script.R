# For Loop Script
library(readxl)
library(tidyverse)
library(rvest)
library(lubridate)
team_key <- read_excel("~/R/mls_data/team_key.xlsx")
schedule_raw <- read_excel("~/R/mls_data/schedule/2013_2018_schedule.xlsx")

pre_merge_key <- select(team_key, schedule_name, url, team_no)

schedule_raw %>%
        mutate(t = as.character(str_sub(Time, -8,-1)),
               d = ymd_hms(paste(Date, t),tz='UTC'),
               local_time = d - dhours(10))-> test 


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






game_db <- as.data.frame(matrix(nrow = 0, ncol = 14))
team_db <- as.data.frame(matrix(nrow = 0, ncol = 17))
players_db <- as.data.frame(matrix(nrow = 0, ncol = 12))
goalie_db <- as.data.frame(matrix(nrow = 0, ncol = 12))

for (i in 1:nrow(scrape_input)){
        data_selected <- scrape_input[i,]
        info_webpage <- read_html(data_selected$url_input)
        
        ###     Game DB
        match_info = html_text(html_nodes(info_webpage, '.match-info div'))
        add_game <- data.frame(game_no = data_selected$game_no,
                               home_team = html_text(html_nodes(info_webpage, '.sb-home .sb-club-name-full')),
                               home_team_no = data_selected$home_team_no,
                               away_team = html_text(html_nodes(info_webpage, '.sb-away .sb-club-name-full')),
                               away_team_no = data_selected$away_team_no,
                              home_score = html_text(html_nodes(info_webpage, '.sb-home .sb-score')),
                              away_score = html_text(html_nodes(info_webpage, '.sb-away .sb-score')),
                              date = html_text(html_nodes(info_webpage, '.sb-match-date')),
                              time = html_text(html_nodes(info_webpage, '.sb-match-time')),
                              time_matched = data_selected$local_time,
                              field = match_info[1],
                              location = match_info[2],
                              attendance = match_info[3],
                              weather = match_info[4]
        )
        ###     Team DB
        #       Record 1 (Home team)
        home_team_stats <- data.frame(game_no = data_selected$game_no,
                                      team_no = data_selected$home_team_no,
                                      opp_team_no = data_selected$away_team_no,
                                      home = 1,
                                      date = data_selected$Date,
                                      time = data_selected$Time,
                                      datetime = data_selected$local_time
                                      )
        
        
        
        
        
        away_team_stats <- data.frame(game_no = data_selected$game_no,
                                      team_no = data_selected$away_team_no,
                                      opp_team_no = data_selected$home_team_no,
                                      home = 0,
                                      
        )
        team_db<- rbind(team_db,
                        as.data.frame(t(html_text(html_nodes(info_webpage,'.summary-table td:nth-child(1)')))),
                        as.data.frame(t(html_text(html_nodes(info_webpage,'.summary-label+ td')))))
        colnames(team_db) <- c( 'shots', 'sot', 'sofft', 'blocked_shots', 'corners', 'crosses', 'offsides', 'fouls', 'yellows', 'reds',
                                'total_passes', 'pass_acc', 'possession', 'duels_w', 'tackles_w', 'saves', 'clearances')
        
        
        
        
        
        game_db <- rbind(game_db, add_game)
        print(scrape_input[i,])
}

schedule_input[1,]
rm(i)


i <-60
i <- 21

