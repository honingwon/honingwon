<?php
 	include_once("../../common.php");  
 	require_once(DATACONTROL . '/BMManage/IsLogin.php');
 	require_once(DATACONTROL . '/BMManage/GoodsTypeProvider.php'); 
 	require_once(DATAMODEL . '/BMManage/GoodsTypeMDL.php'); 

 	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "ListType1":
 			$listResult = GoodsTypeProvider::getInstance()->ListType1();
 			echo json_encode($listResult);
 			break;
 		case "ListType2":
 			$listResult = GoodsTypeProvider::getInstance()->ListType2($_POST["type1Id"]);
 			echo json_encode($listResult);
 			break;
 		case "ListType3":
 			$listResult = GoodsTypeProvider::getInstance()->ListType3($_POST["type2Id"]);
 			echo json_encode($listResult);
 			break;
 		case "List":
 			$listResult = GoodsTypeProvider::getInstance()->ListAll();
 			echo json_encode($listResult);
 			break;
 		case "Add":
 			$addResult = GoodsTypeProvider::getInstance()->AddGoodsType($_POST["index"],$_POST["parentId"],$_POST["name"],$_POST["order"]);
 			echo json_encode($addResult);
 			break;
 		case "edit1":
 			$editResult = GoodsTypeProvider::getInstance()->updateGoodsType1( $_POST["id"],  $_POST["name"], $_POST["order"], $_POST["state"]);
 			echo json_encode($editResult);
 			break;
 		case "edit2":
 			$editResult = GoodsTypeProvider::getInstance()->updateGoodsType2( $_POST["id"],$_POST["type1_id"],  $_POST["name"], $_POST["order"], $_POST["state"]);
 			echo json_encode($editResult);
 			break;
 		case "edit3":
 			$editResult = GoodsTypeProvider::getInstance()->updateGoodsType3( $_POST["id"], $_POST["type2_id"],  $_POST["name"], $_POST["order"], $_POST["state"]);
 			echo json_encode($editResult);
 			break;
 	}
?>