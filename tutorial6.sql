-- Modify it to show the matchid and player name for all goals scored by Germany
SELECT matchid, player
FROM goal
WHERE teamid = 'GER'

-- Show id, stadium, team1, team2 for just game 1012
SELECT id,stadium,team1,team2
FROM game
WHERE id = 1012

-- Modify it to show the player, teamid, stadium and mdate for every German goal
SELECT player,teamid,stadium,mdate
FROM game
JOIN goal
ON game.id = goal.matchid
WHERE goal.teamid = 'GER'

-- Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT team1, team2, player
FROM game
JOIN goal
ON game.id = goal.matchid
WHERE goal.player LIKE 'Mario%'

-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
FROM goal
JOIN eteam
ON goal.teamid = eteam.id
WHERE gtime<=10

-- List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach
SELECT game.mdate, eteam.teamname
FROM game
JOIN eteam
ON eteam.id = team1
WHERE eteam.coach = 'Fernando Santos'

-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT goal.player
FROM game
INNER JOIN goal
ON game.id = goal.matchid
WHERE game.stadium = 'National Stadium, Warsaw'

-- Instead show the name of all players who scored a goal against Germany
SELECT DISTINCT player
FROM game
JOIN goal
ON goal.matchid = game.id
WHERE (team1='GER' OR team2='GER')
AND goal.teamid != 'GER'

-- Show teamname and the total number of goals scored
SELECT teamname, COUNT(*)
FROM eteam
JOIN goal
ON eteam.id = goal.teamid
GROUP BY teamname

-- Show the stadium and the number of goals scored in each stadium
SELECT stadium, COUNT(*)
FROM game
JOIN goal
ON game.id = goal.matchid
GROUP BY game.stadium

-- For every match involving 'POL', show the matchid, date and the number of goals scored
SELECT goal.matchid, game.mdate, COUNT(*)
FROM game
JOIN goal
ON game.id = goal.matchid
WHERE game.team1 = 'POL' OR game.team2 = 'POL'
GROUP BY game.mdate, goal.matchid
ORDER BY COUNT(*) DESC

-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT goal.matchid, game.mdate, COUNT(*)
FROM game
JOIN goal
ON game.id = goal.matchid
WHERE goal.teamid = 'GER'
GROUP BY goal.matchid, game.mdate

-- Sort your result by mdate, matchid, team1 and team2
--NOT ENTIRELY CORRECT BUT NO RESOURCE TO FIND WHAT
SELECT mdate, team1, SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) AS score1,
              team2, SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) AS score2
FROM game
JOIN goal
ON goal.matchid = game.id
GROUP BY mdate, team1, team2
ORDER BY mdate, matchid, team1, team2;
