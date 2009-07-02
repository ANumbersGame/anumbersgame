<?php

// put full path to Smarty.class.php
require('../protected/Smartylib/Smarty.class.php');
$smarty = new Smarty();

$smarty->template_dir = '../protected/smarty/templates';
$smarty->compile_dir = '../protected/smarty/templates_c';
$smarty->cache_dir = '../protected/smarty/cache';
$smarty->config_dir = '../protected/smarty/configs';

$smarty->assign('name', 'World');
$smarty->display('index.tpl');

?>
