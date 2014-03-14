<?php
require_once(INCLUDELOG . "/log4php/Logger.php");
Logger::configure(ROOT . "log4php.properties");   
$logger = @Logger::getLogger("default"); 
$GLOBALS['LOGGER'] = $logger;
?>