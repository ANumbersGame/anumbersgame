#!/bin/bash

if [[ $1 = '' || $2 = '' ]]
then
    echo "Usage: $0 DATABASE TOURNAMENT_NUMBER YEAR produces an SVG and PNG of the strongly-connected components in the directory named DATABASE"
    exit 1
else
    readonly QUERY=(mktemp)
    cat >$QUERY <<EOF 
USE $1;

SELECT MAX(TeamNum) AS ''
FROM TeamNumbers;

SELECT COUNT(*) AS ''
FROM TeamNumbers
WHERE TeamNum IS NOT NULL
AND Acronym IS NOT NULL;

SELECT CONCAT(TeamNum,'\n',Acronym) as ''
FROM TeamNumbers
WHERE TeamNum IS NOT NULL
AND Acronym IS NOT NULL;

CREATE TEMPORARY TABLE TempTourn
SELECT 
IF(JudgeDec=1,AffTeam,NegTeam) as Win, 
IF(JudgeDec=2,AffTeam,NegTeam) as Lose,
COUNT(*) as val
FROM MasterResults,Ballots 
WHERE MasterResultsID=ID
AND (JudgeDec=1 OR JudgeDec=2)
AND Round < 10
AND Tournament = $2
GROUP BY Win, Lose
ORDER BY Win, Lose;

SELECT COUNT(*) as ''
FROM TempTourn;

SELECT CONCAT(Win,'\n',Lose,'\n',val) as ''
FROM TempTourn;
EOF
    mkdir -p ${1}
    mysql -r < $QUERY | ./sccPic > ${1}/${2}.dot
    cat >$QUERY <<EOF
USE $1;

SELECT TourneyName as ''
FROM MasterTournaments
WHERE ID = ${2};
EOF
    NAME=$(mysql < $QUERY | ./cleanName);

    echo ${1} ${2}
    sed "s/replace\.tournament\.name\.with\.shorter\.string\.anumbersgame\.net/${NAME}, ${3}/g" ${1}/${2}.dot >"${1}/${NAME}".dot
    rm ${1}/${2}.dot
#    setsid dot -Txdot "${1}/${NAME}.dot" > "${1}/${NAME}.xdot"
#    setsid dot -Tsvg  "${1}/${NAME}.dot" > "${1}/${NAME}.svg"
    setsid dot -Tpng  "${1}/${NAME}.dot" > "${1}/${NAME}.png"
    rm $QUERY
fi