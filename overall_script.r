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
# schedule_url <- 'http://www.football-data.co.uk/usa.php'
' After years of searching, I found football-data-co-uk that has a excel schedule going back to 2013 games. I would
Have liked it going back to 2010 or earlier but this is a good start. It has 2000+ games. The idea is to fold this in such
a way to create urls for mls.com and pull the necessary data.
'
