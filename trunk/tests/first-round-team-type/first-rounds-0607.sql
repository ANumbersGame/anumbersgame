USE DebateResults0607;

ALTER TABLE TeamNumbers
ADD COLUMN FirstRdCharacter
ENUM('critique','policy','mainly policy')
NULL
DEFAULT NULL
COMMENT 'Characterization of first rounds by Nate Cohn';

ALTER TABLE TeamNumbers
ADD INDEX (FirstRdCharacter);

UPDATE TeamNumbers
SET FirstRdCharacter = 'critique'
WHERE 
0 !=
LOCATE(Acronym,
'
| CSUF MoMa     | 1
| IdahoS YeMo   | 2
| Oklhma ClJo   | 3
| UMKC GoFo     | 4
| WayneS MuTi   | 5
');

UPDATE TeamNumbers
SET FirstRdCharacter = 'policy'
WHERE 
0 !=
LOCATE(Acronym,
'
| Emory HaHo    | 6
| Harvard AnMu  | 7
| Harvard MiRe  | 8
| Kansas JeBr   | 9
| Nwstrn BrWa   | 10
| Nwstrn ChSh   | 11
| USC IfSm      | 12
| Whitman RiSc  | 13
');

UPDATE TeamNumbers
SET FirstRdCharacter = 'mainly policy'
WHERE 
0 !=
LOCATE(Acronym,
'
| Dartmth ClOl  | 14
| Emory MiPr    | 15
| Georgia CuRa  | 16
');

/*
These are not the most efficient, but they're fast enough
*/

SELECT AffNum.FirstRdCharacter as `aff type`, 
IF(JudgeDec=1,'AFF','   neg') as `winner`, 
COUNT(*)
FROM Ballots,MasterResults,TeamNumbers as AffNum, TeamNumbers as NegNum
WHERE MasterResultsID = ID
AND AffTeam = AffNum.TeamNum
AND NegTeam = NegNum.TeamNum
AND AffNum.FirstRdCharacter IS NOT NULL
AND NegNum.FirstRdCharacter IS NOT NULL
AND (JudgeDec = 1 OR JudgeDec = 2)
GROUP BY AffNum.FirstRdCharacter, JudgeDec;