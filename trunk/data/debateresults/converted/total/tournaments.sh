#!/bin/bash

cat <<EOF

use DebateResultsAll;

drop table
if exists
tournaments;

create table
tournaments
(
   aka int unsigned not null auto_increment
   comment 'Tournaments with the same aka represent the same tournament from different years, 
or partitions of a tournament that were listed as separate tournaments in the debateresults.com data',
   key (aka),

   year smallint unsigned not null
   comment 'year ending the season in which the tournament was held',
   id int not null
   comment 'original debateresults.com primary key',
   unique key (year,id),

   name varchar (100)
   comment 'full name of tournament',
   shortname varchar (20)
   comment 'abbreviated tournament name',

   host int
   comment 'host school',
   key (year,host),
/*
   foreign key (year,host)
   references schools (year,id),
*/
   start date,
   end date,

   invite text,
   inviteURL varchar(160),

   sideEqualization enum ('no','yes'),
   
   MPJ enum ('no','yes'),

   MPJcategories smallint unsigned,

   CEDAsanctioned enum ('no','yes'),

   AFAsanctioned enum ('no','yes'),

   nonAFAschoolsPermitted enum ('no','yes'),

   level enum ('high school','college'),
   
   threePersonTeamsAllowed enum ('no','yes'),

   hybridTeamsAllowed enum ('no','yes'),

   resultsURL varchar(150),

   roundRobin enum ('no','yes'),

   hotelURL varchar(250),
   
   MPJdivisions enum ('open', 'open & JV', 'open, JV, & novice', 'open, JV, novice, & rookie')
   
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
ID as id,
if(${YEAR} >= 2009, TourneyName,
replace(TourneyName,'Diiv','Div')) as name,
Abbrev as shortname,
HostSchool as host,
str_to_date(StartDate, 
if(${YEAR} >= 2009,'%c/%e/%Y','%m/%d/%y')) as start,
str_to_date(EndDate, 
if(${YEAR} >= 2009,'%c/%e/%Y','%m/%d/%y')) as end,
if(${YEAR} >= 2009, Invite, 
replace(Invite,'Diiv','Div')) as invite,

InviteURL as inviteURL,

if(ElimSides is null, null,
if(ElimSides = '1', 'no',
if(ElimSides = '2', 'yes',''))) as sideEqualization,

if(UsePrefs is null, null,
if(UsePrefs = '0', 'no',
if(abs(UsePrefs) = '1', 'yes',''))) as MPJ,

PrefCats as MPJcategories,

if(CEDASanc is null, null,
if(CEDASanc = '0', 'no',
if(abs(CEDASanc) = '1', 'yes',''))) as CEDAsanctioned,

if(AFASanc is null, null,
if(AFASanc = '0', 'no',
if(abs(AFASanc) = '1', 'yes',''))) as AFAsanctioned,

if(AFAOpen is null, null,
if(AFAOpen = '0', 'no',
if(abs(AFAOpen) = '1', 'yes',''))) as nonAFAschoolsPermitted,
/*
EOF
    if [[ ( ${YEAR} -gt 2004) && ( ${YEAR} -lt 2009)]]
    then LEVEL="if(HighSchool is null, null,
	        if(HighSchool = '0', 'college',
		if(abs(HighSchool) = '1', 'high school','')))"
    else LEVEL="'college'"
    fi
    cat <<EOF
*/
${LEVEL} as level,

if(ThreeOK is null, null,
if(ThreeOK = '0', 'no',
if(abs(ThreeOK) = '1', 'yes',''))) as threePersonTeamsAllowed,

if(HybridsOK is null, null,
if(HybridsOK = '0', 'no',
if(abs(HybridsOK) = '1', 'yes',''))) as hybridTeamsAllowed,

/*
EOF
    if [[ ${YEAR} -ge 2005 ]]
    then RESULTSURL="ResultsURL"
    else RESULTSURL="null"
    fi

    cat <<EOF
*/

${RESULTSURL} as resultsURL,

if(RoundRobin is null, null,
if(RoundRobin = '0', 'no',
if(abs(RoundRobin) = '1', 'yes',''))) as roundRobin,

/*
EOF
    if [[ ${YEAR} -ge 2006 ]]
    then HOTELURL="HotelURL"
    else HOTELURL="null"
    fi

    if [[ ${YEAR} -ge 2009 ]]
    then MPJDIV="PrefsDiv"
    else MPJDIV="PrefsDiiv"
    fi

    cat <<EOF
*/
${HOTELURL} as hotelURL,

${MPJDIV} as MPJdivisions

from DebateResults${PREV:2}${YEAR:2}.MasterTournaments

union all

/*
EOF
done

cat <<EOF
*/

select 1,2,3,4,5,6,7,8,9,10
,11,12,13,14,15,16,17,18,19,20,21,22,23
from DebateResults0809.MasterTournaments
where 1 = 0;

delimiter |

drop procedure
if exists
sametournament|

create procedure 
sametournament(yr1 smallint unsigned, 
  	       id1 int,
	       yr2 smallint unsigned, 
	       id2 int)
begin
   declare aka1 int unsigned;
   declare aka2 int unsigned;
   declare minaka int unsigned;
   
   select aka
   into aka1
   from tournaments
   where year = yr1
   and id = id1;

   select aka
   into aka2
   from tournaments
   where year = yr2
   and id = id2;

   set minaka = if(aka1 < aka2, aka1, aka2);

/*   select aka1, aka2, minaka; */

   update tournaments
   set aka = minaka
   where aka = aka1
   or aka = aka2;

end|

drop procedure
if exists
sametournament_short_host|

create procedure 
sametournament_short_host()
begin

   declare vaka int unsigned;
   declare vshortname varchar(20);
   declare vlevel enum('high school','college');

   declare vminaka int unsigned;

   declare done int default 0;

   declare identifier cursor for 
   select schools.aka, tournaments.shortname, level
   from tournaments, schools
   where host = schools.id
   and tournaments.year = schools.year;

   declare continue handler for not found set done = 1;

   open identifier;

   repeat
      fetch identifier into vaka, vshortname, vlevel;
      if not done then

         select min(tournaments.aka)
	 into vminaka
	 from tournaments, schools
	 where host = schools.id
	 and tournaments.year = schools.year
	 and schools.aka = vaka
	 and tournaments.shortname = vshortname
	 and level = vlevel;
/*
	 select vminaka, vid, vshortname, vname;

	 select concat('update schools set aka = ',vminaka,' where id = ',vid,' and (instr(shortname,''',vshortname,''') or instr(name,''',vname,'''));') as query;

	 select count(*) 
	 from schools 
	 where id = vid 
	 and (instr(shortname,vshortname) 
	 or instr(name,vname));
*/

	 update tournaments, schools
	 set tournaments.aka = vminaka
	 where host = schools.id
	 and tournaments.year = schools.year
	 and schools.aka = vaka
	 and tournaments.shortname = vshortname
	 and level = vlevel;
      end if;
   until done end repeat;
end|

delimiter ;

call sametournament_short_host();

call sametournament(2006,21,2008,146);
call sametournament(2007,94,2009,99);
call sametournament(2006,70,2009,78);
call sametournament(2009,78,2008,212);
call sametournament(2008,212,2007,92);
call sametournament(2004,313,2005,366);
call sametournament(2004,365,2005,415);
call sametournament(2006,67,2005,415);
call sametournament(2008,228,2009,1);
call sametournament(2007,118,2004,285);
call sametournament(2008,125,2007,119);
call sametournament(2007,119,2007,18);
call sametournament(2005,363,2006,10);
call sametournament(2006,57,2007,65);
call sametournament(2004,302,2005,365);
call sametournament(2007,111,2004,381);
call sametournament(2004,381,2005,451);
call sametournament(2009,8,2005,379);
call sametournament(2005,379,2004,358);
call sametournament(2004,333,2005,410);
call sametournament(2009,72,2008,196);
call sametournament(2006,69,2007,85);
call sametournament(2005,417,2007,85);
call sametournament(2004,379,2009,15);
call sametournament(2004,363,2009,89);
call sametournament(2009,89,2009,90);
call sametournament(2009,90,2008,189);
call sametournament(2008,189,2006,62);
call sametournament(2006,62,2007,86);
call sametournament(2004,292,2004,379);
call sametournament(2006,22,2004,292);
call sametournament(2008,215,2004,383);
call sametournament(2004,307,2005,360);
call sametournament(2004,375,2006,110);
call sametournament(2006,110,2005,443);
call sametournament(2005,443,2009,46);
call sametournament(2009,46,2007,77);
call sametournament(2004,294,2005,436);
call sametournament(2004,293,2005,344);
call sametournament(2005,368,2004,300);
call sametournament(2004,316,2005,431);
call sametournament(2006,113,2004,293);
call sametournament(2007,105,2009,59);
call sametournament(2009,59,2004,374);
call sametournament(2006,103,2004,374);
call sametournament(2004,374,2006,103);
call sametournament(2006,103,2005,395);
call sametournament(2005,395,2008,160);
call sametournament(2007,120,2006,113);
call sametournament(2009,26,2004,331);
call sametournament(2007,90,2005,347);
call sametournament(2005,347,2008,220);
call sametournament(2008,220,2009,92);
call sametournament(2009,92,2004,367);
call sametournament(2004,367,2006,102);
call sametournament(2005,407,2005,408);
call sametournament(2005,409,2006,46);
call sametournament(2007,63,2005,385);
call sametournament(2005,385,2008,179);
call sametournament(2004,298,2008,179);
call sametournament(2007,64,2005,383);
call sametournament(2005,387,2004,330);
call sametournament(2004,384,2006,100);
call sametournament(2009,97,2008,225);
call sametournament(2008,225,2006,106);
call sametournament(2004,381,2006,106);
call sametournament(2004,369,2005,438);
call sametournament(2005,438,2006,107);
call sametournament(2006,9,2005,359);
call sametournament(2009,17,2007,117);
call sametournament(2007,117,2008,123);
call sametournament(2007,11,2007,122);
call sametournament(2008,222,2006,93);
call sametournament(2006,93,2009,96);
call sametournament(2006,112,2005,452);
call sametournament(2006,94,2009,95);
call sametournament(2009,95,2004,386);
call sametournament(2007,110,2006,111);
call sametournament(2006,111,2005,453);
call sametournament(2005,453,2009,82);
call sametournament(2006,101,2004,378);
call sametournament(2009,76,2006,95);
call sametournament(2006,95,2007,99);
call sametournament(2006,112,2008,181);
call sametournament(2008,181,2004,385);
call sametournament(2007,71,2006,101);
call sametournament(2006,101,2005,449);
call sametournament(2005,449,2005,446);
call sametournament(2009,93,2008,224);
call sametournament(2008,224,2007,107);
call sametournament(2007,107,2005,448);
call sametournament(2005,448,2004,377);
call sametournament(2004,377,2006,104);
call sametournament(2006,104,2006,105);
call sametournament(2009,100,2004,385);
call sametournament(2006,95,2004,368);
call sametournament(2008,223,2004,386);
call sametournament(2008,127,2007,121);
call sametournament(2009,18,2007,121);
call sametournament(2007,19,2008,157);
call sametournament(2006,44,2004,281);
call sametournament(2005,393,2004,366);
call sametournament(2008,129,2006,2);
call sametournament(2008,177,2007,54);
call sametournament(2004,376,2009,50);
call sametournament(2005,454,2004,384);
call sametournament(2005,354,2006,15);
call sametournament(2008,185,2004,321);
call sametournament(2005,361,2007,34);
call sametournament(2008,142,2009,22);
call sametournament(2009,21,2004,311);
call sametournament(2005,391,2004,323);
call sametournament(2005,378,2007,48);
call sametournament(2009,73,2008,188);
call sametournament(2005,396,2004,388);
call sametournament(2007,79,2008,164);
call sametournament(2006,80,2004,380);
call sametournament(2004,380,2008,217);
call sametournament(2008,227,2009,101);
call sametournament(2005,433,2004,360);
call sametournament(2004,360,2006,93);
call sametournament(2004,383,2005,453);
call sametournament(2005,428,2006,95);
call sametournament(2005,422,2004,386);
call sametournament(2005,440,2006,80);
call sametournament(2006,26,2007,62);
call sametournament(2007,62,2005,351);
call sametournament(2005,350,2004,295);
call sametournament(2007,78,2006,68);
call sametournament(2005,341,2006,68);
call sametournament(2005,384,2006,64);
call sametournament(2005,407,2009,84);
call sametournament(2009,84,2009,85);
call sametournament(2009,79,2005,406);
call sametournament(2007,73,2004,371);
call sametournament(2006,64,2008,197);
call sametournament(2008,166,2007,94);
call sametournament(2006,45,2005,383);
/*call sametournament(2009,61,2004,382);*/
call sametournament(2004,302,2006,5);
call sametournament(2007,49,2006,28);
call sametournament(2005,380,2004,321);
call sametournament(2004,329,2006,37);
call sametournament(2006,49,2004,330);
call sametournament(2004,282,2006,2);
call sametournament(2007,53,2004,308);
call sametournament(2005,378,2004,315);
call sametournament(2009,3,2004,284);
call sametournament(2006,24,2009,91);
call sametournament(2005,419,2004,318);
call sametournament(2009,44,2005,435);
call sametournament(2005,400,2004,330);
call sametournament(2006,52,2004,321);
call sametournament(2005,445,2005,444);
call sametournament(2007,43,2005,354);
call sametournament(2008,228,2004,338);
call sametournament(2008,211,2006,108);
call sametournament(2004,357,2007,98);
call sametournament(2006,71,2007,79);
call sametournament(2005,404,2004,363);
call sametournament(2005,450,2005,448);
call sametournament(2005,421,2006,38);
/* call sametournament(2008,141,2009,5); */
call sametournament(2009,104,2009,1);


EOF