SELECT *
FROM NBAMisc
ORDER BY 2,1

SELECT *
FROM NBAPerGame
ORDER BY TEAM

-- Counts the number of elite 3pt shooters (snipers) on every Team w/o using SNIPER column
SELECT UPPER(TEAM) as TEAM, COUNT(NAME) as NumberOfSnipers
FROM NBAMisc
WHERE "3P%" >= 0.37
GROUP BY TEAM

-- Shows every NBA player's FT, 2P, and 3P averages per number of games they've played
SELECT misc.NAME, UPPER(misc.TEAM) as TEAM, (misc.FTA/perG.GP) as FTperGame, (misc."2PA"/perG.GP) as "2PperGame", (misc."3PA"/perG.GP) as "3PperGame"
FROM NBAMisc misc
JOIN NBAPerGame perG
ON misc.NAME = perG.NAME and misc.TEAM = perG.TEAM
ORDER BY TEAM

-- Counts how many players are/were on each team this year, partitioned by each player
SELECT TEAM, NAME, COUNT(NAME) OVER (Partition by TEAM) as TotalPlayers
FROM NBAMisc misc
ORDER BY 1

-- Shows every NBA team's oldest and youngest players
DROP TABLE if exists #OldAges
CREATE TABLE #OldAges
(
TEAM nvarchar(255),
OldAGE float
)
INSERT INTO #OldAges
SELECT TEAM, MAX(AGE)
FROM NBAMisc
GROUP BY TEAM

DROP TABLE if exists #YoungAges
CREATE TABLE #YoungAges
(
TEAM nvarchar(255),
YoungAGE float
)
INSERT INTO #YoungAges
SELECT TEAM, MIN(AGE)
FROM NBAMisc
GROUP BY TEAM

SELECT UPPER(NBAMisc.TEAM) as TEAM, NBAMisc.NAME, #OldAges.OldAGE
FROM #OldAges
JOIN NBAMisc
ON #OldAges.TEAM = NBAMisc.TEAM and #OldAges.OldAGE = NBAMisc.AGE
ORDER BY TEAM

SELECT UPPER(NBAMisc.TEAM) as TEAM, NBAMisc.NAME, #YoungAges.YoungAGE
FROM #YoungAges
JOIN NBAMisc
ON #YoungAges.TEAM = NBAMisc.TEAM and #YoungAges.YoungAGE = NBAMisc.AGE
ORDER BY TEAM

CREATE VIEW TeamSnipers as
SELECT UPPER(TEAM) as TEAM, COUNT(NAME) as NumberOfSnipers
FROM NBAMisc
WHERE "3P%" >= 0.37
GROUP BY TEAM

CREATE VIEW OffensiveNumbers as
SELECT misc.NAME, UPPER(misc.TEAM) as TEAM, (misc.FTA/perG.GP) as FTperGame, (misc."2PA"/perG.GP) as "2PperGame", (misc."3PA"/perG.GP) as "3PperGame"
FROM NBAMisc misc
JOIN NBAPerGame perG
ON misc.NAME = perG.NAME and misc.TEAM = perG.TEAM

CREATE VIEW TotalPlayers as
SELECT TEAM, NAME, COUNT(NAME) OVER (Partition by TEAM) as TotalPlayers
FROM NBAMisc misc

CREATE VIEW OldPlayers as
SELECT TEAM, MAX(AGE) as OldAge
FROM NBAMisc
GROUP BY TEAM

CREATE VIEW YoungPlayers as
SELECT TEAM, MIN(AGE) as YoungAge
FROM NBAMisc
GROUP BY TEAM









