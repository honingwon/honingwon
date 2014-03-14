<?php
	/*
		卡审核
	*/
	include_once("../../common.php"); 
	require_once(DATACONTROL . '/BMAccount/IsLogin.php'); 
 	require_once(DATACONTROL . '/BMAccount/CardApplyProvider.php'); 
 	require_once(DATAMODEL . '/BMAccount/CardApplyFormMDL.php');
 	
 	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "List":
 			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 20;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$offer	  	= ($curPage - 1) * $pageSize;	
 			echo json_encode(CardApplyProvider::getInstance()->GetCardFormListByState(0,$offer,$pageSize));
 			break;
		//不通过
 		case "Undone":
 			$cardFormID = $_POST['ID'];
 			$remark		= $_POST['dec'];
 			echo json_encode(CardApplyProvider::getInstance()->UnPassCardForm($cardFormID,$remark));
 			break;
		//通过
 		case "done":
 			$cardFormID = $_POST['ID'];
 			$remark		= $_POST['dec'];
 			echo json_encode(CardApplyProvider::getInstance()->DoPassCardInfo($cardFormID,$remark));
 			break;
 	}
?>