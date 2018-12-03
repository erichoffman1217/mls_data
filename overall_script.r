library('rvest')
library('tidyverse')
url_1 <- 'https://matchcenter.mlssoccer.com/matchcenter/2018-10-08-seattle-sounders-fc-vs-houston-dynamo/boxscore'
url_2 <- 'https://matchcenter.mlssoccer.com/matchcenter/2018-09-05-new-york-city-fc-vs-new-england-revolution/boxscore'

info_webpage <- read_html(url_1)
info_webpage <- read_html(url_2)

###     Game DB
match_info = html_text(html_nodes(info_webpage, '.match-info div'))


game_db <- data.frame(away_team = html_text(html_nodes(info_webpage, '.sb-away .sb-club-name-full')),
                      home_team = html_text(html_nodes(info_webpage, '.sb-home .sb-club-name-full')),
                      home_score = html_text(html_nodes(info_webpage, '.sb-home .sb-score')),
                      away_score = html_text(html_nodes(info_webpage, '.sb-away .sb-score')),
                      date = html_text(html_nodes(info_webpage, '.sb-match-date')),
                      time = html_text(html_nodes(info_webpage, '.sb-match-time')),
                      field = match_info[1],
                      location = match_info[2],
                      attendance = match_info[3],
                      weather = match_info[4]
                      )



###     Team DB
team_db <- as.data.frame(matrix(nrow = 0, ncol = 17))
colnames(team_db) <- c( 'shots', 'sot', 'sofft', 'blocked_shots', 'corners', 'crosses', 'offsides', 'fouls', 'yellows', 'reds',
                        'total_passes', 'pass_acc', 'possession', 'duels_w', 'tackles_w', 'saves', 'clearances')
                         

team_db<- rbind(team_db,
                as.data.frame(t(html_text(html_nodes(info_webpage,'.summary-table td:nth-child(1)')))),
                as.data.frame(t(html_text(html_nodes(info_webpage,'.summary-label+ td')))))

colnames(team_db) <- c( 'shots', 'sot', 'sofft', 'blocked_shots', 'corners', 'crosses', 'offsides', 'fouls', 'yellows', 'reds',
                        'total_passes', 'pass_acc', 'possession', 'duels_w', 'tackles_w', 'saves', 'clearances')

team_db %>%
        mutate(game_no = 1,
               date = 2) -> team_db


### Notes
' Not the most efficient way to scrape but do it once and forget about it.
        Problem: need to create four tables initially, then combine h_player and h_goalie. Goalies
        have different stats than players do. Apparently
'
### Home Team
home_team_stats <- data.frame(j_no = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(1)'))),
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
colnames(home_team_stats) <- c('j_no', 'pos', 'name', 'minutes', 'goals', 'assists', 'shots', 'sog', 'corners', 'offsides', 'fouls_com', 'fouls_suf')

### Home Keeper
home_goalie_stats = data.frame(h_players_g_no = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) tbody td:nth-child(1)'))),
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


### Away Team 
away_team_stats <- data.frame(j_no = as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table tbody td:nth-child(1)'))),
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
colnames(away_team_stats) <- c('j_no', 'pos', 'name', 'minutes', 'goals', 'assists', 'shots', 'sog', 'corners', 'offsides', 'fouls_com', 'fouls_suf')


### Away Keeper
away_goalie_stats = data.frame(h_players_g_no = as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table tbody td:nth-child(1)'))),
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










###     Wanted  ###
'''
H-team,
A-team,
H-score,
A-score,
date-time,
time,
H-roster,
A-roster,
Attendance,
Weather,
On TV,
'''



###     Schedule 1
# schedule_url <- 'http://www.football-data.co.uk/usa.php'
' After years of searching, I found football-data-co-uk that has a excel schedule going back to 2013 games. I would
Have liked it going back to 2010 or earlier but this is a good start. It has 2000+ games. The idea is to fold this in such
a way to create urls for mls.com and pull the necessary data.
'

###     Schedule 2
#url_2<- 'https://www.skysports.com/mls-results/2017-18'
' Doesnt work very well for pulling data. Comes out in weird table format that would be time consuming for doing multiple seasons.
'
