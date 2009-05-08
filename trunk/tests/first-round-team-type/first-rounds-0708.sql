USE DebateResults0708;

ALTER TABLE TeamNumbers
ADD COLUMN RecvdFirstRd
BIT 
NULL
DEFAULT NULL;

ALTER TABLE TeamNumbers
ADD INDEX (RecvdFirstRd);

UPDATE TeamNumbers
SET RecvdFirstRd = b'1'
WHERE 
0 !=
LOCATE(FullName,
'
| Berkle Burshteyn/Polin    | 
| Dartmth Olsen/Kernoff     | 
| Emory Hoehn/Weil          | 
| Emory Schwab/Miller       | 
| Harvard Anders/Murray     | 
| Harvard Rebrovick/Warsh   | 
| Kansas Jennings/Bricker   | 
| Kansas Johnson/Stone      | 
| Michigan Keenan/Farra     | 
| MictSt Eyzaguirre/Lanning | 
| Mo St Osborn/Webb         | 
| Nwstrn Bruce/Mulholand    | 
| Nwstrn Warden/Fisher      | 
| USC Jones/Jones           | 
| WakeFr Lamballe/Gannon    | 
| WestGa Lundeen/Schultz    |
');

/*
These are not the most efficient, but they're fast enough
*/

SELECT JudgeDec, COUNT(*)
FROM Ballots,MasterResults,TeamNumbers as AffNum, TeamNumbers as NegNum
WHERE MasterResultsID = ID
AND AffTeam = AffNum.TeamNum
AND NegTeam = NegNum.TeamNum
AND AffNum.RecvdFirstRd = b'1'
AND NegNum.RecvdFirstRd = b'1'
GROUP BY JudgeDec;

SELECT JudgeDec, COUNT(*)
FROM Ballots,MasterResults,TeamNumbers as AffNum, TeamNumbers as NegNum
WHERE MasterResultsID = ID
AND AffTeam = AffNum.TeamNum
AND NegTeam = NegNum.TeamNum
AND AffNum.RecvdFirstRd = b'1'
AND NegNum.RecvdFirstRd = b'1'
AND AffTeam != 321 /* NW BM */
AND AffTeam != 348 /* Emory MS */
GROUP BY JudgeDec;

SELECT JudgeDec, COUNT(*)
FROM Ballots,MasterResults,TeamNumbers as AffNum, TeamNumbers as NegNum
WHERE MasterResultsID = ID
AND AffTeam = AffNum.TeamNum
AND NegTeam = NegNum.TeamNum
AND AffNum.FirstRd = 1
AND NegNum.FirstRd = 1
GROUP BY JudgeDec;
