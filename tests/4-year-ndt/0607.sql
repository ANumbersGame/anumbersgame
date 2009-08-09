use test;

alter table DebateResults0607.TeamNumbers add index (Speaker1), add index (Speaker2), add index (Speaker3);
alter table DebateResults0607.MasterResults add index (AffTeam), add index (NegTeam), add index (Diivision);

create temporary table openers
(key (openid))
select distinct(CompetitorID) as openid
from 
DebateResults0607.MasterCompetitors,
DebateResults0607.TeamNumbers,
DebateResults0607.MasterResults
where 
(CompetitorID = Speaker1
 OR
 CompetitorID = Speaker2
 OR
 CompetitorID = Speaker3
)
AND
(TeamNum = AffTeam
 OR
 TeamNum = NegTeam
)
AND
Diivision = 1;

select count(*) as '2006-2007 open division debaters:'
from openers;

alter table DebateResults0607.MasterCompetitors add index (FirstName), add index (LastName);
alter table DebateResults0506.MasterCompetitors add index (FirstName), add index (LastName);

create temporary table freshpeople
(key (freshid))
select six.CompetitorID as freshid
from DebateResults0607.MasterCompetitors as six
left join DebateResults0506.MasterCompetitors as five
on six.FirstName = five.FirstName
and six.LastName = five.LastName
where five.CompetitorID is null;

create temporary table freshdebaters
(key (terid))
select distinct(freshid) as terid
from 
freshpeople,
DebateResults0607.TeamNumbers,
DebateResults0607.MasterResults
where 
(freshid = Speaker1
 OR
 freshid = Speaker2
 OR
 freshid = Speaker3
)
AND
(TeamNum = AffTeam
 OR
 TeamNum = NegTeam
);

select count(*) as '2006-2007 new college debaters:'
from freshdebaters;

select count(*) as '2006-2007 freshperson open division debaters:'
from freshdebaters, openers
where terid = openid;

create temporary table ndters
(key (ndtid))
select distinct(AffTeam) as ndtid
from DebateResults0607.MasterResults, DebateResults0607.MasterTournaments
where Tournament = DebateResults0607.MasterTournaments.ID
and TourneyName = 'National Debate Tournament';

select count(*) as '2006-2007 NDT freshpersons:'
from ndters, freshdebaters, DebateResults0607.TeamNumbers
where TeamNum = ndtid
and 
(terid = Speaker1
 OR
 terid = Speaker2
 OR
 terid = Speaker3);