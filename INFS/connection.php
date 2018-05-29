<?php
class Db
{
    private static $instance = null;

    private function __construct()
    {}

    private function __clone()
    {}

    public static function getInstance()
    {
        if (!isset(self::$instance)) {
            $pdo_options[PDO::ATTR_ERRMODE] = PDO::ERRMODE_EXCEPTION;
            $pdo_options[PDO::MYSQL_ATTR_INIT_COMMAND] = "SET NAMES utf8";
                 
            self::$instance = new PDO('mysql:host=localhost;dbname=ExpressDB', 'root', '', $pdo_options);
        }
        return self::$instance;
    }
}
