<?php
	include_once("../../common.php");  
	require_once(DATACONTROL . '/BMAccount/IsLogin.php');
 	require_once(DATACONTROL . '/BMAccount/CardTypeProvider.php'); 
 	require_once(DATACONTROL . '/BMAccount/CardApplyProvider.php'); 
 	require_once(DATAMODEL . '/BMAccount/CardTypeMDL.php');
 	require_once(DATAMODEL . '/BMAccount/CardApplyFormMDL.php');
 	
	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "cardlist":
 			echo json_encode(CardTypeProvider::getInstance()->ListAllCardType());
 			break;
 		case "creat":
 			$cardName = $_POST["name"];
 			$remark	  = $_POST["dec"];
 			$cardStr  = $_POST["str"];
 			echo json_encode(CardApplyProvider::getInstance()->CreatCardApplyInfo($cardName,$remark,$cardStr,''));
 			break;
 		case "applyList":
 			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 20;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$offer	  	= ($curPage - 1) * $pageSize;	
			$state 		= $_POST['s'];
 			echo json_encode(CardApplyProvider::getInstance()->GetCardFormListByState($state,$offer,$pageSize));
 			break;
 		case "cardInfo"://CardForm CardTypeInfo
 			$cardFormID = $_POST['ID'];
 			echo json_encode(CardApplyProvider::getInstance()->GetCardTypeInfoByCardFormID($cardFormID));
 			break;
 		case "Tlist":
 			$cardFormID = $_POST['ID'];
 			echo json_encode(CardApplyProvider::getInstance()->getCardListByFormID($cardFormID));
 			break;
 		case "updateapply":
 			$cardFormID = $_POST['ID'];
 			echo json_encode(CardApplyProvider::getInstance()->UpdateCardFormState($cardFormID));
 			break;
 	}
?>