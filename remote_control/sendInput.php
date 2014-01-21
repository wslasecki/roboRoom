<?php
error_reporting(E_ALL);

include('_db.php');
session_start();

if( isset($_REQUEST['command'])) {
//if( isset($_REQUEST['time']) && isset($_REQUEST['command'])) {
  $cmd = $_REQUEST['command'];
  $session = session_id();

  $rID = 0;
  if( isset($_REQUEST['robotId']) ) {
    $rID = intval($_REQUEST['robotId']);
  }

/*
  if (!empty($_REQUEST['session'])) {
      $session = $_REQUEST['session'];
  }

  if(isset($_REQUEST['worker']) && $_REQUEST['worker'] != "") {
    $worker = $_REQUEST['worker'];
  } else {
    $worker = "NO_ID";
  }
*/

  // Old socket code went here.

  try {
    $dbh = getDatabaseHandle();
  } catch(PDOException $e) {
    echo $e->getMessage();
  }

  if($dbh) {
    //$sth = $dbh->prepare("INSERT INTO Control (RoombaID, command, worker, session) VALUES(:rID, :cmd, '$worker', '$session')");
    $sth = $dbh->prepare("INSERT INTO Control (RoombaID, command) VALUES(:rID, :cmd) ON DUPLICATE KEY UPDATE command=:cmd");
    $sth->execute(array(':rID'=>$rID, ':cmd'=>$cmd));
    $add_id = $dbh->lastInsertId();

    echo("Sending:: " . $rID . " -> " . $cmd . "\n");

    echo($add_id);
  }

}


?>

