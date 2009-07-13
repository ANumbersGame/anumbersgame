#!/bin/bash

cat <<EOF

use DebateResultsAll;

drop table
if exists ballots;

drop table
if exists people;

create table people
(
   aka int unsigned not null auto_increment
   comment 'Records in this table with the same aka represent the same person',
   key (aka),

   year smallint unsigned not null
   comment 'year in which this entry appears in the debateresults.com database',

   id int not null
   comment 'original debateresults.com primary key',
   key (id),

   role enum ('judge', 'competitor') not null,
   key (role),

   unique key (year,id,role),

   firstname varchar(24),
   key (firstname),

   lastname varchar(40),
   key (lastname),
   
   school int,
/*
   foreign key (year, school)
   references schools (year,id)
   on update cascade,
*/
   philosophy text

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
null as aka,
${YEAR} as year,
CompetitorID as id,
'competitor' as role,
FirstName as firstname,
LastName as lastname,
CompetitorSchool as school,
null as philosophy
from DebateResults${PREV:2}${YEAR:2}.MasterCompetitors
union all

select
null as aka,
${YEAR} as year,
JudgeID as id,
'judge' as role,
FirstName as firstname,
LastName as lastname,
JudgeSchool as school,
Philo as philosophy
from DebateResults${PREV:2}${YEAR:2}.MasterJudges
union all

EOF
done

cat <<EOF

select 1,2,3,4,5,6,7,8
from DebateResults0304.MasterCompetitors
where 1 = 0;

delimiter |

drop procedure
if exists
loopname|

create procedure 
loopname()
begin

   declare affected int unsigned default 0;

   repeat

      set affected = 0;

      drop temporary table
      if exists samelast;

      create temporary table samelast
      select min(aka) as minaka, 
      id,
      role,
      lastname
      from people
      group by id,
      role,
      lastname;

      update people, samelast
      set people.aka = samelast.minaka
      where people.role = samelast.role
      and people.id = samelast.id
      and people.lastname = samelast.lastname;

      set affected = affected + row_count();

      drop temporary table
      if exists samefirst;

      create temporary table samefirst
      select min(aka) as minaka, 
      id,
      role,
      firstname
      from people
      group by id,
      role,
      firstname;

      update people, samefirst
      set people.aka = samefirst.minaka
      where people.role = samefirst.role
      and people.id = samefirst.id
      and people.firstname = samefirst.firstname;

      set affected = affected + row_count();

      drop temporary table 
      if exists continuity;

      create temporary table continuity
      select min(aka) as minaka, 
      firstname,
      lastname
      from people
      group by firstname,
      lastname;

      update people, continuity
      set people.aka = continuity.minaka
      where people.firstname = continuity.firstname
      and people.lastname = continuity.lastname;

      set affected = affected + row_count();

   until affected = 0 end repeat;
end|

delimiter ;

call loopname();


delimiter |

drop procedure
if exists
sameperson|

create procedure 
sameperson(yr1 smallint unsigned, 
	   id1 int,
	   role1 varchar (20),
	   yr2 smallint unsigned, 
	   id2 int,
	   role2 varchar (20))
begin
   declare aka1 int unsigned;
   declare aka2 int unsigned;
   declare minaka int unsigned;
   
   select aka
   into aka1
   from people
   where year = yr1
   and id = id1
   and role = role1;

   select aka
   into aka2
   from people
   where year = yr2
   and id = id2
   and role = role2;

   set minaka = if(aka1 < aka2, aka1, aka2);

   update people
   set aka = minaka
   where aka = aka1
   or aka = aka2;

end|

delimiter ;


call sameperson(2008,24495,'competitor',2009,24495,'competitor');
call sameperson(2009,23857,'competitor',2008,23857,'competitor');
call sameperson(2008,16962,'competitor',2009,16962,'competitor');
call sameperson(2005,7790,'competitor',2006,7790,'competitor');
call sameperson(2004,1270,'competitor',2005,1270,'competitor');
call sameperson(2005,579,'competitor',2006,579,'competitor');
call sameperson(2008,7538,'judge',2009,7538,'judge');
call sameperson(2008,22390,'competitor',2008,24163,'competitor');
call sameperson(2006,3697,'judge',2006,433,'competitor');
call sameperson(2008,7739,'judge',2007,7301,'judge');

delimiter |

drop procedure
if exists
diffperson|

create procedure 
diffperson(fn varchar(24),
	   ln varchar(40))
begin
   declare vaka int unsigned;

   drop temporary table
   if exists resets;

   create temporary table resets
   select * 
   from people
   where firstname = fn
   and lastname = ln;

   update resets
   set aka = null;

   delete from people
   where firstname = fn
   and lastname = ln;

   insert into people
   select * 
   from resets
   order by role, year, id
   limit 1;

   set vaka = last_insert_id();

   insert into people
   select * 
   from resets
   order by role, year, id
   limit 18446744073709551615 offset 1;

   update people
   set aka = vaka
   where firstname = fn
   and lastname = ln;

end|

delimiter ;

call diffperson('Kim','Lechtreck');
call diffperson('Ryan','Kreck');
call diffperson('Mike','UNI');

EOF