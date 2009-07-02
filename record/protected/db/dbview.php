<?php

class dbview extends PDO {
  function __construct () {
    require('password.php');
    parent::__construct("mysql:host={$dbviewhost};dbname=DebateResultsAll", $dbviewuser, $dbviewpass);
  }
}

?>