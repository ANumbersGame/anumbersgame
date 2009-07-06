<?php

require_once ('site-config.php');

class config extends siteConfig 
{
  public static function firstyear() { return 2004; }
  public static function lastyear() { return 2010; }
  public static function servroot() { return dirname(__FILE__).'/../'; }
}
?>