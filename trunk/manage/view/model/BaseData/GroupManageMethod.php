<?php
 	include_once("../../common.php");  
 	require_once(DATACONTROL . '/BMAccount/IsLogin.php');
 	require_once(DATACONTROL . '/BMAccount/GroupProvider.php'); 
 	require_once(DATAMODEL . '/BMAccount/GroupMDL.php'); 
 	
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
 			$editArray  = array("bm_GroupName" => $_POST["name"],"bm_RankRemark" => $_POST["dec"]);
 			$editResult = GroupProvider::getInstance()->UpdateGroup($_POST["ID"],$editArray);
 			echo json_encode($editResult);
 			break;
 	}
?>