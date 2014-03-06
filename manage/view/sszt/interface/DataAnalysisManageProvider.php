<?php
require_once( DATALIB . '/SqlResult.php');
require_once(DATALIB . '/DynamicSqlHelper.php');

/**
 * 神武九天 运营分析数据函数类，直接访问游戏从库查询统计
 * @author 4399
 *
 */
class DataAnalysisManageProvider
{
	private static $instance;
	private function __construct(){}

	public static function getInstance()
	{
		if(self::$instance == null)
		{
			self::$instance = new DataAnalysisManageProvider();
		}
		return self::$instance;
	}	
	
	/**
	 * 服务器流失率统计
	 * @param unknown_type $startTime
	 * @param unknown_type $endTime
	 * @param unknown_type $serverId
	 * 返回:0=完成创建角色的人数,1=到达第一次加载页面的人数,2=到达创建角色页面的人数,3=完成创建角色的人数
	 * 4=完成load主程序,5=进入游戏的人数,6=第一次加载流失率,7=创建角色流失率,8=进入游戏流失率
	 * 9=总流失,10=点击欢迎窗口,11=完成首个任务
	 */
	public static function dataMentods_ErosionrateServer($startTime,$endTime,$serverID)
	{
		if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 $serverName = $serverDBinfo["serverName"];
 		 	
 		 /** 不建议以下这种蛋疼的写法，但是应要求要用mysql语句一句一句执行，建议改写成存储过程，利于维护
 		  * 以下四个客户端自己计算流失公式
 		  * ($r_step2 - $r_step3) / $r_step2  第一次加载流失率
 		  * ($r_step3 - $r_step4) / $r_step3 创建角色流失率
 		  * ($r_step4 - $r_step6) / $r_step4 进入游戏流失率
 		  * ($r_step2 - $r_step6) / $r_step2 总流失
 		  */
 		$sql_step1 = "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_click_link WHERE log_time >= '".$startTime."' AND log_time <= '".$endTime."'";//开始访问服务器的人数
 		$sql_step2 = "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_page_load WHERE log_time >= '".$startTime."' AND log_time <= '".$endTime."'"; //到达第一次加载页面的人数
 		$sql_step3 = "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_tempt_to_create_role WHERE log_time >= '".$startTime."' AND log_time <= '".$endTime."'";//到达创建角色页面的人数
 		$sql_step4 = "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_create_role_success WHERE log_time >= '".$startTime."' AND log_time <= '".$endTime."'";//完成创建角色的人数
 		$sql_step5 = "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_finish_load WHERE log_time >= '".$startTime."' AND log_time <= '".$endTime."'";//完成load主程序
 		$sql_step6 = "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_enter_game WHERE log_time >= '".$startTime."' AND log_time <= '".$endTime."'";//进入游戏的人数
 		$sql_step7 = "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_welcome WHERE log_time >= '".$startTime."' AND log_time <= '".$endTime."'";//-- 点击欢迎窗口
 		$sql_step8 = "SELECT IFNULL(COUNT(DISTINCT user_id), 0) FROM t_log_task WHERE task_id = 11001 AND TYPE = 10003 AND log_time >= '".$startTime."' AND log_time <= '".$endTime."'";//完成首个任务
		
 		$r_step1 = sql_fetch_oneDyn($sql_step1,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		$r_step2 = sql_fetch_oneDyn($sql_step2,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		$r_step3 = sql_fetch_oneDyn($sql_step3,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		$r_step4 = sql_fetch_oneDyn($sql_step4,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		$r_step5 = sql_fetch_oneDyn($sql_step5,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		$r_step6 = sql_fetch_oneDyn($sql_step6,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		$r_step7 = sql_fetch_oneDyn($sql_step7,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		$r_step8 = sql_fetch_oneDyn($sql_step8,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
		
 		$ary = Array();
 		if(!empty($r_step1)) $ary[] = $r_step1[0];
 		else	$ary[] = -1;
 		if(!empty($r_step2)) $ary[] = $r_step2[0];
 		else	$ary[] = -1;
 		if(!empty($r_step3)) $ary[] = $r_step3[0];
 		else	$ary[] = -1;
 		if(!empty($r_step4)) $ary[] = $r_step4[0];
 		else	$ary[] = -1;
 		if(!empty($r_step5)) $ary[] = $r_step5[0];
 		else	$ary[] = -1;
 		if(!empty($r_step6)) $ary[] = $r_step6[0];
 		else	$ary[] = -1;
 		if(!empty($r_step7)) $ary[] = $r_step7[0];
 		else	$ary[] = -1;
 		if(!empty($r_step8)) $ary[] = $r_step8[0];
 		else	$ary[] = -1;
 		$ary[] = $serverName;
		
 		return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$ary);
	}
	
	
	/**
	 * 查看即时服务器的在线情况
	 * @param unknown_type $dateTime
	 * @param unknown_type $serverID
	 */
	public static function dataMentods_onlineManageNumber($dateTime,$serverID)
	{
		 if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $sql = 'SELECT log_time,online FROM t_log_online WHERE  DATE(FROM_UNIXTIME(log_time)) = DATE("'.$dateTime.'") ORDER BY log_time';
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	$returnArry = Array();
 		 	$returnArry[] = $r;
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$returnArry);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,NULL,NULL,NULL);
	}
	
	/**
	 * 查询日在线情况
	 * @param unknown_type $startTime 时间戳
	 * @param unknown_type $endTime   时间戳
	 * @param unknown_type $serverID
	 */
	public static function dataMentods_dailyOnlineManageNumber($startTime,$endTime,$serverID)
	{
		if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 
 		 $sql = 'SELECT DATE(FROM_UNIXTIME(log_time)),  MAX(online),FLOOR(AVG(online)) ,MIN(online) FROM t_log_online ';
 		 $sql.= 'WHERE log_time >="'.$startTime.'" AND log_time <= "'.$endTime.'" GROUP BY DATE(FROM_UNIXTIME(log_time));';
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	$returnArry = Array();
 		 	$returnArry[] = $r;
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$returnArry);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,NULL,NULL,NULL);
	}
	
	/**
	 * 任务流失统计
	 * @param unknown_type $startTime  时间戳
	 * @param unknown_type $endTime    时间戳
	 * @param unknown_type $serverID
	 * 返回  任务id，接受次数 ，完成次数 ，流失数
	 */
	public static function dataMentods_taskRateManage($startTime,$endTime,$serverID)
	{
		if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];

 		 $sql = 'SELECT A.task_id,
 		 		A.accept_count,IFNULL(B.finish_count, 0),
 				A.accept_count - IFNULL(B.finish_count, 0),
 		 		( A.accept_count - IFNULL(B.finish_count, 0) ) / A.accept_count 
				FROM 
				(SELECT task_id, COUNT(DISTINCT user_id) AS accept_count FROM t_log_task  
				WHERE TYPE = 10001 AND log_time >= "'.$startTime.'" AND log_time <= "'.$endTime.'" 
				GROUP BY task_id) AS A LEFT JOIN  
				(SELECT task_id, COUNT(DISTINCT user_id) AS  finish_count FROM t_log_task  
				WHERE TYPE = 10003 AND log_time >= "'.$startTime.'" AND log_time <= "'.$endTime.'" 
				GROUP BY task_id) AS B ON A.task_id = B.task_id';
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,NULL,NULL,NULL);
	}
	
	/**
	 * 在线时长流失统计
	 * @param unknown_type $startTime  时间戳
	 * @param unknown_type $endTime   时间戳
	 * @param unknown_type $serverID  时间戳
	 * 返回  字段时间名，人数，占比
	 */
	public static function dataMentods_onlineTimeRateManage($startTime,$endTime,$serverID)
	{
		if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $sql = "SELECT ELT(INTERVAL(A.total_online, 0, 60, 180, 300, 600, 1800, 3600, 86400000), '1...0-1分钟', '2...1-3分钟','3...3-5分钟','4...5-10分钟','5...10-30分钟','6...30-60分钟','7...60分钟以上') AS online_area,
 		 			COUNT(A.user_id) AS 人数, COUNT(A.user_id) / (SELECT COUNT(role_id) FROM t_log_create_role_success WHERE log_time >= '".$startTime."' AND log_time <= '".$endTime."') AS '占比'  FROM  
 		 			(  SELECT A.user_id, SUM(B.online_time) AS total_online FROM t_log_create_role_success A LEFT JOIN  
 		 			t_log_in_out B ON A.user_id = B.role_id	 
 		 			WHERE A.log_time >= '".$startTime."' AND A.log_time <= '".$endTime."' AND  
 		 			B.login_time >= '".$startTime."' AND B.login_time <= '".$endTime."' 
 		 			GROUP BY A.user_id 
 		 			) AS A 
 		 			GROUP BY ELT(INTERVAL(A.total_online, 0, 60, 180, 300, 600, 1800, 3600, 86400000), '...0-1分钟', '...1-3分钟','...3-5分钟','...5-10分钟','...10-30分钟','...30-60分钟','...60分钟以上')";
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,NULL,NULL,NULL);
	}
	
	/**
	 * 在线时段分布  以天为单位，累计在线时长
	 * @param unknown_type $startTime 时间戳
	 * @param unknown_type $endTime   时间戳
	 * @param unknown_type $serverID
	 */
	public static function dataMentods_onlineTimeIntervalRateManage($startTime,$endTime,$serverID)
	{
		if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $sql = "SELECT ELT(INTERVAL(A.total_online, 0, 60, 180, 300, 600, 1800, 3600, 86400000), '1...0-1分钟', '2...1-3分钟','3...3-5分钟','4...5-10分钟','5...10-30分钟','6...30-60分钟','7...60分钟以上') AS online_area, 
 		 		COUNT(A.role_id) AS 人数, COUNT(A.role_id) / (SELECT COUNT(DISTINCT role_id) FROM t_log_in_out WHERE login_time >= '".$startTime."' AND login_time <= '".$endTime."') AS '占比'  FROM  
 		 		( SELECT role_id, SUM(online_time) AS total_online FROM t_log_in_out WHERE login_time >= '".$startTime."' AND login_time <= '".$endTime."'  
 		 		GROUP BY role_id 
 		 		) AS A  
 		 		GROUP BY ELT(INTERVAL(A.total_online, 0, 60, 180, 300, 600, 1800, 3600, 86400000), '...0-1分钟', '...1-3分钟','...3-5分钟','...5-10分钟','...10-30分钟','...30-60分钟','...60分钟以上')";
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
	}
	
	/**
	 * 留存统计 
	 * @param unknown_type $dataTime 登陆日  时间戳
	 * @param unknown_type $serverID
	 */
	public static function dataMentods_dayRemainManage($beginDate,$endDate,$serverID)
	{
		if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 $sql = "SELECT GROUP_CONCAT(DAY ORDER BY day),GROUP_CONCAT(num ORDER BY day) ,FROM_UNIXTIME(timer)  FROM t_log_onlineduration where timer >= ".$beginDate." and timer <= ".$endDate."  group by timer ORDER BY timer;";
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
 		 	
 		 
	}
	
	/**
	 * 商城出售物品统计 
	 * @param unknown_type $startTime
	 * @param unknown_type $endTime
	 * @param unknown_type $serverID
	 * @param unknown_type $shopType 1=商城 2=神秘商城 3=功勋商店4=优惠商品 5 =其它
	 */
	public static function dataMentods_shopSellingItem($startTime,$endTime,$serverID,$shopType)
	{
		switch($shopType)
		{
			case 1:
				return self::dataMentods_mallSellingItem(16,$startTime,$endTime,$serverID);
				break;
			case 2:
				return self::dataMentods_mallSellingItem(24,$startTime,$endTime,$serverID);
				break;
			case 3:
				return self::dataMentods_mallSellingItem(14,$startTime,$endTime,$serverID);
				break;
			case 4:
				return self::dataMentods_mallSellingItem(18,$startTime,$endTime,$serverID);
				break;
			case 5:
				return self::dataMentods_otherSellingItem($startTime,$endTime,$serverID);
				break;
			default:
				return new DataResult(ResultStateLevel::ERROR,"errorType",NULL,NULL);
				break;
		}
	}
	
	/**
	 * 
	 * @param $startTime 起始时间
	 * @param $endTime 结束时间
	 * @param $serverID 服务器
	 * @param $nickName 玩家角色名
	 */
	public static function dataMentods_playerYuanbaoLog($startTime,$endTime,$serverID,$nickName)
	{
		if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $sql = "SELECT id FROM sszt_game.t_users WHERE nick_name = '".$nickName."';";
 		 
 		 $r = sql_fetch_one_cellDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 
 		 $sql1 = "SELECT yuanbao ,bind_yuanbao ,is_consume, type, template_id , amount ,level,FROM_UNIXTIME(utime) FROM  sszt_admin.t_log_yuanbao";
 		 $con = " WHERE user_id = ".$r;
 		 
		 if($startTime != 0)
 		 {
 		 	$con .= " AND utime >=  ".$startTime;
 		 }
		 if($endTime != 0)
 		 {
 		 	$con .= " AND utime <=  ".$endTime;
 		 }
 		 $sql1 .= $con." ORDER BY `utime` desc";
// 		 return new DataResult(ResultStateLevel::ERROR,"".$sql1,-1,NULL);
 		 $r1 = sql_fetch_rowsDyn($sql1,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r1);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,'null data'.$r1,NULL,NULL);
	}
	
	/**
	 * 玩家物品日志查询
	 * @param $startTime 起始时间
	 * @param $endTime 结束时间
	 * @param $serverID 服务器
	 * @param $nickName 玩家角色名
	 * @param $itemID 物品ID
	 * @param $itemType 操作类型
	 */
	public static function dataMentods_playerItemLog($startTime,$endTime,$serverID,$nickName,$itemID,$templateID,$itemType)
	{
		if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $sql = "SELECT id FROM sszt_game.t_users WHERE nick_name = '".$nickName."';";
 		 
 		 $r = sql_fetch_one_cellDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 
 		 $sql1 = "SELECT a.template_id ,a.item_id ,b.name, a.type, a.amount , a.usenum ,FROM_UNIXTIME(a.time) FROM  sszt_admin.t_log_items a, sszt_template.t_item_template b";
 		 $con = " WHERE a.template_id = b.template_id and user_id = ".$r;
 		 if($itemID != 0)
 		 {
 		 	$con .= " AND item_id =  ".$itemID;
 		 }
		 if($templateID != 0)
 		 {
 		 	$con .= " AND a.template_id =  ".$templateID;
 		 }
 		 if($itemType != 0)
 		 {
 		 	$con .= " AND type =  ".$itemType;
 		 }
		 if($startTime != 0)
 		 {
 		 	$con .= " AND time >=  ".$startTime;
 		 }
		 if($endTime != 0)
 		 {
 		 	$con .= " AND time <=  ".$endTime;
 		 }
 		 $sql1 .= $con." ORDER BY `time` desc";
// 		 return new DataResult(ResultStateLevel::ERROR,"".$sql1,-1,NULL);
 		 
 		 $r1 = sql_fetch_rowsDyn($sql1,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r1);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
	}
		
	/**
	 * 日活动参与度统计（功能（系统）参与度）
	 * @param unknown_type $dateTime  日  时间戳
	 * @param unknown_type $serverID
	 * 返回  活动名称=0, 开始时间（hh：mm：ss）=1,截止时间=2，可进入人数 =3， 实际进入人数=4，完成活动的玩家=5，参与度=6
	 */
	public static function dataMentods_activeParticipationCount($dateTime,$serverID)
	{
		if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $endTime = $dateTime +  86400;
 		 $sql = "SELECT T_C.system AS '系统', DATE_FORMAT(FROM_UNIXTIME(T_C.start_time),'%T') AS '开始时间', DATE_FORMAT(FROM_UNIXTIME(T_C.end_time),'%T') AS '结束时间', T_C.can_enter_user AS '可进入玩家数',
 		 		T_C.enter_count '实际进入玩家数', T_D.finish_count AS '完成活动玩家数', T_C.enter_count / T_C.can_enter_user AS '用户参与度' FROM
 		 		(SELECT A.system,A.start_time, A.end_time, MAX(A.user_count) AS can_enter_user, COUNT(DISTINCT user_id) AS enter_count FROM t_log_can_join_activity_count A LEFT JOIN t_log_activity B ON
 		 		A.activity_id = B.activity_id WHERE A.log_time >= '".$dateTime."' AND A.log_time <= '".$endTime."' AND B.log_time >= A.start_time AND B.log_time <= A.end_time AND B.action_type = 1
 		 		GROUP BY A.system, A.start_time, A.end_time) AS T_C LEFT JOIN
 		 		(SELECT A.system,A.start_time, A.end_time,  COUNT(DISTINCT user_id) AS finish_count FROM t_log_can_join_activity_count A LEFT JOIN t_log_activity B ON
 		 		A.activity_id = B.activity_id WHERE A.log_time >= '".$dateTime."' AND A.log_time <= '".$endTime."' AND B.log_time >= A.start_time AND B.log_time <= A.end_time AND B.action_type = 3
 		 		GROUP BY A.system, A.start_time, A.end_time) AS T_D ON T_D.system = T_C.system AND T_D.start_time = T_C.start_time";
 		
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
	}
	
	/**
	 * 活跃用户=在固定周期内有登录≥2次的用户
	 * @param unknown_type $dateTime   在这一天登陆过的玩家  时间戳
	 * @param unknown_type $serverID
	 * 返回：活跃天数2天，活跃天数3天，活跃天数7天，活跃天数14天
	 */
	public static function dataMentods_livelyUserCount($dateTime,$serverID) 
	{
		 if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $endTime1 = $dateTime + 2 * 24 * 3600;
 		 $endTime2 = $dateTime + 3 * 24 * 3600;
 		 $endTime3 = $dateTime + 7 * 24 * 3600;
 		 $endTime4 = $dateTime + 14 * 24 * 3600;
 		 $sql1 = "SELECT COUNT(role_id) FROM 
				(SELECT role_id, COUNT(DISTINCT FROM_UNIXTIME(login_time)) AS login_days FROM t_log_in_out WHERE login_time >= '".$dateTime."' AND login_time <= '".$endTime1."' GROUP BY role_id) AS A 
				WHERE A.login_days >= 2";
 		 $sql2 = "SELECT COUNT(role_id) FROM 
				(SELECT role_id, COUNT(DISTINCT FROM_UNIXTIME(login_time)) AS login_days FROM t_log_in_out WHERE login_time >= '".$dateTime."' AND login_time <= '".$endTime2."' GROUP BY role_id) AS A 
				WHERE A.login_days >= 2";
 		 $sql3 = "SELECT COUNT(role_id) FROM 
				(SELECT role_id, COUNT(DISTINCT FROM_UNIXTIME(login_time)) AS login_days FROM t_log_in_out WHERE login_time >= '".$dateTime."' AND login_time <= '".$endTime3."' GROUP BY role_id) AS A 
				WHERE A.login_days >= 2";
 		 $sql4 = "SELECT COUNT(role_id) FROM 
				(SELECT role_id, COUNT(DISTINCT FROM_UNIXTIME(login_time)) AS login_days FROM t_log_in_out WHERE login_time >= '".$dateTime."' AND login_time <= '".$endTime4."' GROUP BY role_id) AS A 
				WHERE A.login_days >= 2";
 		 
 		 $r_result1 = sql_fetch_oneDyn($sql1,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 $r_result2 = sql_fetch_oneDyn($sql2,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 $r_result3 = sql_fetch_oneDyn($sql3,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 $r_result4 = sql_fetch_oneDyn($sql4,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 
 		 $ary = Array();
 		 if(!empty($r_result1)) $ary[] = $r_result1[0];
 		 else	$ary[] = -1;
 		 if(!empty($r_result2)) $ary[] = $r_result2[0];
 		 else	$ary[] = -1;
 		 if(!empty($r_result3)) $ary[] = $r_result3[0];
 		 else	$ary[] = -1;
 		 if(!empty($r_result4)) $ary[] = $r_result4[0];
 		 else	$ary[] = -1;
 		
 		 return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$ary);
	}
	
	/**
	 * 货币产出统计
	 * @param unknown_type $startTime 时间戳  精确到秒
	 * @param unknown_type $endTime   时间戳  精确到秒
	 * @param unknown_type $serverID
	 * @param unknown_type $moneyType 货币类型 1 = 元宝，2=铜钱，3=礼金
	 * 返回 产出类型名称，产出类型ID，数量，次数 ，参与人数，人均产量
	 */
	public static function dataMentods_investmentMoneyCount($startTime,$endTime,$serverID,$moneyType)
	{
		$sql = '';
		switch($moneyType)
		{
			case 1://元宝
				$sql = "SELECT A.change_reason AS '产出来源', A.produce AS '产出数量', A.produce_count AS '产出次数', A.users AS '参与该货币产出人数',  A.produce / A.users AS '人均产出数量' FROM 
					(
					SELECT change_reason, SUM(change_count) AS produce, COUNT(id) AS produce_count, COUNT(DISTINCT user_id) AS users FROM t_log_add_del_yuanbao WHERE  log_time >= '".$startTime."'AND log_time <= '".$endTime."'   AND change_count > 0 GROUP BY change_reason
					) AS A ORDER BY A.produce DESC";
				break;
			case 2://铜钱
				$sql = "SELECT A.change_reason AS '产出来源', A.produce AS '产出数量', A.produce_count AS '产出次数', A.users AS '参与该货币产出人数',  A.produce / A.users AS '人均产出数量' FROM 
						(
						SELECT change_reason, SUM(change_count) AS produce, COUNT(id) AS produce_count, COUNT(DISTINCT user_id) AS users FROM t_log_add_del_copper WHERE log_time >= '".$startTime."'AND log_time <= '".$endTime."' AND change_count > 0 GROUP BY change_reason
						) AS A ORDER BY A.produce DESC";
				break;
			case 3://礼金
				$sql = "SELECT A.change_reason AS '产出来源', A.produce AS '产出数量', A.produce_count AS '产出次数', A.users AS '参与该货币产出人数',  A.produce / A.users AS '人均产出数量' FROM 
						(
						SELECT change_reason, SUM(change_count) AS produce, COUNT(id) AS produce_count, COUNT(DISTINCT user_id) AS users FROM t_log_add_del_liquan WHERE  log_time >= '".$startTime."'AND log_time <= '".$endTime."' AND change_count > 0 GROUP BY change_reason
						) AS A ORDER BY A.produce DESC";
				break;
			default:
				return new DataResult(ResultStateLevel::ERROR,"errorType",NULL,NULL);
				break;
		}
		
		if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 			$ary = Array();
 			$define_doneTypeArray = enumerationDefine::Define_GameDoneType_name();
 			foreach($r as $k=>$v){
 				$o = Array();
				if(!isset($define_doneTypeArray[$v[0]]))
					$o[] = "";
				else
					$o[] = $define_doneTypeArray[$v[0]];
				$o[] = $v[0];
				$o[] = $v[1];
				$o[] = $v[2];
				$o[] = $v[3];
				$o[] = $v[4];
 				$ary[] = $o;
 			}
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$ary);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
	}
	
	/**
	 * 消费点分布统计（按消费总数倒叙排列）
	 * @param unknown_type $startTime 时间戳
	 * @param unknown_type $endTime
	 * @param unknown_type $serverID
	 * 返回：消费点名称,消费点ID，消费总数，消费次数，消费人数
	 */
	public static function dataMentods_consumeCount($startTime,$endTime,$serverID)
	{
		 if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $sql_total = "SELECT -SUM(change_count) FROM t_log_add_del_yuanbao WHERE log_time >= '".$startTime."' AND log_time < '".$endTime."' AND change_count < 0";
 		 
 		 $sql = "SELECT change_reason AS '消费点', -SUM(change_count) AS '消费总数', COUNT(id) AS '消费次数', COUNT(DISTINCT user_id) AS '消费人数' FROM t_log_add_del_yuanbao
				WHERE log_time >= '".$startTime."' AND log_time < '".$endTime."' AND change_count < 0 GROUP BY change_reason ORDER BY -SUM(change_count) DESC";
 		 
 		 $r_total = sql_fetch_rowsDyn($sql_total,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 $r 	  = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 
 		 $consume_Total = -1;
 		 if(!empty($r_total)) 
 		 	$consume_Total = $r_total[0];
 		  if(!empty($r))
 		 {
 			$ary = Array();
 			$define_doneTypeArray = enumerationDefine::Define_GameDoneType_name();
 			foreach($r as $k=>$v){
 				$o = Array();
				if(!isset($define_doneTypeArray[$v[0]]))
					$o[] = "";
				else
					$o[] = $define_doneTypeArray[$v[0]];
				$o[] = $v[0];
				$o[] = $v[1];
				$o[] = $v[2];
				$o[] = $v[3];
 				$ary[] = $o;
 			}
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,$consume_Total,$ary);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",$consume_Total,NULL);
	}
	
	/**
	 * 查询单个人货币日志  ----货币类型 1 = 元宝，2=铜钱，3=礼金
	 * @param unknown_type $moneyType 货币类型 1 = 元宝，2=铜钱，3=礼金
	 * @param unknown_type $startTime 时间戳
	 * @param unknown_type $endTime
	 * @param unknown_type $serverID
	 * @param unknown_type $account
	 * @param unknown_type $nickName
	 * @param unknown_type $offer
	 * @param unknown_type $pageSize
	 * 返回  原元宝0，变更数量1，新元宝2，变更原因3，发生时间4
	 */
	public static function dataMentods_searchPlayerYuanbaoLog($moneyType,$startTime,$endTime,$serverID,$account,$nickName,$offer, $pageSize)
	{
		 if(empty($account) && empty($nickName))
		 	return new DataResult(ResultStateLevel::ERROR,"请输入要查询的玩家账号或者主角名！",-1,NULL);
		 if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $sqlWhere = '';
 		 $sql = '';
 		 $sqlCount = '';
 		 if(!empty($account))
 		 	$sqlWhere = " AND a.user_name ='".$account."'";
 		 if(!empty($nickName))
 			$sqlWhere = " AND a.nick_name ='".$nickName."'";
 		 switch($moneyType)
 		 {
 		 	case 1:
 		 		$sql = "SELECT b.origin_yuan_bao AS '原元宝', b.change_count AS '变更数量', b.new_yuan_bao AS '新元宝', b.change_reason AS '变更原因',FROM_UNIXTIME(b.log_time)";
 		 		$sql.= " FROM red_moon_game.t_users a,red_moon_log.t_log_add_del_yuanbao b";
 				$sql.= " WHERE a.id = b.user_id ".$sqlWhere." AND b.log_time >='".$startTime."' AND b.log_time <= '".$endTime."' ORDER BY b.log_time DESC  LIMIT $offer, $pageSize";
 		 		$sqlCount = "SELECT COUNT(*) as num FROM red_moon_game.t_users a,red_moon_log.t_log_add_del_yuanbao b  WHERE a.id = b.user_id ".$sqlWhere." AND b.log_time >='".$startTime."' AND b.log_time <= '".$endTime."' ORDER BY b.log_time";
 				break;
 		 	case 2:
 		 		$sql = "SELECT b.origin_copper AS '原铜钱', b.change_count AS '变更数量', b.new_copper AS '新铜钱', b.change_reason AS '变更原因',FROM_UNIXTIME(b.log_time) ";
 		 		$sql.= " FROM red_moon_game.t_users a,red_moon_log.t_log_add_del_copper b";
 		 		$sql.= " WHERE a.id = b.user_id ".$sqlWhere." AND b.log_time >='".$startTime."' AND b.log_time <= '".$endTime."' ORDER BY b.log_time DESC  LIMIT $offer, $pageSize";
 		 		$sqlCount = "SELECT COUNT(*) as num FROM red_moon_game.t_users a,red_moon_log.t_log_add_del_copper b  WHERE a.id = b.user_id ".$sqlWhere." AND b.log_time >='".$startTime."' AND b.log_time <= '".$endTime."' ORDER BY b.log_time";
 		 		break;
 		 	case 3:
 		 		$sql = "SELECT b.origin_li_quan AS '原礼金', b.change_count AS '变更数量', b.new_li_quan AS '新礼金', b.change_reason AS '变更原因',FROM_UNIXTIME(b.log_time) ";
 		 		$sql.= " FROM red_moon_game.t_users a,red_moon_log.t_log_add_del_liquan b";
 		 		$sql.= " WHERE a.id = b.user_id ".$sqlWhere." AND b.log_time >='".$startTime."' AND b.log_time <= '".$endTime."' ORDER BY b.log_time DESC  LIMIT $offer, $pageSize";
 		 		$sqlCount = "SELECT COUNT(*) as num FROM red_moon_game.t_users a,red_moon_log.t_log_add_del_liquan b  WHERE a.id = b.user_id ".$sqlWhere." AND b.log_time >='".$startTime."' AND b.log_time <= '".$endTime."' ORDER BY b.log_time";
 		 		break;
 		 	default:
 		 		return new DataResult(ResultStateLevel::ERROR,"errorType",NULL,NULL);
 		 		break;
 		 }

 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
   		 if(!empty($r)){
   		 	$ary = Array();
 			$define_doneTypeArray = enumerationDefine::Define_GameDoneType_name();
 			foreach($r as $k=>$v){
 				$o = Array();
 				$o[] = $v[4];
				if(!isset($define_doneTypeArray[$v[3]]))
					$o[] = "";
				else
					$o[] = $define_doneTypeArray[$v[3]];
				$o[] = $v[0];
				$o[] = $v[1];
				$o[] = $v[2];
 				$ary[] = $o;
 			}
 			$count = sql_fetch_one_cellDyn($sqlCount,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port); 
 			return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$ary);
 		 }
 		 else{
 			return new DataResult(ResultStateLevel::ERROR,"暂无数据",$sql,NULL);
 		 } 	
	}
	
	
	/**
	 * 时间段内商城出售道具统计( 单个服按照物品总销售金额倒叙排列)
	 * @param unknown_type $startTime 时间戳
	 * @param unknown_type $endTime	  时间戳
	 * @param unknown_type $serverID
	 * 返回：物品 ID=0，购买数量=1，购买单价=2，购买人数=3，购买次数=4，消费总额=5，占比=6 ，物品名称=7
	 */
	private static function dataMentods_mallSellingItem($type,$startTime,$endTime,$serverID)
	{
		 if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $sql = "SELECT SUM(amount)  AS amount, COUNT(DISTINCT user_id) AS num, COUNT(1) times,SUM(yuanbao) AS yuanbao,SUM(bind_yuanbao)  AS bind_yuanbao  FROM  sszt_admin.t_log_yuanbao 
 		 WHERE  TYPE =".$type." and utime >= '".$startTime."' AND utime < '".$endTime."';
SELECT  a.template_id,b.name,SUM(amount)  AS amount, COUNT(DISTINCT user_id) AS num, COUNT(1) times,SUM(yuanbao) AS yuanbao,SUM(bind_yuanbao)  AS bind_yuanbao
FROM  sszt_admin.t_log_yuanbao a,sszt_template.t_item_template b  
WHERE TYPE =".$type." and utime >= '".$startTime."' AND utime < '".$endTime."' AND  a.template_id = b.template_id  GROUP BY a.template_id ORDER BY yuanbao DESC;";
 		 $r = sql_fetch_tablesDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
	}
	
	
	private static function dataMentods_otherSellingItem($startTime,$endTime,$serverID)
	{
		 if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $sql = "
 		 SELECT SUM(amount)  AS amount, COUNT(DISTINCT user_id) AS num, COUNT(1) times,SUM(yuanbao) AS yuanbao,SUM(bind_yuanbao)  AS bind_yuanbao  FROM  sszt_admin.t_log_yuanbao 
 		 WHERE type <100 and TYPE <> 12 and utime >= '".$startTime."' AND utime < '".$endTime."';
 		 SELECT TYPE,IF(TYPE=0, '无类型',IF(TYPE=1,'元宝商店购买',IF(TYPE=2,'原地复活',IF(TYPE=3,'元宝寄售',IF(TYPE=4,'购买寄售',IF(TYPE=5,'公会捐献',IF(TYPE=6,'使用玫瑰花',IF(TYPE=7,'发送邮件',IF(TYPE=8,'刷新坐骑技能',
IF(TYPE=9,'宠物洗髓',IF(TYPE=10,'刷新宠物技能',IF(TYPE=11,'立即完成江湖令任务',IF(TYPE=12,'清除穴位cd',IF(TYPE=13,'离线经验兑换',IF(TYPE=14,'副本商店购买',IF(TYPE=15,'委托任务元宝完成',IF(TYPE=16,'物品购买',
IF(TYPE=17,'背包扩展',IF(TYPE=18,'优惠商品出售',IF(TYPE=19,'淘宝消耗元宝',IF(TYPE=20,'重置副本消耗',IF(TYPE=21,'功勋商店购买',IF(TYPE=22,'切换资源战场阵营消耗',IF(TYPE=23,'神秘商店刷新',IF(TYPE=24,'神秘商店购买',
IF(TYPE=26,'任务直接完成',IF(TYPE=27,'兑换银两',IF(TYPE=28,'结婚消耗',IF(TYPE=29,'结婚送礼',IF(TYPE=30,'结婚发送喜糖',IF(TYPE=31,'强制离婚',IF(TYPE=31,'小妾提升为妻子',''))))))) ))))))))))))))))))))))))) AS typename,
SUM(amount)  AS amount, COUNT(DISTINCT user_id) AS num, COUNT(1) times,SUM(yuanbao) AS yuanbao,SUM(bind_yuanbao)  AS bind_yuanbao  FROM 	sszt_admin.t_log_yuanbao
 WHERE type <100 and TYPE <> 12  and utime >= '".$startTime."' AND utime < '".$endTime."' 
GROUP BY  TYPE ORDER BY yuanbao desc;";
 		 $r = sql_fetch_tablesDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
	}
	
	/**
	 * 时间段内神秘商城出售道具统计( 单个服按照物品总销售金额倒叙排列)
	 * @param unknown_type $startTime 时间戳
	 * @param unknown_type $endTime	  时间戳
	 * @param unknown_type $serverID
	 * 返回：物品 ID=0，购买数量=1，购买单价=2，购买人数=3，购买次数=4，消费总额=5，占比=6 ，物品名称=7
	 */
	private static  function dataMentods_mysteryMallSellingItem($startTime,$endTime,$serverID)
	{
		 if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $sql = "SELECT a.*,b.name FROM
 		 		(SELECT item_id AS item_id, COUNT(id) AS '购买数量', MAX(yb_count) AS '购买单价', COUNT(DISTINCT user_id) AS '购买人数',
 		 		COUNT(id) AS '购买次数', SUM(yb_count) AS '消费总额', SUM(yb_count) / (SELECT SUM(yb_count) FROM red_moon_log.t_log_mysterious_buy WHERE log_time >= '".$startTime."' AND log_time <= '".$endTime."') AS '占商城所有卖出物品的百分比' 
 		 		FROM red_moon_log.t_log_mysterious_buy
 		 		WHERE  log_time >= '".$startTime."' AND log_time <= '".$endTime."'
 		 		GROUP BY item_id ORDER BY SUM(yb_count) DESC) AS a  LEFT JOIN red_moon_config.t_item_template b ON a.item_id = b.template_id";
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
	}
	
	/**
	 * 时间段内帮派商城出售道具统计( 单个服按照物品总销售金额倒叙排列)
	 * @param unknown_type $startTime 时间戳
	 * @param unknown_type $endTime	  时间戳
	 * @param unknown_type $serverID
	 * 返回：物品 ID=0，购买数量=1，购买单价=2，购买人数=3，购买次数=4，消费总额=5，占比=6 ，物品名称=7
	 */
	private static  function dataMentods_guildMallSellingItem($startTime,$endTime,$serverID)
	{
		 if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $sql = "SELECT a.*,b.name FROM
 		 		(SELECT item_id AS item_id, SUM(item_num) AS '购买数量', MAX(cost / item_num) AS '购买单价', COUNT(DISTINCT user_id) AS '购买人数',
 		 		COUNT(id) AS '购买次数', SUM(cost) AS '消费总额', SUM(cost) / (SELECT SUM(cost) FROM t_log_guild_shop WHERE log_time >= '".$startTime."' AND log_time <= '".$endTime."') AS '占商城所有卖出物品的百分比'
 		 		FROM red_moon_log.t_log_guild_shop
 		 		WHERE  log_time >= '".$startTime."' AND log_time <= '".$endTime."'
 		 		GROUP BY item_id ORDER BY SUM(cost) DESC) AS a LEFT JOIN red_moon_config.t_item_template b ON a.item_id = b.template_id  ";
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
	}
	
	/**
	 * 通天塔商城购买统计( 单个服按照物品总销售金额倒叙排列)
	 * @param unknown_type $startTime 时间戳
	 * @param unknown_type $endTime	  时间戳
	 * @param unknown_type $serverID
	 * 返回：物品 ID=0，购买数量=1，购买单价=2，购买人数=3，购买次数=4，消费总额=5，占比=6 ，物品名称=7
	 */
	private static function dataMentods_towerMallSellingItem($startTime,$endTime,$serverID)
	{
		if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $sql = "SELECT a.*,b.name FROM
 		 		(SELECT item_id AS item_id, SUM(item_num) AS '购买数量', MAX(price) AS '购买单价', COUNT(DISTINCT user_id) AS '购买人数', 
 		 		COUNT(id) AS '购买次数', SUM(cost) AS '消费总额', SUM(cost) / (SELECT SUM(cost) FROM t_log_tower_buy WHERE log_time >= '".$startTime."' AND log_time <= '".$endTime."') AS '占商城所有卖出物品的百分比'  
 		 		FROM red_moon_log.t_log_tower_buy
 		 		WHERE  log_time >= '".$startTime."' AND log_time <= '".$endTime."'
 		 		GROUP BY item_id ORDER BY SUM(cost) DESC) AS a LEFT JOIN red_moon_config.t_item_template b ON a.item_id = b.template_id  ";
 		 
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
	}
	
	
	/**获取服务器数据库连接信息
	 * $serverId
	 */
	private static function getServerConnDBLogById($serverID)
	{
		$sql_check = "SELECT bm_ServerConnString,bm_ServerName FROM bm_gameserver WHERE bm_ServerID = " .$serverID ;
 		$r_check = sql_fetch_one($sql_check);
 		$returnAry = Array();
 		if($r_check == ""){
 			$returnAry = Array("ret"=>false);
 		}
 		else
 		{
 			$servAry = json_decode($r_check[0],true);
 			$returnAry = Array("ret"=>true,
 							   "IP"=>$servAry['log']['logIP'],
 							   "user"=>$servAry['log']['logUser'],
 							   "pwd"=>$servAry['log']['logPSW'],
 							   "name"=>$servAry['log']['logDataName'],
 							   "port"=>$servAry['log']['port'],
 							   "serverName"=>$r_check[1]);
 		}
 		return $returnAry;
	}
	
	
	
	public static function dataMentods_searchQPayLog($startTime,$serverID,$offer, $pageSize)
	{
		 if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 $Year = date('Y',$startTime);
 		 $Month = date('m',$startTime);
 		 $Day = date('d',$startTime);
 		 $sqlWhere = ' year= '.$Year.' and month='.$Month.' and day='.$Day;
 		 $sql = '';
 		 $sqlTotal = '';
 		 $sqlCount = '';
 		
 		 $sql = "SELECT pay_amt  ,payamt_coins,pubacct_payamt_coins,FROM_UNIXTIME( pay_time),account_name FROM t_user_pay_qq where ".$sqlWhere ." order by id desc LIMIT ".$offer.",". $pageSize;
  		
 		$sqlTotal = "SELECT SUM(pay_amt)  AS pay_amt,SUM(payamt_coins) AS pay_amt,SUM(pubacct_payamt_coins) AS pay_amt FROM t_user_pay_qq WHERE ".$sqlWhere;
 		$sqlCount = "SELECT count(1) FROM t_user_pay_qq WHERE ".$sqlWhere;
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
   		 if(!empty($r)){
   		 	$ary = Array();
 		 	$ary[] = $r;
 		 	
 			$r1 = sql_fetch_rowsDyn($sqlTotal,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port); 
 			$ary[] = $r1;
 			$count = sql_fetch_one_cellDyn($sqlCount,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port); 
 			
 			return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$ary);
 		 }
 		 else{
 			return new DataResult(ResultStateLevel::ERROR,"暂无数据",$sql,NULL);
 		 } 	
	}
	
	/**
	 * 查询ARPU值
	 * @param unknown_type $startTime 时间戳
	 * @param unknown_type $endTime	  时间戳
	 * @param unknown_type $serverID
	 * 
	 */
	public static function dataMentods_searchARPU($startTime,$endTime,$serverID)
	{
		if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		
 		 $sql = "SELECT FROM_UNIXTIME(log_time),regist_count, max_online, avg_online, login_user, pay_amt, payamt_coins, pubacct_payamt_coins, pay_user_count, pay_times, log_time  FROM t_log_arpu 
 		 		WHERE  log_time >= ".$startTime." AND log_time <= ".$endTime."  ORDER BY  log_time";
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
	}
	
	/**
	 *  查询及时数据
	 * @param $startTime
	 * @param $endTime
	 * @param $server
	 */
	public static function dataMentods_searchtimely($startTime,$endTime,$server)
	{
		$serverAry = explode(",", $server);
		if( $serverAry == false)
    	{
    		$serverAry = array($server);
    	}
    	$ary = Array();
    	foreach($serverAry as $serverID)
    	{
    		if(!empty($serverID)){
    			if(empty($serverID)) 
	 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
	 			$serverDBinfo = self::	getServerConnDBLogById($serverID);
	 			if(!$serverDBinfo["ret"]) return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
	 			$sql_IP	= $serverDBinfo["IP"];
		 		$sql_user	= $serverDBinfo["user"];
		 		$sql_pwd	= $serverDBinfo["pwd"];
		 		$sql_name	= $serverDBinfo["name"];
		 		$sql_port	= $serverDBinfo["port"];
		 		$sql = "SELECT COUNT(1) FROM  t_log_register WHERE  create_time >= ".$startTime." AND create_time <= ".$endTime." ;";
 		 		$sql .= "SELECT IF(SUM(pay_amt) IS NULL,0,SUM(pay_amt)/100)+ IF(SUM(payamt_coins) IS NULL,0,SUM(payamt_coins)/10)+IF(SUM(pubacct_payamt_coins) IS NULL,0,SUM(pubacct_payamt_coins)/10) as coins,COUNT(DISTINCT account_name) as num  FROM t_user_pay_qq  WHERE  pay_time >= ".$startTime." AND pay_time <= ".$endTime." ;";
 		 		$r = sql_fetch_tablesDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 		$ary[] = $r;
    		}
    	}
    	
    	if(!empty($ary)){
    		return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$ary);
    	}
    	else return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
	}
	
	
/**
	 * 查询用户信息
	 * @param unknown_type $startTime 时间戳
	 * @param unknown_type $endTime	  时间戳
	 * @param unknown_type $serverID
	 * 
	 */
	public static function dataMentods_searchUserInfo($serverID,$userName,$type)
	{
		if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		
 		 if($type==0)
 		 {
 		 	$sql = "SELECT id, nick_name, LEVEL, total_online_time,FROM_UNIXTIME(last_online_date), FROM_UNIXTIME(register_date), career, money, vip_id,yuan_bao, bind_yuan_bao, copper,bind_copper FROM sszt_game.t_users WHERE nick_name = '".$userName."';";
 		 }
		 else if($type==1)
 		 {
 		 	$sql = "SELECT id, nick_name, LEVEL, total_online_time,FROM_UNIXTIME(last_online_date), FROM_UNIXTIME(register_date), career, money, vip_id,yuan_bao, bind_yuan_bao, copper,bind_copper FROM sszt_game.t_users WHERE user_name = '".$userName."';";
 		 }
 		 else
 		 {
 		 	$sql = "SELECT id, nick_name, user_name,LEVEL,  money FROM sszt_game.t_users WHERE nick_name like '%".$userName."%';";
 		 }
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
	}
	
	public static function dataMentods_levelLostSearch($serverID,$startTime,$type)
	{
		 if(empty($serverID)) 
 			return new DataResult(ResultStateLevel::ERROR,"sorry，请刷新后再试！",-1,NULL);
 		 $serverDBinfo = self::	getServerConnDBLogById($serverID);
 		 if(!$serverDBinfo["ret"])
 		 	return new DataResult(ResultStateLevel::ERROR,"服务器不存在或被删除！",-1,NULL);
 		 
 		 $sql_IP	= $serverDBinfo["IP"];
 		 $sql_user	= $serverDBinfo["user"];
 		 $sql_pwd	= $serverDBinfo["pwd"];
 		 $sql_name	= $serverDBinfo["name"];
 		 $sql_port	= $serverDBinfo["port"];
 		 
 		 $sql = "SELECT IF (SUM(player_num) is null,0,SUM(player_num)) FROM  sszt_admin.t_log_level_loss 
 		 WHERE  TYPE =".$type." and utime = ".$startTime.";
SELECT  level,player_num
FROM  sszt_admin.t_log_level_loss WHERE TYPE =".$type." and utime = ".$startTime." order by level ;";
 		 $r = sql_fetch_tablesDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(!empty($r))
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,"null data",NULL,NULL);
	}
	
	
}
?>