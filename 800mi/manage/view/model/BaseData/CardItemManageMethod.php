<?php
	include_once("../../common.php");  
	require_once(DATACONTROL . '/BMAccount/IsLogin.php'); 
 	require_once(DATACONTROL . '/ServerManager/ServerManageProvider.php'); 
 	require_once(DATACONTROL . '/BMAccount/GameItemProvider.php'); 
 	require_once(DATAMODEL . '/ServerManager/GameMDL.php'); 
 	require_once(DATAMODEL . '/BMAccount/GameItemMDL.php'); 
 	
 	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "game":
 			echo json_encode(ServerManageProvider::getInstance()->getGameList());	
 			break;
 		case "itemList":
 			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 20;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$offer	  	= ($curPage - 1) * $pageSize;	
			$gameID		= $_POST['ID'];
			$itemName	= $_POST['txt'];
 			echo json_encode(GameItemProvider::getInstance()->GetAllGameItemByGameID($offer,$pageSize,$gameID,$itemName));
 			break;
 		case "itemListupdate":
 			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 20;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$offer	  	= ($curPage - 1) * $pageSize;	
			$gameID		= $_POST['ID'];
			$itemName	= $_POST['txt'];
			$type       = $_POST['type'];
 			echo json_encode(GameItemProvider::getInstance()->GetAllGameItemByGameIDUpdate($offer,$pageSize,$gameID,$itemName,$type));
 			break;
 		case "add":
 			$gameID		= $_POST['ID'];
 			$name		= $_POST['name'];
 			$GID		= $_POST['gid'];
 			$rank		= $_POST['rank'];
 			$dec		= $_POST['dec'];
 			echo json_encode(GameItemProvider::getInstance()->AddNewGameItem($gameID,$name,$GID,$rank,$dec));
 			break;
 		case "update":
 			$itemindex	= $_POST['ID'];
 			$name		= $_POST['name'];
 			$GID		= $_POST['gid'];
 			$rank		= $_POST['rank'];
 			$dec		= $_POST['dec'];
 			echo json_encode(GameItemProvider::getInstance()->UpdateGameItem($itemindex,$name,$GID,$rank,$dec));
 			break;
 		case "del":
 			$itemindex	= $_POST['ID'];
 			echo json_encode(GameItemProvider::getInstance()->DelGameItem($itemindex));
 			break;
 	}
?>