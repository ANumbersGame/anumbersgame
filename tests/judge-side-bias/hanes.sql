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
,count(if(decision = 'aff',1,null)) /
 count(if(decision in ('aff','neg'),1,null)) as prob
from ballots
group by year;

create temporary table color
select must.year,
affcount < (tcount * prob) + sqrt(tcount * prob * (1-prob))
and
affcount > (tcount * prob) - sqrt(tcount * prob * (1-prob)) as ingreen,
affcount = (tcount * prob) - sqrt(tcount * prob * (1-prob))
or
affcount = (tcount * prob) + sqrt(tcount * prob * (1-prob)) as ongreen,
affcount < (tcount * prob) + 2*sqrt(tcount * prob * (1-prob))
and
affcount > (tcount * prob) - 2*sqrt(tcount * prob * (1-prob)) as inyellow,
affcount = (tcount * prob) - 2*sqrt(tcount * prob * (1-prob))
or
affcount = (tcount * prob) + 2*sqrt(tcount * prob * (1-prob)) as onyellow,
affcount < (tcount * prob) + 3*sqrt(tcount * prob * (1-prob))
and
affcount > (tcount * prob) - 3*sqrt(tcount * prob * (1-prob)) as inred,
affcount = (tcount * prob) - 3*sqrt(tcount * prob * (1-prob))
or
affcount = (tcount * prob) + 3*sqrt(tcount * prob * (1-prob)) as onred,
affcount > (tcount * prob) + 3*sqrt(tcount * prob * (1-prob))
or
affcount < (tcount * prob) - 3*sqrt(tcount * prob * (1-prob)) as outred
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

select concat('||',year, 
concat('||',round(100*avg(ingreen),2),'%'),
concat('||',round(100*avg(inyellow),2),'%'),
concat('||',round(100*avg(inred),2),'%'),
concat('||',round(100*avg(outred),2),'%'),
'||')
from color
group by year;