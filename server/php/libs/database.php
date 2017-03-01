<?php
/**
 * R - Ultra lightweight REST server
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    REST
 * @subpackage Core
 * @author     Restya <info@restya.com>
 * @copyright  2014-2017 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 * @todo       Fix code duplication & make it really lightweight
 * @since      2013-08-23
 */
use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Events\Dispatcher;
use Illuminate\Container\Container;
$capsule = new Capsule;
$capsule->addConnection(array(
    'driver' => R_DB_DRIVER,
    'host' => R_DB_HOST,
    'database' => R_DB_NAME,
    'username' => R_DB_USER,
    'password' => R_DB_PASSWORD,
    'port' => R_DB_PORT,
    'charset' => 'utf8',
    'collation' => 'utf8_general_ci',
    'prefix' => ''
));
$capsule->setEventDispatcher(new Dispatcher(new Container));
$capsule->setAsGlobal();
$capsule->bootEloquent();
