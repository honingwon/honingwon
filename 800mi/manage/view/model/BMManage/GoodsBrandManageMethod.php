<?php
 	include_once("../../common.php");  
 	require_once(DATACONTROL . '/BMManage/IsLogin.php');
 	require_once(DATACONTROL . '/BMManage/GoodsBrandProvider.php'); 
 	require_once(DATAMODEL . '/BMManage/GoodsBrandMDL.php'); 

 	if(isset($_POST["method"])){
 		$methods = $_POST["method"];
 	}
	else if(isset($_GET["method"])){
		$methods = $_GET["method"];
	}
	else{
		exit;
	} 

 	switch($methods)
 	{
 		case "List":
 			$listResult = GoodsBrandProvider::getInstance()->ListAll($_GET["lv"],$_GET["type3Id"]);
 			echo json_encode($listResult);
 			break;
 		case "Add":
 			$addResult = GoodsBrandProvider::getInstance()->AddGoodsBrand($_POST["name"],$_POST["order"]);
 			echo json_encode($addResult);
 			break;
 		case "edit":
 			$editResult = GoodsBrandProvider::getInstance()->updateGoodsBrand( $_POST["id"],  $_POST["name"], $_POST["order"], $_POST["state"]);
 			echo json_encode($editResult);
 			break;
 	}
?>