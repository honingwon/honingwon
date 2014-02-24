<?php
 	include_once("../../common.php");  
 	require_once(DATACONTROL . '/BMManage/IsLogin.php');
 	require_once(DATACONTROL . '/BMManage/GoodsProvider.php'); 
 	require_once(DATAMODEL . '/BMManage/GoodsMDL.php'); 


// $listResult = GoodsProvider::getInstance()->ListGoods(1,2,2,0,99);
// echo json_encode($listResult);
//	 	$addResult1= GoodsProvider::getInstance()->AddGoods(1,1,1,1,'name',
// 									1,0,0,'123',1,1,2,'1234');
// 	echo json_encode($addResult1);

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
 			$listResult = GoodsProvider::getInstance()->ListGoods($_GET["lv"],$_GET["type3Id"],$_GET["brandId"],$_GET["offset"],$_GET["pageSize"]);
 			echo json_encode($listResult);
 			break;
 		case "Add":
 			$acccount_Id = $_SESSION['account_ID'];
 			$addResult = GoodsProvider::getInstance()->AddGoods($acccount_Id,$_POST["brandId"],$_POST["type3Id"],$_POST["barcode"],$_POST["name"],$_POST["unit"],
 									$_POST["weight"],$_POST["stime"],$_POST["etime"],$_POST["picUrl"],$_POST["number"],$_POST["price"],$_POST["aprice"],$_POST["remark"]);
 			echo json_encode($addResult);
 			break;
 		case "edit":
 			$editArray  = array("brand_id" => $_POST["brandId"],"type3_id" => $_POST["type3_id"],
 								"goods_barcode" => $_POST["barcode"],"goods_name" => $_POST["name"],"goods_unit" => $_POST["unit"],
 								"goods_weight" => $_POST["weight"],"goods_active_stime" => $_POST["stime"],"goods_active_etime" =>$_POST["etime"],
 								"goods_pic_url" => $_POST["picUrl"],"goods_number" => $_POST["number"],
 								"goods_price" => $_POST["price"],"goods_active_price" => $_POST["aprice"],"goods_remark" => $_POST["remark"]);
 			$editResult = GoodsProvider::getInstance()->UpdateGoods( $_POST["goodsId"], $editArray);
 			echo json_encode($editResult);
 			break;
 		case "Del":
 			$delresult = GoodsProvider::getInstance()->DeleteGoods($_POST["goodsId"]);
 			echo json_encode($delresult);
 			break;
 	}
?>