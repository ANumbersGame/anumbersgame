use DebateResults0304;

alter table MasterTournaments
drop column DistrictQual;

alter table MasterTournaments
add column DistrictQual
int null
default null
comment 'Not null if tournament is district NDT qualifier';

update MasterTournaments
set DistrictQual = 1
where TourneyName = 'NDT D1 Qualifying and CA Junior-Novice Champs';

update MasterTournaments
set DistrictQual = 3
where TourneyName = 'D3 NDT Qualifying tournament';

update MasterTournaments
set DistrictQual = 4
where TourneyName = 'District IV NDT Qualifier';

update MasterTournaments
set DistrictQual = 5
where TourneyName = 'District 5 Qualifier';

update MasterTournaments
set DistrictQual = 6
where TourneyName = 'SECEDA/SCCEDA/D-6';

update MasterTournaments
set DistrictQual = 7
where TourneyName = 'District VII Qualifying Tournament';

update MasterTournaments
set DistrictQual = 8
where TourneyName = 'NDT District 8';

update MasterTournaments
set DistrictQual = 9
where TourneyName = 'District 9 NDT Qualifier';

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