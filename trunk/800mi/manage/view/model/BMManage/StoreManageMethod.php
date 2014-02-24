<?php
 	include_once("../../common.php");  
 	require_once(DATACONTROL . '/BMManage/IsLogin.php');
 	require_once(DATACONTROL . '/BMManage/StoreProvider.php'); 
 	require_once(DATAMODEL . '/BMManage/StoreMDL.php'); 
 	
// 	$editArray  = array("shop_name" =>"江南铭庭2" ,"shop_province" => "浙江省","shop_city" => "杭州市",
// 												"shop_district" => "滨江区", "shop_addr" => "江南铭庭", "shop_contacts" => "联系方式???", "shop_phone" => "12025623");
// 			$editResult = StoreProvide::getInstance()->UpdateStore( "4", $editArray);
// 			echo json_encode($editResult);
// 	$addResult = StoreProvide::getInstance()->AddStore("test","浙江","杭州","滨江","diseksd1111","sadfas","1235632");
// 	echo json_encode($addResult);
 	
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
 			$listResult = StoreProvider::getInstance()->ListStore();
 			echo json_encode($listResult);
 			break;
 		case "Add":
 			$addResult = StoreProvider::getInstance()->AddStore($_POST["name"],$_POST["province"],$_POST["city"],$_POST["district"],
 																										$_POST["addr"],$_POST["contacts"],$_POST["phone"]);
 			echo json_encode($addResult);
 			break;
 		case "edit":
 			$editArray  = array("shop_name" => $_POST["name"],"shop_province" => $_POST["province"],"shop_city" => $_POST["city"],
 												"shop_district" => $_POST["district"], "shop_addr" => $_POST["addr"], "shop_contacts" => $_POST["contacts"], "shop_phone" => $_POST["phone"]);
 			$editResult = StoreProvider::getInstance()->UpdateStore( $_POST["storeId"], $editArray);
 			echo json_encode($editResult);
 			break;
 		case "Del":
 			$delresult = StoreProvider::getInstance()->DeleteStore($_POST["storeId"]);
 			echo json_encode($delresult);
 			break;
 	}
?>
