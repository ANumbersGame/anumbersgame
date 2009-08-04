#!/bin/bash

cat <<EOF

use DebateResultsAll;


drop table
if exists ballots;

drop table 
if exists rounds;

drop table
if exists teams;

create table teams (

   year smallint unsigned not null,

   id int not null
   comment 'the original primary key from debateresults.com',
   unique key (year,id),
   

   speaker1 int,
   -- foreign key (year,speaker1) references people (year,id,'competitor' as role),
   speaker2 int,
   -- foreign key (year,speaker2) references people (year,id,'competitor' as role),
   speaker3 int
   comment 'No teams through 2008-2009 have a third speaker',
   
   name varchar(100),
   shortname varchar(50),

   firstroundApplicant enum ('no','yes'),
   secondroundApplicant enum ('no','yes'),
   qualifyNDT enum ('no','yes')
   comment 'Did the team qualify (via either first-round bid or districts; second rounds are "no"s). Probably not good data'
   
)
/*
type = InnoDB
*/
EOF

for YEAR in $(seq 2004 1 2009)
do
    PREV=$(( ${YEAR} - 1 ))
    cat <<EOF

select 
${YEAR} as year,
TeamNum as id,
Speaker1 as speaker1,
Speaker2 as speaker2,
Speaker3 as speaker3,
FullName as name,
Acronym as shortname,

if(FirstRd = 0, 'no',
if(FirstRd = '-1', 'yes',
if(FirstRd = '1', 'yes',
if(FirstRd is null, null, '')))) as firstroundApplicant,

if(SecondRd = 0, 'no',
if(SecondRd = '-1', 'yes',
if(SecondRd = '1', 'yes',
if(SecondRd is null, null, '')))) as secondroundApplicant,

if(NDTQual = 0, 'no',
if(NDTQual = '-1', 'yes',
if(NDTQual = '1', 'yes',
if(NDTQual is null, null, '')))) as qualifyNDT

from DebateResults${PREV:2}${YEAR:2}.TeamNumbers

union all

EOF

done

cat <<EOF

select 1,2,3,4,5,6,7,8,9,10
from DebateResults0304.TeamNumbers
where 1=0;

EOF