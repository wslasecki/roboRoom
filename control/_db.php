<?php
function getDatabaseHandle() {
    $dbh = new PDO("mysql:host=128.12.174.211;port=678;dbname=test", "FurnitureMaster", "areallyhardpasswordtobruteforce");
    return $dbh;
}
?>
