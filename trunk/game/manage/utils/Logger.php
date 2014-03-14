<?php
require_once(dirname(__FILE__)."/../include/log4php/Logger.php");  
Logger::configure(dirname(__FILE__)."/../log4php.properties");   
$logger = @Logger::getLogger("default"); 
$GLOBALS['LOGGER'] = $logger;
?>