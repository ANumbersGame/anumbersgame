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
tournaments;

drop table 
if exists
schools;

drop table 
if exists
ndtDistricts;

drop table 
if exists
cedaRegions;

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
   comment 'Which cities, states, and/or zip codes are included in this district'
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
