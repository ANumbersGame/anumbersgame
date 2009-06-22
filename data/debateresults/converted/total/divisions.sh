#!/bin/bash

cat <<EOF

use DebateResultsAll;

create table
divisions
(
   year smallint unsigned not null
   comment 'year ending the season in which the division was held',
   tournament int not null
   comment 'tournament holding the division',
/*
   foreign key (year,tournament)
   references tournaments (year,id)
   on update cascade,
*/

   name varchar(60),

   level enum ('open', 'JV', 'novice', 'rookie'),

   speakerRanks enum ('no', 'yes') not null,   
   
   maxPoints smallint unsigned,

   rounds tinyint unsigned,

   prelimJudges tinyint unsigned,

   style enum ('policy', 'NFA LD', 'parli'),

   MPJ enum ('no','yes') not null

)
type = InnoDB
/*charset = utf8*/
EOF

for DIV in 1 2 3 4 
do
    cat <<EOF

select
2004 as year,
ID as tournament,
null as name,
NameD${DIV} as level,
RRanksD${DIV} as speakerRanks,
MaxPtsD${DIV} as maxPoints,
RdsD${DIV} as rounds,
PrelimJudges as prelimjudges,
null as style,
'' as MPJ
from DebateResults0304.MasterTournaments
union all

EOF
done

for YEAR in $(seq 2005 1 2008)
do
    PREV=$(( ${YEAR} - 1 ))
    cat <<EOF

select
${YEAR} as year,
Tournament as tournament,
DiivName as name,
Lvl as level,
RRanks as speakerRanks,
MaxPts as maxPoints,
Rds as rounds,
PrelimJudges as prelimjudges,
DebateType as style,
UsePrefs as MPJ
from DebateResults${PREV:2}${YEAR:2}.DebateDiivisions
union all

EOF
done

cat <<EOF

select
2009 as year,
Tournament as tournament,
DivName as name,
Lvl as level,
if(RRanks='0','no',
if(RRanks='-1','yes','')) as speakerRanks,
MaxPts as maxPoints,
Rds as rounds,
PrelimJudges as prelimjudges,
DebateType as style,
if(UsePrefs='0','no',
if(UsePrefs='-1','yes','')) as MPJ
from DebateResults0809.DebateDivisions

/*
union all
*/
/*
select 1,2,3,4,5,6,7,8,9
from DebateResults0304.MasterTournaments
where 1 = 0
*/
;
EOF