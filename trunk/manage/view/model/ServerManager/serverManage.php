<?php
	//目前正在用的
	include_once("../../common.php");  
	require_once(DATACONTROL . '/BMAccount/IsLogin.php');
 	require_once(DATACONTROL . '/ServerManager/ServerManageProvider.php'); 
 	require_once(DATAMODEL . '/ServerManager/GameMDL.php'); 
 	require_once(DATAMODEL . '/ServerManager/GameAreaMDL.php'); 
 	require_once(DATAMODEL . '/ServerManager/GameServerMDL.php'); 
//if (empty($_POST)) $_POST = $_GET;
 	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "gamelist":
 			echo json_encode(ServerManageProvider::getInstance()->getGameList());
 			break;
 		case "addGame":
 			echo json_encode(ServerManageProvider::getInstance()->addNewGame($_POST['name']));
 			break;
 		case "updateGame":
 			echo json_encode(ServerManageProvider::getInstance()->upDateGame($_POST['name'],$_POST['ID']));
 			break;
 		case "delGame":
 			echo json_encode(ServerManageProvider::getInstance()->deleteGame($_POST['ID']));
 			break;
 		case "arealist":
 			echo json_encode(ServerManageProvider::getInstance()->gameAreaList($_POST['ID']));
 			break;
 		case "areaALLlist":
 			echo json_encode(ServerManageProvider::getInstance()->gameAreaAllList());
 			break;
 		case "addArea":
 			$areaName = $_POST['name'];
 			$areaARI = $_POST['ari'];
 			$areaDesc = $_POST['desc'];
 			echo json_encode(ServerManageProvider::getInstance()->AddGameArea($_POST['ID'],$areaName,$areaARI,$areaDesc));
 			break;
 		case "updateArea":
 			$areaName = $_POST['name'];
 			$areaARI = $_POST['ari'];
 			$areaDesc = $_POST['desc'];
 			echo json_encode(ServerManageProvider::getInstance()->UpdateGameArea($_POST['ID'],$areaName,$areaARI,$areaDesc));
 			break;
 		case "delArea":
 			echo json_encode(ServerManageProvider::getInstance()->deleteGameArea($_POST['ID']));
 			break;
 		case "servlist":
 			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 20;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$offer	  	= ($curPage - 1) * $pageSize;	
			$gameID		= $_POST['game'];
			$areaID		= $_POST['area'];
			echo json_encode(ServerManageProvider::getInstance()->gameServList($offer,$pageSize,$gameID,$areaID));
 			break;
 		case "addServer":
 			$gameID		= $_POST['game'];
			$areaID		= $_POST['area'];	
			$serverName = $_POST['name'];
			$serverPRI	= $_POST['ari'];
			$serverCon  = $_POST['con'];
			$serverDesc = $_POST['desc'];
			$serverSHH  = $_POST['shh'];
			echo json_encode(ServerManageProvider::getInstance()->AddGameServer($gameID,$areaID,$serverName,$serverPRI,$serverDesc,$serverCon,$serverSHH));
 			break;
 		case "updateSer":	
			$serverName = $_POST['name'];
			$serverPRI	= $_POST['ari'];
			$serverCon  = $_POST['con'];
			$serverDesc = $_POST['desc'];
			$serverSHH  = $_POST['shh'];
			echo json_encode(ServerManageProvider::getInstance()->UpdateGameServer($_POST['ID'],$serverName,$serverPRI,$serverDesc,$serverCon,$serverSHH));
 			break;
 		case "delSer":
 			echo json_encode(ServerManageProvider::getInstance()->deleteGameServer($_POST['ID']));
 			break;
 		case "heSer":
 			$gameID		= $_POST['game'];
			$serverID	= $_POST['ID'];	
			$serverRPI  = $_POST['RPI'];   //目标服
			$desc		= $_POST['desc'];  //描述字段
			$timezone = "Asia/Hong_Kong";
			if(function_exists('date_default_timezone_set')) date_default_timezone_set($timezone);
			$time = date('Y-m-d H:i:s');
			$remark = $desc.$time;
 			echo json_encode(ServerManageProvider::getInstance()->updateGameServerHE($serverID,$serverRPI,$remark,$gameID));
 			break;
 		case "closeSer":
			$serverID	= $_POST['ID'];	
 			echo json_encode(ServerManageProvider::getInstance()->updateCloseGameServer($serverID));
 			break;
 	}
?>