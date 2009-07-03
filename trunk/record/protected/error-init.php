<?php

function display_error($errno, $errstr, $errfile = null, $errline = null, $errcontext = null) 
{

  $errkey = uniqid();
  
  error_log("$errno $errkey $errfile $errline");

  require_once('smarty/template.php');
  $template = new template();

  $template->assign('errkey', $errkey);
  $template->display('error.tpl');

  return FALSE;
}

set_error_handler("display_error");

?>