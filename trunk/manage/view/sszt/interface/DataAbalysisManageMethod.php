<?php
include_once("../../common.php");  
require_once(DATACONTROL . '/BMAccount/IsLogin.php');
//require_once(DATACONTROL . '/BMAccount/IsRights.php');
require_once('DataAnalysisManageProvider.php');
if (empty($_POST)) $_POST = $_GET;
//	echo'<SCRIPT language="JavaScript">window.alert("'.$_POST["method"].'");</SCRIPT>';	
	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	
 	switch($methods)
 	{
 		case "serverErosionRate": //加载流失率
 			$startTime	= $_POST['startTime'];	
 			$endTime	= $_POST['endTime'];	
 			$server		= $_POST['server'];			
 			echo json_encode(DataAnalysisManageProvider::dataMentods_ErosionrateServer(strtotime($startTime),strtotime($endTime),$server));
 			break;
 		case "serverTaskRate": //任务流失率
 			$startTime	= $_POST['startTime'];	
 			$endTime	= $_POST['endTime'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_taskRateManage(strtotime($startTime),strtotime($endTime),$server));
 			break;
 		case "serverOnlineTimeRate"://在线时间流失
 			$startTime	= $_POST['startTime'];	
 			$endTime	= $_POST['endTime'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_onlineTimeRateManage(strtotime($startTime),strtotime($endTime),$server));
 			break;
 		case "serverOnlineTimeIntervalRate": //在线时段分布
 			$startTime	= $_POST['startTime'];	
 			$endTime	= $_POST['endTime'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_onlineTimeIntervalRateManage(strtotime($startTime),strtotime($endTime),$server));
 			break;
 		case "serverDayRemain"://日留存统计
 			$beginDate	= $_POST['beginDate'];	
 			$endDate	= $_POST['endDate'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_dayRemainManage(strtotime($beginDate),strtotime($endDate),$server));
 			break;
 		case "mallSelling":  //商城销售情况，游戏商城、神秘商城、帮派商城、通天塔商城
 			$shopType   = $_POST['shopType'];
 			$startTime	= $_POST['startTime'];	
 			$endTime	= $_POST['endTime'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_shopSellingItem(strtotime($startTime),strtotime($endTime),$server,$shopType));
 			break;
 		case "playerItemLog":	//角色物品操作日志
 			$nickName	= $_POST['nickname'];	
 			$itemID		= $_POST['itemid'];	
 			$templateID = $_POST['templateid'];	
 			$itemType	= $_POST['itemtype'];	
 			$startTime	= $_POST['startTime'];	
 			$endTime	= $_POST['endTime'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_playerItemLog(strtotime($startTime),strtotime($endTime),$server,$nickName,$itemID,$templateID,$itemType));
 			break;
 		case "playerYuanbaoLog":	//角色元宝操作日志
 			$nickName	= $_POST['nickname'];	
 			$startTime	= $_POST['startTime'];	
 			$endTime	= $_POST['endTime'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_playerYuanbaoLog(strtotime($startTime),strtotime($endTime),$server,$nickName));
 			break;
 		case "activeParticipationCount": //系统活动参与度统计
 			$startTime	= $_POST['startTime'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_activeParticipationCount(strtotime($startTime),$server));
 			break;
 		case "livelyUserCount": //活跃用户  =在固定周期内有登录≥2次的用户
 			$startTime	= $_POST['startTime'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_livelyUserCount(strtotime($startTime),$server));
 			break;
 		case "moneyInvestmentCount": //货币产出统计
 			$moneyType  = $_POST['moneyType'];
 			$startTime	= $_POST['startTime'];	
 			$endTime	= $_POST['endTime'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_investmentMoneyCount(strtotime($startTime),strtotime($endTime),$server,$moneyType));
 			break;
 		case "serverConsumeCount"://消费点分布
 			$startTime	= $_POST['startTime'];	
 			$endTime	= $_POST['endTime'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_consumeCount(strtotime($startTime),strtotime($endTime),$server));
 			break;
 		case "moneyUseLog":  //货币更改日志
 			$startTime	= $_POST['startTime'];	
 			$endTime	= $_POST['endTime'];	
 			$server		= $_POST['server'];	
 			$account	= $_POST['account'];	
 			$nickname	= $_POST['nickname'];	
 			$moneyType  = $_POST['moneyType'];
 			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 50;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$offer	  	= ($curPage - 1) * $pageSize;
 			echo json_encode(DataAnalysisManageProvider::dataMentods_searchPlayerYuanbaoLog($moneyType,strtotime($startTime),strtotime($endTime),$server,$account,$nickname,$offer,$pageSize));
 			break;
 			
 		case "qpaysearch":  //Q点充值查询
 			$startTime	= $_POST['startTime'];	
 			$server		= $_POST['server'];	
 			$pageSize 	= intval($_POST['pagesize']) ? intval($_POST['pagesize']) : 50;
			$curPage  	= intval($_POST['curpage'])  ? intval($_POST['curpage'])  : 1;
			$offer	  	= ($curPage - 1) * $pageSize;
 			echo json_encode(DataAnalysisManageProvider::dataMentods_searchQPayLog(strtotime($startTime),$server,$offer,$pageSize));
 			break;
 			
 		case "searchArpu"://查询arpu值统计
 			$startTime	= $_POST['startTime'];	
 			$endTime	= $_POST['endTime'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_searchARPU(strtotime($startTime),strtotime($endTime),$server));
 			break;
 		case "searchtimely"://查询及时数据
 			$startTime	= $_POST['startTime'];	
 			$endTime	= $_POST['endTime'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_searchtimely(strtotime($startTime),strtotime($endTime) + 3600*24,$server));
 			break;
 		case "searchuserinfo"://查询用户数据
 			$type	= $_POST['type'];	
 			$userName	= $_POST['username'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_searchUserInfo($server,$userName,$type));
 			break;
 		case "levelLostSearch":  //商城销售情况，游戏商城、神秘商城、帮派商城、通天塔商城
 			$type   = $_POST['type'];
 			$startTime	= $_POST['startTime'];	
 			$server		= $_POST['server'];	
 			echo json_encode(DataAnalysisManageProvider::dataMentods_levelLostSearch($server,strtotime($startTime),$type));
 			break;
 	}
?>