library(tidyverse)
library(readxl)

team_db <- read_delim("database/raw/team_db.txt", 
                      "|", escape_double = FALSE,trim_ws = TRUE)
game_db <- read_delim("database/raw/game_db.txt", 
                      "|", escape_double = FALSE,trim_ws = TRUE)
players_db <- read_delim("database/raw/players_db.txt", 
                      "|", escape_double = FALSE,trim_ws = TRUE)
goalie_db <- read_delim("database/raw/goalie_db.txt", 
                      "|", escape_double = FALSE,trim_ws = TRUE)
team_key <- read_excel("~/R/mls_data/team_key.xlsx")

dist_matrix <- read_delim("dist_matrix.txt", 
                        "|", escape_double = FALSE,trim_ws = TRUE)
###     Team
team_db %>%
        group_by(team_no) %>%
        count (team_no)-> test
        



###     Game
dist_matrix <- select(dist_matrix, home_team, away_team, dist_1)
game_db <- merge(game_db, dist_matrix, by.x = c('home_team_no', 'away_team_no'),by.y = c('home_team', 'away_team'))


###     Players



###     Goalie