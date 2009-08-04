#!/bin/bash

cat <<EOF

use DebateResultsAll;

drop table 
if exists
schools;

create table
schools
(
   aka int unsigned not null auto_increment
   comment 'Schools with the same aka represent the same school',
   key (aka),

   year smallint unsigned not null
   comment 'year in which this school entry appears in the database',
   id int not null
   comment 'original debateresults.com primary key',
   unique key (year,id),

   key (id),

   name varchar (50),
   shortname varchar (16),
   key (shortname),

   type enum
   ('community college', 
   'public university', 
   'private university', 
   'high school'),

   ndtDistrict tinyint unsigned
   comment 'hopefully a key into ndtDistricts',

   cedaRegion tinyint unsigned
   comment 'hopefully a key into cedaRegions'   
   
)
/*
type = InnoDB
*/
/*charset = utf8*/

/*
EOF

for YEAR in $(seq 2004 1 2009)
do
    PREV=$(( ${YEAR} - 1 ))
    cat <<EOF
*/

select 
null as aka, 
${YEAR} as year, 
SchoolID as id, 
SchoolName as name, 
Acronym as shortname, 
SchoolType as type, 
NDTDistrict as ndtDistrict, 
CEDADistrict as cedaRegion
from DebateResults${PREV:2}${YEAR:2}.MasterSchools

union all

/*
EOF

done

cat <<EOF

*/

select 1,2,3,4,5,6,7,8
from DebateResults0809.MasterSchools
where 1 = 0;

delimiter |

drop procedure
if exists
sameschool|

create procedure 
sameschool(yr1 smallint unsigned, 
	   id1 int,
	   yr2 smallint unsigned, 
	   id2 int)
begin
   declare aka1 int unsigned;
   declare aka2 int unsigned;
   declare minaka int unsigned;
   
   select aka
   into aka1
   from schools
   where year = yr1
   and id = id1;

   select aka
   into aka2
   from schools
   where year = yr2
   and id = id2;

   set minaka = if(aka1 < aka2, aka1, aka2);

   update schools
   set aka = minaka
   where aka = aka1
   or aka = aka2;

end |

drop procedure
if exists
sameschool_inname|

create procedure 
sameschool_inname()
begin

   declare vaka int unsigned;
   declare vyear smallint unsigned;
   declare vid int;
   declare vname varchar(50);
   declare vshortname varchar(16);

   declare vminaka int unsigned;

   declare done int default 0;

   declare identifier cursor for 
   select aka, year, id, name, shortname
   from schools;

   declare continue handler for not found set done = 1;

   open identifier;

   repeat
      fetch identifier into vaka, vyear, vid,vname, vshortname;
      if not done then

         select min(aka)
	 into vminaka
	 from schools
	 where id = vid
	 and (instr(shortname,vshortname)
         or instr(name,vname));

	 update schools
	 set aka = vminaka
	 where id = vid
	 and (instr(shortname,vshortname)
         or instr(name,vname));
      end if;
   until done end repeat;
end|

delimiter ;

call sameschool_inname();

call sameschool(2007,44,2004,44);
call sameschool(2006,728,2007,728);
call sameschool(2004,663,2007,1317);
call sameschool(2004,254,2006,926);
call sameschool(2004,228,2004,138);
call sameschool(2009,1403,2004,222);
call sameschool(2004,186,2008,1365);
call sameschool(2006,643,2004,198);
call sameschool(2006,643,2008,1357);
call sameschool(2008,1330,2004,215);
call sameschool(2009,1400,2004,548);
call sameschool(2007,1314,2004,565);
call sameschool(2004,200,2006,742);
call sameschool(2007,1140,2004,214);
call sameschool(2004,577,2007,978);
call sameschool(2004,167,2004,93);
call sameschool(2008,1341,2004,199);
call sameschool(2004,192,2006,734);
call sameschool(2006,734,2004,197);
call sameschool(2007,962,2007,995);
call sameschool(2004,572,2006,647);
call sameschool(2004,209,2004,193);
call sameschool(2004,209,2006,743);
call sameschool(2004,662,2007,1311);
call sameschool(2004,456,2004,471);
call sameschool(2008,1348,2004,22);
call sameschool(2004,458,2004,457);
call sameschool(2006,905,2004,222);
call sameschool(2006,932,2004,521);
call sameschool(2004,369,2004,571);
call sameschool(2006,645,2004,195);
call sameschool(2007,1309,2004,404);
call sameschool(2009,1401,2004,219);
call sameschool(2007,1307,2004,434);
call sameschool(2004,221,2006,730);
call sameschool(2006,730,2006,747);
call sameschool(2004,578,2006,915);
call sameschool(2004,614,2007,1306);
call sameschool(2008,1359,2004,6);
call sameschool(2004,196,2009,1402);
call sameschool(2004,234,2009,1392);
call sameschool(2004,184,2006,737);
call sameschool(2006,738,2004,187);
call sameschool(2008,1330,2004,46);
call sameschool(2008,1363,2004,218);
call sameschool(2007,1301,2004,605);
call sameschool(2004,216,2006,726);
call sameschool(2006,746,2004,207);
call sameschool(2006,736,2004,212);
call sameschool(2004,189,2006,913);
call sameschool(2009,1393,2004,572);
call sameschool(2005,287,2004,78);

EOF