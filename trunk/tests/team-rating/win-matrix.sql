SELECT MAX(TeamNum) as ``
FROM TeamNumbers;

SELECT COUNT(*) as `` 
FROM 
(
SELECT 
IF(JudgeDec=1,AffTeam,NegTeam) as Win, 
IF(JudgeDec=2,AffTeam,NegTeam) as Lose,
COUNT(*) as val
FROM MasterResults,Ballots 
WHERE MasterResultsID=ID
AND (JudgeDec=1 OR JudgeDec=2)
GROUP BY Win, Lose
ORDER BY Win, Lose
) as must;

SELECT CONCAT(Win,'\n',Lose,'\n',val) as `` 
FROM
(
SELECT 
IF(JudgeDec=1,AffTeam,NegTeam) as Win, 
IF(JudgeDec=2,AffTeam,NegTeam) as Lose,
COUNT(*) as val
FROM MasterResults,Ballots 
WHERE MasterResultsID=ID
AND (JudgeDec=1 OR JudgeDec=2)
GROUP BY Win, Lose
ORDER BY Win, Lose
) as must;