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
   key (year, id, role, school),
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

/*

Finding people who should have the same aka:

select aka, year, people.id, people.role, lastname, firstname 
from people, 
(select role, id 
from 
(select *, count(*) as many 
from 
(select id, role 
from people 
group by aka) as must 
group by role, id) as must 
where many > 1) as have 
where people.id = have.id 
and people.role = have.role;
 
select aka, year, people.id, people.role, lastname, firstname 
from people, 
(select role, id 
from 
(select *, count(*) as many 
from 
(select id, role 
from people 
group by aka) as must 
group by role, id) as must 
where many > 1) as have 
where people.id = have.id 
and people.role = have.role 
order by role, id;

select aka, year, people.id, people.role, lastname, firstname 
from people, 
(select role, id 
from 
(select *, count(*) as many 
from 
(select id, role 
from people 
group by aka) as must 
group by role, id) as must 
where many > 1) as have 
where people.id = have.id 
and people.role = have.role 
group by lastname, firstname, id, role 
order by role, id, year;
*/	

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
call sameperson(2006,1006,'judge',2009,5130,'judge');
call sameperson(2009,916,'judge',2009,7922,'judge');
/*
People with the same last name and similar first names. Can't do this automatically, becuase some last names will cause lots of collisions, like "Smith"

select a.year, a.id, a.role, a.aka,
 b.firstname, a.firstname, a.lastname, 
schools.aka, 
concat(a.year,',',a.id,',''',a.role,'''') 
from schools, people as a, people as b 
where schools.year = a.year 
and schools.id = a.school 
and ((instr(a.firstname,b.firstname) and length(b.firstname)>1) 
or (instr(b.firstname,a.firstname) and length(a.firstname)>1)) 
and a.lastname = b.lastname 
and a.aka != b.aka 
group by a.role, a.aka, b.firstname, a.firstname, a.lastname, a.school 
order by a.lastname, a.firstname, a.aka, a.school, a.year, a.id ;

*/

call sameperson(2009,7616,'judge',2009,8096,'judge');
call sameperson(2006,9315,'competitor',2005,4373,'competitor');
call sameperson(2007,6109,'judge',2006,10960,'competitor');
call sameperson(2009,7811,'judge',2005,3730,'competitor');
call sameperson(2009,24883,'competitor',2009,352,'judge');
call sameperson(2005,303,'judge', 2006,3527,'judge');
call sameperson(2009,378,'competitor',2004,1478,'competitor');
call sameperson(2009,7634,'judge',2005,3518,'competitor');
call sameperson(2007,19042,'competitor',2009,11646,'competitor');
call sameperson(2009,2276,'judge', 2004,1136,'judge');
call sameperson(2009,24604,'competitor',2009,8265,'judge');
call sameperson(2008,24317,'competitor', 2006,10736,'competitor');
call sameperson(2006,4179,'judge',2004,596,'competitor');
call sameperson(2007,5728,'judge',2007,15602,'competitor');
call sameperson(2009,8191,'judge',2006,9496,'competitor');
call sameperson(2006,8479,'competitor',2007,7329,'judge');
call sameperson(2004,1007,'judge',2004,462,'competitor');
call sameperson(2004,462,'competitor',2006,3491,'judge');
call sameperson(2006,3908,'judge',2004,479,'competitor');
call sameperson(2004,136,'judge',2009,7843,'judge');
call sameperson(2004,91,'competitor',2007,4566,'judge');
call sameperson(2005,925,'competitor',2008,7552,'judge');
call sameperson(2004,1582,'competitor', 2004,834,'competitor');
call sameperson(2007,5587,'judge',2005,3181,'competitor');
call sameperson(2004,114,'judge',2008,7522,'judge');
call sameperson(2009,25966,'competitor',2008,23740,'competitor');
/*Nazarov*/
call sameperson(2004,584,'judge',2006,5032,'judge');
call sameperson(2005,7200,'competitor', 2009,8247,'judge');
call sameperson(2004,1928,'competitor',2009,8247,'judge');
call sameperson(2009,24890,'competitor',2006,9493,'competitor');
call sameperson(2008,23678,'competitor',2008,17087,'competitor');
call sameperson(2009,7848,'judge',2009,8255,'judge');
call sameperson(2004,1169,'competitor',2004,1267,'judge');
call sameperson(2006,9760,'competitor',2007,22392,'competitor');
call sameperson(2007,6250,'judge',2008,7515,'judge');
call sameperson(2007,22322,'competitor',2007,22642,'competitor');
call sameperson(2009,8196,'judge',2004,288,'competitor');
call sameperson(2007,22610,'competitor',2007,18649,'competitor');
call sameperson(2009,26195,'competitor',2009,22326,'competitor');
call sameperson(2006,3500,'judge',2004,1517,'competitor');
call sameperson(2004,533,'judge',2007,5885,'judge');
call sameperson(2005,1118,'judge',2004,424,'competitor');
call sameperson(2008,24489,'competitor',2008,24490,'competitor');
call sameperson(2009,25135,'competitor',2006,11561,'competitor');
call sameperson(2008,23086,'competitor', 2004,422,'competitor');
call sameperson(2006,15438,'competitor',2007,5127,'judge');
call sameperson(2009,26084,'competitor',2009,25522,'competitor');
call sameperson(2005,2848,'competitor', 2008,7521,'judge');
call sameperson(2008,23959,'competitor',2006,10803,'competitor');
/*Freels*/
call sameperson(2008,7856,'judge',2007,16089,'competitor');
call sameperson(2007,5144,'judge',2005,52,'competitor');
call sameperson(2009,8134,'judge',2006,11461,'competitor');
call sameperson(2005,1556,'judge', 2006,2898,'judge');
call sameperson(2009,24671,'competitor', 2008,23846,'competitor');
call sameperson(2009,7921,'judge',2008,22348,'competitor');
call sameperson(2004,262,'competitor',2009,3635,'judge');
call sameperson(2008,7537,'judge',2004,1320,'competitor');
call sameperson(2008,22810,'competitor', 2009,25415,'competitor');
call sameperson(2008,7840,'judge',2004,101,'competitor');
call sameperson(2004,1149,'judge', 2005,1134,'judge');
call sameperson(2004,869,'competitor',2006,2907,'judge');
call sameperson(2007,5363,'judge',2004,1088,'competitor');
call sameperson(2007,17008,'competitor',2009,25951,'competitor');
call sameperson(2004,1117,'judge',2005,1561,'judge');

/*
People with the same first name and similar last names.

select a.year, a.id, a.role, a.aka,
 a.firstname, a.lastname, b.lastname, 
schools.aka, 
concat(a.year,',',a.id,',''',a.role,'''') 
from schools, people as a, people as b 
where schools.year = a.year 
and schools.id = a.school 
and ((instr(a.lastname,b.lastname) and length(b.lastname)>2) 
or (instr(b.lastname,a.lastname) and length(a.lastname)>2)) 
and a.firstname = b.firstname
and a.aka != b.aka 
group by a.role, a.aka, b.lastname, a.lastname, a.firstname, a.school 
order by a.firstname, a.lastname, a.aka, a.school, a.year, a.id ;

*/

call sameperson(2009,25841,'competitor',2008,23039,'competitor');
call sameperson(2005,4965,'competitor',2005,6817,'competitor');
call sameperson(2008,23153,'competitor',2008,24175,'competitor');
call sameperson(2006,8352,'competitor',2006,15427,'competitor');
call sameperson(2006,1559,'competitor',2007,5826,'judge');
call sameperson(2009,8164,'judge',2007,5348,'judge');
call sameperson(2004,1041,'judge',2005,2771,'judge');
call sameperson(2004,1266,'judge',2005,1186,'competitor');
call sameperson(2006,1016,'competitor',2009,6006,'judge');
call sameperson(2007,19262,'competitor',2009,24754,'competitor');
call sameperson(2006,5021,'judge', 2009,8299,'judge');
call sameperson(2008,7701,'judge', 2009,8248,'judge');
call sameperson(2009,24702,'competitor',2009,24772,'competitor');
call sameperson(2009,24887,'competitor',2009,24889,'competitor');
call sameperson(2004,1032,'judge',2005,1623,'judge');
call sameperson(2005,1500,'competitor',2009,7907,'judge'); 
call sameperson(2004,1343,'competitor',2006,2870,'judge');
call sameperson(2006,15223,'competitor',2006,15239,'competitor');
call sameperson(2005,6821,'competitor',2004,130,'competitor');
call sameperson(2004,736,'judge',2007,6008,'judge');
call sameperson(2004,1163,'judge',2005,1583,'judge');
call sameperson(2008,22144,'competitor',2007,22649,'competitor');
call sameperson(2008,24388,'competitor',2008,24389,'competitor');
call sameperson(2004,1118,'competitor',2004,941,'judge');
call sameperson(2008,7591,'judge',2009,25172,'competitor');
call sameperson(2006,9314,'competitor',2005,4370,'competitor');
call sameperson(2004,220,'competitor',2005,2740,'judge');
call sameperson(2004,698,'competitor',2006,4522,'competitor');

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