<?php

require_once (dirname(__FILE__).'/../config.php');

class dbstmt {

  public $stmt;

  public $query;
  
  public function __construct(PDOStatement $par) {
    $this->stmt = $par;
  }
  

  public function execute($binds = array()) {
    $res = $this->stmt->execute($binds);
    if (FALSE == $res) {
      $err = $this->stmt->errorInfo();
      error_log("SQL Error: {$this->query} {$err[0]} {$err[1]} {$err[2]} ".print_r($binds,TRUE));
    }
  }

  public function get($binds = array()) {
    $this->execute($binds);
    return $this->fetchAll(PDO::FETCH_ASSOC);
  }

  public function fetchAll($way) {
    return $this->stmt->fetchAll($way);
  }

  public function nextRowset() {
    $this->stmt->nextRowset();
  }

   
}


class dbview extends PDO {

  public function __construct () {
    parent::__construct("mysql:host=".config::dbviewhost().";dbname=DebateResultsAll", config::dbviewuser(), config::dbviewpass());
  }


  public function prepare($stmt, $opts = array()) {
    $ans = new dbstmt(parent::prepare($stmt, $opts));
    $ans->query = $stmt;
    return $ans;
  }

  public function get($query, $binds = array()) {
    $stmt = $this->prepare($query);
    return $stmt->get($binds);
  }
       
      

}

?>