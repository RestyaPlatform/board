<?php
$container = $app->getContainer();
$container['db'] = function ($c)
{
    $pdo = new PDO(R_DB_DRIVER . ":host=" . R_DB_HOST . ";dbname=" . R_DB_NAME, R_DB_USER, R_DB_PASSWORD);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    return $pdo;
};
