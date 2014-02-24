<?php
 	include_once("../../common.php");  
 	require_once(DATACONTROL . '/BMManage/IsLogin.php');
 	require_once(DATACONTROL . '/BMManage/ShoppingCartProvider.php'); 
 	//require_once(DATAMODEL . '/BMManage/ShoppingCartMDL.php'); 
 	
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
 			$listResult = ShoppingCartProvider::getInstance()->ListShoppingCart();
 			echo json_encode($listResult);
 			break;
 		case "Add":
 			$addResult = ShoppingCartProvider::getInstance()->AddShoppingCart($_POST["goodsId"],$_POST["goodsNum"]);
  			echo json_encode($addResult);
 			break;
 		case "Del":
 			$delresult = GoodsProvider::getInstance()->DeleteGoods($_POST["shoppingCartId"]);
 			echo json_encode($delresult);
 			break;
?>
