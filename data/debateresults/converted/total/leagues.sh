#!/bin/bash

cat <<EOF

use DebateResultsAll;

drop table if exists cedaRegions;

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
/*
type = InnoDB
*/
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

drop table if exists ndtDistricts;

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
/*
type = InnoDB
*/
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

update ndtDistricts, tournaments
set tournament = tournaments.aka
where ndtDistricts.year = tournaments.year
and instr(shortname,concat('D',district)) = 1;

EOF