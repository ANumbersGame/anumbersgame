/*
select TourneyName
from MasterTournaments
where instr(lower(TourneyName),'national debate tournament') != 0;
*/

create temporary table NdtTeams
select distinct AffTeam as Team, AffOne as Speaker1, AffTwo as Speaker2
from MasterResults, MasterTournaments
where Tournament = MasterTournaments.ID
and instr(lower(TourneyName),'national debate tournament') != 0;
/*
create temporary table NdtNames1
select Speaker1 as Nom
from NdtTeams;

create temporary table NdtNames2
select Speaker2 as Nom
from NdtTeams;

create temporary table NdtNames
select * from
(select * from NdtNames1 
union
select * from NdtNames2) as must;
*/

create temporary table NdtAffWins
select MasterResults.ID, Round, AffTeam, NegTeam, 
if(avg(JudgeDec) is null,null,if(avg(JudgeDec) < 1.5, 'WIN', 'LOSS')) as Affwin
from (MasterTournaments
inner join MasterResults
on (Tournament = MasterTournaments.ID
and instr(lower(TourneyName),'national debate tournament') != 0))
left join Ballots
on MasterResultsID = MasterResults.ID
group by MasterResultsID
order by Round;

/*
select * from NdtAffWins;
*/
/*
create temporary table BestAffLoss
select AffTeam as Team, max(Round) as BestLoss
from (select * 
from NdtAffWins 
where Round >= 10
and AffTeam != 0
and Affwin='LOSS') as must
group by Team;
*/
create temporary table BestAffLoss
select AffTeam as Team, max(Round) as BestLoss
from NdtAffWins 
where Round >= 10
and AffTeam != 0
and Affwin='LOSS'
group by Team;


create temporary table BestNegLoss
select NegTeam as Team, max(Round) as BestLoss
from NdtAffWins 
where Round >= 10
and NegTeam != 0
and (Affwin is null
or Affwin = 'WIN')
group by Team;

create temporary table BestLoss
select * from
(select * from BestAffLoss
union all 
select * from BestNegLoss) as must
order by BestLoss, Team;

/*
select * from BestLoss;
*/

drop temporary table BestAffLoss;
drop temporary table BestNegLoss;

create temporary table BestWin
select if(Affwin='LOSS',NegTeam,AffTeam) as Team, max(Round) as LastWin
from (select * 
from NdtAffWins 
where Round >= 10
and AffTeam != 0) as must
group by Team;

create temporary table TopWin
select max(LastWin) as TopWin
from BestWin;

create temporary table TopPair
select *
from BestWin, TopWin;

drop temporary table BestWin;
drop temporary table TopWin;

delete from TopPair
where LastWin != TopWin;

update TopPair
set LastWin = LastWin+1; 

create temporary table BestElim
select Team, BestLoss as BestElim from
(select * from BestLoss
union all
select Team, LastWin from TopPair) as must
order by BestElim;
/*
select * from BestElim;
/*
select * from TopPair;
select * from BestLoss;
*/

drop temporary table TopPair;
drop temporary table BestLoss;

/*
create temporary table BestNegLoss
select NegTeam as Team, max(Round) as LastWin
from (select * 
from NdtAffWins 
where Round >= 10
and NegTeam != 0) as must
where Affwin is null
or Affwin = 'WIN'
group by Team;

create temporary table 

create temporary table BestAffWin
select AffTeam as Team, max(Round) as LastWin
from (select * 
from NdtAffWins 
where Round >= 10) as must
where (NegTeam = 0 and Affwin is null)
or Affwin = 'WIN'
group by Team;

create temporary table BestAffAppear
select AffTeam as Team, max(Round) as LastWin
from (select * 
from NdtAffWins 
where Round >= 10) as must
group by Team;
*/
/*
select * from BestAffWin;
*/
/*
create temporary table BestNegWin
select NegTeam as Team, max(Round) as LastWin
from (select * 
from NdtAffWins 
where Round >= 10) as must
where (AffTeam = 0 and Affwin is null)
or Affwin = 'LOSE'
group by Team;

create temporary table BestNegAppear
select NegTeam as Team, max(Round) as LastWin
from (select * 
from NdtAffWins 
where Round >= 10) as must
group by Team;

create temporary table Champ
select 
*/
/*
create temporary table BestWin
select Team, max(LastWin) as FinalRound
from (select *
from BestAffWin
union
select *
from BestNegWin) as must
group by Team;
*/
create temporary table AnyElimWin
select NdtTeams.Team as Team, 
if(BestElim is null, 9, BestElim) as ElimWin
from NdtTeams
left join BestElim
on NdtTeams.Team = BestElim.Team;
/*
select count(*) from AnyElimWin;
*/
/*show columns from TeamNumbers;*/
/*
select Acronym, NdtTeams.Team, ElimWin
from NdtTeams, AnyElimWin, TeamNumbers
where NdtTeams.Team = AnyElimWin.Team
and NdtTeams.Team = TeamNum
order by ElimWin;

/*
select * 
from AnyElimWin
order by ElimWin;
*/
create temporary table AffWins
select AffTeam as Team, count(*) as Wins
from NdtAffWins
where Round < 10
and Affwin = 'WIN'
group by AffTeam;

create temporary table NegWins
select NegTeam as Team, count(*) as Wins
from NdtAffWins
where Round < 10
and Affwin = 'LOSS'
group by NegTeam;

create temporary table AllWins
select NdtTeams.Team, if(sum(Wins) is null, 0, sum(Wins)) as TotalWins
from NdtTeams
left join
(select *
from AffWins
union all
select *
from NegWins) 
as must
on NdtTeams.Team = must.Team
group by Team;
/*
select * from AllWins;

select count(*) from AllWins;
*/
/*
select *
from AllWins
order by TotalWins;
*/
/*
select Acronym, NdtTeams.Team, ElimWin, TotalWins
from NdtTeams, AnyElimWin, TeamNumbers, AllWins
where NdtTeams.Team = AnyElimWin.Team
and NdtTeams.Team = AllWins.Team
and NdtTeams.Team = TeamNum
order by ElimWin, TotalWins;
*/
create temporary table AffBallots
select AffTeam as Team, count(*) as Ballots
from NdtAffWins, Ballots
where Round < 10
and ID = MasterResultsID
and JudgeDec = 1
group by Team;

create temporary table NegBallots
select NegTeam as Team, count(*) as Ballots
from NdtAffWins, Ballots
where Round < 10
and ID = MasterResultsID
and JudgeDec = 2
group by Team;

create temporary table AllBallots
select NdtTeams.Team, if(sum(Ballots) is null, 0, sum(Ballots)) as TotalBallots
from NdtTeams
left join
(select *
from AffBallots
union all
select *
from NegBallots) as must
on NdtTeams.Team = must.Team
group by Team;
/*
select Acronym, NdtTeams.Team, ElimWin, TotalWins, TotalBallots
from NdtTeams, AnyElimWin, TeamNumbers, AllWins, AllBallots
where NdtTeams.Team = AnyElimWin.Team
and NdtTeams.Team = AllWins.Team
and NdtTeams.Team = AllBallots.Team
and NdtTeams.Team = TeamNum
order by ElimWin, TotalWins, TotalBallots;
*/

/*
select *
from AllBallots
order by TotalBallots;
*/
create temporary table SpeaksAff
select AffTeam as Team, Round, Judge, PointsAff1+PointsAff2 as Points
from MasterTournaments, MasterResults, Ballots
where Round < 10
and MasterResults.ID = MasterResultsID
and Tournament = MasterTournaments.ID
and instr(lower(TourneyName),'national debate tournament') != 0;

create temporary table SpeaksNeg
select NegTeam as Team, Round, Judge, PointsNeg1+PointsNeg2 as Points
from MasterTournaments, MasterResults, Ballots
where Round < 10
and MasterResults.ID = MasterResultsID
and Tournament = MasterTournaments.ID
and instr(lower(TourneyName),'national debate tournament') != 0;

create temporary table AllSpeaks
select Team, Points, count(*) as Many
from 
(select * from SpeaksAff
union all select * from SpeaksNeg)
as must
group by Team, Points
order by Points, Many, Team;

/*
select Team, sum(Many) = 24
from AllSpeaks
group by Team;
*/

create temporary table MinSpeaks
select Team, min(Points) as MinSpeaks
from AllSpeaks
group by Team
order by MinSpeaks;

create temporary table MinPair
select AllSpeaks.Team as Team, Points, Many, MinSpeaks
from AllSpeaks, MinSpeaks
where AllSpeaks.Team = MinSpeaks.Team;

drop temporary table MinSpeaks;
drop temporary table AllSpeaks;

update MinPair
set Many = Many-1
where Points = MinSpeaks;

delete from MinPair
where Many = 0;

create temporary table MaxSpeaks
select Team, max(Points) as MaxSpeaks
from MinPair
group by Team
order by MaxSpeaks;

create temporary table MaxPair
select MinPair.Team as Team, Points, Many, MaxSpeaks
from MinPair, MaxSpeaks
where MinPair.Team = MaxSpeaks.Team;

drop temporary table MaxSpeaks;
drop temporary table MinPair;

update MaxPair
set Many = Many-1
where Points = MaxSpeaks;

delete from MaxPair
where Many = 0;
/*
select Team, sum(Many) = 22
from MaxPair
group by Team;
*/

create temporary table Drop1Speaks
select Team, sum(Points*Many) as Drop1Speaks
from MaxPair
group by Team
order by Drop1Speaks;
/*
select * from Drop1Speaks;

select count(*) from Drop1Speaks;
*/
/*
select Acronym, NdtTeams.Team, ElimWin, TotalWins, TotalBallots, Drop1Speaks
from NdtTeams, AnyElimWin, TeamNumbers, AllWins, AllBallots, Drop1Speaks
where NdtTeams.Team = AnyElimWin.Team
and NdtTeams.Team = AllWins.Team
and NdtTeams.Team = AllBallots.Team
and NdtTeams.Team = Drop1Speaks.Team
and NdtTeams.Team = TeamNum
order by ElimWin, TotalWins, TotalBallots, Drop1Speaks;
*/
-- -----------------------------------------------------------------

create temporary table MinSpeaks
select Team, min(Points) as MinSpeaks
from MaxPair
group by Team
order by MinSpeaks;

create temporary table MinPair
select MaxPair.Team as Team, Points, Many, MinSpeaks
from MaxPair, MinSpeaks
where MaxPair.Team = MinSpeaks.Team;

drop temporary table MinSpeaks;
drop temporary table MaxPair;

update MinPair
set Many = Many-1
where Points = MinSpeaks;

delete from MinPair
where Many = 0;

create temporary table MaxSpeaks
select Team, max(Points) as MaxSpeaks
from MinPair
group by Team
order by MaxSpeaks;

create temporary table MaxPair
select MinPair.Team as Team, Points, Many, MaxSpeaks
from MinPair, MaxSpeaks
where MinPair.Team = MaxSpeaks.Team;

drop temporary table MinPair;
drop temporary table MaxSpeaks;

update MaxPair
set Many = Many-1
where Points = MaxSpeaks;

delete from MaxPair
where Many = 0;
/*
select Team, sum(Many) = 20
from MaxPair
group by Team;
*/
create temporary table Drop2Speaks
select Team, sum(Points*Many) as Drop2Speaks
from MaxPair
group by Team
order by Drop2Speaks;
/*
select * from Drop2Speaks;

select count(*) from Drop2Speaks;
*/
-- -----------------------------------------------------------------

create temporary table MinSpeaks
select Team, min(Points) as MinSpeaks
from MaxPair
group by Team
order by MinSpeaks;

create temporary table MinPair
select MaxPair.Team as Team, Points, Many, MinSpeaks
from MaxPair, MinSpeaks
where MaxPair.Team = MinSpeaks.Team;

drop temporary table MinSpeaks;
drop temporary table MaxPair;

update MinPair
set Many = Many-1
where Points = MinSpeaks;

delete from MinPair
where Many = 0;

create temporary table MaxSpeaks
select Team, max(Points) as MaxSpeaks
from MinPair
group by Team
order by MaxSpeaks;

create temporary table MaxPair
select MinPair.Team as Team, Points, Many, MaxSpeaks
from MinPair, MaxSpeaks
where MinPair.Team = MaxSpeaks.Team;

drop temporary table MinPair;
drop temporary table MaxSpeaks;

update MaxPair
set Many = Many-1
where Points = MaxSpeaks;

delete from MaxPair
where Many = 0;
/*
select Team, sum(Many) = 18
from MaxPair
group by Team;
*/
create temporary table Drop3Speaks
select Team, sum(Points*Many) as Drop3Speaks
from MaxPair
group by Team
order by Drop3Speaks;
/*
select * from Drop3Speaks;

select count(*) from Drop3Speaks;
*/
-- -----------------------------------------------------------------

create temporary table MinSpeaks
select Team, min(Points) as MinSpeaks
from MaxPair
group by Team
order by MinSpeaks;

create temporary table MinPair
select MaxPair.Team as Team, Points, Many, MinSpeaks
from MaxPair, MinSpeaks
where MaxPair.Team = MinSpeaks.Team;

drop temporary table MinSpeaks;
drop temporary table MaxPair;

update MinPair
set Many = Many-1
where Points = MinSpeaks;

delete from MinPair
where Many = 0;

create temporary table MaxSpeaks
select Team, max(Points) as MaxSpeaks
from MinPair
group by Team
order by MaxSpeaks;

create temporary table MaxPair
select MinPair.Team as Team, Points, Many, MaxSpeaks
from MinPair, MaxSpeaks
where MinPair.Team = MaxSpeaks.Team;

drop temporary table MinPair;
drop temporary table MaxSpeaks;

update MaxPair
set Many = Many-1
where Points = MaxSpeaks;

delete from MaxPair
where Many = 0;
/*
select Team, sum(Many) = 16
from MaxPair
group by Team;
*/
create temporary table Drop4Speaks
select Team, sum(Points*Many) as Drop4Speaks
from MaxPair
group by Team
order by Drop4Speaks;
/*
select * from Drop4Speaks;

select count(*) from Drop4Speaks;
*/
-- -----------------------------------------------------------------

create temporary table MinSpeaks
select Team, min(Points) as MinSpeaks
from MaxPair
group by Team
order by MinSpeaks;

create temporary table MinPair
select MaxPair.Team as Team, Points, Many, MinSpeaks
from MaxPair, MinSpeaks
where MaxPair.Team = MinSpeaks.Team;

drop temporary table MinSpeaks;
drop temporary table MaxPair;

update MinPair
set Many = Many-1
where Points = MinSpeaks;

delete from MinPair
where Many = 0;

create temporary table MaxSpeaks
select Team, max(Points) as MaxSpeaks
from MinPair
group by Team
order by MaxSpeaks;

create temporary table MaxPair
select MinPair.Team as Team, Points, Many, MaxSpeaks
from MinPair, MaxSpeaks
where MinPair.Team = MaxSpeaks.Team;

drop temporary table MinPair;
drop temporary table MaxSpeaks;

update MaxPair
set Many = Many-1
where Points = MaxSpeaks;

delete from MaxPair
where Many = 0;
/*
select Team, sum(Many) = 14
from MaxPair
group by Team;
*/
create temporary table Drop5Speaks
select Team, sum(Points*Many) as Drop5Speaks
from MaxPair
group by Team
order by Drop5Speaks;
/*
select * from Drop5Speaks;

select count(*) from Drop5Speaks;
*/
-- -----------------------------------------------------------------

create temporary table MinSpeaks
select Team, min(Points) as MinSpeaks
from MaxPair
group by Team
order by MinSpeaks;

create temporary table MinPair
select MaxPair.Team as Team, Points, Many, MinSpeaks
from MaxPair, MinSpeaks
where MaxPair.Team = MinSpeaks.Team;

drop temporary table MinSpeaks;
drop temporary table MaxPair;

update MinPair
set Many = Many-1
where Points = MinSpeaks;

delete from MinPair
where Many = 0;

create temporary table MaxSpeaks
select Team, max(Points) as MaxSpeaks
from MinPair
group by Team
order by MaxSpeaks;

create temporary table MaxPair
select MinPair.Team as Team, Points, Many, MaxSpeaks
from MinPair, MaxSpeaks
where MinPair.Team = MaxSpeaks.Team;

drop temporary table MinPair;
drop temporary table MaxSpeaks;

update MaxPair
set Many = Many-1
where Points = MaxSpeaks;

delete from MaxPair
where Many = 0;
/*
select Team, sum(Many) = 20
from MaxPair
group by Team;
*/
create temporary table Drop6Speaks
select Team, sum(Points*Many) as Drop6Speaks
from MaxPair
group by Team
order by Drop6Speaks;

create temporary table NdtOrder
select Acronym, NdtTeams.Team, ElimWin, TotalWins, TotalBallots,
Drop1Speaks, Drop2Speaks, Drop3Speaks, Drop4Speaks, Drop5Speaks, Drop6Speaks
from NdtTeams, AnyElimWin, TeamNumbers, AllWins, AllBallots, 
Drop1Speaks, Drop2Speaks, Drop3Speaks, Drop4Speaks, Drop5Speaks, Drop6Speaks
where NdtTeams.Team = AnyElimWin.Team
and NdtTeams.Team = AllWins.Team
and NdtTeams.Team = AllBallots.Team
and NdtTeams.Team = Drop1Speaks.Team
and NdtTeams.Team = Drop2Speaks.Team
and NdtTeams.Team = Drop3Speaks.Team
and NdtTeams.Team = Drop4Speaks.Team
and NdtTeams.Team = Drop5Speaks.Team
and NdtTeams.Team = Drop6Speaks.Team
and NdtTeams.Team = TeamNum
order by ElimWin, TotalWins, TotalBallots, 
Drop1Speaks, Drop2Speaks, Drop3Speaks, Drop4Speaks, Drop5Speaks, Drop6Speaks;


/*
select * from Drop6Speaks;

select count(*) from Drop6Speaks;
*/


/*
create temporary table MinSpeaks3
select Team, min(Points) as MinSpeaks
from MaxPair2
group by Team
order by MinSpeaks;

create temporary table MinPair3
select MaxPair2.Team as Team, Points, Many, MinSpeaks
from MaxPair2, MinSpeaks3
where MaxPair2.Team = MinSpeaks3.Team;

drop temporary table MinSpeaks3;
drop temporary table MaxPair2;

update MinPair3
set Many = Many-1
where Points = MinSpeaks;

delete from MinPair3
where Many = 0;

create temporary table MaxSpeaks3
select Team, max(Points) as MaxSpeaks
from MinPair3
group by Team
order by MaxSpeaks;

create temporary table MaxPair3
select MinPair3.Team as Team, Points, Many, MaxSpeaks
from MinPair3, MaxSpeaks3
where MinPair3.Team = MaxSpeaks3.Team;

drop temporary table MinPair3;
drop temporary table MaxSpeaks3;

update MaxPair3
set Many = Many-1
where Points = MaxSpeaks;

delete from MaxPair3
where Many = 0;
/*
select Team, sum(Many) = 18
from MaxPair3
group by Team;
*/
/*
create temporary table Drop3Speaks
select Team, sum(Points*Many) as Drop3Speaks
from MaxPair3
group by Team
order by Drop3Speaks;

------------------------------------------------------------------

create temporary table MinSpeaks4
select Team, min(Points) as MinSpeaks
from MaxPair3
group by Team
order by MinSpeaks;

create temporary table MinPair4
select MaxPair3.Team as Team, Points, Many, MinSpeaks
from MaxPair3, MinSpeaks4
where MaxPair3.Team = MinSpeaks4.Team;

drop temporary table MinSpeaks4;
drop temporary table MaxPair3;

update MinPair4
set Many = Many-1
where Points = MinSpeaks;

delete from MinPair4
where Many = 0;

create temporary table MaxSpeaks4
select Team, max(Points) as MaxSpeaks
from MinPair4
group by Team
order by MaxSpeaks;

create temporary table MaxPair4
select MinPair4.Team as Team, Points, Many, MaxSpeaks
from MinPair4, MaxSpeaks4
where MinPair4.Team = MaxSpeaks4.Team;

drop temporary table MinPair4;
drop temporary table MaxSpeaks4;

update MaxPair3
set Many = Many-1
where Points = MaxSpeaks;

delete from MaxPair3
where Many = 0;
/*
select Team, sum(Many) = 18
from MaxPair3
group by Team;
*/
/*
create temporary table Drop3Speaks
select Team, sum(Points*Many) as Drop3Speaks
from MaxPair3
group by Team
order by Drop3Speaks;

/*

create temporary table Drop1Speaks
select *
from AllSpeaks;

update Drop1Speaks
set Many = Many-1
where 

create temporary table MaxSpeaks
select Speaker, min(Points) as MaxSpeaks
from AllSpeaks
group by Speaker
order by MaxSpeaks;
*/

/*
select Team, sum(Points) as TotalSpeaks
from AllSpeaks
group by Team
order by TotalSpeaks;
*/
/*
create temporary table AllSpeaks
select Speaker, Points, count(*) as Many
from AllSpeaks
group by Speaker, Points;

select

create temporary table TeamDrop1Speaks
select Team, sum(Drop1Speaks) as TeamDrop1Speaks
from NdtTeams, TeamNumbers, Drop1Speaks
where TeamNum = Team
and (Speaker1 = Speaker
or Speaker2 = Speaker)
group by Team
order by TeamDrop1Speaks;

select * from TeamDrop1Speaks;

create temporary table Drop2Speaks
select Speaker, sum(Points) - min(Points) - max(Points) as Drop1Speaks
from AllSpeaks
group by Speaker
order by Drop1Speaks;
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
/*
select count(*) from NdtTeams;

select count(*) from NdtOrder;
*/
select CedaTeams.AffTeam is null as ''
from NdtOrder
left join CedaTeams
on NdtOrder.Team = CedaTeams.AffTeam;