use DebateResults0506;

alter table MasterTournaments
drop column DistrictQual;

alter table MasterTournaments
add column DistrictQual
int null
default null
comment 'Not null if tournament is district NDT qualifier';

update MasterTournaments
set DistrictQual = 1
where TourneyName = 'District 1 NDT Qualifier';

update MasterTournaments
set DistrictQual = 3
where TourneyName = 'District III NDT';

update MasterTournaments
set DistrictQual = 4
where TourneyName = 'District 4 Qualifier';

update MasterTournaments
set DistrictQual = 5
where TourneyName = 'District 5 NDT Qualifier';

update MasterTournaments
set DistrictQual = 6
where TourneyName = 'D6 NDT Qualifier and SEC/SE CEDA';
/*
update MasterTournaments
set DistrictQual = 7
where TourneyName = 'District VII-JV and Novice Tournament';
*/
update MasterTournaments
set DistrictQual = 7
where TourneyName = 'District VII-NDT Qualifying Tournament';

update MasterTournaments
set DistrictQual = 8
where TourneyName = 'District 8 NDT qualifier';

update MasterTournaments
set DistrictQual = 9
where TourneyName = 'District 9 NDT Qualifier';

select count(*) = 9
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