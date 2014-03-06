<?php
/**
 * 游戏分区，游戏服务器对外提供的方法
 */
	include_once("../../common.php");
	require_once(DATACONTROL . '/BMAccount/IsLogin.php');
	require_once(DATACONTROL . '/BMAccount/RightsProvider.php');
	
	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "area": //依据游戏ID获得当前登录账号游戏分区权限信息
 			$gameID = $_POST['ID'];
 			echo json_encode(RightsProvider::getInstance()->GetAccountAreaRights($gameID));
 			break;
 		case "server"://依据游戏ID获得当前登录账号游戏服务器权限信息
 			$gameID = $_POST['ID'];
 			echo json_encode(RightsProvider::getInstance()->GetCurrentAccountServerRights($gameID));
 			break;
 	}
?>