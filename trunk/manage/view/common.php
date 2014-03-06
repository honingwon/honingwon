<?php	
require_once(dirname(__FILE__).'/../language/Language/view.php'); 
require_once(dirname(__FILE__).'/../language/Language/module.php');
define('JS_LANGUAGE', '/gameManage/language/Language/language.js');	
define('VIEW', str_replace("\\", '/', dirname(__FILE__) ) );
define('ROOT', str_replace("\\", '/', substr(VIEW,0,-4) ) );
define('TIMEZONE', 'PRC');//Asia/Tokyo=日本   时区设置

define('DATACONTROL', ROOT.'control');
define('DATAMODEL', ROOT.'model');
define('DATALIB', ROOT.'lib');
define('DATAVIEW', ROOT.'view');
define('VIEWMODEL', ROOT.'view/model');
define('INCLUDELOG', ROOT.'include');
define('UTILS', ROOT.'utils');
define('SOCKET', ROOT.'socket');

define('MANAGER_PATH', '');
define('IMAGE_DIR', MANAGER_PATH.'/view/images');
define('JS_DIR', MANAGER_PATH.'/view/js');
define('CSS_DIR', MANAGER_PATH.'/view/css');

define('DRAWFONE_PATH', '../Fonts/msyh.ttf');

$managerURL = "http://" . $_SERVER['HTTP_HOST'] . MANAGER_PATH;

include_once("function.php");
if (version_compare(PHP_VERSION, '5.3.0', '<')) 
{
    set_magic_quotes_runtime(0);
}

//系统相关变量检测
$registerGlobals = @ini_get("register_globals");
$isUrlOpen = @ini_get("allow_url_fopen");
$isSafeMode = @ini_get("safe_mode");


date_default_timezone_set("PRC");
////php5.1版本以上时区设置
////由于这个函数对于是php5.1以下版本并无意义，因此实际上的时间调用，应该用MyDate函数调用
//if(PHP_VERSION > '5.1')
//{
//    $time51 = $cfg_cli_time * -1;
//    @date_default_timezone_set('Etc/GMT'.$time51);
//}
//$cfg_isUrlOpen = @ini_get("allow_url_fopen");
?>