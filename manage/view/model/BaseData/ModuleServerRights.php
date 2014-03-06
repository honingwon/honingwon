<?php
	include_once("../../common.php"); 
	require_once(DATACONTROL . '/BMAccount/IsLogin.php');  
 	require_once(DATACONTROL . '/BMAccount/CardTypeProvider.php'); 
 	require_once(DATACONTROL . '/ServerManager/ServerManageProvider.php'); 
 	require_once(DATACONTROL . '/BMAccount/GameItemProvider.php'); 
 	require_once(DATAMODEL . '/BMAccount/CardTypeMDL.php');
 	require_once(DATAMODEL . '/ServerManager/GameMDL.php'); 
 	require_once(DATAMODEL . '/BMAccount/GameItemMDL.php');
 	 
 	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "rightMoule"://受到特殊服务器权限控制功能模块
 			$cardTypeName = $_POST['txt'];
 			echo json_encode(CardTypeProvider::getInstance()->ListAllCardType($cardTypeName));
 			break;
 		case "game":
 			echo json_encode(ServerManageProvider::getInstance()->getGameList());	
 			break;
 		case "gameitem":
 			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 20;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$offer	  	= ($curPage - 1) * $pageSize;	
			$gameID		= $_POST['ID'];
			$itemName	= $_POST['txt'];
 			echo json_encode(GameItemProvider::getInstance()->GetAllGameItemByGameID($offer,$pageSize,$gameID,$itemName));	
 			break;
 		case "carditem":
 			$cardID		= $_POST['ID'];
 			echo json_encode(CardTypeProvider::getInstance()->GetCardItemByCardType($cardID));
 			break;
 		case "updateitem":
 			$cardID		= $_POST['ID'];
 			$addStr		= $_POST['str'];
 			echo json_encode(CardTypeProvider::getInstance()->UpdateCardItemInfo($cardID,$addStr));
 			break;
 	}
?>