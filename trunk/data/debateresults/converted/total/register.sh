#!/bin/bash

cat <<EOF

use DebateResultsAll;

drop table
if exists teamRegister;

create table
teamRegister (

   year smallint unsigned not null,
   tournament int unsigned,
   speaker1 int unsigned,
   speaker2 int unsigned,
   speaker3 int unsigned,
   division int unsigned,
   school int unsigned

)
select 
2009 as year,
Tournament as tournament,
SpeakerOne as speaker1,
SpeakerTwo as speaker2,
SpeakerThree as speaker3,
School as school,
Division as division
from DebateResults0809.TeamEntries;

drop table
if exists
judgeRegister;

create table
judgeRegister (

   year smallint unsigned not null,
   tournament int unsigned,
   judge int unsigned,
   school int unsigned

)
select 
2009 as year,
Tournament as tournament,
Judge as judge,
School as school
from DebateResults0809.JudgeEntries;

EOF