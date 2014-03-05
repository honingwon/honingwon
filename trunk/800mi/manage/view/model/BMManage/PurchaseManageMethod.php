<?php
 	include_once("../../common.php");  
 	require_once(DATACONTROL . '/BMManage/IsLogin.php');
 	require_once(DATACONTROL . '/BMManage/PurchaseProvider.php'); 
 	require_once(DATAMODEL . '/BMManage/PurchaseInfoMDL.php'); 
 	
// 	$addResult = PurchaseProvider::getInstance()->UpdatePurchaseState("1","98");
// 			echo json_encode($addResult);
// 	 		$ary = explode('|',"1,2,3|10,11,12");
// 			$key = explode(',',$ary[0]);
// 			$value = explode(',',$ary[1]);
// 			$list = array_combine($key,$value); 			
// 			$addResult = PurchaseProvider::getInstance()->AddPurchase("5","test",$list);
// 			echo json_encode($addResult);
 	
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
 			$listResult = PurchaseProvider::getInstance()->ListPurchase();
 			echo json_encode($listResult);
 			break;
 		case "Add":
 			$itemList = $_POST["list"];
 			$ary = explode('|',$itemList);
 			$key = explode(',',$ary[0]);
 			$value = explode(',',$ary[1]);
 			$list = array_combine($key,$value);
 			$addResult = PurchaseProvider::getInstance()->AddPurchase($_POST["storeId"],$_POST["remark"],$list);
 			echo json_encode($addResult);
 			break;
 		case "UpdateSate":
 			$addResult = PurchaseProvider::getInstance()->UpdatePurchaseState($_POST["purchaseId"],$_POST["state"]);
 			echo json_encode($addResult);
 			break; 			
 	} 	
 	
?>
