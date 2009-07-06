<?php

require_once (dirname(__FILE__).'/../config.php');
require_once (config::servroot()."/protected/Smartylib/Smarty.class.php");

class template extends Smarty {

  function __construct() {

    parent::__construct();

    $this->template_dir = config::servroot()."/protected/smarty/templates";
    $this->compile_dir = config::servroot()."/protected/smarty/templates_c";
    $this->cache_dir = config::servroot()."/protected/smarty/cache";
    $this->config_dir = config::servroot()."/protected/smarty/config";
    
    //$this->default_modifiers = array('escape:"htmlall":"UTF-8"','nl2br');
    
    $this->assign('webroot',config::webroot());

  }
}

?>
