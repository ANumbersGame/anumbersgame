<?php

require_once('../../../protected/config.php');

require_once (config::servroot()."/protected/smarty/template.php");
$template = new template();

require_once (config::servroot()."/protected/db/dbview.php");
$dbh = new dbview();

// Find the tournament specified by the URL
$sres = $dbh->get('select count(*) as many
from tournaments
where id = :id
and year = :year
and aka = :aka',
array(':id' => $_GET['id'],
      ':aka' => $_GET['aka'],
      ':year' => $_GET['year']));

if (0 == $sres[0]['many']) {

  error_log("Can't find series: aka: {$_GET['aka']}, id: {$_GET['id']}, year: {$_GET['year']}");

  // Find all tournaments with a given aka
  $akaAll = 'select 
tournaments.name as name, 
tournaments.year, 
tournaments.id, 
start,
host,
schools.name as sname
from tournaments
left join schools
on host = schools.id
and tournaments.year = schools.year
where tournaments.aka = :aka
order by start desc, tournaments.name';

  // All tournaments witht eh aka given by the URL
  $akaGrp = $dbh->get($akaAll, array(':aka' => $_GET['aka']));
  $template->assign('akaGrp',$akaGrp);
  
  /*
   Find the tournament specified by the year,id pair from URL.
   This should be a unique key to the `tournaments` table, so there should be only one.
  */
  $altAkaArr = $dbh->get('select aka
from tournaments
where id = :id
and year = :year
limit 1',
    array(':id' => $_GET['id'],
	  ':year' => $_GET['year']));

  // If we can't even find the aka for this tournament, don't bother finding aka-alikes
  if (isset($altAkaArr[0]['aka'])) {
    $altAka = $altAkaArr[0]['aka'];
    $template->assign('altAka',$altAka);
  
    // All tournaments with same aka as the tournamanet with the year,id specified by the URL
    $altAkaGrp = $dbh->get($akaAll, array(':aka' => $altAka));
    $template->assign('altAkaGrp',$altAkaGrp);
  }

  $template->display('tournaments/series-error.tpl');
  
  exit;
}

// OK, assume we found the right tournament series

// Find most recent tournament from this aka, call the series by that name
$nameArr = $dbh->get('select name
from tournaments
where aka = :aka
order by 
if(start is null, makedate(year,1), start)
desc
limit 1',array(':aka' => $_GET['aka']));

$name = $nameArr[0]['name'];
$template->assign('name',$name);

// Get attendance numbers, grouped and concatenated with commas for Google Charts API
$attGr = $dbh->get('select level, 
max(many) as xm, /* the most that ever participated in this division */
max(truyr) as xy, min(truyr) as iy, /* The first and last year this division was at the tournament series */
/* We\'ll double the data points, since Google won\'t draw a line when given just one point,
even if it is decorated with a circle */
concat(
group_concat(concat(truyr,\',\',truyr) order by truyr),
\'|\',
group_concat(concat(many,\',\',many) order by truyr)) as ds
from (select 
if(start is null, tournaments.year,
year(start) + if(datediff(start,makedate(year(start),210)) > 0, 1, 0))
/* Around July 1, all following-academic-year tournaments have yet to be held, 
and all previous-academic-year tournaments have already been held */
as truyr,
rounds.level,
/* Every team is aff at least once */
count(distinct affteam) as many
from tournaments, rounds
where rounds.year = tournaments.year
and rounds.tournament = tournaments.id
and tournaments.aka = :aka
and negteam != 0
/* Don\'t count outrounds -- avoinds double counting teams in breakout rounds */
and roundNum > 0
group by rounds.level,
if(start is null, tournaments.year, year(start) + if(datediff(start,makedate(year(start),210)) > 0,1,0))
) as must 
group by level',array(':aka' => $_GET['aka']));

if (count($attGr) > 0) {
  $minyear = min(array_map(create_function('$x','return $x["iy"];'),$attGr));
  
  $maxyear = max(array_map(create_function('$x','return $x["xy"];'),$attGr));

  if ($minyear != $maxyear) {

    // Attendance data
    $att = "chd=t:".implode("|",array_map(create_function('$x','return $x["ds"];'),$attGr));
    
    // The maximum attendance in any division
    $maxdiv = max(array_map(create_function('$x','return $x["xm"];'),$attGr));
    // DOn't put any points at the top line of the graph
    $maxdiv = round(1.1*$maxdiv);
    
    //Rescale the chart so it's not intepreting tthe data in a field of 100x100
    $scal = 'chds='.implode(',',array_map(create_function('$x','return "'.$minyear.'".","."'.$maxyear.'".",0,'.$maxdiv.'";'),$attGr));
    
    //labels for the levels
    $labs = "chdl=".implode("|",array_map(create_function('$x','return $x["level"];'),$attGr));
    
    //turn "2009" into "'08-'09"
    $years = "chxl=0:|".implode("|",array_map(create_function('$x','return "\'".substr($x-1,2)."-\'".substr($x,2);'),range($minyear,$maxyear)));
    
    // Put horizonal on the graph markers
    $rang = round($maxdiv/(8));
    // Make sure they're at least 1 apart
    $rang = max($rang,1);
    
    $template->assign('att',$att);
    $template->assign('scal',$scal);
    $template->assign('labs',$labs);
    $template->assign('maxdiv',$maxdiv);  
    $template->assign('rang',$rang);
    $template->assign('numyears',$maxyear-$minyear);
    $template->assign('years',$years);
  }
}

$template->display('tournaments/series.tpl');

?>