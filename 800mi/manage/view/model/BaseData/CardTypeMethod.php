<?php
	include_once("../../common.php"); 
	require_once(DATACONTROL . '/BMAccount/IsLogin.php'); 
 	require_once(DATACONTROL . '/BMAccount/RightsProvider.php'); 
 	require_once(DATACONTROL . '/BMAccount/CardTypeProvider.php'); 
 	require_once(DATAMODEL . '/ServerManager/GameMDL.php'); 
 	require_once(DATAMODEL . '/ServerManager/GameAreaMDL.php');
 	require_once(DATAMODEL . '/ServerManager/GameServerMDL.php');
 	require_once(DATAMODEL . '/BMAccount/CardTypeMDL.php');
 	
 	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "game":
 			echo json_encode(RightsProvider::getInstance()->getGameData());
 			break;
 		case "Add":
 			$name = $_POST["name"];
 			$rict = $_POST["rict"];
 			$point = $_POST["point"];
 			$price = $_POST["price"];
 			$rank = $_POST["rank"];
 			$remark = $_POST["dec"];
 			$str = $_POST["str"];
 			echo json_encode(CardTypeProvider::getInstance()->AddCardType($name,$rict,$point,$price,$rank,$remark,$str));
 			break;
 		case "updateBase":
 			$editArray  = array("cd_CardTypeName" => $_POST["name"],
 								"cd_CardPoint" => $_POST["point"],"cd_CardPrice" => $_POST["price"],
 								"cd_CardTypeUnique" => $_POST["rank"],"cd_Remark" => $_POST["dec"]);
 			echo json_encode(CardTypeProvider::getInstance()->UpdateCardInfo($_POST["ID"],$editArray));
 			break;
 		case "updateLimit":
 			$rict = $_POST["rict"];
 			$str = $_POST["str"];
 			echo json_encode(CardTypeProvider::getInstance()->UpdateCardLimit($_POST["ID"],$rict,$str));
 			break;
 		case "del":
 			echo json_encode(CardTypeProvider::getInstance()->UpdateCardInfo($_POST["ID"],""));
 			break;
 		case "open":
 			echo json_encode(CardTypeProvider::getInstance()->openCardStart($_POST["ID"]));
 			break;
 		case "cardList":
			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 20;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$offer	  	= ($curPage - 1) * $pageSize;	
			$name 		= $_POST['name'];
 			$listResult = CardTypeProvider::getInstance()->ListCardType($offer,$pageSize,$name);
 			echo json_encode($listResult);
 			break;
 		case "oneFo":
 			echo json_encode(CardTypeProvider::getInstance()->GetCardTypeByCardID($_POST["ID"]));
 			break;
 		case "AllFo":
 			echo json_encode(CardTypeProvider::getInstance()->getCardAllInfoByCardID($_POST["ID"]));
 			break;
 	}
?>