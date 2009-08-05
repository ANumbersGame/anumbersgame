/*
On Wed, Aug 5, 2009 at 12:55 PM, Jacob Thompson wrote:
> 2)        HIGH QUALITY COMPETITION—We were the 5th largest debate tournament
> in America last year and will only continue to grow in size and competition
> quality as time goes on.

DebateResults.com shows 78 teams competing at the UNLV invitational
last year, which makes it tied (with the NDT) for the 18th/19th
largest tournament in the 2008-2009 season.

This does not include any other formats of forensic competition.
*/
select concat(count(*), ' -- ', name) as rounds
from rounds, tournaments 
where tournaments.year = rounds.year 
and tournaments.id = rounds.tournament 
and result = 'ballots' 
and rounds.year = 2009 
group by tournament 
order by count(*) desc;

select concat(count(*), ' -- ', name) as ballots
from rounds, ballots, tournaments 
where tournaments.year = rounds.year 
and tournaments.id = rounds.tournament 
and rounds.id = ballots.round 
and ballots.year = rounds.year 
and ballots.decision in ('aff','neg') 
and rounds.year = 2009 
group by tournament 
order by count(*) desc;

select sum(many)/count(*) as `mean teams`, 
pow(exp(sum(log(many))),1/count(*)) as `geometric mean teams` 
from (
select count(distinct affteam) as many
from rounds 
where rounds.year = 2009 
group by tournament) 
as must;

select concat(count(distinct affteam), ' -- ', name) as teams
from rounds, tournaments 
where tournaments.year = rounds.year 
and tournaments.id = rounds.tournament 
and rounds.year = 2009 
group by tournament 
order by count(distinct affteam) desc;

select concat(count(distinct affteam), ' -- ', name) as teams08prop
from rounds, tournaments 
where tournaments.year = rounds.year 
and tournaments.id = rounds.tournament 
and year(tournaments.start) = 2008
group by tournament 
order by count(distinct affteam) desc;

select concat(count(distinct affteam), ' -- ', rounds.level, ' -- ',name) as teams
from rounds, tournaments 
where tournaments.year = rounds.year 
and tournaments.id = rounds.tournament 
and rounds.year = 2009 
and roundNum > 0
group by tournament, rounds.level 
order by rounds.level,count(distinct affteam) desc;
