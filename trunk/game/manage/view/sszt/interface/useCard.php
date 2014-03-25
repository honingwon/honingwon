<?php

include_once("../../common.php");  
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMAccount/EventLog.php');
require_once('UtilsProvider.php');

$cardSN = '';
$userName = '';
$ip = '';
$serverId = 0;

if(isset($_GET['cardSN']) && isset($_GET['userName']) &&  isset($_GET['ip']) && isset($_GET['serverId']))
{
	$cardSN = $_GET['cardSN'];
	$userName = $_GET['userName'];
	$ip = $_GET['ip'];
	$serverId = $_GET['serverId'];
	$sql = sprintf("CALL CheckCard('%s','%s','%s',%d);",$cardSN,$userName,$ip,$serverId);
	$r = sql_fetch_one_cell($sql);
}
else
	$r = 0;

if($r > 0)
{
	
	$result = UtilsProvider::dataMentods_sendCardItem($r,$userName,$serverId);
	if($result->Success)
	{
		$sql = sprintf("CALL ChargeCard('%s','%s','%s',%d);",$cardSN,$userName,$ip,$serverId);
		$r = sql_fetch_one_cell($sql);
		echo 1;
	}
	else
	{
		$sql = sprintf("CALL BreakCard('%s','%s',%d);",$cardSN,$userName,$serverId);
		$r = sql_fetch_one_cell($sql);
		echo 0;
		//echo json_encode($result);
	}
}
else
{
	echo 0;
}
?>