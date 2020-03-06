<?php

require_once dirname(__FILE__) . '/../src/bb-load.php';
$di = include dirname(__FILE__) . '/../src/bb-di.php';
$pdo = $di['pdo'];

$installPath = BB_PATH_ROOT . '/install';
$structureSql = $installPath.'/structure.sql';
$contentSql = $installPath.'/content_test.sql';

/*
if (APPLICATION_ENV == 'production') {
    $contentSql = $installPath.'/content.sql';
    echo "Production content" . PHP_EOL;
}
*/

$sth = $pdo->prepare("SELECT DATABASE();");
$sth->execute();
$dbname = $sth->fetchColumn();

$sth = $pdo->prepare("SHOW TABLES FROM $dbname");
$sth->execute();
$tables = array();
while($row = $sth->fetch()) {
    $tables[] = array_pop(array_reverse($row));
}

if(!empty($tables)) {
    foreach($tables as $table) {
        echo "Dropping table {$table}" . PHP_EOL;
        $stmt = $pdo->prepare("DROP TABLE {$table};");
        $stmt->execute();
    }
}

echo sprintf("Create SQL database structure from file %s", $structureSql) . PHP_EOL;
$sql = file_get_contents($structureSql);
$pdo->exec($sql);
$error = $pdo->errorInfo();
if ($error[2]) {
    var_dump($pdo->errorInfo());
    exit;
}

echo sprintf("Import content to database from file %s", $contentSql) . PHP_EOL;
$sql = file_get_contents($contentSql);
$stmt = $pdo->prepare($sql);
$stmt->execute();
$i = 0;
do{
}while($stmt->nextRowset());


echo "Finished" . PHP_EOL;