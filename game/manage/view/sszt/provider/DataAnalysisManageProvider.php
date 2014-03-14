<?php
require_once( DATALIB . '/SqlResult.php');
require_once(DATALIB . '/DynamicSqlHelper.php');



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
 		 
 		 $sql = 'SELECT log_time,online FROM t_log_online WHERE  DATE(FROM_UNIXTIME(log_time)) = DATE("'.$dateTime.'") ORDER BY log_time desc LIMIT 0,60;
 		 SELECT log_time,online FROM t_log_online WHERE  DATE(FROM_UNIXTIME(log_time)) = DATE("'.$dateTime.'") ORDER BY online desc LIMIT 0,1;
 		 ';
 		 $r = sql_fetch_tablesDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 if(count($r)>0)
 		 {
 		 	return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$r);
 		 }
 		 else
 		 	return new DataResult(ResultStateLevel::ERROR,NULL,NULL,NULL);
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
	public static function dataMentods_dayRemainManage($dataTime,$serverID)
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
 		 
 		 ////////////////////建议改成脚本执行////////////////////////////////////////////////////
 		 $endTime = $dataTime + 3600 * 24; // totime
 		 $one_day_startTime = $dataTime + 1 * 24 * 3600;
 		 $one_day_endTime	= $endTime + 1 * 24 * 3600;
 		 $two_day_startTime = $dataTime + 2 * 24 * 3600;
 		 $two_day_endTime	= $endTime + 2 * 24 * 3600;
 		 $three_day_startTime = $dataTime + 3 * 24 * 3600;
 		 $three_day_endTime	= $endTime + 3 * 24 * 3600;
 		 $four_day_startTime = $dataTime + 4 * 24 * 3600;
 		 $four_day_endTime	= $endTime + 4 * 24 * 3600;
 		 $five_day_startTime = $dataTime + 5 * 24 * 3600;
 		 $five_day_endTime	= $endTime + 5 * 24 * 3600;
 		 $six_day_startTime = $dataTime + 6 * 24 * 3600;
 		 $six_day_endTime	= $endTime + 6 * 24 * 3600;
 		 $seven_day_startTime = $dataTime + 7 * 24 * 3600;
 		 $seven_day_endTime	= $endTime + 7 * 24 * 3600;
 		 $fifteen_day_startTime = $dataTime + 15 * 24 * 3600;
 		 $fifteen_day_endTime	= $endTime + 15 * 24 * 3600;
 		 $sql_GameNumber = "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_in_out WHERE login_time >= '".$dataTime."' AND login_time <= '".$endTime."'";  //当日进入游戏的总人数
 		 $sql_GameNew	= "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_enter_game WHERE log_time >= '".$dataTime."'  AND log_time <= '".$endTime."'"; ///*计算日新增活跃*/
 		 $sql_remain1	= "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_in_out WHERE login_time >= '".$one_day_startTime."' AND login_time <= '".$one_day_endTime."' AND  
							user_name IN ( SELECT DISTINCT user_name FROM t_log_enter_game WHERE log_time >= '".$dataTime."' AND log_time <= '".$endTime."' )";
 		 $sql_remain2	= "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_in_out WHERE login_time >= '".$two_day_startTime."' AND login_time <= '".$two_day_endTime."' AND 
							user_name IN ( SELECT DISTINCT user_name FROM t_log_enter_game WHERE log_time >= '".$dataTime."' AND log_time <= '".$endTime."' )";
 		 $sql_remain3	= "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_in_out WHERE login_time >= '".$three_day_startTime."' AND login_time <= '".$three_day_endTime."' AND 
							user_name IN ( SELECT DISTINCT user_name FROM t_log_enter_game WHERE log_time >= '".$dataTime."' AND log_time <= '".$endTime."' )";
 		 $sql_remain4	= "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_in_out WHERE login_time >= '".$four_day_startTime."' AND login_time <= '".$four_day_endTime."' AND 
							user_name IN ( SELECT DISTINCT user_name FROM t_log_enter_game WHERE log_time >= '".$dataTime."' AND log_time <= '".$endTime."' )";
 		 $sql_remain5	= "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_in_out WHERE login_time >= '".$five_day_startTime."' AND login_time <= '".$five_day_endTime."' AND 
							user_name IN ( SELECT DISTINCT user_name FROM t_log_enter_game WHERE log_time >= '".$dataTime."' AND log_time <= '".$endTime."' )";
 		 $sql_remain6	= "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_in_out WHERE login_time >= '".$six_day_startTime."' AND login_time <= '".$six_day_endTime."' AND 
							user_name IN ( SELECT DISTINCT user_name FROM t_log_enter_game WHERE log_time >= '".$dataTime."' AND log_time <= '".$endTime."' )";
 		 $sql_remain7	= "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_in_out WHERE login_time >= '".$seven_day_startTime."' AND login_time <= '".$seven_day_endTime."' AND 
							user_name IN ( SELECT DISTINCT user_name FROM t_log_enter_game WHERE log_time >= '".$dataTime."' AND log_time <= '".$endTime."' )";
 		 $sql_remain15	= "SELECT IFNULL(COUNT(DISTINCT user_name), 0) FROM t_log_in_out WHERE login_time >= '".$fifteen_day_startTime."' AND login_time <= '".$fifteen_day_endTime."' AND 
							user_name IN ( SELECT DISTINCT user_name FROM t_log_enter_game WHERE log_time >= '".$dataTime."' AND log_time <= '".$endTime."' )";
 		 
 		 $r_GameNumber = sql_fetch_oneDyn($sql_GameNumber,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 $r_GameNew = sql_fetch_oneDyn($sql_GameNew,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 $r_remain1 = sql_fetch_oneDyn($sql_remain1,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 $r_remain2 = sql_fetch_oneDyn($sql_remain2,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 $r_remain3 = sql_fetch_oneDyn($sql_remain3,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 $r_remain4 = sql_fetch_oneDyn($sql_remain4,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 $r_remain5 = sql_fetch_oneDyn($sql_remain5,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 $r_remain6 = sql_fetch_oneDyn($sql_remain6,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 $r_remain7 = sql_fetch_oneDyn($sql_remain7,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 $r_remain15 = sql_fetch_oneDyn($sql_remain15,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
 		 
 		 $ary = Array();
 		 if(!empty($r_GameNumber)) $ary[] = $r_GameNumber[0];
 		 else	$ary[] = -1;
 		 if(!empty($r_GameNew)) $ary[] = $r_GameNew[0];
 		 else	$ary[] = -1;
 		 
 		 if(!empty($r_remain1)) $ary[] = $r_remain1[0];
 		 else	$ary[] = -1;
 		 if(!empty($r_remain2)) $ary[] = $r_remain2[0];
 		 else	$ary[] = -1;
 		 if(!empty($r_remain3)) $ary[] = $r_remain3[0];
 		 else	$ary[] = -1;
 		 if(!empty($r_remain4)) $ary[] = $r_remain4[0];
 		 else	$ary[] = -1;
 		 if(!empty($r_remain5)) $ary[] = $r_remain5[0];
 		 else	$ary[] = -1;
 		 if(!empty($r_remain6)) $ary[] = $r_remain6[0];
 		 else	$ary[] = -1;
 		 if(!empty($r_remain7)) $ary[] = $r_remain7[0];
 		 else	$ary[] = -1;
 		 if(!empty($r_remain15)) $ary[] = $r_remain15[0];
 		 else	$ary[] = -1;
 		 return new DataResult(ResultStateLevel::SUCCESS,NULL,NULL,$ary);
	}
	
	/**
	 * 商城出售物品统计 
	 * @param unknown_type $startTime
	 * @param unknown_type $endTime
	 * @param unknown_type $serverID
	 * @param unknown_type $shopType 1=商城 2=神秘商城 3=帮派商城 4=通天塔商城
	 */
	public static function dataMentods_shopSellingItem($startTime,$endTime,$serverID,$shopType)
	{
		switch($shopType)
		{
			case 1:
				return self::dataMentods_mallSellingItem($startTime,$endTime,$serverID);
				break;
			case 2:
				return self::dataMentods_mysteryMallSellingItem($startTime,$endTime,$serverID);
				break;
			case 3:
				return self::dataMentods_guildMallSellingItem($startTime,$endTime,$serverID);
				break;
			case 4:
				return self::dataMentods_towerMallSellingItem($startTime,$endTime,$serverID);
				break;
			default:
				return new DataResult(ResultStateLevel::ERROR,"errorType",NULL,NULL);
				break;
		}
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
	private static function dataMentods_mallSellingItem($startTime,$endTime,$serverID)
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
 		 		(SELECT item_template_id AS item_id, SUM(item_count) AS '购买数量', MAX(money_count / item_count) AS '购买单价', COUNT(DISTINCT user_id) AS '购买人数',
 		 		COUNT(id) AS '购买次数', SUM(money_count) AS '消费总额', SUM(money_count) / (SELECT SUM(money_count) FROM red_moon_log.t_log_buy_item WHERE log_time >= '".$startTime."' AND log_time <= '".$endTime."' AND money_type = 2) AS '占商城所有卖出物品的百分比' 
 		 		FROM red_moon_log.t_log_buy_item
 		 		WHERE  log_time >= '".$startTime."' AND log_time <= '".$endTime."' AND money_type = 2
 		 		GROUP BY item_template_id ORDER BY SUM(money_count) DESC) AS a  LEFT JOIN red_moon_config.t_item_template b ON a.item_id = b.template_id ";
 		 $r = sql_fetch_rowsDyn($sql,$sql_IP,$sql_user,$sql_pwd,$sql_name,"log_".$serverID,$sql_port);
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
}
?>