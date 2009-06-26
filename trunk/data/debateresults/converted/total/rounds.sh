#!/bin/bash

cat <<EOF

use DebateResultsAll;

drop table
if exists ballots;

drop table
if exists rounds;

create table
rounds (

   year smallint unsigned not null
   comment 'year ending the season in which the round was held',
   tournament int not null
   comment 'tournament holding the round',
   foreign key (year, tournament)
   references tournaments (year,id),

   id int not null
   comment 'original primary key',
   unique key (year,id),

   roundNum tinyint not null
   comment 'Negative values denote elim rounds. -1 is finals, -2 is semis, etc.',

   level enum ('open', 'JV', 'novice', 'rookie') not null,

   affTeam int not null,
/*
   foreign key (year, affTeam)
   references teams (year,id),
*/   
   negTeam int not null,
/*
   foreign key (year, negTeam)
   references teams (year,id),
*/

   aff1 int,
/*
   foreign key (year, aff1)
   references people (year,id,'competitor' as role)
*/

   aff2 int,
   neg1 int,
   neg2 int,


   affwin varchar(100), -- enum ('loss', 'win', 'bye', 'forfeit') not null,
   negwin varchar(100), -- enum ('loss', 'win', 'bye', 'forfeit', 'closed out') not null,

   affElims enum ('none','cleared','missed on points','missed on points and cleared?') not null,
   negElims enum ('none','cleared','missed on points','missed on points and cleared?') not null,

   result enum ('ballots', 'bye', 'aff walk') not null

EOF

for JUDNUM in $(seq 9)
do
    cat <<EOF
/*
,Judge${JUDNUM} int
,JudgeDec${JUDNUM} int
*/
EOF

done

cat <<EOF

) type = InnoDB

EOF

for YEAR in $(seq 2004 1 2009)
do
    PREV=$(( ${YEAR} - 1 ))
    if [[ ${YEAR} -ge 2009 ]]
    then
	LVL="Division"
    else
	LVL="Diivision"
    fi
    cat <<EOF

select

${YEAR} as year,
Tournament as tournament,
ID as id,
if(Round < 10, Round, Round - 17) as roundNum,
${LVL} as level,
AffTeam as affteam,
NegTeam as negteam,

AffOne as aff1,
AffTwo as aff2,
NegOne as neg1,
NegTwo as neg2,


Affwin as affwin,
Negwin as negwin,

if(AffClr = 1 or AffClr = -1, if(AffMOP = 0, 'cleared',
if(AffMOP = 1 or AffMOP = -1, 'missed on points and cleared?','')),
if(AffClr = 0, if(AffMOP = 0, 'none',
if(AffMOP = 1 or AffMOP = -1, 'missed on points','')),'')) as affElims,

if(NegClr = 1 or NegClr = -1, if(NegMOP = 0, 'cleared',
if(NegMOP = 1 or NegMOP = -1, 'missed on points and cleared?','')),
if(NegClr = 0, if(NegMOP = 0, 'none',
if(NegMOP = 1 or NegMOP = -1, 'missed on points','')),'')) as negElims

EOF

for JUDNUM in $(seq 9)
do
    cat <<EOF
/*
,Judge${JUDNUM}
,JudgeDec${JUDNUM}
*/
EOF

done

cat <<EOF

,'' as result
from DebateResults${PREV:2}${YEAR:2}.MasterResults

union all

EOF
done

cat <<EOF

select 1,2,3,4,5,6,7,8,9,10,11
,12,13,14,15,16
/*
,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29
*/
from DebateResults0304.MasterResults
where 1 = 0;

update rounds
set result = 'bye'
where negteam = 0;

drop table
if exists ballots;

create table ballots
(
   year smallint unsigned not null
   comment 'year ending the season in which the ballot was signed',
   round int not null,
   foreign key (year,round)
   references rounds (year,id),

   judgeOrder tinyint unsigned not null,


   judge int,
   decision int,

   aff1points int,
   aff2points int,
   neg1points int,
   neg2points int,

   aff1rank int,
   aff2rank int,
   neg1rank int,
   neg2rank int

) type = InnoDB

EOF

for YEAR in $(seq 2004 1 2009)
do
    PREV=$(( ${YEAR} - 1 ))
    for JUNO in $(seq 9)
    do
	A1P="PointsAff${JUNO}1"
	A2P="PointsAff${JUNO}2"
	N1P="PointsNeg${JUNO}1"
	N2P="PointsNeg${JUNO}2"

	A1R="RankAff${JUNO}1"
	A2R="RankAff${JUNO}2"
	N1R="RankNeg${JUNO}1"
	N2R="RankNeg${JUNO}2"

	if [[ ${JUNO} -gt 3 ]]
	then
	    A1P=0
	    A2P=0
	    N1P=0
	    N2P=0

	    A1R=0
	    A2R=0
	    N1R=0
	    N2R=0
	fi

	cat <<EOF

select
${YEAR} as year,
ID as round,
${JUNO} as judgeOrder,
Judge${JUNO} as judge,
JudgeDec${JUNO} as decision,

${A1P} as aff1points,
${A2P} as aff2points,
${N1P} as neg1points,
${N2P} as neg2points,

${A1R} as aff1rank,
${A2R} as aff2rank,
${N1R} as neg1rank,
${N2R} as neg2rank

from DebateResults${PREV:2}${YEAR:2}.MasterResults
where NegTeam != 0
and (Judge${JUNO} != 0
or JudgeDec${JUNO} != 0)
and not (${JUNO} = 3
and JudgeDec2 = 0
and Judge2 = 0
and Judge3 = 0)

union all

EOF
    done
done

cat <<EOF

select 1,2,3,4,5
,6,7,8,9
,10,11,12,13
from DebateResults0304.MasterResults
where 1 = 0;

drop table if exists ballotsum;

create table ballotsum
select have.*, affwin, negwin
from rounds, 
(select year, round, 
sum(d0) as s0, sum(d1) as s1, sum(d2) as s2, sum(d3) as s3, sum(d4) as s4, sum(d5) as s5, sum(d6) as s6 
from 
(select year, round, 
decision = 0 as d0, decision = 1 as d1, decision = 2 as d2, decision = 3 as d3, decision = 4 as d4, decision = 5 as d5, decision = 6 as d6 
from ballots) as must 
group by year, round) 
as have 
where have.year = rounds.year 
and have.round = rounds.id;

update rounds, ballotsum
set rounds.result = 'ballots'
where rounds.year = ballotsum.year
and rounds.id = ballotsum.round
and result = ''
and s0 = 0
and s3 = 0
and s4 = 0
and s5 = 0
and s6 = 0;

update rounds, ballotsum
set rounds.result = 'aff walk'
where rounds.year = ballotsum.year
and rounds.id = ballotsum.round
and result = ''
and (rounds.affwin = 'win'
or rounds.affwin = 'bye')
and s1 = 0
and s2 = 0
and s3 = 0
and s4 = 0
and s6 = 0;

delete ballots.*
from ballots, rounds
where ballots.round = rounds.id
and ballots.year = rounds.year
and rounds.result = 'aff walk';

drop table if exists ballotsum;
/*
create table ballotsum
select have.*, affwin, negwin
from rounds, 
(select year, round, 
sum(d0) as s0, sum(d1) as s1, sum(d2) as s2, sum(d3) as s3, sum(d4) as s4, sum(d5) as s5, sum(d6) as s6 
from 
(select year, round, 
decision = 0 as d0, decision = 1 as d1, decision = 2 as d2, decision = 3 as d3, decision = 4 as d4, decision = 5 as d5, decision = 6 as d6 
from ballots) as must 
group by year, round) 
as have 
where have.year = rounds.year 
and have.round = rounds.id;
*/
alter table rounds
drop column affwin;

alter table rounds
drop column negwin;

alter table rounds
drop column affelims;

alter table rounds
drop column negelims;

EOF