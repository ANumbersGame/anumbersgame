<?php

require_once (dirname(__FILE__).'/../Smartylib/Smarty.class.php');

class template extends Smarty {

  function __construct() {
    parent::__construct();

    $this->template_dir = dirname(__FILE__).'/templates';
    $this->compile_dir = dirname(__FILE__).'/templates_c';
    $this->cache_dir = dirname(__FILE__).'/cache';
    $this->config_dir = dirname(__FILE__).'/configs';
    
    $this->default_modifiers = array('escape:"htmlall":"UTF-8"','nl2br');
  }
}

?>
