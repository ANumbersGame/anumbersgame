#!/bin/bash

cat <<EOF

use DebateResultsAll;

create table people
(
   aka int unsigned not null auto_increment
   comment 'People with the same aka represent the same person',
   key (aka),

   year smallint unsigned not null
   comment 'year in which this entry appears in the database',

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
type = InnoDB
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

/*
select 'done inserting';
*/
/*
drop procedure
if exists
sameperson_byname|

create procedure 
sameperson_byname()
begin


   declare vfirstname varchar(50);
   declare vlastname varchar(16);
   declare vminaka int unsigned;

   declare done int default 0;

   declare name cursor for 
   select min(aka), firstname, lastname
   from people
   group by firstname, lastname;

   declare continue handler for not found set done = 1;

   open name;

   repeat
      fetch name into vminaka, vfirstname, vlastname;
      if not done then

	 update people
	 set aka = vminaka
	 where (firstname = vfirstname
	 or firstname is null
	 or vfirstname is null)
	 and lastname = vlastname;

      end if;
   until done end repeat;
end|

delimiter ;

call sameperson_byname()
*/

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
/*
      select count(*) as 'samelast to mod' from people, samelast where people.role = samelast.role       and people.id = samelast.id       and people.lastname = samelast.lastname and people.aka != samelast.minaka;
*/

/*
      select aka, people.year, people.id, firstname, people.lastname, people.role, many, count(*)
      from people,
      ( select id, lastname, role, many from
        ( select id, role, lastname, count(distinct firstname) as many
          from people
          group by id, role, lastname) as must
      where many > 1) as analias
      where people.id = analias.id
      and people.lastname = analias.lastname
      and people.role = analias.role
      group by people.id, people.lastname, people.role, firstname
      order by people.id, people.role, people.lastname, people.firstname;
*/
      update people, samelast
      set people.aka = samelast.minaka
      where people.role = samelast.role
      and people.id = samelast.id
      and people.lastname = samelast.lastname;

      set affected = affected + row_count();
/*
      select affected as 'samelast';
*/

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
/*
      select affected as 'samefirst';
*/

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
/*
      select affected as 'continuity';
*/

   until affected = 0 end repeat;
end|

delimiter ;

call loopname();

/*
update people as a, 
(select aka, 
firstname,
lastname,
role,
id
from people
group by firstname,
lastname,
role,
id
) as b
set a.aka = b.aka
where a.firstname = b.firstname
and a.lastname = b.lastname
and a.role = b.role
and a.id = b.id
;
*/

/*
select aka, year, people.id, people.role, lastname, firstname from people, (select role, id from (select *, count(*) as many from (select id, role from people group by aka) as must group by role, id) as must where many > 1) as have where people.id = have.id and people.role = have.role;

select aka, year, people.id, people.role, lastname, firstname from people, (select role, id from (select *, count(*) as many from (select id, role from people group by aka) as must group by role, id) as must where many > 1) as have where people.id = have.id and people.role = have.role order by role, id;

 select aka, year, people.id, people.role, lastname, firstname from people, (select role, id from (select *, count(*) as many from (select id, role from people group by aka) as must group by role, id) as must where many > 1) as have where people.id = have.id and people.role = have.role group by lastname, firstname, id, role order by role, id, year;

*/

delimiter |

drop procedure
if exists
sameperson|

create procedure 
sameperson(aka1 int unsigned, 
	   aka2 int unsigned)
begin
   declare minaka int unsigned;
   
   set minaka = if(aka1 < aka2, aka1, aka2);

   update people
   set aka = minaka
   where aka = aka1
   or aka = aka2;

end|

delimiter ;


call sameperson(38448,28369);
call sameperson(27736,37818);
call sameperson(17477,35539);
/*
9676,15477
*/
call sameperson(9353,5613);
/*
1766,4572
*/
call sameperson(1233,4174);
/*
TODO:
aka, year, id, role, lastname, firstname
|  3651 | 2007 |  655 | competitor | Lechtreck          | Kim        | 
|  3651 | 2005 |  655 | competitor | Lechtreck          | Kirstin    | 
*/
call sameperson(565,7440);
call sameperson(30619,42577);

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