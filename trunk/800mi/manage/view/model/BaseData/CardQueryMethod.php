<?php
	include_once("../../common.php");  
	require_once(DATACONTROL . '/BMAccount/IsLogin.php');
 	require_once(DATACONTROL . '/BMAccount/CardProvider.php'); 
 	require_once(DATAMODEL . '/BMAccount/CardMDL.php');
 	
 	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "info":
 			$type 	 = $_POST["type"];
 			$cardNum = "";
 			$cardPWD = $_POST["txt"];
 			if($type  == 1){
 				$cardNum = $_POST["txt"];
 				$cardPWD = "";
 			}
 			echo json_encode(CardProvider::getInstance()->SearchCardinfo($cardNum,$cardPWD));
 			break;
 	}
?>