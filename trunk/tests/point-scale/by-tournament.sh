#!/bin/bash

cat <<EOF

use DebateResultsAll;

drop 
temporary table
if exists
points;

create temporary table points


/*
EOF

for POS in aff1 aff2 neg1 neg2
do
    cat <<EOF
*/

select tournaments.aka,
tournaments.name,
rounds.tournament,
rounds.level,
rounds.year,
rounds.roundNum,
affteam,
negteam,
judge,
rounds.${POS} as spkr,
ballots.${POS}points as points
from ballots, rounds, tournaments
where ballots.year = rounds.year
and ballots.round = rounds.id
and rounds.year = tournaments.year
and rounds.tournament = tournaments.id
and ballots.${POS}points > 0

union all

/*
EOF
done

cat <<EOF
*/

select 1,2,3,4,5,6,7,8,9,10,11
from ballots
where 1 = 0;


select 
avg(round(points*1) != points*1) as whole,
avg(round(points*2) != points*2) as half,
avg(round(points*4) != points*4) as quarter,
avg(round(points*10) != points*10) as tenth,
avg(points) as avp,
count(*) as many,
year, tournament, aka, name
from points
where aka in (27,50,26,19,22,27,64,3,66)
group by year, tournament
order by aka, year, quarter, half, whole, avp;


/*
2007,3
2008,3
2007,50
2008,66
*/

drop procedure
if exists range_incr;

delimiter |

create procedure
range_incr(yr smallint unsigned, 
	   ak int unsigned, 
	   bottom decimal(6,3), 
	   incr decimal(6,3), 
	   top decimal(6,3),
	   coarse decimal(6,3))
begin
/*
  select points, count(*) from (
  select points, if(points <= bottom, bottom,
         round(points/incr)*incr) as rp
  from points
  where year = yr
  and aka = ak
  and level = 'open') as must
  group by points;
  
  select points, count(*) from (
  select points, if(points <= bottom, bottom,
         round(points/incr)*incr) as rp
  from points
  where year = yr+1
  and aka = ak
  and level = 'open') as must
  group by points;
*/


drop 
temporary table
if exists
mypoints;

create temporary table mypoints
/*
EOF

for POS in aff1 aff2 neg1 neg2
do
    cat <<EOF
*/

select tournaments.aka,
tournaments.name,
tournaments.shortname,
rounds.tournament,
rounds.level,
rounds.year,
rounds.roundNum,
round,
affteam,
negteam,
judge,
rounds.${POS} as spkr,
ballots.${POS}points as points
from ballots, rounds, tournaments
where ballots.year = rounds.year
and ballots.round = rounds.id
and rounds.year = tournaments.year
and rounds.tournament = tournaments.id
and ballots.${POS}points > 0
and tournaments.aka = ak
and tournaments.year = yr
and rounds.level = 'open'

union all

/*
EOF
done

cat <<EOF
*/

select 1,2,3,4,5,6,7,8,9,10,11,12,13
from ballots
where 1 = 0;

  select max(roundNum), year, name, shortname
  from mypoints;
/*
  drop temporary table
  if exists winpct;
  
  create temporary table winpct
  select team, avg(win) as winpct from (
  select affteam as team, 
  if(decision = 'aff',1,
  if(decision = 'neg',0,0.5)) as win
  from rounds, ballots, tournaments
  where ballots.year = rounds.year
  and ballots.round = rounds.id
  and rounds.year = yr
  and rounds.level = 'open'
  and rounds.tournament = tournaments.id
  and tournaments.year = rounds.year
  and tournaments.aka = ak
  and roundNum > 0
  and result = 'ballots'
  union all
  select negteam, 
  if(decision = 'neg',1,
  if(decision = 'aff',0,0.5)) as win
  from rounds, ballots, tournaments
  where ballots.year = rounds.year
  and ballots.round = rounds.id
  and rounds.year = yr
  and rounds.level = 'open'
  and rounds.tournament = tournaments.id
  and tournaments.year = rounds.year
  and tournaments.aka = ak
  and roundNum > 0
  and result = 'ballots') as must
  group by team;

  drop temporary table
  if exists winpct2;

  create temporary table 
  winpct2
  select * from winpct;
*/
/*
  drop temporary table
  if exists qual;

  create temporary table qual
  select judge, 
  avg((aff.winpct + neg.winpct)/2) as tqual,
  avg(points) as rqual
  from mypoints, winpct as aff, winpct2 as neg
  where affteam = aff.team
  and negteam = neg.team
  group by judge;


  select avg(tqual) as mx, avg(rqual) as my,
  stddev_samp(tqual) as sx, stddev_samp(rqual) as sy,
  count(*) as ln
  from qual
  into @mx, @my, @sx, @sy, @ln;

  select (sum((tqual - @mx)*(rqual - @my)))/(@sx * @sx * (@ln -1)) as cc
  from qual;


  select * from qual order by tqual;
*/
/*

EOF

for RNM in 1 2 3 4 5 6 7 8
do

    cat <<EOF

*/
/*
  drop temporary table
  if exists qual;

  create temporary table qual
  select roundNum, (aff.winpct + neg.winpct)/2 as tqual,
  avg(points) as rqual
  from winpct as aff, winpct2 as neg, mypoints
  where affteam = aff.team
  and negteam = neg.team
  and year = yr
  and aka = ak
  and roundNum = ${RNM}
  group by judge
  order by tqual;

  select avg(tqual) as mx, avg(rqual) as my,
  stddev_samp(tqual) as sx, stddev_samp(rqual) as sy,
  count(*) as ln
  from qual
  into @mx, @my, @sx, @sy, @ln;

  select roundNum, (sum((tqual - @mx)*(rqual - @my)))/(@sx * @sx * (@ln -1)) as cc
  from qual;
*/
/*
  select * from qual order by tqual;
*/
/*

EOF

done

cat <<EOF

*/  

  select 'Distinct points per speaker at tournament' as '';

  select max(roundNum)
  from mypoints
  into @rntot;

  select count(distinct spkr)
  from mypoints
  into @sptot;

  select concat(group_concat(many),'|',group_concat(100*nn/@sptot)) as '' from (
  select many, count(*) as nn from (
  select count(distinct points) as many
  from mypoints
  group by spkr) as must
  group by many order by many) as have;

  select 'Distinct points per round' as '';

  select count(distinct round) 
  from mypoints
  into @rtot;

  select concat(group_concat(many),'|',group_concat(100*nn/@rtot)) as '' from (
  select many, count(*) as nn from (
  select roundNum, count(distinct points) as many
  from mypoints
  group by roundNum, judge) as must
  group by many
  order by many) as must;

  select 'Point distribution' as '';

  select count(*) 
  from mypoints
  into @ptot;

  select concat(group_concat(points),'|',group_concat(nn/@ptot)) as '' from (
  select points, count(*) as nn
  from mypoints
  group by points
  order by points) as must;

  select 'coarsening by round' as '';

  select concat(group_concat(roundNum),'|',group_concat(avan)) as '' from (
  select roundNum, avg(allnot) as avan from (
  select roundNum, avg(round(points/coarse) = points/coarse) = 1 as allnot
  from mypoints
  group by judge, roundNum) as must
  group by roundNum) as have;

  select concat(group_concat(roundNum),'|',group_concat(avan)) as '' from (
  select roundNum, 1-avg(round(points/coarse) = points/coarse) as avan
  from mypoints
  group by roundNum) as must;

  select 'coarsening by judge' as '';

  select many, avg(follow) from (
  select judge, avg(allnot) = 1 as follow, count(*) as many from (
  select judge, avg(round(points/coarse) = points/coarse) = 1 as allnot
  from mypoints
  group by judge, roundNum) as must
  group by judge 
  order by follow) as have
  group by many with rollup;

  select follow, sum(many) from (
  select judge, avg(allnot) = 1 as follow, count(*) as many from (
  select judge, avg(round(points/coarse) = points/coarse) = 1 as allnot
  from mypoints
  group by judge, roundNum) as must
  group by judge 
  order by follow) as have
  group by follow with rollup;

  select 'separate out non-compliant judges' as '';

  drop temporary table
  if exists
  cooper;

  create temporary table
  cooper
  select judge from 
  (select judge, avg(round(points/coarse) = points/coarse) as oldscale
  from mypoints
  group by judge) as must
  where oldscale != 1;

  drop temporary table
  if exists
  uncooper;

  create temporary table
  uncooper
  select judge from 
  (select judge, avg(round(points/coarse) = points/coarse) as oldscale
  from mypoints
  group by judge) as must
  where oldscale = 1;

  select 'Cooper point distribution' as '';  

  select count(*) 
  from mypoints, cooper
  where mypoints.judge = cooper.judge
  into @ptot;

  select concat(group_concat(points),'|',group_concat(nn/@ptot)) as '' from (
  select points, count(*) as nn
  from mypoints, cooper
  where mypoints.judge = cooper.judge
  group by points
  order by points) as must;

  select 'Uncooper point distribution' as '';  

  select count(*) 
  from mypoints, uncooper
  where mypoints.judge = uncooper.judge
  into @ptot;

  select concat(group_concat(points),'|',group_concat(nn/@ptot)) as '' from (
  select points, count(*) as nn
  from mypoints, uncooper
  where mypoints.judge = uncooper.judge
  group by points
  order by points) as must;

  select 'Cooper coarsening by round' as '';

  select concat(group_concat(roundNum),'|',group_concat(avan)) as '' from (
  select roundNum, 1-avg(round(points/coarse) = points/coarse) as avan
  from mypoints, cooper
  where mypoints.judge = cooper.judge
  group by roundNum) as must;

  select '3,5,8' as '';

  select follow, oldfol, sum(many) from (
  select judge, avg(allnot) = 1 as follow, avg(oldnot) = 1 as oldfol, count(*) as many from (
  select judge, avg(10*(points - floor(points)) in (0,3,5,8)) = 1 as allnot,
  avg(10*(points - floor(points)) in (0,5)) = 1 as oldnot
  from mypoints
  group by judge, roundNum) as must
  group by judge 
  order by follow) as have
  group by follow, oldfol with rollup;

  select 'separate out example scale judges' as '';

  drop temporary table
  if exists
  cooper;

  create temporary table
  cooper
  select judge from 
  (select judge, avg(10*(points - floor(points)) in (0,3,5,8)) as oldscale
  from mypoints
  group by judge) as must
  where oldscale != 1;

  drop temporary table
  if exists
  uncooper;

  create temporary table
  uncooper
  select judge from 
  (select judge, avg(10*(points - floor(points)) in (0,3,5,8)) as example,
  avg(10*(points - floor(points)) in (0,5)) as oldscale
  from mypoints
  group by judge) as must
  where example = 1
  and oldscale != 1;

  select 'Cooper point distribution' as '';  

  select count(*) 
  from mypoints, cooper
  where mypoints.judge = cooper.judge
  into @ptot;

  select concat(group_concat(points),'|',group_concat(nn/@ptot)) as '' from (
  select points, count(*) as nn
  from mypoints, cooper
  where mypoints.judge = cooper.judge
  group by points
  order by points) as must;

  select 'Uncooper point distribution' as '';  

  select count(*) 
  from mypoints, uncooper
  where mypoints.judge = uncooper.judge
  into @ptot;

  select concat(group_concat(points),'|',group_concat(nn/@ptot)) as '' from (
  select points, count(*) as nn
  from mypoints, uncooper
  where mypoints.judge = uncooper.judge
  group by points
  order by points) as must;

  select 'Cooper coarsening by round' as '';

  select concat(group_concat(roundNum),'|',group_concat(avan)) as '' from (
  select roundNum, 1-avg(round(points/coarse) = points/coarse) as avan
  from mypoints, cooper
  where mypoints.judge = cooper.judge
  group by roundNum) as must;

  select 'Cooper exampling by round' as '';

  select concat(group_concat(roundNum),'|',group_concat(avan)) as '' from (
  select roundNum, 1-avg(10*(points - floor(points)) in (0,3,5,8)) as avan
  from mypoints, cooper
  where mypoints.judge = cooper.judge
  group by roundNum) as must;

  select 'Uncooper coarsening by round' as '';

  select concat(group_concat(roundNum),'|',group_concat(avan)) as '' from (
  select roundNum, 1-avg(round(points/coarse) = points/coarse) as avan
  from mypoints, uncooper
  where mypoints.judge = uncooper.judge
  group by roundNum) as must;

  select 'Uncooper exampling by round' as '';

  select concat(group_concat(roundNum),'|',group_concat(avan)) as '' from (
  select roundNum, 1-avg(10*(points - floor(points)) in (0,3,5,8)) as avan
  from mypoints, uncooper
  where mypoints.judge = uncooper.judge
  group by roundNum) as must;

/*
  select roundNum, avg(many) from (
  select roundNum, count(distinct points) as many
  from points
  where year = yr
  and aka = ak
  and level = 'open'
  group by roundNum, judge) as must
  group by roundNum
  order by roundNum;
*/

end |

delimiter ;

/*
2007,3 0.5 -> 0.25
2008,3 0.25 -> 0.1
2007,50 0.5 -> 1->100 by 1
2008,66 0.5 -> 0.1
*/


call range_incr(2007,3,25,0.5,30,1);
call range_incr(2008,3,25,0.25,30,0.5);
call range_incr(2009,3,25,0.1,30,0.5);
call range_incr(2007,50,25,0.5,30,1);
call range_incr(2008,50,70,1,100,5);
call range_incr(2009,50,70,1,100,5);
call range_incr(2004,19,25,0.5,30,1);
call range_incr(2007,19,25,0.5,30,1);
call range_incr(2005,27,25,0.5,30,1);
call range_incr(2006,27,25,0.5,30,1);
call range_incr(2008,66,25,0.5,30,1);
call range_incr(2009,66,25,0.1,30,0.5);


/*call range_incr(2008,66,24,0.5,30);*/

drop procedure
if exists range_incr;

/*
EOF