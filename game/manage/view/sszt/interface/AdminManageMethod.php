<?php
/**
 * 操作数据库接口类
 */
require_once('../../common.php');
require_once(DATACONTROL . '/BMAccount/IsLogin.php');
//require_once(DATACONTROL . '/BMAccount/IsRights.php');
require_once('UtilsProvider.php');
require_once(DATACONTROL . '/ServerManager/ServerManageProvider.php'); 

if (empty($_POST)) $_POST = $_GET;
	
	$methods = $_POST["method"];
	
 	switch($methods)
 	{
 		case "itemApply": //道具发放申请
 			$title		= $_POST['title'];  //申请标题
 			$desc		= $_POST['desc'];   //申请说明
 			$remark		= $_POST['remark'];  //申请理由
 			$userType	= $_POST['userType'];  //发放类型 0=角色名  1=账号
 			$userInfo	= $_POST['userInfo'];  //账号 或者角色名  换行间隔
 			$condition	= $_POST['condition']; //账号条件  已是json格式
 			$moneyItem	= $_POST['moneyItem']; //货币物品， 已是json格式
 			$propItem	= $_POST['propItem'];  //道具物品 ，每个道具以','间隔 （ID|数量|绑定,ID|数量|绑定）
 			$server		= $_POST['server'];   //服务器
 			echo json_encode(UtilsProvider::dataMentods_insertApplyItem($title,$desc,$remark,$userType,$userInfo,$condition,$moneyItem,$propItem,$server));
 			break;
 		case "itemCheckPass": //通过审核
 			$applyId	 = $_POST['applyId'];
 			$applyRemark = $_POST['applyRemark'];
 			echo json_encode(UtilsProvider::dataMentods_updateApplyItem($applyId,$applyRemark));
 			break;
 		case "itemCheckUnPass":  //不通过审核
 			$applyId	 = $_POST['applyId'];
 			$applyRemark = $_POST['applyRemark'];
 			echo json_encode(UtilsProvider::dataMentods_unpassApplyItem($applyId,$applyRemark));
 			break;
 		case "itemApplyList": //道具申请发送列表
 			$areaId 	= $_POST['areaId'];
 			$server		= $_POST['server'];
 			$state		= $_POST['state'];
 			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 50;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$offer	  	= ($curPage - 1) * $pageSize;
			echo json_encode(UtilsProvider::dataMentods_ListApplyItem($areaId,$server,$state,$offer,$pageSize));
 			break;
 		case "systemMailList": //系统邮件列表
 			$startTime 	= $_POST['startTime'];
 			$ednTime	= $_POST['ednTime'];
 			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 50;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$offer	  	= ($curPage - 1) * $pageSize;
			echo json_encode(UtilsProvider::dataMentods_ListSystemMail($startTime,$ednTime,$offer,$pageSize));
 			break;
 		case "system_send_mail"://发放系统邮件
 			$userinfo		= $_POST['userinfo'];
 			$title			= $_POST['title'];
 			$reamark		= $_POST['reamark'];
 			$action			= $_POST['action'];
 			$min_lev		= $_POST['min_lev'];
 			$max_lev 		= $_POST['max_lev'];
 			$server			= $_POST['server'];
 			echo json_encode(UtilsProvider::mentodsSendSystemMail($userinfo,$action,$min_lev,$max_lev,$title,$reamark,$server));
 			break;
 		case "commonServerName": //根据服务器ID :1,2,3得到服务器名称
 			$server		= $_POST['server'];
 			echo json_encode(ServerManageProvider::getServerNameByServerIdString($server));
 			break;
 		case "reSendingSystemMail"://重新同步发送未成功的系统邮件
 			$mailId 	= $_POST['mailId'];
 			echo json_encode(UtilsProvider::dataMentods_ReSendSystemMail($mailId));
 			break;
 		case "newBulletinAdd": //公告发布，先操作数据库再请求网关，网关返回错误再更新数据库
 			$sendType	= intval($_POST['sendType']); 
 			$startTime 	= strtotime($_POST['startTime']);
 			$endTime	= strtotime($_POST['endTime']);
 			$interval	= intval($_POST['interval']); 
 			$content	= $_POST['content'];   
 			$server		= $_POST['server'];   //以','间隔，格式如下：1,2,3 
 			$area		= $_POST['area'];
 			echo json_encode(UtilsProvider::dataMentods_AddBulletin(1,$sendType,$startTime,$endTime,$interval,$content,$server,$area));
 			break;
 		case "bulletinList":  //公告列表 依据分区为依据
 			$startTime 	= $_POST['startTime'];
 			$ednTime	= $_POST['ednTime'];
 			$area		= $_POST['area'];
			echo json_encode(UtilsProvider::dataMentods_GetBulletinList($startTime,$ednTime,$area));
 			break;
 		case "bulletinServerInfo"://依据公告ID 得到此公告发送的服信息
 			$bulletinId = $_POST['bulletinId'];
 			echo json_encode(UtilsProvider::dataMentods_GetBulletinServerInfoByBulletinId($bulletinId));
 			break;
 		case "reSendingAllbulletin"://全部同步不更新内容
 			$bulletinId = $_POST['bulletinId'];
 			echo json_encode(UtilsProvider::dataMentods_updateBulletin($bulletinId,1,"","","","",""));
 			break;
 		case "newBulletinUpdate"://修改公告
 			$bulletinId = $_POST['bulletinId'];
 			$startTime 	= strtotime($_POST['startTime']);
 			$endTime	= strtotime($_POST['endTime']);
 			$desc		= $_POST['desc'];   
 			$interval	= $_POST['interval'];  
 			echo json_encode(UtilsProvider::dataMentods_updateBulletin($bulletinId,2,"",$startTime,$endTime,$interval,$desc));  
 			break;
 		case "newBulletinDelete":
 			$bulletinId = $_POST['bulletinId'];  
 			echo json_encode(UtilsProvider::dataMentods_updateBulletin($bulletinId,3,"","","","","")); 
 			break;
 		case "newBulletinDeleteone":
 			$bulletinId = $_POST['bulletinId'];  
 			$server		= $_POST['server'];
 			echo json_encode(UtilsProvider::dataMentods_updateBulletin($bulletinId,4,$server,"","","","")); 
 			break;
 	}
?>