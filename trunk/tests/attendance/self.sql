/*
select TourneyName
from MasterTournaments
where instr(lower(TourneyName),'ceda national') != 0;
*/

create temporary table CedaTeams
select distinct AffTeam
from MasterResults, MasterTournaments
where Tournament = MasterTournaments.ID
and instr(lower(TourneyName),'ceda national') != 0;

create temporary table CedaNames1
select Speaker1 as Nom
from CedaTeams, TeamNumbers
where AffTeam = TeamNum;

create temporary table CedaNames2
select Speaker2 as Nom
from CedaTeams, TeamNumbers
where AffTeam = TeamNum;

create temporary table CedaNames
select * from
(select * from CedaNames1 
union
select * from CedaNames2) as must;

create temporary table NomT
select Nom, Diivision
from MasterResults, CedaNames, TeamNumbers, MasterTournaments
where AffTeam = TeamNum
and (Speaker1 = Nom
or Speaker2 = Nom)
and Tournament = MasterTournaments.ID
and instr(lower(TourneyName),'ceda nationals') = 0
group by Nom, Tournament;

select concat('(',avg2,',',ct,')') as '' 
from
(select ceil(avg*4)/4 as avg2, count(*) as ct from
(select Nom, avg(Diivision) as avg
from NomT
group by Nom) as must
group by avg2)
as most;