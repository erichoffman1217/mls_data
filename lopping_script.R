# For Loop Script
library(readxl)
library(tidyverse)
library(rvest)
library(lubridate)
team_key <- read_excel("~/R/mls_data/team_key.xlsx")
schedule_raw <- read_excel("~/R/mls_data/schedule/2013_2018_schedule.xlsx")

pre_merge_key <- select(team_key, schedule_name, url, team_no)

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
        select(url_input, Date, Time, local_time, Home, Away, home_team_no, away_team_no, game_no, HG, AG) %>%
        filter(Date>= '2013-03-02')-> scrape_input
rm(first_merge, second_merge, team_key)





game_db <- as.data.frame(matrix(nrow = 0, ncol = 16))
team_db <- as.data.frame(matrix(nrow = 0, ncol = 43))
players_db <- as.data.frame(matrix(nrow = 0, ncol = 16))
goalie_db <- as.data.frame(matrix(nrow = 0, ncol = 16))
for (i in 1:nrow(scrape_input)){
###for (i in 1:10){
#for (i in 211:nrow(scrape_input)){}
#for (i in 1070:nrow(scrape_input)){
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
                              check_hg = data_selected$HG,
                              check_ag = data_selected$AG,
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
                                      datetime = data_selected$local_time,
                                      goals_scored = data_selected$HG,
                                      goals_let = data_selected$AG
                                      )
        home_table_stats <-cbind(as.data.frame(t(html_text(html_nodes(info_webpage,'.summary-table td:nth-child(1)')))),
              as.data.frame(t(html_text(html_nodes(info_webpage,'.summary-label+ td'))))
              )
        colnames(home_table_stats) <- c( 'shots', 'sot', 'sofft', 'blocked_shots', 'corners', 'crosses', 'offsides', 'fouls', 'yellows', 'reds',
                                'total_passes', 'pass_acc', 'possession', 'duels_w', 'tackles_w', 'saves', 'clearances',
                                'opp_shots', 'opp_sot', 'opp_sofft', 'opp_blocked_shots', 'opp_corners', 'opp_crosses', 
                                'opp_offsides', 'opp_fouls', 'opp_yellows', 'opp_reds',
                                'opp_total_passes', 'opp_pass_acc', 'opp_possession', 'opp_duels_w', 'opp_tackles_w', 'opp_saves', 'opp_clearances')        
        home_team_stats <- cbind(home_team_stats, home_table_stats)
        
        ### Record 2 (AWay Team)
        away_team_stats <- data.frame(game_no = data_selected$game_no,
                                      team_no = data_selected$away_team_no,
                                      opp_team_no = data_selected$home_team_no,
                                      home = 0,
                                      date = data_selected$Date,
                                      time = data_selected$Time,
                                      datetime = data_selected$local_time,
                                      goals_scored = data_selected$AG,
                                      goals_let = data_selected$HG
        )
        away_table_stats <-cbind(as.data.frame(t(html_text(html_nodes(info_webpage,'.summary-label+ td')))),
                                as.data.frame(t(html_text(html_nodes(info_webpage,'.summary-table td:nth-child(1)'))))
                                 
        )
        colnames(away_table_stats) <- c( 'shots', 'sot', 'sofft', 'blocked_shots', 'corners', 'crosses', 'offsides', 'fouls', 'yellows', 'reds',
                                         'total_passes', 'pass_acc', 'possession', 'duels_w', 'tackles_w', 'saves', 'clearances',
                                         'opp_shots', 'opp_sot', 'opp_sofft', 'opp_blocked_shots', 'opp_corners', 'opp_crosses', 
                                         'opp_offsides', 'opp_fouls', 'opp_yellows', 'opp_reds',
                                         'opp_total_passes', 'opp_pass_acc', 'opp_possession', 'opp_duels_w', 'opp_tackles_w', 'opp_saves', 'opp_clearances')        
        away_team_stats <- cbind(away_team_stats, away_table_stats)
        
        ###     Players DB
        ###     Home Players 
        home_static <- data.frame(game_no = data_selected$game_no,
                                   team_no = data_selected$home_team_no,
                                   opp_team_no = data_selected$away_team_no,
                                   home = 1)
        home_player_stats <- data.frame(j_no = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(1)'))),
                                      pos = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(2)' ))),
                                      name = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) .ps-name' ))),
                                      h_players_min = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) .ps-name+ td' ))),
                                      h_players_goals = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(5)' ))),
                                      h_players_a = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(6)' ))),
                                      h_players_sht = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(7)' ))),
                                      h_players_sog = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(8)' ))),
                                      h_players_ck = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(9)' ))),
                                      h_players_off = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(10)' ))),
                                      h_players_fc = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(11)' ))),
                                      h_players_fs = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(12)' )))
        )
        colnames(home_player_stats) <- c('j_no', 'pos', 'name', 'minutes', 'goals', 'assists', 'shots', 'sog', 'corners', 'offsides', 'fouls_com', 'fouls_suf')
        home_player_stats <- cbind(home_static, home_player_stats)
        
        ###     Away Players
        away_static <- data.frame(game_no = data_selected$game_no,
                                  team_no = data_selected$away_team_no,
                                  opp_team_no = data_selected$home_team_no,
                                  home = 0)
        away_player_stats <- data.frame(j_no = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table tbody td:nth-child(1)'))),
                                      pos = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table tbody td:nth-child(2)' ))),
                                      name = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table .ps-name' ))),
                                      h_players_min = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table .ps-name+ td' ))),
                                      h_players_goals = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table tbody td:nth-child(5)' ))),
                                      h_players_a = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table tbody td:nth-child(6)' ))),
                                      h_players_sht = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table tbody td:nth-child(7)' ))),
                                      h_players_sog = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table tbody td:nth-child(8)' ))),
                                      h_players_ck = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table tbody td:nth-child(9)' ))),
                                      h_players_off = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table tbody td:nth-child(10)' ))),
                                      h_players_fc = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table tbody td:nth-child(11)' ))),
                                      h_players_fs = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table tbody td:nth-child(12)' )))
        )
        colnames(away_player_stats) <- c('j_no', 'pos', 'name', 'minutes', 'goals', 'assists', 'shots', 'sog', 'corners', 'offsides', 'fouls_com', 'fouls_suf')
        away_player_stats <- cbind(away_static, away_player_stats)
        
        
        
        ###     Goalie Table (Part 1)
        home_goalie_stats <- data.frame(h_players_g_no = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(1)'))),
                                  h_players_g_pos =as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(2)' ))),
                                  h_players_g = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) .ps-name' ))),
                                  h_players_g_min = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) .ps-name+ td' ))),
                                  h_players_g_ga = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(5)' ))),
                                  h_players_g_a = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(6)' ))),
                                  h_players_g_sht = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(7)' ))),
                                  h_players_g_saves = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(8)' ))),
                                  h_players_g_p = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(9)' ))),
                                  h_players_g_cc = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(10)' ))),
                                  h_players_g_fc = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(11)' ))),
                                  h_players_g_fs = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(12)' )))
        )
        colnames(home_goalie_stats) <- c('j_no', 'pos', 'name', 'min', 'goals_against', 'assists', 'shots', 'saves', 'punches', 'corners_c', 'fouls_com', 'fouls_suf')
        home_goalie_stats <- cbind(home_static, home_goalie_stats)
        
        ###     Goalie Table (Part 2)
        away_goalie_stats <- data.frame(h_players_g_no = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table tbody td:nth-child(1)'))),
                                        h_players_g_pos =as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table tbody td:nth-child(2)' ))),
                                        h_players_g = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table .ps-name' ))),
                                        h_players_g_min = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table .ps-name+ td' ))),
                                        h_players_g_ga = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table tbody td:nth-child(5)' ))),
                                        h_players_g_a = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table tbody td:nth-child(6)' ))),
                                        h_players_g_sht = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table tbody td:nth-child(7)' ))),
                                        h_players_g_saves = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table tbody td:nth-child(8)' ))),
                                        h_players_g_p = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table tbody td:nth-child(9)' ))),
                                        h_players_g_cc = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table tbody td:nth-child(10)' ))),
                                        h_players_g_fc = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table tbody td:nth-child(11)' ))),
                                        h_players_g_fs = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table tbody td:nth-child(12)' )))
        )
        colnames(away_goalie_stats) <- c('j_no', 'pos', 'name', 'min', 'goals_against', 'assists', 'shots', 'saves', 'punches', 'corners_c', 'fouls_com', 'fouls_suf')
        away_goalie_stats <- cbind(away_static, away_goalie_stats)
        
        
        goalie_db <- rbind(goalie_db, home_goalie_stats, away_goalie_stats)
        
        
        
        ###     Bind to looping DB
        team_db<- rbind(team_db,
                        home_team_stats,
                        away_team_stats)
        
        goalie_db <- rbind(goalie_db, 
                           home_goalie_stats, 
                           away_goalie_stats)
        
        players_db <- rbind(players_db, 
                            home_player_stats, 
                            away_player_stats)
        
        game_db <- rbind(game_db, 
                         add_game)
        
        print(scrape_input[i,])
        rm(home_team_stats, away_team_stats, home_goalie_stats, away_goalie_stats, home_player_stats, away_player_stats, 
           add_game, home_static, away_static, away_table_stats, home_table_stats, data_selected, info_webpage )
}

write.table(game_db, file = "game_db.txt", quote = FALSE, sep = '|', na= "", row.names = FALSE)        
write.table(players_db, file = "players_db.txt", quote = FALSE, sep = '|', na= "", row.names = FALSE)        
write.table(goalie_db, file = "goalie_db.txt", quote = FALSE, sep = '|', na= "", row.names = FALSE)        
write.table(team_db, file = "team_db.txt", quote = FALSE, sep = '|', na= "", row.names = FALSE)        



       
#schedule_input[1,]
#rm(i)


#i <-37

