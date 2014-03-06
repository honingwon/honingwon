<?php
	include_once("../../common.php"); 
	require_once(DATACONTROL . '/BMAccount/IsLogin.php'); 
 	require_once(DATACONTROL . '/BMAccount/RightsProvider.php'); 
 	require_once(DATAMODEL . '/ServerManager/GameMDL.php'); 
 	require_once(DATAMODEL . '/ServerManager/GameAreaMDL.php');
 	require_once(DATAMODEL . '/ServerManager/GameServerMDL.php');
 	
 	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "game":
 			echo json_encode(RightsProvider::getInstance()->getGameData());
 			break;
 		case "sRightList":
 			$Account = intval($_POST['ID']);
 			$listRightsList = RightsProvider::getInstance()->GetServerRightsByAccount($Account) ;
 			echo json_encode($listRightsList);
 			break;
 		case "sRightUpdate":
 			$Account = intval($_POST['ID']);
 			$updateRightsList = RightsProvider::getInstance()->UpdateServerRight($Account,$_POST['Add'],$_POST['Del']) ;
 			echo json_encode($updateRightsList);
 			break;
 		case "sModuleList":
 			$Account = intval($_POST['ID']);
 			echo json_encode(RightsProvider::getInstance()->GetModuleRightsByAccountID($Account));
 			break;
 		case "sModuleUpdate":
 			$Account = intval($_POST['ID']);
 			$str = $_POST['Add'];
 			$array = explode(",",$str);
 			$strAdd = "";
 			for($i=0;$i < count($array);$i++)
 			{
 				if($array[$i]!=""){
 					if($strAdd !="")
 					  $strAdd.=",";
 					 $strAdd.= "(".$Account.",".$array[$i].")";
 				}
 			}
 			$updateModuleList = RightsProvider::getInstance()->UpdateModuleRight($Account,$strAdd,$_POST['Del']) ;
 			echo json_encode($updateModuleList);
 			break;
 		case "sGroupList":
 			$Account = intval($_POST['ID']);
 			echo json_encode(RightsProvider::getInstance()->GetGroupInfoByAccount($Account));
 			break;
 		case "sAGUpdate":
 			$Account = intval($_POST['ID']);
 			echo json_encode(RightsProvider::getInstance()->UpdateAccountGroup($Account,$_POST['Add'],$_POST['Del']));
 			break;
 		case "sGModuleList":
 			$GroupID = intval($_POST['ID']);
 			echo json_encode(RightsProvider::getInstance()->GetGroupModuleRightsByGroup($GroupID));
 			break;
 		case "sGModuleUpdate":
 			$GroupID = intval($_POST['ID']);
 			$strG = $_POST['Add'];
 			$arrayG = explode(",",$strG);
 			$strGAdd = "";
 			for($i=0;$i < count($arrayG);$i++)
 			{
 				if($arrayG[$i]!=""){
 					if($strGAdd !="")
 					  $strGAdd.=",";
 					 $strGAdd.= "(".$GroupID.",".$arrayG[$i].")";
 				}
 			}
 			echo json_encode(RightsProvider::getInstance()->UpdateGroupMoudleRights($GroupID,$strGAdd,$_POST['Del']));
 			break;
 	}
?>