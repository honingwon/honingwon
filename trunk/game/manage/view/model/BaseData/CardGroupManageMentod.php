<?php
	include_once("../../common.php"); 
	require_once(DATACONTROL . '/BMAccount/IsLogin.php'); 
 	require_once(DATACONTROL . '/BMAccount/CardGroupManageProvider.php'); 
 	require_once(DATAMODEL . '/BMAccount/CardGroupMDL.php');
 	
 	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "list":
 			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 20;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$offer	  	= ($curPage - 1) * $pageSize;	
			$name 		= $_POST['name'];
 			echo json_encode(CardGroupManageProvider::getInstance()->ListCardGroup($name,$offer,$pageSize));
 			break;
 		case "groupinfo":
 			$GroupID = $_POST['ID'];
 			echo json_encode(CardGroupManageProvider::getInstance()->GetCardGroupInfo($GroupID));
 			break;
 		case "update":
 			$GroupID = $_POST['ID'];
 			$sTime	 = $_POST['s'];
 			$eTime	 = $_POST['e'];
 			$State	 = $_POST['state'];
 			echo json_encode(CardGroupManageProvider::getInstance()->UpdateCardGroupInfo($GroupID,$State,$sTime,$eTime));
 			break;
 	}
?>