<?php
require_once 'config/config.php';
require_once 'lib/CardNetwork.php';


if(isset($_GET['cardSN']) && isset($_GET['userName']) &&  isset($_GET['ip']))
{
	$cardSN = $_GET['cardSN'];
	$userName = $_GET['userName'];
	$ip = $_GET['ip'];
	$serverId = $GLOBALS['SERVERID'];
	$url = $GLOBALS['CARDCHANGEURL'];
	$param = array(
				'cardSN' => $cardSN,
				'userName' => $userName,
				'ip'=>$ip,
				'serverId'=>$serverId
			);
	$result = CardNetwork::makeRequest($url,$param);
	if($result['result'] == false)
		echo $result['msg'];
	else
		echo $result['msg'];//echo json_encode($result);
}
else
	echo 0;

?>