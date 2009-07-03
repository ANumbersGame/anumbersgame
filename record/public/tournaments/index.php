<?php

  //require_once('../../protected/error-init.php');

require_once ('../../protected/smarty/template.php');
$template = new template();

require_once ('../../protected/db/dbview.php');

$dbh = new dbview();

// avg simply ignored nulls

$tOrdStmt = $dbh->prepare('select aka,
avg(if(datediff(start,makedate(year(start),210)) < 0, 
datediff(start,makedate(year(start),210)) + 365.24, 
datediff(start,makedate(year(start),210)))) as days
from tournaments 
group by aka 
order by days');

$tOrdStmt->execute();

$torder = $tOrdStmt->fetchAll(PDO::FETCH_ASSOC);

require_once ('../../protected/db/years.php');

$tyStmt = $dbh->prepare('select year, id, name
from tournaments
where ((datediff(start, makedate(? - 1,210)) > 0
and datediff(start, makedate(? - 1,210)) < 364)
or (start is null
and year = ?))
and aka = ?');

foreach($torder as $key => $trn) {

  $list = null;

  for ($year = $lastyear; $year >= $firstyear; --$year) {

    $tyStmt->execute(array($year,$year,$year,$trn['aka']));
    $tyear = $tyStmt->fetchAll(PDO::FETCH_ASSOC);
    $list[$year] = $tyear;

  }

  $torder[$key]['list'] = $list;
}

$template->assign('tournaments', $torder);
$template->display('tournaments.tpl');

?>
