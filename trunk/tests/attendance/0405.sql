use DebateResults0405;

alter table MasterTournaments
drop column DistrictQual;

alter table MasterTournaments
add column DistrictQual
int null
default null
comment 'Not null if tournament is district NDT qualifier';

update MasterTournaments
set DistrictQual = 1
where TourneyName = 'NDT D1 / California Policy Debate Championships';

update MasterTournaments
set DistrictQual = 3
where TourneyName = 'NDT District III Qualifying Tournament';

update MasterTournaments
set DistrictQual = 4
where TourneyName = 'District 4 Qualifier';

update MasterTournaments
set DistrictQual = 5
where TourneyName = 'NDT Qualifiers (District 5, CWRU)';

update MasterTournaments
set DistrictQual = 6
where TourneyName = 'SECEDA/SECCEDA D-6';

update MasterTournaments
set DistrictQual = 7
where TourneyName = 'District VII Qualifying';

update MasterTournaments
set DistrictQual = 8
where TourneyName = 'District 8 Qualifier';

update MasterTournaments
set DistrictQual = 9
where TourneyName = 'District Nine Qualifiers';

select count(*) = 8
from MasterTournaments
where DistrictQual is not null;

select DistrictQual as Dist, count(*) as Rounds, Diivision as 'Div', TourneyName
from MasterResults, MasterTournaments
where Tournament = MasterTournaments.ID
and DistrictQual is not null
group by Tournament, Diivision
order by Diivision, DistrictQual;


select count(distinct AffTeam) as 'District Teams'
from MasterResults, MasterTournaments
where Tournament = MasterTournaments.ID
and (DistrictQual = 1
or DistrictQual = 3
or DistrictQual = 5
or DistrictQual = 6
or DistrictQual = 7
or DistrictQual = 8)
and Diivision = 1;

select count(distinct AffTeam) as 'CEDA Teams'
from MasterResults, MasterTournaments
where Tournament = MasterTournaments.ID
and TourneyName = 'CEDA Nationals';