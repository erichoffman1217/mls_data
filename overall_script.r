library('rvest')
url_1 <- 'https://matchcenter.mlssoccer.com/matchcenter/2018-10-08-seattle-sounders-fc-vs-houston-dynamo/boxscore'
info_webpage <- read_html(url_1)




score_html <- html_nodes(info_webpage, '.sb-club-name')

away_team <- html_text(html_nodes(info_webpage, '.sb-away .sb-club-name-full'))
home_team <- html_text(html_nodes(info_webpage, '.sb-home .sb-club-name-full'))
home_score <- html_text(html_nodes(info_webpage, '.sb-home .sb-score'))
away_score <- html_text(html_nodes(info_webpage, '.sb-away .sb-score'))
date <- html_text(html_nodes(info_webpage, '.sb-match-date'))
time <- html_text(html_nodes(info_webpage, '.sb-match-time'))
match_info <- html_text(html_nodes(info_webpage, '.match-info div'))
field <- match_info[1]
location <- match_info[2]
attendance <- match_info[3]
weather <- match_info[4]

### Notes
' Not the most efficient way to scrape but do it once and forget about it.
        Problem: need to create four tables initially, then combine h_player and h_goalie. Goalies
        have different stats than players do. Apparently
'

h_players_no <- as.data.frame(html_text(html_nodes(info_webpage,'.ps-table:nth-child(1) tbody td:nth-child(1)')))
h_players_pos <-as.data.frame(html_text(html_nodes(info_webpage,'.ps-table:nth-child(1) tbody td:nth-child(2)' )))
h_players <- as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) .ps-name' )))
h_players_min <- as.data.frame(html_text(html_nodes(info_webpage,'.ps-table:nth-child(1) .ps-name+ td' )))
h_players_g <- as.data.frame(html_text(html_nodes(info_webpage,'.ps-table:nth-child(1) td:nth-child(5)' )))
h_players_a <- as.data.frame(html_text(html_nodes(info_webpage,'' )))
h_players_sht <- as.data.frame(html_text(html_nodes(info_webpage,'' )))
h_players_sog <- as.data.frame(html_text(html_nodes(info_webpage,'' )))
h_players_ck <- as.data.frame(html_text(html_nodes(info_webpage,'' )))
h_players_off <- as.data.frame(html_text(html_nodes(info_webpage,'' )))
h_players_fc <- as.data.frame(html_text(html_nodes(info_webpage,'' )))
h_players_fs <- as.data.frame(html_text(html_nodes(info_webpage,'' )))


a_players_no <- as.data.frame(html_text(html_nodes(info_webpage,'.ps-table:nth-child(1) tbody td:nth-child(1)')))
a_players_pos <-as.data.frame(html_text(html_nodes(info_webpage,'.ps-table:nth-child(1) tbody td:nth-child(2)' )))
a_players <- as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table:nth-child(1) .ps-name' )))
a_players_min <- as.data.frame(html_text(html_nodes(info_webpage,'.ps-table:nth-child(1) .ps-name+ td' )))
a_players_g <- as.data.frame(html_text(html_nodes(info_webpage,'' )))
a_players_a <- as.data.frame(html_text(html_nodes(info_webpage,'' )))
a_players_sht <- as.data.frame(html_text(html_nodes(info_webpage,'' )))
a_players_sog <- as.data.frame(html_text(html_nodes(info_webpage,'' )))
a_players_ck <- as.data.frame(html_text(html_nodes(info_webpage,'' )))
a_players_off <- as.data.frame(html_text(html_nodes(info_webpage,'' )))
a_players_fc <- as.data.frame(html_text(html_nodes(info_webpage,'' )))
a_players_fs <- as.data.frame(html_text(html_nodes(info_webpage,'' )))


a_players <- as.data.frame(html_text(html_nodes(info_webpage,'h1+ .clearfix .ps-table+ .ps-table .ps-name' )))
h_goalie <- as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table:nth-child(1) .ps-name' )))
a_goalie <- as.data.frame(html_text(html_nodes(info_webpage,'.clearfix+ .clearfix .ps-table+ .ps-table .ps-name' )))


.ps-table:nth-child(1) .ps-name


        
try_again <- html_table(html_nodes(info_webpage,'.ps-table td'), fill=TRUE)









        <- html_text(html_nodes(info_webpage, ))



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
