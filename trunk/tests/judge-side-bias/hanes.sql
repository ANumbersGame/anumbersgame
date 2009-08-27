use DebateResultsAll;

create temporary table jexps
select * from 
(select people.year, people.aka, count(*) as many
from people, rounds, ballots
where ballots.round = rounds.id
and ballots.year = rounds.year
and ballots.judge = people.id
and people.role = 'judge'
and rounds.roundNum > 0
and people.year = rounds.year
and ballots.decision in ('aff','neg')
group by year, aka) as must
where many >= 6;

create temporary table probs
select year
,count(if(decision = 'aff',1,null))/
 count(if(decision in ('aff','neg'),1,null)) as prob
from ballots
group by year;

create temporary table color
select must.year,
affcount < (tcount * prob) - sqrt(tcount * prob * (1-prob))
or
affcount > (tcount * prob) + sqrt(tcount * prob * (1-prob)) as nongreen,
affcount = (tcount * prob) - sqrt(tcount * prob * (1-prob))
or
affcount = (tcount * prob) + sqrt(tcount * prob * (1-prob)) as ongreen
from (select people.year, people.aka,
count(if(ballots.decision = 'aff',1,null)) as affcount,
count(if(ballots.decision in ('aff','neg'),1,null)) as tcount
from jexps, people, ballots
where jexps.year = people.year
and jexps.aka = people.aka
and people.role = 'judge'
and people.year = ballots.year
and people.id = ballots.judge
group by year, people.aka) as must, probs
where must.year = probs.year;

select year, avg(nongreen), avg(ongreen)
from color
group by year;