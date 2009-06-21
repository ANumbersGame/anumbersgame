use DebateResultsAll;

drop table 
if exists
tournament;

drop table 
if exists
divisions;

drop table
if exists
seedOrdering;

drop table 
if exists
ndtDistricts;

drop table 
if exists
tournaments;

drop table 
if exists
schools;

drop table 
if exists
cedaRegions;

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
type = InnoDB
/*charset = utf8*/
select 
null as aka, 
2004 as year, 
SchoolID as id, 
SchoolName as name, 
Acronym as shortname, 
SchoolType as type, 
NDTDistrict as ndtDistrict, 
CEDADistrict as cedaRegion
from DebateResults0304.MasterSchools
union all
select 
null as aka, 
2005 as year, 
SchoolID as id, 
SchoolName as name, 
Acronym as shortname, 
SchoolType as type, 
NDTDistrict as ndtDistrict, 
CEDADistrict as cedaRegion
from DebateResults0405.MasterSchools
union all
select 
null as aka, 
2006 as year, 
SchoolID as id, 
SchoolName as name, 
Acronym as shortname, 
SchoolType as type, 
NDTDistrict as ndtDistrict, 
CEDADistrict as cedaRegion
from DebateResults0506.MasterSchools
union all
select 
null as aka, 
2007 as year, 
SchoolID as id, 
SchoolName as name, 
Acronym as shortname, 
SchoolType as type, 
NDTDistrict as ndtDistrict, 
CEDADistrict as cedaRegion
from DebateResults0607.MasterSchools
union all
select 
null as aka, 
2008 as year, 
SchoolID as id, 
SchoolName as name, 
Acronym as shortname, 
SchoolType as type, 
NDTDistrict as ndtDistrict, 
CEDADistrict as cedaRegion
from DebateResults0708.MasterSchools
union all
select 
null as aka, 
2009 as year, 
SchoolID as id, 
SchoolName as name, 
Acronym as shortname, 
SchoolType as type, 
NDTDistrict as ndtDistrict, 
CEDADistrict as cedaRegion
from DebateResults0809.MasterSchools;

delimiter |

drop trigger
if exists
schools_aka|
/*
create 
trigger schools_aka 
after update on schools
for each row
    if     (OLD.aka is not null)
       AND (NEW.aka is not null)
       AND (NEW.aka != OLD.aka)
    then
       update schools
       set aka = NEW.aka
       where aka = OLD.aka;
     end if|
*/

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

/*   select aka1, aka2, minaka; */

   update schools
   set aka = minaka
   where aka = aka1
   or aka = aka2;

end|

drop procedure
if exists
sameschool_shortname_id;

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
/*
	 select vminaka, vid, vshortname, vname;

	 select concat('update schools set aka = ',vminaka,' where id = ',vid,' and (instr(shortname,''',vshortname,''') or instr(name,''',vname,'''));') as query;

	 select count(*) 
	 from schools 
	 where id = vid 
	 and (instr(shortname,vshortname) 
	 or instr(name,vname));
*/

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

select 'about to tournaments';

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

/*
   flags set
   ('side equalized elims',
   'random judge assignment',
   'not CEDA sanctioned',
   'not AFA sanctioned',
   'non-AFA schools prohibited',
   'high school',
   'three-person teams permitted',
   'hybrid teams prohibited',
   'round robin'),
  */ 
/*
   elimSides enum('flip','side equalization'),
   
   judging enum ('random','mutual preference'),

   preferenceBins smallint unsigned,

   CEDA enum('sanctioned', 'unsanctioned'),

   AFA enum('sanctioned', 'unsanctioned'),

   nonAFASchools enum ('allowed', 'prohibited'),

   level enum ('high school','college'),
   
   unusualTeamsAllowed set('three-person','hybrid'),

   resultsURL varchar(150),

   pairing enum ('round robin','non-round-robin'),
*/

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

   hotelURL varchar(250)
   
)
type = InnoDB
/*charset = utf8*/
select
null as aka,
2004 as year,
ID as id,
replace(TourneyName,'Diiv','Div') as name,
Abbrev as shortname,
HostSchool as host,
str_to_date(StartDate, '%m/%d/%y') as start,
str_to_date(EndDate, '%m/%d/%y') as end,
replace(Invite,'Diiv','Div') as invite,

InviteURL as inviteURL,

if(ElimSides is null, null,
if(ElimSides = '1', 'no',
if(ElimSides = '2', 'yes',''))) as sideEqualization,

if(UsePrefs is null, null,
if(UsePrefs = '0', 'no',
if(UsePrefs = '1', 'yes',''))) as MPJ,

PrefCats as MPJcategories,

if(CEDASanc is null, null,
if(CEDASanc = '0', 'no',
if(CEDASanc = '1', 'yes',''))) as CEDAsanctioned,

if(AFASanc is null, null,
if(AFASanc = '0', 'no',
if(AFASanc = '1', 'yes',''))) as AFAsanctioned,

if(AFAOpen is null, null,
if(AFAOpen = '0', 'no',
if(AFAOpen = '1', 'yes',''))) as nonAFAschoolsPermitted,

'college' as level,

if(ThreeOK is null, null,
if(ThreeOK = '0', 'no',
if(ThreeOK = '1', 'yes',''))) as threePersonTeamsAllowed,

if(HybridsOK is null, null,
if(HybridsOK = '0', 'no',
if(HybridsOK = '1', 'yes',''))) as hybridTeamsAllowed,

null as resultsURL,

if(RoundRobin is null, null,
if(RoundRobin = '0', 'no',
if(RoundRobin = '1', 'yes',''))) as roundRobin,

null as hotelURL

from DebateResults0304.MasterTournaments

union all
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
select
null as aka,
2005 as year,
ID as id,
replace(TourneyName,'Diiv','Div') as name,
Abbrev as shortname,
HostSchool as host,
str_to_date(StartDate, '%m/%d/%y') as start,
str_to_date(EndDate, '%m/%d/%y') as end,
replace(Invite,'Diiv','Div') as invite,

InviteURL as inviteURL,

if(ElimSides is null, null,
if(ElimSides = '1', 'no',
if(ElimSides = '2', 'yes',''))) as sideEqualization,

if(UsePrefs is null, null,
if(UsePrefs = '0', 'no',
if(UsePrefs = '1', 'yes',''))) as MPJ,

PrefCats as MPJcategories,

if(CEDASanc is null, null,
if(CEDASanc = '0', 'no',
if(CEDASanc = '1', 'yes',''))) as CEDAsanctioned,

if(AFASanc is null, null,
if(AFASanc = '0', 'no',
if(AFASanc = '1', 'yes',''))) as AFAsanctioned,

if(AFAOpen is null, null,
if(AFAOpen = '0', 'no',
if(AFAOpen = '1', 'yes',''))) as nonAFAschoolsPermitted,

if(HighSchool is null, null,
if(HighSchool = '0', 'college',
if(HighSchool = '1', 'high school',''))) as level,

if(ThreeOK is null, null,
if(ThreeOK = '0', 'no',
if(ThreeOK = '1', 'yes',''))) as threePersonTeamsAllowed,

if(HybridsOK is null, null,
if(HybridsOK = '0', 'no',
if(HybridsOK = '1', 'yes',''))) as hybridTeamsAllowed,

ResultsURL as resultsURL,

if(RoundRobin is null, null,
if(RoundRobin = '0', 'no',
if(RoundRobin = '1', 'yes',''))) as roundRobin,

null as hotelURL

from DebateResults0405.MasterTournaments

union all
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
select
null as aka,
2006 as year,
ID as id,
replace(TourneyName,'Diiv','Div') as name,
Abbrev as shortname,
HostSchool as host,
str_to_date(StartDate, '%m/%d/%y') as start,
str_to_date(EndDate, '%m/%d/%y') as end,
replace(Invite,'Diiv','Div') as invite,

InviteURL as inviteURL,

if(ElimSides is null, null,
if(ElimSides = '1', 'no',
if(ElimSides = '2', 'yes',''))) as sideEqualization,

if(UsePrefs is null, null,
if(UsePrefs = '0', 'no',
if(UsePrefs = '1', 'yes',''))) as MPJ,

PrefCats as MPJcategories,

if(CEDASanc is null, null,
if(CEDASanc = '0', 'no',
if(CEDASanc = '1', 'yes',''))) as CEDAsanctioned,

if(AFASanc is null, null,
if(AFASanc = '0', 'no',
if(AFASanc = '1', 'yes',''))) as AFAsanctioned,

if(AFAOpen is null, null,
if(AFAOpen = '0', 'no',
if(AFAOpen = '1', 'yes',''))) as nonAFAschoolsPermitted,

if(HighSchool is null, null,
if(HighSchool = '0', 'college',
if(HighSchool = '1', 'high school',''))) as level,

if(ThreeOK is null, null,
if(ThreeOK = '0', 'no',
if(ThreeOK = '1', 'yes',''))) as threePersonTeamsAllowed,

if(HybridsOK is null, null,
if(HybridsOK = '0', 'no',
if(HybridsOK = '1', 'yes',''))) as hybridTeamsAllowed,

ResultsURL as resultsURL,

if(RoundRobin is null, null,
if(RoundRobin = '0', 'no',
if(RoundRobin = '1', 'yes',''))) as roundRobin,

HotelURL as hotelURL

from DebateResults0506.MasterTournaments

union all
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
select
null as aka,
2007 as year,
ID as id,
replace(TourneyName,'Diiv','Div') as name,
Abbrev as shortname,
HostSchool as host,
str_to_date(StartDate, '%m/%d/%y') as start,
str_to_date(EndDate, '%m/%d/%y') as end,
replace(Invite,'Diiv','Div') as invite,

InviteURL as inviteURL,

if(ElimSides is null, null,
if(ElimSides = '1', 'no',
if(ElimSides = '2', 'yes',''))) as sideEqualization,

if(UsePrefs is null, null,
if(UsePrefs = '0', 'no',
if(UsePrefs = '1', 'yes',''))) as MPJ,

PrefCats as MPJcategories,

if(CEDASanc is null, null,
if(CEDASanc = '0', 'no',
if(CEDASanc = '1', 'yes',''))) as CEDAsanctioned,

if(AFASanc is null, null,
if(AFASanc = '0', 'no',
if(AFASanc = '1', 'yes',''))) as AFAsanctioned,

if(AFAOpen is null, null,
if(AFAOpen = '0', 'no',
if(AFAOpen = '1', 'yes',''))) as nonAFAschoolsPermitted,

if(HighSchool is null, null,
if(HighSchool = '0', 'college',
if(HighSchool = '1', 'high school',''))) as level,

if(ThreeOK is null, null,
if(ThreeOK = '0', 'no',
if(ThreeOK = '1', 'yes',''))) as threePersonTeamsAllowed,

if(HybridsOK is null, null,
if(HybridsOK = '0', 'no',
if(HybridsOK = '1', 'yes',''))) as hybridTeamsAllowed,

ResultsURL as resultsURL,

if(RoundRobin is null, null,
if(RoundRobin = '0', 'no',
if(RoundRobin = '1', 'yes',''))) as roundRobin,

HotelURL as hotelURL

from DebateResults0607.MasterTournaments

union all
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
select
null as aka,
2008 as year,
ID as id,
replace(TourneyName,'Diiv','Div') as name,
Abbrev as shortname,
HostSchool as host,
str_to_date(StartDate, '%m/%d/%y') as start,
str_to_date(EndDate, '%m/%d/%y') as end,
replace(Invite,'Diiv','Div') as invite,

InviteURL as inviteURL,

if(ElimSides is null, null,
if(ElimSides = '1', 'no',
if(ElimSides = '2', 'yes',''))) as sideEqualization,

if(UsePrefs is null, null,
if(UsePrefs = '0', 'no',
if(UsePrefs = '1', 'yes',''))) as MPJ,

PrefCats as MPJcategories,

if(CEDASanc is null, null,
if(CEDASanc = '0', 'no',
if(CEDASanc = '1', 'yes',''))) as CEDAsanctioned,

if(AFASanc is null, null,
if(AFASanc = '0', 'no',
if(AFASanc = '1', 'yes',''))) as AFAsanctioned,

if(AFAOpen is null, null,
if(AFAOpen = '0', 'no',
if(AFAOpen = '1', 'yes',''))) as nonAFAschoolsPermitted,

if(HighSchool is null, null,
if(HighSchool = '0', 'college',
if(HighSchool = '1', 'high school',''))) as level,

if(ThreeOK is null, null,
if(ThreeOK = '0', 'no',
if(ThreeOK = '1', 'yes',''))) as threePersonTeamsAllowed,

if(HybridsOK is null, null,
if(HybridsOK = '0', 'no',
if(HybridsOK = '1', 'yes',''))) as hybridTeamsAllowed,

ResultsURL as resultsURL,

if(RoundRobin is null, null,
if(RoundRobin = '0', 'no',
if(RoundRobin = '1', 'yes',''))) as roundRobin,

HotelURL as hotelURL

from DebateResults0708.MasterTournaments

union all
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
select
null as aka,
2009 as year,
ID as id,
TourneyName as name,
Abbrev as shortname,
HostSchool as host,
str_to_date(StartDate, '%c/%e/%Y') as start,
str_to_date(EndDate, '%c/%e/%Y') as end,
Invite as invite,

InviteURL as inviteURL,

if(ElimSides is null, null,
if(ElimSides = '1', 'no',
if(ElimSides = '2', 'yes',''))) as sideEqualization,

if(UsePrefs is null, null,
if(UsePrefs = '0', 'no',
if(UsePrefs = '-1', 'yes',''))) as MPJ,

PrefCats as MPJcategories,

if(CEDASanc is null, null,
if(CEDASanc = '0', 'no',
if(CEDASanc = '-1', 'yes',''))) as CEDAsanctioned,

if(AFASanc is null, null,
if(AFASanc = '0', 'no',
if(AFASanc = '-1', 'yes',''))) as AFAsanctioned,

if(AFAOpen is null, null,
if(AFAOpen = '0', 'no',
if(AFAOpen = '-1', 'yes',''))) as nonAFAschoolsPermitted,

'college' as level,

if(ThreeOK is null, null,
if(ThreeOK = '0', 'no',
if(ThreeOK = '-1', 'yes',''))) as threePersonTeamsAllowed,

if(HybridsOK is null, null,
if(HybridsOK = '0', 'no',
if(HybridsOK = '-1', 'yes',''))) as hybridTeamsAllowed,

ResultsURL as resultsURL,

if(RoundRobin is null, null,
if(RoundRobin = '0', 'no',
if(RoundRobin = '-1', 'yes',''))) as roundRobin,

HotelURL as hotelURL

from DebateResults0809.MasterTournaments;


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
call sametournament(2009,61,2004,382);
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


create table
seedOrdering
(

   year smallint unsigned not null,
   tournament int,
   foreign key (year,tournament)
   references tournaments (year,id),
   
   seed enum ('speaker','team') not null,
   
   precedence tinyint unsigned not null,

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
type = InnoDB
/*charset = utf8*/
;

create table
divisions
(
   year smallint unsigned not null
   comment 'year ending the season in which the division was held',
   id int not null
   comment 'original debateresults.com primary key',
   unique key (year,id),

   tourn int not null
   comment 'tournament holding the division',
   foreign key (year,tourn)
   references tournaments (year,id)

)
type = InnoDB
/*charset = utf8*/
;


create table 
cedaRegions
(
   year smallint unsigned not null
   comment 'Year ending the season before which the region was established',
   region tinyint unsigned not null,
   unique key (year,region),

   name varchar (25),
   shortname char (3),
   description varchar (200) not null
   comment 'Which cities, states, and/or zip codes are included in this region'
)
type = InnoDB
/*charset = utf8*/
comment = 'http://commweb.fullerton.edu/jbruschke/web/ManageAccount.aspx'
;

insert into cedaRegions
set year = 2009,
region = 1,
shortname = 'NW',
name = 'Northwest',
description = 'Alaska, Washington, Oregon, Idaho, and Helena, MT';

insert into cedaRegions
set year = 2009,
region = 2,
shortname = 'W',
name = 'West',
description = 'zip codes 9300-9700 and Reno, NV';

insert into cedaRegions
set year = 2009,
region = 3,
shortname = 'SCA',
name = 'Southern California',
description = 'zip codes 9000-9299, Hawaii, Arizona, and Las Vegas, NV';

insert into cedaRegions
set year = 2009,
region = 4,
shortname = 'RM',
name = 'Rocky Mountain',
description = 'Colorado, Wyoming, Utah, New Mexico, Montana and El Paso, TX';

insert into cedaRegions
set year = 2009,
region = 5,
shortname = 'NC',
name = 'North Central',
description = 'Iowa, Wisconsin, Minnesota, South Dakota, North Dakota, Nebraska and Illinois';

insert into cedaRegions
set year = 2009,
region = 6,
shortname = 'MAm',
name = 'Mid-America',
description = 'Missouri, Kansas and Oklahoma';

insert into cedaRegions
set year = 2009,
region = 7,
shortname = 'EC',
name = 'East Central',
description = 'Ohio, Indiana, Michigan and West Virginia';

insert into cedaRegions
set year = 2009,
region = 8,
shortname = 'SC',
name = 'South Central',
description = 'Louisiana and Texas';

insert into cedaRegions
set year = 2009,
region = 9,
shortname = 'SEC',
name = 'Southeast Central',
description = 'Kentucky, Tennessee, Arkansas, Mississippi and Alabama';

insert into cedaRegions
set year = 2009,
region = 10,
shortname = 'SE',
name = 'Southeast',
description = 'North Carolina, South Carolina, Georgia, and Florida';

insert into cedaRegions
set year = 2009,
region = 11,
shortname = 'NE',
name = 'North East',
description = 'Massachusetts, Maine, Rhode Island, New Jersey, New Hampshire, Vermont, New York, Connecticut, West Virginia';

insert into cedaRegions
set year = 2009,
region = 12,
shortname = 'MAt',
name = 'Mid-Atlantic',
description = 'Pennsylvania, Delaware, District of Columbia, Maryland, Virginia';

create table 
ndtDistricts
(
   year smallint unsigned not null
   comment 'Year ending the season before which the district was established',
   district tinyint unsigned not null,
   unique key (year,district),

   description varchar (200) not null
   comment 'Which cities, states, and/or zip codes are included in this district',

   tournament int unsigned,
   foreign key (tournament)
   references tournaments (aka)
   on update cascade
)
type = InnoDB
/*charset = utf8*/
comment = 'http://www.whitman.edu/rhetoric/ndt/ndt-districts.htm'
;

insert into ndtDistricts
set year = 2009,
district = 1,
description = 'Alaska, California, Hawaii, Nevada (except for UNLV)';

insert into ndtDistricts
set year = 2009,
district = 2,
description = 'Oregon, Washington, Idaho (except for Idaho State)';

insert into ndtDistricts
set year = 2009,
district = 3,
description = 'Arkansas, Kansas, Missouri, Louisiana, Oklahoma, Texas';

insert into ndtDistricts
set year = 2009,
district = 4,
description = 'Iowa, Minnesota, Nebraska, North Dakota, South Dakota, Wisconsin';

insert into ndtDistricts
set year = 2009,
district = 5,
description = 'Illinois, Indiana, Michigan, Ohio';

insert into ndtDistricts
set year = 2009,
district = 6,
description = 'Alabama, Florida, Georgia, Kentucky, Mississippi, North Carolina, South Carolina, Tennessee';

insert into ndtDistricts
set year = 2009,
district = 7,
description = 'Delaware, District of Columbia, Maryland, New Jersey, Pennsylvania, Virginia, West Virginia';

insert into ndtDistricts
set year = 2009,
district = 8,
description = 'Connecticut, Maine, Massachusetts, New Hampshire, New York, Rhode Island, Vermont';

insert into ndtDistricts
set year = 2009,
district = 9,
description = 'Arizona, Colorado, Montana, New Mexico, Utah, Wyoming (UNLV and Idaho State)';

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

insert into ndtDistricts
set year = 2010,
district = 1,
description = 'Arizona, California, Hawaii, Nevada';

insert into ndtDistricts
set year = 2010,
district = 2,
description = 'Alaska, Colorado, Montana, Oregon, Utah, Wyoming, Washington, Idaho';

insert into ndtDistricts
set year = 2010,
district = 3,
description = 'Arkansas, Kansas, Missouri, Louisiana, Oklahoma, Texas, New Mexico';
