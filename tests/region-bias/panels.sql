use DebateResultsAll

drop temporary table if exists biasCount;

create temporary table biasCount
select *, count(*) as many from (

select
year, round,
sum(if(affBias =  2 && decision = 'aff',1,0)) as aff2bias,
sum(if(affBias =  1 && decision = 'aff',1,0)) as aff1bias,
sum(if(affBias =  2 && decision = 'neg',1,0)) as aff2anti,
sum(if(affBias =  1 && decision = 'neg',1,0)) as aff1anti,
sum(if(affBias = -2 && decision = 'aff',1,0)) as neg2anti,
sum(if(affBias = -1 && decision = 'aff',1,0)) as neg1anti,
sum(if(affBias = -2 && decision = 'neg',1,0)) as neg2bias,
sum(if(affBias = -1 && decision = 'neg',1,0)) as neg1bias,
sum(if(affBias =  0 && decision = 'aff',1,0)) as aff,
sum(if(affBias =  0 && decision = 'neg',1,0)) as neg

 from (

select 
if(jsc.cedaRegion = aff.cedaRegion 
and jsc.ndtDistrict = aff.ndtDistrict, 'affBias',
if(jsc.cedaRegion = neg.cedaRegion 
and jsc.ndtDistrict = neg.ndtDistrict, 'negBias',
'noBias')) as bias,
(jsc.cedaRegion = aff.cedaRegion)   +
(jsc.ndtDistrict = aff.ndtDistrict) -
(jsc.cedaRegion = neg.cedaRegion)   -
(jsc.ndtDistrict = neg.ndtDistrict) as affBias,
decision,
jsc.cedaRegion as jfc,
jsc.ndtDistrict as jfn,
aff.cedaRegion as afc,
aff.ndtDistrict as afn,
neg.cedaRegion as nfc,
neg.ndtDistrict as nfn,
ball.year,
ball.round

from rounds,
(select ballots.* 
from ballots, (select * from 
(select *, count(*) as many 
from ballots 
group by year, round) as must
where many > 1) as have
where ballots.year = have.year
and ballots.round = have.round) as ball,


people as aff1,
people as aff2,
people as neg1,
people as neg2,
people as judge,

schools as aff,
schools as neg,
schools as jsc

where ball.round = rounds.id
and ball.year = rounds.year

and aff1.year = rounds.year
and aff1.role = 'competitor'
and aff1.id = aff1

and aff2.year = rounds.year
and aff2.role = 'competitor'
and aff2.id = aff2

and neg1.year = rounds.year
and neg1.role = 'competitor'
and neg1.id = neg1

and neg2.year = rounds.year
and neg2.role = 'competitor'
and neg2.id = neg2

and aff1.school = aff2.school
and aff.year = rounds.year
and aff.id = aff1.school

and neg1.school = neg2.school
and neg.year = rounds.year
and neg.id = neg1.school

and neg.cedaRegion  != aff.cedaRegion
and neg.cedaRegion  != 0
and aff.cedaRegion  != 0
and neg.ndtDistrict != aff.ndtDistrict
and neg.ndtDistrict != 0
and aff.ndtDistrict != 0

and judge.year = ball.year
and judge.id = ball.judge
and judge.role = 'judge'
/*
and (jsc.cedaRegion = aff.cedaRegion
and jsc.ndtDistrict = aff.ndtDistrict)
or (jsc.cedaRegion = neg.cedaRegion
and jsc.ndtDistrict = neg.ndtDistrict)
*/
and jsc.year = judge.year
and jsc.id = judge.school

) as must
group by round, year
) as have
group by aff2bias, aff1bias, aff2anti,
aff1anti,
neg2anti,
neg1anti,
neg2bias,
neg1bias,
aff,
neg
order by many
;

select * from biasCount;

select sum(many) from biasCount;

select *, count(*) 
from (
select 
sum(if(decision='aff',1,0)) as aff,
sum(if(decision='neg',1,0)) as neg
from
(select ballots.* 
from ballots, (select * from 
(select *, count(*) as many 
from ballots 
group by year, round) as must
where many = 3) as have
where ballots.year = have.year
and ballots.round = have.round) as ball
group by year, round
) as must
group by aff, neg with rollup;


select  
sum(many * (aff2bias + neg2bias)) as 2bias,
sum(many * (aff2anti + neg2anti)) as 2anti,
sum(many * (aff2bias + neg2bias))/(sum(many * (aff2anti + neg2anti)) + sum(many * (aff2bias + neg2bias))) as pct2bias,
sum(many * (aff2bias + aff1bias + neg2bias + neg1bias)) as bias,
sum(many * (aff2anti + aff1anti + neg2anti + neg1anti)) as anti,
sum(many * (aff2bias + aff1bias + neg2bias + neg1bias))/(
sum(many * (aff2anti + aff1anti + neg2anti + neg1anti)) +
sum(many * (aff2bias + aff1bias + neg2bias + neg1bias))) as pctbias,
sum(many),
aff, neg,
aff = neg
from biasCount
group by aff = neg, aff, neg with rollup;