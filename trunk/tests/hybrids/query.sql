/* Does not count tournaments like Liberty, which disallow hybrids in outrounds */

select count(*) as 'Tournaments disallowing hybrids:'
from MasterTournaments 
where HybridsOK = 0;

select count(*) as 'Tournaments:'
from MasterTournaments;

select count(*) as 'Rounds at tournaments disallowing hybrids:'
from MasterResults, MasterTournaments
where Tournament = MasterTournaments.ID
and HybridsOK = 0;

select count(*) 'Rounds:'
from MasterResults;

select count(*) 'Ballots at tournaments disallowing hybrids:'
from Ballots, MasterResults, MasterTournaments
where MasterResultsID = MasterResults.ID
and Tournament = MasterTournaments.ID
and HybridsOK = 0;

select count(*) 'Ballots:'
from Ballots;

/* Does not coount three-person hybrid teams: */
/* Some data errors? WGA Binder/Shultz 07-08 */

create temporary table hybrids
select s1.CompetitorID as s1id, s1.FirstName as s1fn, s1.LastName as s1ln, s1.CompetitorSchool as s1u,
s2.CompetitorID as s2id, s2.FirstName as s2fn, s2.LastName as s2ln, s2.CompetitorSchool as s2u,
TeamNum, FullName
from TeamNumbers, 
MasterCompetitors as s1, 
MasterCompetitors as s2
where s1.CompetitorID = Speaker1
and s2.CompetitorID = Speaker2
and s1.CompetitorSchool != s2.CompetitorSchool;

create temporary table hteams
select TeamNum, FullName, 
s1fn, s1ln, u1.SchoolName as s1un, 
s2fn, s2ln, u2.SchoolName as s2un
from hybrids,
MasterSchools as u1,
MasterSchools as u2
where u1.SchoolID = s1u
and u2.SchoolID = s2u;

/*
select count(*) as 'Hybrid teams on debateresults.com:'
from hteams;

select count(*) as 'Total teams on debateresults.com:'
from TeamNumbers;
*/

select count(distinct TeamNum) as 'Hybrid teams that debated:'
from hteams, MasterResults
where TeamNum = AffTeam
OR TeamNum = NegTeam;

select count(distinct AffTeam) as 'Teams that debated:'
from MasterResults;

select count(distinct TeamNum) as 'Hybrid teams that debated in open:'
from hteams, MasterResults
where (TeamNum = AffTeam
OR TeamNum = NegTeam)
AND Diivision = 1;

select count(distinct AffTeam) as 'Teams that debated in open:'
from MasterResults
where Diivision = 1;
