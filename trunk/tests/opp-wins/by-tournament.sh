#!/bin/bash

cat <<EOF

use DebateResultsAll;

drop procedure
if exists tie_break;

delimiter |

create procedure
tie_break(yr smallint unsigned, 
	 tid int unsigned)
begin

/* The max prelim round number in each division */
drop temporary table if exists mrn;

create temporary table mrn
select level, max(roundNum) as mrn
from rounds
where rounds.tournament = tid
and rounds.year = yr
and roundNum > 0
group by rounds.level;

/* trace a teams stats as they progress through prelims. The stats are those AFTER the roundNum */

drop temporary table if exists along;

create temporary table along
select must.team, have.roundNum, have.level,
avg(points) as points, 
(sum(points)-max(points)-min(points))
/
(if(sum(loss+win) > 2, sum(loss+win)-2, null)) as adj1pts, /*If we haven't had three ballots, we can't adjust */
avg(rank) as rank,
(sum(rank) - max(rank) - min(rank))
/
(if(count(rank) > 2, count(rank)-2, null)) as adj1rnk,
avg(oppPoints) as oppPoints, 
avg(oppRank) as oppRank,
sum(loss) as losses, sum(win) as wins from 
(
select 
level,
roundNum,
affteam as team,
aff1points + aff2points as points,
if(aff1rank*aff2rank > 0,aff1rank + aff2rank,null) as rank,
neg1points + neg2points as oppPoints,
if(neg1rank*neg2rank > 0,neg1rank + neg2rank,null) as oppRank,
decision = 'aff' as win,
decision = 'neg' as loss
from rounds, ballots
where ballots.year = rounds.year
and ballots.round = rounds.id
and rounds.tournament = tid
and rounds.year = yr
and roundNum > 0
and result = 'ballots'
and ballots.aff1points > 0
and ballots.aff2points > 0
and ballots.neg1points > 0
and ballots.neg2points > 0

union all

select 
level,
roundNum,
negteam as team, 
neg1points + neg2points as points,
if(neg1rank*neg2rank > 0,neg1rank + neg2rank,null) as rank,
aff1points + aff2points as oppPoints,
if(aff1rank*aff2rank > 0,aff1rank + aff2rank,null) as oppRank,
decision = 'neg' as win,
decision = 'aff' as loss
from rounds, ballots
where ballots.year = rounds.year
and ballots.round = rounds.id
and rounds.tournament = tid
and rounds.year = yr
and roundNum > 0
and result = 'ballots'
and ballots.aff1points > 0
and ballots.aff2points > 0
and ballots.neg1points > 0
and ballots.neg2points > 0
) as must,
(select roundNum, level
from rounds
where roundNum > 0
and rounds.tournament = tid
and rounds.year = yr
group by roundNum, level) as have
where must.roundNum <= have.roundNum
and have.level = must.level
group by must.team, have.roundNum
order by must.team, have.roundNum;

drop temporary table if exists along2;
/* add opponent team number */
create temporary table along2
select along.*, if(affteam = team, negteam, affteam) as opp
from along, rounds
where rounds.roundNum = along.roundNum
and rounds.year = yr
and rounds.tournament = tid
and along.team in (rounds.affteam, rounds.negteam);

/* We neet a permanent table for indexing */
drop table if exists num_losses_p1;
create table num_losses_p1 select * from along2;
alter table num_losses_p1
add key (team, roundNum, level);

drop temporary table if exists opp_win_pct;
/* opponent win percentage through the prelims */
create temporary table opp_win_pct
select have.level, mine.team, have.roundNum, yours.team as yt,
sum(yours.wins) as opp_wins,
sum(yours.losses) as opp_losses,
avg(yours.points) as opp_points,
avg(yours.rank) as opp_rank
from num_losses_p1 as mine,
num_losses_p1 as yours,
(select roundNum, level
from rounds
where roundNum > 0
and rounds.tournament = tid
and rounds.year = yr
group by roundNum, level) as have
where mine.opp = yours.team
and mine.level = yours.level
and mine.roundNum <= have.roundNum
and yours.roundNum = have.roundNum
and mine.level = have.level
group by mine.team, have.roundNum;

drop table if exists tiebrk;

create table tiebrk
select num_losses_p1.level,
num_losses_p1.team,
num_losses_p1.roundNum,
num_losses_p1.points,
num_losses_p1.rank,
num_losses_p1.adj1rnk,
num_losses_p1.wins,
num_losses_p1.losses,
num_losses_p1.adj1pts,
opp_wins - losses as opp_wins,
opp_losses - wins as opp_losses,
opp_win_pct.opp_points,
opp_win_pct.opp_rank
from num_losses_p1, opp_win_pct 
where num_losses_p1.roundNum = opp_win_pct.roundNum
and num_losses_p1.team = opp_win_pct.team;

alter table tiebrk
add key (level, team, roundNum);
/*
select count(*) from tiebrk;
*/
drop table if exists disagree;

drop temporary table if exists disagree;

create temporary table disagree
select rounds.roundNum as rn, 
rounds.level,
/*
rounds.affteam,
rounds.negteam,
*/
ballots.decision as 'dec',
aff.wins,
aff.losses,
/*
neg.wins,
neg.losses,
*/
aff.points as affpoints,
neg.points as negpoints,
aff.opp_wins as aow,
aff.opp_losses as aol,
neg.opp_wins as now,
neg.opp_losses as nol,
if(decision = 'aff',
if(aff.points > neg.points, 1, if(aff.points < neg.points, 0, 0.5)),
if(aff.points < neg.points, 1, if(aff.points > neg.points, 0, 0.5))) as pts_right,
if(decision = 'aff',
if(aff.opp_wins > neg.opp_wins, 1, if(aff.opp_wins < neg.opp_wins, 0, 0.5)),
if(aff.opp_wins < neg.opp_wins, 1, if(aff.opp_wins > neg.opp_wins, 0, 0.5))) as opp_wins_right,
if(decision = 'aff',
if(aff.rank < neg.rank, 1, if(aff.rank > neg.rank, 0, 0.5)),
if(aff.rank > neg.rank, 1, if(aff.rank < neg.rank, 0, 0.5))) as rank_right,
if(decision = 'aff',
if(aff.opp_wins/(aff.opp_wins+aff.opp_losses) > neg.opp_wins/(neg.opp_wins+neg.opp_losses), 1, 
if(aff.opp_wins/(aff.opp_wins+aff.opp_losses) < neg.opp_wins/(neg.opp_wins+neg.opp_losses), 0, 0.5)),
if(aff.opp_wins/(aff.opp_wins+aff.opp_losses) < neg.opp_wins/(neg.opp_wins+neg.opp_losses), 1, 
if(aff.opp_wins/(aff.opp_wins+aff.opp_losses) > neg.opp_wins/(neg.opp_wins+neg.opp_losses), 0, 0.5))) as opp_win_pct_right,
if(decision = 'aff',1,0) as aff_right,
if(decision = 'aff',
if(aff.opp_points > neg.opp_points, 1, if(aff.opp_points < neg.opp_points, 0, 0.5)),
if(aff.opp_points < neg.opp_points, 1, if(aff.opp_points > neg.opp_points, 0, 0.5))) as opp_pts_right,
if(decision = 'aff',
if(aff.adj1pts > neg.adj1pts, 1, if(aff.adj1pts < neg.adj1pts, 0, 0.5)),
if(aff.adj1pts < neg.adj1pts, 1, if(aff.adj1pts > neg.adj1pts, 0, 0.5))) as adj1pts_right,
if(decision = 'aff',
if(aff.opp_rank < neg.opp_rank, 1, if(aff.opp_rank > neg.opp_rank, 0, 0.5)),
if(aff.opp_rank > neg.opp_rank, 1, if(aff.opp_rank < neg.opp_rank, 0, 0.5))) as opp_rank_right,
if(decision = 'aff',
if(aff.adj1rnk < neg.adj1rnk, 1, if(aff.adj1rnk > neg.adj1rnk, 0, 0.5)),
if(aff.adj1rnk > neg.adj1rnk, 1, if(aff.adj1rnk < neg.adj1rnk, 0, 0.5))) as adj1rnk_right,
if(decision = 'aff',
if(aff.opp_wins*aff.points/(aff.opp_wins+aff.opp_losses) > neg.opp_wins*neg.points/(neg.opp_wins+neg.opp_losses), 1, 
if(aff.opp_wins*aff.points/(aff.opp_wins+aff.opp_losses) < neg.opp_wins*neg.points/(neg.opp_wins+neg.opp_losses), 0, 0.5)),
if(aff.opp_wins*aff.points/(aff.opp_wins+aff.opp_losses) < neg.opp_wins*neg.points/(neg.opp_wins+neg.opp_losses), 1, 
if(aff.opp_wins*aff.points/(aff.opp_wins+aff.opp_losses) > neg.opp_wins*neg.points/(neg.opp_wins+neg.opp_losses), 0, 0.5))) as owptp_right,
(aff.rank > 0 and aff.rank is not null 
and neg.rank > 0 and neg.rank is not null) as rank_record

from rounds,
tiebrk as aff,
tiebrk as neg,
ballots,
mrn
where mrn.level = rounds.level
and (rounds.roundNum = aff.roundNum+1
or (rounds.roundNum < 0
and aff.roundNum = mrn.mrn))
and (rounds.roundNum = neg.roundNum+1
or (rounds.roundNum < 0
and neg.roundNum = mrn.mrn))
and affteam = aff.team
and negteam = neg.team
and ballots.round = rounds.id
and ballots.year = rounds.year
and rounds.year = yr
and rounds.tournament = tid
and aff.wins = neg.wins
and aff.losses = neg.losses
/*
and aff.points = neg.points
*/
/*
and aff.rank = neg.rank
*/
and /*(rounds.roundNum > 2
or */rounds.roundNum < 0
/*)*/
;

drop table if exists tiebrk;

drop table if exists num_losses_p1;


end |

delimiter ;

drop procedure if exists tb_ins;

delimiter |

create procedure
tb_ins()
begin
  DECLARE done INT DEFAULT 0;
  declare yr smallint unsigned;
  declare tid int unsigned;
  DECLARE cur1 CURSOR FOR SELECT id,year FROM tournaments order by year desc, id desc;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  drop temporary table if exists predict;

  create temporary table predict (
    aff double,
    pts double,
    adj1pts double,
    opts double,
    rk  double,
    ork  double,
    ark  double,
    ow  double,
    owp double,
    owptp double,
    rr int unsigned,
    num int unsigned,
    yr  smallint unsigned,
    tid int unsigned
  );

  OPEN cur1;

  REPEAT
    FETCH cur1 INTO tid, yr;
    IF NOT done THEN

       call tie_break(yr,tid);

       select sum(aff_right) as aff,
       sum(pts_right) as pts,
       sum(adj1pts_right) as adj1pts,
       sum(opp_pts_right) as opts,
       sum(rank_right * rank_record) as rk,
       sum(opp_rank_right * rank_record) as ork,
       sum(adj1rnk_right * rank_record) as ark,
       sum(opp_wins_right) as ow,
       sum(opp_win_pct_right) as owp,
       sum(owptp_right) as owptp,
       sum(rank_record) as rr,
       count(*) as num
       from disagree;

       insert into predict
       select sum(aff_right) as aff,
       sum(pts_right) as pts,
       sum(adj1pts_right) as adj1pts,
       sum(opp_pts_right) as opts,
       sum(rank_right * rank_record) as rk,
       sum(opp_rank_right * rank_record) as ork,
       sum(adj1rnk_right * rank_record) as ark,
       sum(opp_wins_right) as ow,
       sum(opp_win_pct_right) as owp,
       sum(owptp_right) as owptp,
       sum(rank_record) as rr,
       count(*) as num,
       yr,
       tid
       from disagree;

       select sum(aff)/sum(num) as aff,
       sum(pts)/sum(num) as pts,
       sum(adj1pts)/sum(num) as adj1pts,
       sum(opts)/sum(num) as opts,
       sum(rk)/sum(rr) as rk,
       sum(ork)/sum(rr) as ork,
       sum(ark)/sum(rr) as ark,
       sum(ow)/sum(num) as ow,
       sum(owp)/sum(num) as owp,
       sum(owptp)/sum(num) as owptp,
       yr, tid
       from predict;

    END IF;
  UNTIL done END REPEAT;

  CLOSE cur1;

  select * from predict;

  select sum(aff) as aff,
  sum(pts) as pts,
  sum(adj1pts) as adj1pts,
  sum(opts) as opts,
  sum(rk) as rk,
  sum(ork) as ork,
  sum(ark) as ark,
  sum(ow)as ow,
  sum(owp)as owp,
  sum(owptp) as owptp,
  sum(num) as num,
  sum(rr) as rr
  from predict;

  select sum(aff)/sum(num) as aff,
  sum(pts)/sum(num) as pts,
  sum(adj1pts)/sum(num) as adj1pts,
  sum(opts)/sum(num) as opts,
  sum(rk)/sum(rr) as rk,
  sum(ork)/sum(rr) as ork,
  sum(ark)/sum(rr) as ark,
  sum(ow)/sum(num) as ow,
  sum(owp)/sum(num) as owp,
  sum(owptp)/sum(num) as owptp
  from predict;

end |

delimiter ;
/*
call tb_ins(2007,75);
call tb_ins(2008,180);
call tb_ins(2009,6);
call tb_ins(2007,70);
call tb_ins(2008,184);
call tb_ins(2009,54);
*/

select main.*, avg(main.precedence), count(*) as many
from seedOrdering as main,
seedOrdering as oth
where oth.precedence = 2
and oth.seed = 'team'
and oth.year = main.year
and oth.tournament = main.tournament
and main.seed = 'team'
and ((main.precedence = 2
and main.factor != 'ballots')
or (main.precedence = 3
and oth.factor = 'ballots'))
group by factor
order by many;

select main.*, tournaments.name, tournaments.start 
from seedOrdering as main, seedOrdering as oth, tournaments 
where oth.precedence = 2 
and oth.seed = 'team' 
and oth.year = main.year 
and oth.tournament = main.tournament 
and main.seed = 'team' 
and ((main.precedence = 2 and main.factor != 'ballots') 
or (main.precedence = 3 and oth.factor = 'ballots')) 
and main.factor = 'opponent wins' 
and tournaments.id = main.tournament 
and tournaments.year = main.year 
order by start;

select count(*) 
from rounds, ballots 
where ballots.round = rounds.id
and ballots.year= rounds.year
and roundNum < 0;

select count(distinct concat(year,tournament)) 
from seedOrdering;

call tb_ins();

/*
EOF