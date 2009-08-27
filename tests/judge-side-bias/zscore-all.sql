use DebateResultsAll;
/*
select year, avg(many), count(*) as much
from (select people.year, count(*) as many
from people, ballots
where people.role = 'judge'
and people.year = ballots.year
and ballots.judge = people.id
and ballots.decision in ('aff','neg')
group by people.aka, people.year)
as must
group by year, many<=4
order by year, many;
*/

create temporary table probs
select year
,count(if(decision = 'aff',1,null))/
 count(if(decision in ('aff','neg'),1,null)) as prob
from ballots
group by year;

create temporary table zscores
select must.*, probs.prob,
(affcount - ((affcount+negcount) * prob))
/
sqrt((affcount+negcount) * prob * (1-prob)) as zscore
 from (
select people.year, people.aka, people.id, people.firstname, people.lastname
, count(if(decision = 'aff',1,null)) as affcount
, count(if(decision = 'neg',1,null)) as negcount
from people, rounds, ballots
where rounds.year = ballots.year
and ballots.round = rounds.id
and people.year = rounds.year
and people.role = 'judge'
and ballots.judge = people.id
group by year, aka) as must, probs
where probs.year = must.year
and affcount+negcount >= 12;

create temporary table summaries
select year, avg(zscore) as az, var_pop(zscore) as vz, count(*) as zcount
from zscores
group by year;

create temporary table distrib
select summaries.year, round(round(5*zscore)/5+0,1) as loc, count(*) as many, 
0.2 * zcount * exp(-(pow(round(5*zscore)/5,2))/2)/sqrt(2*pi()) as pdf
from zscores, summaries
where summaries.year = zscores.year
group by round(5*zscore)+0, summaries.year;

select 
concat('<p align="center"><img src="http://chart.apis.google.com/chart?cht=lxy&chs=500x350&chd=t:',
group_concat(loc order by loc),
'|',
group_concat(many order by loc),
'|',
group_concat(loc order by loc),
'|',
group_concat(round(pdf,1)+0 order by loc)
,'&chds=',
min(loc),',',max(loc),',',
0,',',round(1.1*max(if(pdf>many,pdf,many))),',',
min(loc),',',max(loc),',',
0,',',round(1.1*max(if(pdf>many,pdf,many))),
'&chco=ff4444,777777&chtt=',summaries.year-1,'-',summaries.year,' judge side bias distribution|',sum(many),' judges with 12 or more rounds&chdl=actual: μ='
,round(az,2)+0,
', σ='
,round(sqrt(vz),2)+0
,'|expected: μ=0.00, σ=1.00&chxt=x,y,x&chxr=0,',
min(loc),',',max(loc),'1|1,0,',round(1.1*max(if(pdf>many,pdf,many)))
,',5&chxl=2:||z-score|&img=dum.png">'
)
from distrib, summaries
where distrib.year = summaries.year
group by distrib.year;