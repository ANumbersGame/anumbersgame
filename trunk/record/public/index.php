<?php


require_once ('../protected/smarty/template.php');
$template = new template();
/*
require_once ('../protected/db/dbview.php');

$dbh = new dbview();
*/
/*
$template->assign('name', 'World');
*/
$template->display('index.tpl');

?>
