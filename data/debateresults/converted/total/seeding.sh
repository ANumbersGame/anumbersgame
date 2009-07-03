#!/bin/bash

cat <<EOF
use DebateResultsAll;

drop table
if exists mapseed;

create table mapseed
(
   oldname varchar(50) not null,
   unique key (oldname),
   newname enum 
   ('wins',
   'ballots',
   'points',
   '1x adjusted points',
   '2x adjusted points',
   '3x adjusted points',
   '4x adjusted points',
   'judge variance',
   'ranks',
   'adjusted ranks',
   'opponent wins',
   'opponent points',
   'random') not null
);


drop procedure
if exists
loopid;

delimiter |

create procedure loopid()
begin
   declare loopc int unsigned default 0;
   while loopc < 14 do
      insert into mapseed
      set oldname = loopc,
      newname = loopc;
      set loopc = loopc + 1;
   end while;
end|

delimiter ;

call loopid();

insert into mapseed
set oldname = 'Wins',
newname = 'wins';

insert into mapseed
set oldname = 'Ballots',
newname = 'ballots';

insert into mapseed
set oldname = 'Total Points',
newname = 'points';

insert into mapseed
set oldname = 'Hi/Lo Points',
newname = '1x adjusted points';

insert into mapseed
set oldname = 'Double hi/lo points',
newname = '2x adjusted points';

insert into mapseed
set oldname = 'Triple hi/lo points',
newname = '3x adjusted points';

insert into mapseed
set oldname = 'Quadruple hi/lo pts',
newname = '4x adjusted points';

insert into mapseed
set oldname = 'Judge Variance',
newname = 'judge variance';

insert into mapseed
set oldname = 'Ranks',
newname = 'ranks';

insert into mapseed
set oldname = 'Hi/lo ranks',
newname = 'adjusted ranks';

insert into mapseed
set oldname = 'Opponent Wins',
newname = 'opponent wins';

insert into mapseed
set oldname = 'Opposition points',
newname = 'opponent points';

insert into mapseed
set oldname = 'Random',
newname = 'random';

create table
seedOrdering
(

   year smallint unsigned not null,
   tournament int,
   foreign key (year,tournament)
   references tournaments (year,id),
   
   seed enum ('speaker','team') not null,
   
   precedence tinyint unsigned not null,

   unique key (year, tournament, seed, precedence),

   factor enum 
   ('wins',
   'ballots',
   'points',
   '1x adjusted points',
   '2x adjusted points',
   '3x adjusted points',
   '4x adjusted points',
   'judge variance',
   'ranks',
   'adjusted ranks',
   'opponent wins',
   'opponent points',
   'random') not null

)
/*
type = InnoDB
*/
/*charset = utf8*/
EOF

for YEAR in $(seq 2004 1 2009)
do
    PREV=$(( ${YEAR} - 1 ))
    for TYPE in speaker team
    do
	for PREC in $(seq 1 1 13)
	do
	    cat <<EOF
select 
${YEAR} as year,
ID as tournament,
'${TYPE}' as seed,
${PREC} as precedence,
newname as factor
from
DebateResults${PREV:2}${YEAR:2}.MasterTournaments
left join mapseed
on TB${TYPE:0:1}${PREC} = oldname
union all

EOF
	done
    done
done
cat <<EOF

select
1,2,3,4,5
from DebateResultsAll.schools
where 1 = 0;

drop table mapseed;
EOF