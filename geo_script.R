library(geosphere)
library(tidyverse)
library(readxl)

team_key <- read_excel("~/R/mls_data/team_key.xlsx")

dist_only <- select(team_key, team_no, lat, long)

expand.grid(team_key$team_no, team_key$team_no) %>%
        rename(home_team = Var1, away_team = Var2 ) %>%
        filter(home_team != away_team) -> dist_mat
dist_mat <- merge(dist_mat, dist_only, by.x = 'home_team', by.y = 'team_no')
dist_mat <- rename(dist_mat, home_lat = lat, home_long = long)
dist_mat <- merge(dist_mat, dist_only, by.x = 'away_team', by.y = 'team_no')
dist_mat <- rename(dist_mat, away_lat = lat, away_long = long)


#dist_mat$dist <- distm(dist_mat[,c('home_long','home_lat')], dist_mat[,c('away_long','away_lat')], fun=distVincentyEllipsoid)
dist_mat$dist_1 <- distVincentyEllipsoid(dist_mat[,c('home_long','home_lat')], dist_mat[,c('away_long','away_lat')])


write.table(dist_mat, file = "dist_matrix.txt", quote = FALSE, sep = '|', na= "", row.names = FALSE)        

