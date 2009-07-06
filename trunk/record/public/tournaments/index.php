<?php

require_once('../../protected/config.php');

//require_once('../../protected/error-init.php');

require_once (config::servroot()."/protected/smarty/template.php");
$template = new template();

require_once (config::servroot()."/protected/db/dbview.php");

$dbh = new dbview();

// avg simply ignored nulls

$torder = $dbh->get('select aka,
avg(if(datediff(start,makedate(year(start),210)) < 0, 
datediff(start,makedate(year(start),210)) + 365.24, 
datediff(start,makedate(year(start),210)))) as days
from tournaments 
group by aka 
order by days');

$tyStmt = $dbh->prepare('
set @year = :year;
select year, id, name
from tournaments
where ((datediff(start, makedate(@year - 1,210)) > 0
and datediff(start, makedate(@year - 1,210)) < 364)
or (start is null
and year = @year))
and aka = :aka
order by name');

foreach($torder as $key => $trn) {

  $list = null;
  $recentYear = null;
  $recentID = null;

  for ($year = config::lastyear(); $year >= config::firstyear(); --$year) {

    $tyStmt->execute(array(':year' => $year, ':aka' => $trn['aka']));
    $tyStmt->fetchAll(PDO::FETCH_ASSOC);
    $tyStmt->nextRowset();
    $tyear = $tyStmt->fetchAll(PDO::FETCH_ASSOC);
    $list[] = $tyear;
    if (is_null($recentYear) && isset($tyear[0]['year']) &&
	is_null($recentID) && isset($tyear[0]['id'])) {
      $recentYear = $tyear[0]['year'];
      $recentID = $tyear[0]['id'];
    }

  }

  $torder[$key]['list'] = $list;
  $torder[$key]['year'] = $recentYear;
  $torder[$key]['id'] = $recentID;
}

//print_r($torder);

$template->assign('tournaments', $torder);
$template->display('tournaments.tpl');

?>
