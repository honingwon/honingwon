<?php
 	include_once("../../common.php");  
 	require_once(DATACONTROL . '/BMManage/IsLogin.php');
 	require_once(DATACONTROL . '/BMManage/GroupProvider.php'); 
 	require_once(DATAMODEL . '/BMManage/GroupMDL.php'); 
 	
 	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "List":
 			$listResult = GroupProvider::getInstance()->ListAll();
 			echo json_encode($listResult);
 			break;
 		case "Add":
 			$addResult = GroupProvider::getInstance()->AddGroup($_POST["name"],$_POST["dec"]);
 			echo json_encode($addResult);
 			break;
 		case "edit":
 			$editArray  = array("group_name" => $_POST["name"],"group_remark" => $_POST["dec"]);
 			$editResult = GroupProvider::getInstance()->UpdateGroup($_POST["ID"],$editArray);
 			echo json_encode($editResult);
 			break;
 	}
?>