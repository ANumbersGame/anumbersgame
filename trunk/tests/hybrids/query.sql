/* Does not count tournaments like Liberty, which disallow hybrids in outrounds */

/* Some data errors? WGA Binder/Shultz 07-08 */

create temporary table hybridteams
(select FullName, TeamNum, 
s1.CompetitorID as s1id, s1.CompetitorSchool as s1u,
s2.CompetitorID as s2id, s2.CompetitorSchool as s2u,
0 as s3id, 0 as s3u
from TeamNumbers inner join
MasterCompetitors as s1 inner join
MasterCompetitors as s2 inner join
MasterCompetitors as s3
on s1.CompetitorID = Speaker1
and s2.CompetitorID = Speaker2
and 0 = Speaker3
and s1.CompetitorSchool != s2.CompetitorSchool)
union
(select FullName, TeamNum,
s1.CompetitorID as s1id, s1.CompetitorSchool as s1u,
s2.CompetitorID as s2id, s2.CompetitorSchool as s2u,
s3.CompetitorID as s3id, s3.CompetitorSchool as s3u
from TeamNumbers inner join
MasterCompetitors as s1 inner join
MasterCompetitors as s2 inner join
MasterCompetitors as s3
on s1.CompetitorID = Speaker1
and s2.CompetitorID = Speaker2
and s3.CompetitorID = Speaker3
and 
(s1.CompetitorSchool != s2.CompetitorSchool
or s2.CompetitorSchool != s3.CompetitorSchool
and s3.CompetitorSchool != s1.CompetitorSchool));

/*
select * 
from hybridteams
order by TeamNum, s1id,s2id;
*/
/*
select count(*) as 'Hybrid teams on debateresults.com:'
from hybridteams;

select count(*) as 'Total teams on debateresults.com:'
from TeamNumbers;
*/
create temporary table hybriddebateteams
select distinct TeamNum, FullName, s1id, s1u, s2id, s2u, s3id, s3u
from hybridteams, MasterResults
where TeamNum = AffTeam
or TeamNum = NegTeam;

select count(distinct TeamNum) as 'Hybrid teams that debated:'
from hybriddebateteams;

create temporary table debateteams
select distinct AffTeam, Speaker1, Speaker2, Speaker3
from (MasterResults INNER JOIN TeamNumbers 
on AffTeam = TeamNum);

select count(distinct AffTeam) as 'Teams that debated:'
from debateteams;

create temporary table hybridcompetitor1
select s1id as sid, s1u as univ, TeamNum as tnum
from hybridteams;

create temporary table hybridcompetitor2
select s2id, s2u, TeamNum
from hybridteams;

create temporary table hybridcompetitor3
select s3id, s3u, TeamNum
from hybridteams
where s3id != 0;

create temporary table hybridcompetitors
select * from
(select * from hybridcompetitor1
union all
select * from hybridcompetitor2
union all
select * from hybridcompetitor3) as must;
/*
select count(distinct sid) as 'Hybrid competitors on debateresults.com:'
from hybridcompetitors;

select count(*) as 'Competitors on debateresults.com:'
from MasterCompetitors;
*/
/*
create temporary table hteams
select TeamNum, FullName, 
s1fn, s1ln, u1.SchoolName as s1un, 
s2fn, s2ln, u2.SchoolName as s2un
from hybrids,
MasterSchools as u1,
MasterSchools as u2
where u1.SchoolID = s1u
and u2.SchoolID = s2u;
*/

/*
*/


create temporary table hybriddebaters
select distinct sid
from hybridcompetitors, hybriddebateteams
where tnum = TeamNum;

select count(distinct sid) as 'Competitors that debated at least once on a hybrid team:'
from hybriddebaters;

create temporary table debaters
select distinct CompetitorID
from MasterCompetitors, debateteams
where 
(Speaker1 = CompetitorID
or Speaker2 = CompetitorID
or Speaker3 = CompetitorID); 

select count(distinct CompetitorID) as 'Competitors that debated:'
from debaters;

create temporary table somenonhybrid2
select distinct sid
from hybriddebaters, debateteams, 
MasterCompetitors as s1,
MasterCompetitors as s2
where
(Speaker1 = sid
or Speaker2 = sid)
and Speaker1 = s1.CompetitorID
and Speaker2 = s2.CompetitorID
and Speaker3 = 0
and s1.CompetitorSchool = s2.CompetitorSchool;

create temporary table somenonhybrid3
select distinct sid
from hybriddebaters, debateteams, 
MasterCompetitors as s1,
MasterCompetitors as s2,
MasterCompetitors as s3
where
(Speaker1 = sid
or Speaker2 = sid
or Speaker3 = sid)
and Speaker1 = s1.CompetitorID
and Speaker2 = s2.CompetitorID
and Speaker3 = s3.CompetitorID
and s1.CompetitorSchool = s2.CompetitorSchool
and s2.CompetitorSchool = s3.CompetitorSchool;

create temporary table somenonhybrid
select * from somenonhybrid2 
union 
select * from somenonhybrid3;

select count(distinct sid) as 'Hybrid competitors that debated on some non-hybrid team:'
from somenonhybrid;

create temporary table hybridonlys1
select s1id as spid
from hybriddebateteams
left join
somenonhybrid
on s1id = sid
where sid is null;

create temporary table hybridonlys2
select s2id as spid
from hybriddebateteams
left join
somenonhybrid
on s2id = sid
where sid is null;

create temporary table hybridonlys3
select s3id as spid
from hybriddebateteams
left join
somenonhybrid
on s3id = sid
where sid is null;

create temporary table hybridonly2p
select TeamNum
from hybriddebateteams, 
hybridonlys1 as s1,
hybridonlys2 as s2
where s1.spid = s1id
and s2.spid = s2id
and 0 = s3id;

create temporary table hybridonly3p
select TeamNum
from hybriddebateteams, 
hybridonlys1 as s1,
hybridonlys2 as s2,
hybridonlys3 as s3
where s1.spid = s1id
and s2.spid = s2id
and s3.spid = s3id;

create temporary table hybridonlyteams
select distinct TeamNum from
(select * from hybridonly2p
union
select * from hybridonly3p) as must;

select count(*) as 'Teams with two competitors who only debated on hybrid teams:'
from hybridonlyteams;


create temporary table nonhybridonlys1
select s1id as spid
from hybriddebateteams, somenonhybrid
where s1id = sid;

create temporary table nonhybridonlys2
select s2id as spid
from hybriddebateteams,
somenonhybrid
where s2id = sid;

create temporary table nonhybridonlys3
select s3id as spid
from hybriddebateteams
, somenonhybrid
where s3id = sid;

create temporary table nonhybridonly2p
select TeamNum
from hybriddebateteams, 
nonhybridonlys1 as s1,
nonhybridonlys2 as s2
where s1.spid = s1id
and s2.spid = s2id
and 0 = s3id;

create temporary table nonhybridonly3p
select TeamNum
from hybriddebateteams, 
nonhybridonlys1 as s1,
nonhybridonlys2 as s2,
nonhybridonlys3 as s3
where s1.spid = s1id
and s2.spid = s2id
and s3.spid = s3id;

create temporary table nonhybridonlyteams
select distinct TeamNum from
(select * from nonhybridonly2p
union
select * from nonhybridonly3p) as must;

select count(*) as 'Teams with two competitors each of whom debated at least once on non-hybrid teams:'
from nonhybridonlyteams;

create temporary table hybrid_open
select distinct TeamNum
from hybriddebateteams, MasterResults
where TeamNum = AffTeam
and Diivision = 1;
/*
select count(*) as 'Hybrid teams that debated in open at least once:'
from hybrid_open;
*/
create temporary table hybrid_jv
select distinct TeamNum
from hybriddebateteams, MasterResults
where TeamNum = AffTeam
and Diivision = 2;
/*
select count(*) as 'Hybrid teams that debated in JV at least once:'
from hybrid_jv;
*/
create temporary table hybrid_nov
select distinct TeamNum
from hybriddebateteams, MasterResults
where TeamNum = AffTeam
and (Diivision = 3
or Diivision = 4);
/*
select count(*) as 'Hybrid teams that debated in novice or rookie at least once:'
from hybrid_nov;
*/
create temporary table hybrid_openjv
select distinct hybrid_open.TeamNum as TeamNum
from hybrid_open, hybrid_jv
where hybrid_open.TeamNum = hybrid_jv.TeamNum;

create temporary table hybrid_opennov
select distinct hybrid_open.TeamNum as TeamNum
from hybrid_open, hybrid_nov
where hybrid_open.TeamNum = hybrid_nov.TeamNum;

create temporary table hybrid_novjv
select distinct hybrid_jv.TeamNum as TeamNum
from hybrid_jv, hybrid_nov
where hybrid_jv.TeamNum = hybrid_nov.TeamNum;

create temporary table hybridall
select distinct hybrid_nov.TeamNum as TeamNum
from hybrid_jv, hybrid_nov, hybrid_open
where hybrid_jv.TeamNum = hybrid_nov.TeamNum
and hybrid_nov.TeamNum = hybrid_open.TeamNum;

select count(*) as 'Hybrid teams that debated in each of open, JV, and novice or rookie at least once:'
from hybridall;

create temporary table hybrid_openjvonly
select distinct hybrid_openjv.TeamNum as TeamNum
from hybrid_openjv 
left join hybridall
on hybrid_openjv.TeamNum = hybridall.TeamNum
where hybridall.TeamNum is null;

select count(*) as 'Hybrid teams that debated in both open and JV at least once, but never in novice or rookie:'
from hybrid_openjvonly;

create temporary table hybrid_opennovonly
select distinct hybrid_opennov.TeamNum as TeamNum
from hybrid_opennov 
left join hybridall
on hybrid_opennov.TeamNum = hybridall.TeamNum
where hybridall.TeamNum is null;

select count(*) as 'Hybrid teams that debated in both novice (or rookie) and open at least once, but never in JV:'
from hybrid_opennovonly;

create temporary table hybrid_novjvonly
select distinct hybrid_novjv.TeamNum as TeamNum
from hybrid_novjv 
left join hybridall
on hybrid_novjv.TeamNum = hybridall.TeamNum
where hybridall.TeamNum is null;

select count(*) as 'Hybrid teams that debated in both novice and JV at least once, but never in open:'
from hybrid_novjvonly;

create temporary table hybrid_openmul
select * from hybrid_openjv
union
select * from hybrid_opennov;

create temporary table hybrid_openonly
select distinct hybrid_open.TeamNum as TeamNum
from hybrid_open 
left join hybrid_openmul
on hybrid_open.TeamNum = hybrid_openmul.TeamNum
where hybrid_openmul.TeamNum is null;

select count(*) as 'Hybrid teams that debated only in open rounds:'
from hybrid_openonly;

create temporary table hybrid_jvmul
select * from hybrid_openjv
union
select * from hybrid_novjv;

create temporary table hybrid_jvonly
select distinct hybrid_jv.TeamNum as TeamNum
from hybrid_jv 
left join hybrid_jvmul
on hybrid_jv.TeamNum = hybrid_jvmul.TeamNum
where hybrid_jvmul.TeamNum is null;

select count(*) as 'Hybrid teams that debated only in JV rounds:'
from hybrid_jvonly;


create temporary table hybrid_novmul
select * from hybrid_opennov
union
select * from hybrid_novjv;

create temporary table hybrid_novonly
select distinct hybrid_nov.TeamNum as TeamNum
from hybrid_nov 
left join hybrid_novmul
on hybrid_nov.TeamNum = hybrid_novmul.TeamNum
where hybrid_novmul.TeamNum is null;

select count(*) as 'Hybrid teams that debated only in novice rounds:'
from hybrid_novonly;

/*
###################################################################################################
*/

create temporary table total_open
select distinct debateteams.AffTeam
from debateteams, MasterResults
where debateteams.AffTeam = MasterResults.AffTeam
and Diivision = 1;
/*
select count(*) as 'Teams that debated in open at least once:'
from total_open;
*/
create temporary table total_jv
select distinct debateteams.AffTeam
from debateteams, MasterResults
where debateteams.AffTeam = MasterResults.AffTeam
and Diivision = 2;
/*
select count(*) as 'Teams that debated in JV at least once:'
from total_jv;
*/
create temporary table total_nov
select distinct debateteams.AffTeam
from debateteams, MasterResults
where debateteams.AffTeam = MasterResults.AffTeam
and (Diivision = 3
or Diivision = 4);
/*
select count(*) as 'Teams that debated in novice or rookie at least once:'
from total_nov;
*/
create temporary table total_openjv
select distinct total_open.AffTeam as AffTeam
from total_open, total_jv
where total_open.AffTeam = total_jv.AffTeam;

create temporary table total_opennov
select distinct total_open.AffTeam as AffTeam
from total_open, total_nov
where total_open.AffTeam = total_nov.AffTeam;

create temporary table total_novjv
select distinct total_jv.AffTeam as AffTeam
from total_jv, total_nov
where total_jv.AffTeam = total_nov.AffTeam;

create temporary table total_all
select distinct total_nov.AffTeam as AffTeam
from total_jv, total_nov, total_open
where total_jv.AffTeam = total_nov.AffTeam
and total_nov.AffTeam = total_open.AffTeam;

select count(*) as 'Teams that debated in each of open, JV, and novice or rookie at least once:'
from total_all;

create temporary table total_openjvonly
select distinct total_openjv.AffTeam as AffTeam
from total_openjv 
left join total_all
on total_openjv.AffTeam = total_all.AffTeam
where total_all.AffTeam is null;

select count(*) as 'Teams that debated in both open and JV at least once, but never in novice or rookie:'
from total_openjvonly;

create temporary table total_opennovonly
select distinct total_opennov.AffTeam as AffTeam
from total_opennov 
left join total_all
on total_opennov.AffTeam = total_all.AffTeam
where total_all.AffTeam is null;

select count(*) as 'Teams that debated in both novice (or rookie) and open at least once, but never in JV:'
from total_opennovonly;

create temporary table total_novjvonly
select distinct total_novjv.AffTeam as AffTeam
from total_novjv 
left join total_all
on total_novjv.AffTeam = total_all.AffTeam
where total_all.AffTeam is null;

select count(*) as 'Teams that debated in both novice and JV at least once, but never in open:'
from total_novjvonly;

create temporary table total_openmul
select * from total_openjv
union
select * from total_opennov;

create temporary table total_openonly
select distinct total_open.AffTeam as AffTeam
from total_open 
left join total_openmul
on total_open.AffTeam = total_openmul.AffTeam
where total_openmul.AffTeam is null;

select count(*) as 'Teams that debated only in open rounds:'
from total_openonly;

create temporary table total_jvmul
select * from total_openjv
union
select * from total_novjv;

create temporary table total_jvonly
select distinct total_jv.AffTeam as AffTeam
from total_jv 
left join total_jvmul
on total_jv.AffTeam = total_jvmul.AffTeam
where total_jvmul.AffTeam is null;

select count(*) as 'Teams that debated only in JV rounds:'
from total_jvonly;


create temporary table total_novmul
select * from total_opennov
union
select * from total_novjv;

create temporary table total_novonly
select distinct total_nov.AffTeam as AffTeam
from total_nov 
left join total_novmul
on total_nov.AffTeam = total_novmul.AffTeam
where total_novmul.AffTeam is null;

select count(*) as 'Teams that debated only in novice rounds:'
from total_novonly;


/*

how many hybrid debaters did it for n years? how many hybrid-only debaters? did debaters become hybrid-only over the course of their careers?

Hybrid teams debating at non-hybrid tournaments

how many hybrid-only members on each team?

how many hybrid teams in each division?

how many no-hybrids tournaments actually had rounds?

how many hybrids-allowed tournaments actually had hybrids?

*/

/*
select count(distinct CompetitorID) as 'Debaters on hybrid teams:'
from hdebateteams, MasterCompetitors
where CompetitorID = s1id
or CompetitorID = s2id;


select count(distinct TeamNum) as 'Hybrid teams that debated in open:'
from hteams, MasterResults
where (TeamNum = AffTeam
OR TeamNum = NegTeam)
AND Diivision = 1;

select count(distinct AffTeam) as 'Teams that debated in open:'
from MasterResults
where Diivision = 1;
*/

create temporary table enteredtourneys
select MasterTournaments.ID as etid, HybridsOK, TeamNum, FullName
from 
MasterTournaments 
inner join 
(
MasterResults
left join 
hybriddebateteams on AffTeam = TeamNum)
on (Tournament = MasterTournaments.ID)
group by etid, TeamNum is null;

/*select * from enteredtourneys;*/

select count(*) as 'Tournaments disallowing hybrids:'
from enteredtourneys 
where HybridsOK = 0
and TeamNum is null;

select count(*) as 'Tournaments only nominally disallowing hybrids:'
from enteredtourneys 
where HybridsOK = 0
and TeamNum is not null;

select count(*) as 'Tournaments allowing hybrids with hybrid entries:'
from enteredtourneys
where HybridsOK = 1
and TeamNum is not null;

select count(*) as 'Tournaments allowing hybrids with no hybrid entries:'
from enteredtourneys
where HybridsOK = 1
and TeamNum is null;

/*
select count(*) as 'Tournaments:'
from enteredtourneys;
*/
/*
select count(*) as 'Rounds at tournaments disallowing hybrids:'
from 
(MasterResults inner join MasterTournaments
on Tournament = MasterTournaments.ID
and HybridsOK = 0);

select count(*) 'Rounds:'
from MasterResults;
*/

select count(*) 'Ballots at tournaments disallowing hybrids:'
from Ballots, MasterResults, enteredtourneys
where MasterResultsID = MasterResults.ID
and Tournament = etid
and HybridsOK = 0
and TeamNum is null;

select count(*) 'Ballots at tournaments only nominally disallowing hybrids:'
from Ballots, MasterResults, enteredtourneys
where MasterResultsID = MasterResults.ID
and Tournament = etid
and HybridsOK = 0
and TeamNum is not null;

select count(*) 'Ballots at tournaments allowing hybrids with hybrid entries:'
from Ballots, MasterResults, enteredtourneys
where MasterResultsID = MasterResults.ID
and Tournament = etid
and HybridsOK = 1
and TeamNum is not null;

select count(*) 'Ballots at tournaments nominally allowing hybrids, but with no hybrid entries:'
from Ballots, MasterResults, enteredtourneys
where MasterResultsID = MasterResults.ID
and Tournament = etid
and HybridsOK = 1
and TeamNum is null;

/*
select count(*) 'Ballots:'
from Ballots;
*/
