library('rvest')
url_1 <- 'https://matchcenter.mlssoccer.com/matchcenter/2018-10-08-seattle-sounders-fc-vs-houston-dynamo/boxscore'
url_2<- 'https://www.skysports.com/mls-results/2017-18'
info_webpage <- read_html(url_1)
schedule_webpage <- read_html(url_2)



score_html <- html_nodes(webpage, '.sb-club-name')

away_html<- html_nodes(webpage, '.sb-away .sb-club-name-full')
away_html<- html_nodes(webpage, '.sb-away .sb-club-name-full')
away_team <- html_text(html_nodes(webpage, '.sb-away .sb-club-name-full'))
home_team <- html_text(html_nodes(webpage, '.sb-home .sb-club-name-full'))
home_score <- html_text(html_nodes(webpage, '.sb-home .sb-score'))
away_score <- html_text(html_nodes(webpage, '.sb-away .sb-score'))
date <- html_text(html_nodes(webpage, '.sb-match-date'))
date <- html_text(html_nodes(webpage, '.sb-match-time'))
match_info <- html_text(html_nodes(webpage, '.match-info div'))
field <- match_info[1]
location <- match_info[2]
attendance <- match_info[3]
weather <- match_info[4]
players <- as.data.frame(html_text(html_nodes(webpage,'.ps-name' )))




        <- html_text(html_nodes(webpage, ))



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
url_2<- 'https://www.skysports.com/mls-results/2017-18'

schedule_webpage <- read_html(url_2)

game_dates <- as.data.frame(html_text(html_nodes(schedule_webpage,'.fixres__header2')))
games_home <- as.data.frame(html_text(html_nodes(schedule_webpage,'.matches__participant--side1')))
games_away <- as.data.frame(html_text(html_nodes(schedule_webpage,'.matches__participant--side2')))
games_outcome <- as.data.frame(html_text(html_nodes(schedule_webpage,'.matches__status')))

test<- as.data.frame(html_text(html_nodes(schedule_webpage,".fixres__header2 , .fixres__header1")))
test_1 <- as.data.frame(html_text(html_nodes(schedule_webpage,".matches__status , .matches__participant--side2 , .matches__participant--side1 , .fixres__header2 , .fixres__header1")))


###     Schedule 2
url_3 <- 'https://www.flashscore.com/football/usa/mls/results/'
schedule_webpage <- read_html(url_3)
test_1 <- html_text(html_nodes(schedule_webpage,'.bold , .padl , .padr , .time'))




