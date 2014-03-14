<?php
	require_once('../../common.php');
	require_once(DATACONTROL . '/BMAccount/IsLogin.php');
//	require_once(DATACONTROL . '/BMAccount/IsRights.php');

	require_once('UtilsProvider.php');
 	require_once(DATACONTROL . '/ServerManager/ServerManageProvider.php'); 
	
	if (empty($_POST)) $_POST = $_GET;
	
	$methods = $_POST["method"];
	
 	switch($methods)
 	{
 		case "bulletin": //发布公告
 			$msg_type	= $_POST['msg_type']; //公告类型
 			$content	= $_POST['content'];  //公告内容
 			$server		= $_POST['server'];
 			echo json_encode(swjtUtilsProvider::mentodsBulletin($msg_type,$content,$server));
 			break;
 		case "itemGrant"://发放道具物品
 			break;
 		case "forbidplayer"://封禁账号
 			$is_forbid		= $_POST['is_forbid'];
 			$forbid_date	= $_POST['forbid_date'];
 			if($forbid_date != 1)
 				$forbid_date = strtotime($forbid_date);
 			else
 				$forbid_date = "0";
 			$user_name		= $_POST['user_name'];
 			$reason			= $_POST['reason'];
 			$server			= $_POST['server'];
 			echo json_encode(swjtUtilsProvider::mentodsForbidPalyer($user_name,$is_forbid,$forbid_date,$reason,$server));
 			break;
 		case "forbidip"://封禁Ip
 			$is_forbid		= $_POST['is_forbid'];
 			$forbid_date	= $_POST['forbid_date'];
 			if($forbid_date != 1)
 				$forbid_date = strtotime($forbid_date);
 			else
 				$forbid_date = "-1";
 			$ip				= $_POST['ip'];
 			$server			= $_POST['server'];
 			echo json_encode(swjtUtilsProvider::mentodsForbidIP($ip,$is_forbid,$forbid_date,$server));
 			break;
 		case "kickplayer"://踢人
 			$user_name		= $_POST['user_name'];
 			$kick_all		= $_POST['kick_all'];
 			$server			= $_POST['server'];
 			echo json_encode(swjtUtilsProvider::mentodsKickPlayer($user_name,$kick_all,$server));
 			break;
 		case "banchat"://禁言/解封
 			$user_name		= $_POST['user_name'];
 			$is_ban			= $_POST['is_ban'];
 			$ban_date		= $_POST['ban_date'];
 			$server			= $_POST['server'];
 			$forbid_date=0;
 			if($ban_date!=0)
 			{
 				$forbid_date = strtotime($ban_date);
 			}
 			echo json_encode(UtilsProvider::mentodsBanChatPlayer($user_name,$is_ban,$forbid_date,$server));
 			break;
 		case "forbid"://禁登/解封
 			$user_name		= $_POST['user_name'];
 			$is_forbid		= $_POST['is_forbid'];
 			$ban_date		= $_POST['forbid_date'];
 			$server			= $_POST['server'];
 			$forbid_date=0;
 			if($ban_date!=0)
 			{
 				$forbid_date = strtotime($ban_date);
 			}
 			echo json_encode(UtilsProvider::mentodsForbidPlayer($user_name,$is_forbid,$forbid_date,$server));
 			break;
 			
 		case "forbidbyid"://禁登
 			$user_id		= $_POST['user_id'];
 			$server			= $_POST['server'];
 			$forbid_date = strtotime(date('Y-m-d',strtotime('200 day')));
 			echo json_encode(UtilsProvider::mentodsForbidPlayerbyId($user_id,$forbid_date,$server));
 			break;
 		case "gameinstructor"://指导员身份设置
 			$user_name		= $_POST['user_name'];
 			$type			= $_POST['type'];
 			$instructor_type= $_POST['instructor_type'];
 			$start_stamp	= $_POST['start_stamp'];
 			if($start_stamp == 1)
 				$start_stamp = time();
 			else
 				$start_stamp = strtotime($start_stamp);
 			$end_stamp		= $_POST['end_stamp'];
 			if($end_stamp == 1)
 				$end_stamp = time();
 			else
 				$end_stamp = strtotime($end_stamp);
 			$server			= $_POST['server'];
 			echo json_encode(swjtUtilsProvider::mentodsGameInstructor($user_name,$type,$instructor_type,$start_stamp,$end_stamp,$server));
 			break;
 		case "loginPlayer"://后台登录玩家账号
 			$user_name		= $_POST['user_name'];
 			$server			= $_POST['server'];
 			echo json_encode(swjtUtilsProvider::mentodsLoginPlayer($user_name,$server));
 			break;
 		case "user_info_detail":
 			$user_id		= "";//$_POST['user_id'];
 			$user_name		= "";//$_POST['user_name'];
 			$account		= "eva";//$_POST['account'];
 			$server			= "1";//$_POST['server'];
 			echo json_encode(swjtUtilsProvider::mentodsSearchOnePlayer($user_id,$user_name,$account,$server));
 			break;
 		case "system_send_mail"://发放系统邮件
 			$userinfo		= $_POST['userinfo'];
 			$title			= $_POST['title'];
 			$reamark		= $_POST['reamark'];
 			$action			= $_POST['action'];
 			$min_lev		= $_POST['min_lev'];
 			$max_lev 		= $_POST['max_lev'];
 			$server			= $_POST['server'];
 			echo json_encode(swjtUtilsProvider::mentodsSendSystemMail($userinfo,$action,$min_lev,$max_lev,$title,$reamark,$server));
 			break;
 	}
?>