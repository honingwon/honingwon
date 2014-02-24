<?php
	include_once("../../common.php");  
	require_once(DATACONTROL . '/BMManage/IsLogin.php');
	require_once(DATALIB . '/SqlResult.php');
 	require_once(DATACONTROL . '/BMManage/AccountProvider.php'); 
 	require_once(DATAMODEL . '/BMManage/AccountMDL.php'); 

 	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "List":
 			$accout   	= $_POST['account'];	
			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 20;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$type       = intval($_POST['type']);
			$offer	  	= ($curPage - 1) * $pageSize;	
 			$listResult = AccountProvider::getInstance()->ListAllAccount($offer,$pageSize,$accout,$type);
 			echo json_encode($listResult);
 			break;
 		case "Add":
 			$addResult  = AccountProvider::getInstance()->AddNew($_POST["account"],$_POST["name"],$_POST["level"],$_POST["type"],$_POST["dec"]);
 			echo json_encode($addResult);
 			break;
 		case "edit":
 			$editArray  = array("account_name" => $_POST["name"],
 								"account_level" => $_POST["level"],
 								"account_type" => $_POST["type"],"account_remark" => $_POST["dec"]);
 			$editResult = AccountProvider::getInstance()->Update($_POST["ID"],$editArray);
 			echo json_encode($editResult);
 			break;
 		case  "del":
 			echo json_encode(AccountProvider::getInstance()->Update($_POST["ID"],""));
 			break;
 		case "pwd":
			$old = $_POST["old"];
			$new = $_POST["new"];
 			$pwdResult = AccountProvider::getInstance()->EditPassWord($old,$new);
 			echo json_encode($pwdResult);
 			break;
 		case "oneFo":
 			$onefoResult = AccountProvider::getInstance()->getAccountByAccountID($_POST["ID"]);
 			echo json_encode($onefoResult);
 			break;
 		case "reset":
 			echo json_encode(AccountProvider::getInstance()->ResetPassWord($_POST["ID"]));
 			break;
 		case "youlong":
 			$starttime   	= $_POST['starttime'];	
			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 20;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$endtime       = $_POST['endtime'];
			$offer	  	= ($curPage - 1) * $pageSize;	
 			echo json_encode(AccountProvider::getInstance()->youlongLog($offer,$pageSize,$starttime,$endtime));
 			break;
 	}
?>