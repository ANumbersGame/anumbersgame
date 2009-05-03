SELECT MAX(TeamNum) as ``
FROM TeamNumbers;

SELECT COUNT(*) AS ``
FROM TeamNumbers;

SELECT CONCAT(TeamNum,'\n',Acronym) as ``
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
/*
AND AffTeam+NegTeam < 800
*/
/* 2007 -2008 tournaments */
/* 156 is very interesting, 211, 225, 160 is CEDA, 222 is D1, 123 is first, < 150 is nice*/
/* 196, 143, adn 123 together is nice */
/* NORCAL:
AND (Tournament = 196 OR Tournament = 143 OR Tournament = 123 OR Tournament = 217 OR Tournament = 212 OR Tournament = 222)*/
/* NDT is 149 */
/* 183 is odd */
/* 189 has mnay levels */
/* 180 has a hidden JV? */
/* 130 looks funny: average */
AND Round < 10
AND (Tournament = 179)
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
/*
AND AffTeam+NegTeam < 800
*/
AND Round < 10
AND (Tournament = 179)
GROUP BY Win, Lose
ORDER BY Win, Lose
) as must;

/*
AND 
(AffTeam=1154
OR AffTeam=1143
OR AffTeam=1142
OR AffTeam=1091
OR AffTeam=1024
OR AffTeam=1014
OR AffTeam=1013
OR AffTeam=1011
OR AffTeam=1005
OR AffTeam=1004
OR AffTeam=938
OR AffTeam=937
OR AffTeam=934
OR AffTeam=926
OR AffTeam=925
OR AffTeam=923
OR AffTeam=921
OR AffTeam=920
OR AffTeam=918
OR AffTeam=526)
AND
(NegTeam=1154
OR NegTeam=1143
OR NegTeam=1142
OR NegTeam=1091
OR NegTeam=1024
OR NegTeam=1014
OR NegTeam=1013
OR NegTeam=1011
OR NegTeam=1005
OR NegTeam=1004
OR NegTeam=938
OR NegTeam=937
OR NegTeam=934
OR NegTeam=926
OR NegTeam=925
OR NegTeam=923
OR NegTeam=921
OR NegTeam=920
OR NegTeam=918
OR NegTeam=526)
*/
