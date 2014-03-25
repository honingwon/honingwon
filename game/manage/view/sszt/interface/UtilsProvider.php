<?php
require_once(DATALIB . '/SqlResult.php');
require_once('SnsNetwork.php');


class UtilsProvider
{
	private static $instance;
	private function __construct(){}

	public static function getInstance()
	{
		if(self::$instance == null)
		{
			self::$instance = new UtilsProvider();
		}
		return self::$instance;
	}
	
	
	/***** 公告  start ******/
	/**
	 * 发送公告
	 * @param unknown_type $msgType
	 * @param unknown_type $sendType
	 * @param unknown_type $startTime
	 * @param unknown_type $endTime
	 * @param unknown_type $interval
	 * @param unknown_type $content
	 * @param unknown_type $server
	 * @param unknown_type $area
	 */
	public static function dataMentods_AddBulletin($msgType,$sendType,$startTime,$endTime,$interval,$content,$server,$area)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['user']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1"); 
    	}
    	$accountName = $_SESSION['user'];
    	$time = date("Y-m-d H:i:s");
    	
    	$bulletinState = 0; //公告默认发送状态是成功的
    	$sql_insert = "INSERT INTO bm_bulletin(bm_BulletinTypeID,bm_BulletinState,bm_BulletinDesc,bm_Account,bm_BulletinCreatTime,bm_startTime,bm_endTime,bm_interval,bm_logDesc,bm_AreaID)";
    	$sql_insert.= ' values('.$sendType.',0,"'.$content.'","'.$accountName.'","'.$time.'","'.$startTime.'","'.$endTime.'",'.$interval.',"",'.$area.')';
    	$insertID = sql_insert($sql_insert);
    	if($insertID)
    	{
    		$isSuccessRequset = true; //网关请求是否异常  默认正常
    		$isSuccessDBdata  = true; //操作数据请求请求是否异常  默认正常
    		$serverAry = explode(",", $server);
    		if( $serverAry == false)
    		{
    			$serverAry = array($server);
    		}
    		//////////////////////////////请求网关发送公告	
    		foreach($serverAry as $val){
				if(!empty($val)){
					$quest_Result = self::mentodsSendingBulletin($insertID,1,$sendType,$startTime,$endTime,$interval,$content,$val);
					$bulletinServerState = 0;//默认是成功
					if(!empty($quest_Result->Tag))
					{
						$bulletinServerState = 1; //需要同步
						$isSuccessRequset = false;
					}
					$sql_insertServer = 'INSERT INTO bm_bulletingameserver(bm_BulletinID,bm_ServerID,bm_state) values('.$insertID.','.$val.','.$bulletinServerState.')';
					$r = sql_insert($sql_insertServer);
    				if($r == 0){
    						logManageErrorDBdate("Error：sql:".$sql_insertServer);
    						$isSuccessDBdata = false;
    				}
				}
			}
			/////////////////////////////网关发送结果处理，不给精确提示，可以通过日志查看	
			if($isSuccessRequset && $isSuccessDBdata)	
					return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
			else{
				if(!$isSuccessRequset && $isSuccessDBdata)
					$bulletinState = 1;
				if($isSuccessRequset && !$isSuccessDBdata)
					$bulletinState = 2;
				if(!$isSuccessRequset && !$isSuccessDBdata)
					$bulletinState = 3;
				$sql_update = 'UPDATE bm_bulletin SET bm_BulletinState = '.$bulletinState.'  WHERE bm_BulletinID = '.$insertID;
				$result_update = sql_query($sql_update);
 				if($result_update != 0){
    				return new ExcuteResult(ResultStateLevel::SUCCESS,"部分公告请求发送时出现异常，请查看公告列表以确认",1);
    			}
    			else
    	  			return new ExcuteResult(ResultStateLevel::EXCEPTION,"公告发送时出现异常，更新公告基础数据也失败，请通知管理人员查看那日志以及数据状态！",NULL);
			}
	
//			$quest_Result = self::sendSysMsg($insertID,$msgType,$sendType,$startTime,$endTime,$interval,$content,$server);
//			return  $quest_Result;
    	}
    	else
    		return new ExcuteResult(ResultStateLevel::ERROR,"insert 公告基础数据失败",NULL);
    }
    
    
 
    /**
     * 获取公告类表
     * @param unknown_type $startTime  公告创建时间
     * @param unknown_type $endTime    公告结束时间
     * @param unknown_type $areaID     运营代理商
     * 返回 分区0，公告类型1，公告ID2，公告状态3，公告内容4，账号5，创建时间6，开始时间7，截止时间8，时间间隔9，错误日志10
     */
    public static function dataMentods_GetBulletinList($startTime,$endTime,$areaID)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1"); 
    	}
    	$accountId = $_SESSION['account_ID'];
    	
    	$sql = 'SELECT DISTINCT a.bm_AreaID AS areaId,b.bm_BulletinTypeID,b.bm_BulletinID,b.bm_BulletinState,b.bm_BulletinDesc,b.bm_Account,b.bm_BulletinCreatTime,FROM_UNIXTIME(b.bm_startTime),FROM_UNIXTIME(b.bm_endTime),b.bm_interval,b.bm_logDesc';
    	
    	$sqlWhere = ' FROM bm_accountgameserver a LEFT JOIN bm_bulletin b ON a.bm_AreaID = b.bm_AreaID WHERE a.bm_AccountID = '.$accountId.' AND a.bm_AreaID= '.$areaID;
    	if($startTime != "")
    		$sqlWhere.= '  AND b.bm_BulletinCreatTime >= "'.$startTime.'"';
    	if($endTime != "")
    		$sqlWhere.= '  AND b.bm_BulletinCreatTime <= "'.$endTime.'"';
    		
    	$sql.= $sqlWhere."  ORDER BY bm_BulletinCreatTime DESC";
    	
    	$r = sql_fetch_rows($sql);
    	
    	if(!empty($r)){
 			return new DataResult(ResultStateLevel::SUCCESS,"1",NULL,$r);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"暂无数据",$sql,NULL);
 		} 
    }
    
   /**
     * 获取指定公告的服发送列表
     * @param unknown_type $bulletinId
     */
    public static  function dataMentods_GetBulletinServerInfoByBulletinId($bulletinId)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1"); 
    	}
    	
    	$sql = "SELECT a.bm_ServerID,b.bm_ServerName,a.bm_state,a.bm_BulletinID FROM bm_bulletingameserver a,bm_gameserver b WHERE a.bm_ServerID = b.bm_ServerID AND a.bm_BulletinID = ".$bulletinId." ORDER BY a.bm_state DESC";
    	$r = sql_fetch_rows($sql);
    	
    	if(!empty($r)){
 			return new DataResult(ResultStateLevel::SUCCESS,"1",NULL,$r);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 		} 
    	
    }
    
    
	/**
     * 公告修改，删除  ，同步 =1 全部同步，=2 修改 3=删除，4=删除一个服的某条公告
     * @param unknown_type $bulletinId
     * @param unknown_type $doType
     * @param unknown_type $serverId
     * @param unknown_type $startTime
     * @param unknown_type $endTime
     * @param unknown_type $Interval
     * @param unknown_type $bulletinDesc
     */
    public static function dataMentods_updateBulletin($bulletinId,$doType,$serverId,$startTime,$endTime,$Interval,$bulletinDesc)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['user']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1"); 
    	}
    	$accountName = $_SESSION['user'];
    	
    	$sql_search = 'SELECT bm_BulletinID,bm_BulletinTypeID,bm_BulletinDesc,bm_startTime,bm_endTime,bm_interval,bm_BulletinState,bm_logDesc FROM bm_bulletin WHERE bm_BulletinID ='.$bulletinId;
    	$r = sql_fetch_one($sql_search);
    	if(empty($r))
    		return new ExcuteResult(ResultStateLevel::ERROR,"公告不存在","-1"); 
    		
    	$time = date("Y-m-d H:i:s");
    	switch($doType)
    	{
    		case 1: //全部同步
    			return self::dataMentods_updateBulletin_allSending($bulletinId,$r[1],$r[3],$r[4],$r[5],$r[2]);
    			break;
    		case 2://更新内容后再执行同步
    			if($startTime == $r[3] && $endTime == $r[4] && $Interval == $r[5] && $bulletinDesc == $r[2])
    				return new ExcuteResult(ResultStateLevel::ERROR,"公告信息没有发生任何改变，不能提交请求",NULL);
   				$logDesc = $sql_search[7].$accountName." 在".$time." 修改了公告信息<br/>";
    			return self::dataMentods_updateBulletin_reSending($bulletinId,$r[1],$startTime,$endTime,$Interval,$bulletinDesc,$logDesc);
    			break;
    		case 3://删除
    			$logDesc = $sql_search[7].$accountName." 在".$time." 删除了公告信息<br/>";
    			return self::dataMentods_updateBulletin_delSending($bulletinId,"",$r[1],$r[3],$r[4],$r[5],$r[2],$logDesc);
    			break;
    		case 4: //删除某个服务器的公告（已经发布成功的公告）
    			$logDesc = $sql_search[7].$accountName." 在".$time." 删除了服：".$serverId."的公告<br/>";
    			return self::dataMentods_updateBulletin_delSending($bulletinId,$serverId,$r[1],$r[3],$r[4],$r[5],$r[2],$logDesc);
    			break;
    		default:
    			return new ExcuteResult(ResultStateLevel::ERROR,"error_done_Type",NULL);
    			break;
    	}
    }
    
    
      /**
     * 对于全部发布正常的公告进行一次修改 然后同步更新到所有相关服
     * @param unknown_type $bulletinId
     * @param unknown_type $bulletinType
     * @param unknown_type $startTime
     * @param unknown_type $endTime
     * @param unknown_type $Interval
     * @param unknown_type $bulletinDes
     */
    private static function dataMentods_updateBulletin_reSending($bulletinId,$bulletinType,$startTime,$endTime,$Interval,$bulletinDes,$logDesc)
    {
    	$sql_server = 'SELECT a.bm_ServerID,a.bm_state FROM bm_bulletingameserver a,bm_gameserver b WHERE a.bm_ServerID = b.bm_ServerID AND a.bm_state !=99  AND a.bm_BulletinID = '.$bulletinId;
    	$r_server = sql_fetch_rows($sql_server);
    	if(empty($r_server) || count($r_server) == 0){
    			return new ExcuteResult(ResultStateLevel::ERROR,"该公告没有指定服发送公告",NULL);
    	}
    	
    	$sql_update = 'UPDATE bm_bulletin SET bm_startTime = "'.$startTime.'", bm_endTime="'.$endTime.'",bm_interval="'.$Interval.'",bm_BulletinDesc="'.$bulletinDes.'",bm_logDesc="'.$logDesc.'",bm_BulletinState = 0';
    	$sql_update.= '  WHERE bm_BulletinID = '.$bulletinId;
    	$result_update = sql_query($sql_update);
    	if($result_update == 0){
    		return new ExcuteResult(ResultStateLevel::ERROR,"修改公告状态失败",NULL);
    	}
    	$isSuccessRequset = true; //网关请求是否异常  默认正常
    	$isSuccessDBdata  = true; //操作数据请求请求是否异常  默认正常
    	foreach($r_server as $k=>$v){
			 	$quest_Result = self::mentodsSendingBulletin($bulletinId,1,$bulletinType,$startTime,$endTime,$Interval,$bulletinDes,$v[0]);
			 	$serverStateOne = 0;
				if(empty($quest_Result->Tag))
				{
					if($v[1] == 0)
						continue;
				}
				else{
					$isSuccessRequset = false;
					$serverStateOne = 1;
					if($v[1] == 1)
						continue;
				}
    	        //修改公告信息后，向游戏服务器发送更改请求失败 更新
				$sql_updateServer = 'UPDATE bm_bulletingameserver SET bm_state ='.$serverStateOne.' WHERE bm_BulletinID ='.$bulletinId.' AND bm_ServerID ='.$v[0];
				$result_Serverupdate = sql_query($sql_updateServer);
 				if($result_Serverupdate == 0){
    				logManageErrorDBdate("Error：sql:".$sql_updateServer);
    				$isSuccessDBdata = false;
    			}
 		}
   	 	if($isSuccessRequset && $isSuccessDBdata)	
				return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
		else{
			$bulletinState = 0;
			if(!$isSuccessRequset && $isSuccessDBdata)
				$bulletinState = 1;
			if($isSuccessRequset && !$isSuccessDBdata)
				$bulletinState = 2;
			if(!$isSuccessRequset && !$isSuccessDBdata)
				$bulletinState = 3;
			$sql_update = 'UPDATE bm_bulletin SET bm_BulletinState = '.$bulletinState.'  WHERE bm_BulletinID = '.$bulletinId;
			$result_update = sql_query($sql_update);
 			if($result_update != 0){
    			return new ExcuteResult(ResultStateLevel::SUCCESS,"部分公告请求发送时出现异常，请查看公告列表以确认",1);
    		}
    		else
    	  		return new ExcuteResult(ResultStateLevel::SUCCESS,"公告发送时出现异常，更新公告基础数据也失败，请通知管理人员查看那日志以及数据状态！",NULL);
		}
    }
    
    
	/**
     * 对于上一次出现发送失败的公告进行同步一次
     * @param unknown_type $bulletinId
     */
    private static function dataMentods_updateBulletin_allSending($bulletinId,$bulletinType,$startTime,$endTime,$Interval,$bulletinDes)
    {
    	$sql_server = 'SELECT a.bm_ServerID FROM bm_bulletingameserver a,bm_gameserver b WHERE a.bm_ServerID = b.bm_ServerID AND a.bm_state =1 AND a.bm_BulletinID = '.$bulletinId;
    	$r_server = sql_fetch_rows($sql_server);
    	if(empty($r_server)){
    			return new ExcuteResult(ResultStateLevel::ERROR,"该公告正常不需要同步",NULL);
    	}
    	else{
    		$succNumber = 0;
    		$DBsucc = true;
    		foreach($r_server as $k=>$v){
			 	$quest_Result = self::mentodsSendingBulletin($bulletinId,1,$bulletinType,$startTime,$endTime,$Interval,$bulletinDes,$v[0]);
				if(empty($quest_Result->Tag))
				{
					$sql_updateServer = 'UPDATE bm_bulletingameserver SET bm_state =0 WHERE bm_BulletinID ='.$bulletinId.' AND bm_ServerID ='.$v[0];
					$result_Serverupdate = sql_query($sql_updateServer);
 					if($result_Serverupdate == 0){
    					logManageErrorDBdate("Error：sql:".$sql_updateServer);
    					$DBsucc = false;
    				}
    				$succNumber++;
				}
 			}
 			if(count($r_server) == $succNumber)
 			{
 				$sql_update = 'UPDATE bm_bulletin SET bm_BulletinState = 0  WHERE bm_BulletinID = '.$bulletinId;
				$result_update = sql_query($sql_update);
 				if($result_update != 0){
    				return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    			}
    			else
    	  			return new ExcuteResult(ResultStateLevel::SUCCESS,"同步已经成功，但是公告基础数据更改状态失败，请联系管理人员！",NULL);
 			}
 			else
 				return new ExcuteResult(ResultStateLevel::ERROR,"同步出现失败，请查看接口请求日志！",NULL);
    	}
    }
  
    /**
     * 删除某个公告  当$serverId == ""时，是删除此公告所有服信息
     * @param $bulletinId
     * @param $serverId
     */
    private static function dataMentods_updateBulletin_delSending($bulletinId,$serverId,$bulletinType,$startTime,$endTime,$Interval,$bulletinDes,$logDesc)
    {
    	$sqlWhere_ser = '';
    	if($serverId == "") //删除所有服
    	{
    		$sqlWhere_ser = ' AND a.bm_state !=99 ';
    		
    	}
    	else{
    		$sqlWhere_ser = ' AND  a.bm_ServerID ='.$serverId;
    	}
    	$sql_server = 'SELECT a.bm_ServerID,a.bm_state FROM bm_bulletingameserver a,bm_gameserver b WHERE a.bm_ServerID = b.bm_ServerID '.$sqlWhere_ser.'  AND a.bm_BulletinID = '.$bulletinId;
    	
    	$r_server = sql_fetch_rows($sql_server);
//    	if(empty($r_server) || count($r_server) == 0){
//    		return new ExcuteResult(ResultStateLevel::ERROR,"1",NULL);
//    	}
    	
    	$succNumber = 0;
    	$DBsucc = true;
    	foreach($r_server as $k=>$v){
			 $quest_Result = self::mentodsSendingBulletin($bulletinId,2,$bulletinType,$startTime,$endTime,$Interval,$bulletinDes,$v[0]);
			 if(empty($quest_Result->Tag))
			 {
				$sql_updateServer = 'UPDATE bm_bulletingameserver SET bm_state =99 WHERE bm_BulletinID ='.$bulletinId.' AND bm_ServerID ='.$v[0];
				$result_Serverupdate = sql_query($sql_updateServer);
 				if($result_Serverupdate == 0){
    				logManageErrorDBdate("Error：sql:".$sql_updateServer);
    				$DBsucc = false;
    			}
    			$succNumber++;
			}
 		}
 		
 		if($serverId != "") //单服
 		{
 			if($succNumber == 1){
 				$errorMsg = $DBsucc == true ? '' :'游戏内删除已成功，但是公告基础数据更改状态失败，请联系管理人员！';
 				return new ExcuteResult(ResultStateLevel::SUCCESS,$errorMsg,NULL);
 			}
 			else
 				return new ExcuteResult(ResultStateLevel::ERROR,"请求删除游戏服务器失败，请查看网关访问错误日志！",NULL);
 		}
 		else{
 			$sql_update = 'UPDATE bm_bulletin SET bm_BulletinState = 99,bm_logDesc="'.$logDesc.'"  WHERE bm_BulletinID = '.$bulletinId;
			$result_update = sql_query($sql_update);
 			if($result_update != 0){
 				if($succNumber == count($r_server) && $DBsucc == true)
 					return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
 				else
    				return new ExcuteResult(ResultStateLevel::SUCCESS,"部分公告请求发送时出现异常，请查看公告列表以确认",1);
    		}
    		else
    	  		return new ExcuteResult(ResultStateLevel::SUCCESS,"请查看公告列表以确认",NULL);
 		}
    }
    
    
	private static function mentodsSendingBulletin($id,$op,$sendType,$startTime,$endTime,$interval,$content,$server)
	{
		$serverAry = self::getServerInfoTOhttprequest("/send_sys_msg",$server);
		if(count($serverAry) <= 0)
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		$arryResult = Array();
		
		for($i=0;$i<count($serverAry);++$i)
		{
			$params = array("id"=>$id,"op"=>$op, "msgType"=>1,"sendType"=>$sendType,"startTime"=>$startTime,"endTime"=>$endTime,"interval"=>$interval,"content"=>$content);
			$result = self::makeRequst($serverAry[$i],$params,'get');
			if($result['result'] == false){
//				return new DataResult(ResultStateLevel::ERROR,"",NULL,$arryResult);
				$arryResult[] = $serverAry[$i].",error：".$result['msg'];
			}
		}
		return new DataResult(ResultStateLevel::SUCCESS,"",$arryResult,NULL);
	}
	
	/***** 公告  end ******/
	
	
	/**   系统邮件 stand  **/
	/**
	 * 发送系统邮件
	 * @param unknown_type $userInfo  玩家昵称信息 可能为空字符串
	 * @param unknown_type $action /1为对某一个或一部分玩家发送，2为对某一等级段里的所有玩家发送，3为对所在在线玩家发送
	 * @param unknown_type $min_lev 最小等级
	 * @param unknown_type $max_lev	最大等级
	 * @param unknown_type $title   标题
	 * @param unknown_type $desc    内容
	 * @param unknown_type $serverIdString 游戏服
	 * md5($search.$send_mail.$time.KEY);
	 */
	public static function mentodsSendSystemMail($userInfo,$action,$min_lev,$max_lev,$title,$desc,$serverIdString)
	{
		if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['user']))  {
    		return new DataResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1",NULL); 
    	}
    	$accountID = $_SESSION['user'];
    	
		$accountString = 'null';
		if($action == "1")
		{
			$bm_sendUser = str_replace(array("\r", "\n"), array("", ","),(trim($userInfo)));
			$userInfo_ary = explode(",",$bm_sendUser);
		 	for($j=0;$j < count($userInfo_ary);++$j)
		  	{
		   		if($accountString != '')
		   	 		$accountString = $accountString.',';
		   	 	$accountString = $accountString.$userInfo_ary[$j];
		 	 }
		}
		$searchCondition = '{"name_list":["'.$accountString.'"],"action":"'.$action.'","min_lv":"'.$min_lev.'","max_lv":"'.$max_lev.'"}';
		if($min_lev=="") $min_lev = 0;
		if($max_lev=="") $max_lev = 0;
		$searchCondition1 = join("$",array($accountString,$action,$min_lev,$max_lev));
		
		$result_request = self::mentodsReSendSystemMail($searchCondition1,$title,$desc,$serverIdString);
    	$resultError = $result_request->Tag;
    	$errorServerPost = $result_request->DataList;
		
		$insertTime = date("Y-m-d H:i:s");
		$insertState = 1;
		$errorLog  ="";
		if(count($errorServerPost) > 0 )
    	{
    		$insertState = 2;
    		$errorLog = join(",",$errorServerPost);
    	}
//		if($errorServerPost != "")
//			$insertState = 2;
		$sql = 'INSERT INTO bm_gamesystemmail(bm_systemTitle,bm_systemRemark,bm_sendTime,bm_state,bm_searchCondition,bm_doneRemark,bm_serverID,bm_errorLog,bm_account)';
		$sql.= "values ('$title','$desc','$insertTime',$insertState,'$searchCondition','','$serverIdString',\"$errorLog\",'$accountID')";
		$r = sql_insert($sql);
		$insertTag = false;
    	if($r != 0){
    		$insertTag = true;
    	}
		return new DataResult(ResultStateLevel::SUCCESS,"",$insertTag,$errorServerPost);
	}
	
	
	
	
	 /**
     * 获取邮件发送列表  用于同步
     * @param unknown_type $startTime 开始时间
     * @param unknown_type $endTime	    截止时间
     * @param unknown_type $offer
     * @param unknown_type $pageSize
     * 邮件Id=0，标题=1，内容=2，发送时间=3，状态=4，发送条件=5，发送日志说明=6，服务器ID=7，错误日志=8，操作账号=9
     */
    public static function dataMentods_ListSystemMail($startTime,$endTime,$offer, $pageSize)
    {
    	$sqlwhere = '';
    	if(!empty($startTime))
    		$sqlwhere.=' WHERE bm_sendTime >= "'.$startTime.'"';
    	if(!empty($endTime))
    	{
    		if($sqlwhere == "")
    			$sqlwhere.=' WHERE bm_sendTime <= "'.$endTime.'"';
    		else
    			$sqlwhere.=' AND bm_sendTime <= "'.$endTime.'"';
    	}
    	$sql = 'SELECT bm_systemMailId,bm_systemTitle,bm_systemRemark,bm_sendTime,bm_state,bm_searchCondition,bm_doneRemark,bm_serverID,bm_errorLog,bm_account';
    	$sql.= " FROM bm_gamesystemmail ".$sqlwhere."  ORDER BY bm_sendTime DESC LIMIT $offer, $pageSize";
    	
		$r = sql_fetch_rows($sql);
		if(!empty($r)){
 			$count = sql_fetch_one_cell("SELECT COUNT(*) as num FROM bm_gamesystemmail ".$sqlwhere); 
 			return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$r);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 		} 	
    }
    
    /**
     * 同步发布异常的服务器邮件
     * @param $mailID  邮件ID
     */
    public static function dataMentods_ReSendSystemMail($mailID)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['user']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1"); 
    	}
    	$accountName = $_SESSION['user'];
    	
    	$sql_mailInfo = 'SELECT bm_systemMailId,bm_systemTitle,bm_systemRemark,bm_sendTime,bm_state,bm_searchCondition,bm_doneRemark,bm_serverID,bm_errorLog,bm_account';
    	$sql_mailInfo.= ' FROM bm_gamesystemmail WHERE bm_systemMailId = '.$mailID;
    	$result_sql_mailInfo = sql_fetch_one($sql_mailInfo);
    	if($result_sql_mailInfo == ""){

    		return new ExcuteResult(ResultStateLevel::ERROR,"邮件不存在！",NULL); 
    	}

    	if($result_sql_mailInfo[4] == 2 && $result_sql_mailInfo[8] != "")
    	{
    		$result_request = self::mentodsReSendSystemMail($result_sql_mailInfo[5],$result_sql_mailInfo[1],$result_sql_mailInfo[2],$result_sql_mailInfo[8]);
//    		$resultArry = $result_request->DataList;
    		$resultError = $result_request->Tag;
    		
    		$time = date("Y-m-d H:i:s");
    		$Mailstate = 2;
    		$done_mailLog = $result_sql_mailInfo[6];
    		if($done_mailLog != "")
    			$done_mailLog .= "<br/>";
    		$done_mailLog .=  $time."    ".$accountName."   操做同步服务器：".$result_sql_mailInfo[8];
    		
    		$errorLog = $result_sql_mailInfo[8];
    		if(count($resultError) == 0 )
    		{
    			$Mailstate = 3;
    			$errorLog = "";
    		}
    		else
    		{
    			$errorLog = join("$",$resultError);
    		}
    		
    		$sql_update = 'UPDATE bm_gamesystemmail  SET bm_state = '.$Mailstate.',bm_doneRemark="'.$done_mailLog.'",bm_errorLog="'.$errorLog.'"  WHERE bm_systemMailId ='.$mailID;
    		$r_update = sql_query($sql_update);
 			if($r_update != 0){
    			return new ExcuteResult(ResultStateLevel::SUCCESS,"",$resultArry);
    		}
    		else{
    			if($resultError == "")
    	  			return new ExcuteResult(ResultStateLevel::EXCEPTION,"游戏服已发放邮件，但是发送日志保存失败，请联系管理员，不要重复同步！",NULL);
    	  		else
    	  			return new ExcuteResult(ResultStateLevel::EXCEPTION,"请联系管理员，不要重复同步！请查看请求日志，网关已发送部分请求，保存操作结果失败",$resultArry);
    		}
    		
    	}
    	else
    		return new ExcuteResult(ResultStateLevel::ERROR,"此邮件不需要同步！",NULL);
    }
    
	
	
	
	/**
	 * 同步发送系统邮件（再次发送请求出错的邮件）
	 * @param unknown_type $condition  发放对象的条件
	 * @param unknown_type $title  标题
	 * @param unknown_type $desc   内容
	 * @param unknown_type $serverIdString 服务器 格式 1,2,3
	 */
	private static function mentodsReSendSystemMail($searchCondition,$title,$desc,$serverIdString)
	{
		$serverAry = self::getServerInfoTOhttprequest1("/send_sys_mail",$serverIdString);
		if(count($serverAry) <= 0)
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
//		$send_mail = '{"title":"'.$title.'","content":"'.$desc.'"}';
		$arryResult = Array();
		$arryErrorServerId = Array();
//		$errorServerPost = "";   //服务器ID
		
		for($i=0;$i<count($serverAry);++$i)
		{
			$ary = $serverAry[$i];
//			$time = time();
//			$flag = md5($searchCondition.$send_mail.$time.INTERFACE_KEY);
			$params = array("search"=>$searchCondition,"title"=>$title,"desc"=>$desc);
			$result = self::makeRequst($ary[0],$params,'get');
			if($result['result'] == false){
				$arryResult[] = $ary[0].",error：".$result['msg'];
				$arryErrorServerId[] = $ary[1];
//				if($errorServerPost != "")
//					$errorServerPost.= ",";
//				$errorServerPost.= $ary[1];
			}
		}
		return new DataResult(ResultStateLevel::SUCCESS,"",$arryResult,$arryErrorServerId);
	}
	
	/**   系统邮件 end  **/
	
	
	
	
	/**
	 * 发送游戏公告  get方式
	 * @param unknown_type $msg_type 消息类型  2表示聊天栏，5表示顶部滚动
	 * @param unknown_type $content
	 * @param unknown_type $serverIdString 格式： 1,2,3,4
	 * 接口请求 签名 格式 md5($msg_type.$time.KEY)
	 */
	public static function mentodsBulletin($msg_type,$content,$serverIdString)
	{
		$serverAry = self::getServerInfoTOhttprequest(SEND_SYS_BULLETIN,$serverIdString);
		if(count($serverAry) <= 0)
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		$arryResult = Array();
		for($i=0;$i<count($serverAry);++$i)
		{
			$time = time();
			$flag = md5($msg_type.$time.INTERFACE_KEY);
			$params = array("msg_type"=>$msg_type,"content"=>$content,"time"=>$time,"flag"=>$flag);
		$param_url = $serverAry[$i].'?';
		foreach ($params as $key => $value ) {
			$param_url .= $key . "=" . $value . "&";
		}
			file_put_contents("log.txt",$param_url);
			$result = self::makeRequst($serverAry[$i],$params,'get');
			
			if($result['result'] == false){
				$arryResult[] = $serverAry[$i].",error：".$result['msg'];
			}
		}
		return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$arryResult);
	}
	
	/**
	 * 解封/封禁 玩家账号 get方式
	 * @param $user_name  玩家角色昵称
	 * @param $is_forbid  1--->封号； 0---->解封
	 * @param $forbid_date  1 --->永久封号，其他情况徐发送截至的时间戳
	 * @param $reason 操作原因
	 * @param $serverIdString 格式： 1,2,3,4
	 * 接口请求 签名 格式 md5($user_name. $is_forbid.$forbid_date. $time.KEY)
	 */
//	public static function mentodsForbidPalyer($user_name,$is_forbid,$forbid_date,$reason,$serverIdString)
//	{
//		$serverAry = self::getServerInfoTOhttprequest(FORBID_LOGIN,$serverIdString);
//		if(count($serverAry) <= 0)
//			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
//		$arryResult = Array();
//		for($i=0;$i<count($serverAry);++$i)
//		{
//			$time = time();
//			$flag = md5($user_name.$is_forbid.$forbid_date.$time.INTERFACE_KEY);
//			$params = array("user_name"=>$user_name,"is_forbid"=>$is_forbid,"forbid_date"=>$forbid_date,"reason"=>$reason,"time"=>$time,"flag"=>$flag);
//			$result = self::makeRequst($serverAry[$i],$params,'get');
//			if($result['result'] == false)
//				$arryResult[] = $serverAry[$i].",error：".$result['msg'];
//		}
//		return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$arryResult);
//	}
	
	/**
	 * 封禁(解禁)IP接口
	 * @param unknown_type $ip
	 * @param unknown_type $is_forbid 1--->封； 0---->解封
	 * @param unknown_type $forbid_date 1 --->永久封，其他情况徐发送截至的时间戳
	 * @param $reason 操作原因
	 * @param unknown_type $serverIdString 格式： 1,2,3,4
	 */
	public static function mentodsForbidIP($ip,$is_forbid,$forbid_date,$serverIdString)
	{
		$serverAry = self::getServerInfoTOhttprequest(FORBID_IPBAN,$serverIdString);
		if(count($serverAry) <= 0)
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		$arryResult = Array();
		for($i=0;$i<count($serverAry);++$i)
		{
			$time = time();
			$flag = md5($ip.$is_forbid.$forbid_date.$time.INTERFACE_KEY);
			$params = array("ip"=>$ip,"is_forbid"=>$is_forbid,"forbid_date"=>$forbid_date,"time"=>$time,"flag"=>$flag);
			$result = self::makeRequst($serverAry[$i],$params,'get');
			if($result['result'] == false)
				$arryResult[] = $serverAry[$i].",error：".$result['msg'];
		}
		return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$arryResult);
	}
	
	/**
	 * 踢人操作
	 * @param unknown_type $user_name
	 * @param unknown_type $kick_all 1--->踢出所有玩家； 0---->踢出单个玩家
	 * @param unknown_type $serverIdString 格式： 1,2,3,4
	 * $flag = md5($user_name. $kick_all. $time.KEY);
	 */
	public static function mentodsKickPlayer($user_name,$kick_all,$serverIdString)
	{
		$serverAry = self::getServerInfoTOhttprequest(KICK_USER,$serverIdString);
		if(count($serverAry) <= 0)
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		$arryResult = Array();
		for($i=0;$i<count($serverAry);++$i)
		{
			$time = time();
			$flag = md5($user_name.$kick_all.$time.INTERFACE_KEY);
			$params = array("user_name"=>$user_name,"kick_all"=>$kick_all,"time"=>$time,"flag"=>$flag);
			$result = self::makeRequst($serverAry[$i],$params,'get');
			if($result['result'] == false)
				$arryResult[] = $serverAry[$i].",error：".$result['msg'];
		}
		return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$arryResult);
	}
	
	/**
	 *禁言与解禁接口
	 * @param unknown_type $user_name
	 * @param unknown_type $is_ban  1--->禁言； 0---->解禁
	 * @param unknown_type $ban_date 1 --->永久禁言，其他情况徐发送截至的时间戳
	 * @param unknown_type $serverIdString 格式： 1,2,3,4
	 *  md5($user_nick. $is_ban.$ban_date. $time.KEY);
	 */
	public static function mentodsBanChatPlayer($user_name,$is_ban,$ban_date,$serverIdString)
	{
		$serverAry = self::getServerInfoTOhttprequest1("/banchat",$serverIdString);
		if(count($serverAry) <= 0)
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		$arryResult = Array();
		for($i=0;$i<count($serverAry);++$i)
		{
			$ary = $serverAry[$i];
			$params = array("user_name"=>$user_name,"ban_date"=>$ban_date,"is_ban"=>$is_ban,"msg"=>'');
			$result = self::makeRequst($ary[0],$params,'get');
			if($result['result'] == false)
				$arryResult[] = $serverAry[$i].",error：".$result['msg'];
		}
		return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$arryResult);
	}
	
/**
	 *禁登与解禁接口
	 * @param unknown_type $user_name
	 * @param unknown_type $is_forbid  1--->解禁； 0---->禁登
	 * @param unknown_type $serverIdString 格式： 1,2,3,4
	 *  md5($user_nick. $is_ban.$ban_date. $time.KEY);
	 */
	public static function mentodsForbidPlayer($user_name,$is_forbid,$forbid_date,$serverIdString)
	{
		$serverAry = self::getServerInfoTOhttprequest1("/forbid_login",$serverIdString);
		if(count($serverAry) <= 0)
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		$arryResult = Array();
		for($i=0;$i<count($serverAry);++$i)
		{
			$ary = $serverAry[$i];
			$params = array("user_name"=>$user_name,"forbid_date"=>$forbid_date,"is_forbid"=>$is_forbid,"msg"=>'');
			$result = self::makeRequst($ary[0],$params,'get');
			if($result['result'] == false)
				$arryResult[] = $serverAry[$i].",error：".$result['msg'];
		}
		return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$arryResult);
	}
	
	public static function mentodsForbidPlayerbyId($user_id,$forbid_date,$serverIdString)
	{
		$serverAry = self::getServerInfoTOhttprequest1("/forbid_login_byid",$serverIdString);
		if(count($serverAry) <= 0)
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		$arryResult = Array();
		for($i=0;$i<count($serverAry);++$i)
		{
			$ary = $serverAry[$i];
			$params = array("user_id"=>$user_id,"forbid_date"=>$forbid_date,"is_forbid"=>0,"msg"=>'');
			$result = self::makeRequst($ary[0],$params,'get');
			if($result['result'] == false)
				$arryResult[] = $serverAry[$i].",error：".$result['msg'];
		}
		return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$arryResult);
	}
	
	/**
	 * 新手指导员接口
	 * @param unknown_type $user_name  角色名
	 * @param unknown_type $type 1增加，2删除
	 * @param unknown_type $instructor_type 1菜鸟指导员，2指导员达人 3新手导师, 4长期指导员 ，5GM
	 * @param unknown_type $start_stamp  有效开始时间
	 * @param unknown_type $end_stamp	有效截止时间
	 * @param unknown_type $serverIdString  格式： 1,2,3,4
	 * flag = md5($user_name.$type.$instructor_type.$start_stamp.$end_stamp.KEY)
	 */
	public static function mentodsGameInstructor($user_name,$type,$instructor_type,$start_stamp,$end_stamp,$serverIdString)
	{
		$serverAry = self::getServerInfoTOhttprequest(GAME_INSTRUCTOR,$serverIdString);
		if(count($serverAry) <= 0)
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		$arryResult = Array();
		for($i=0;$i<count($serverAry);++$i)
		{
			$time = time();
			$flag = md5($user_name.$type.$instructor_type.$start_stamp.$end_stamp.INTERFACE_KEY);
			$params = array("user_name"=>$user_name,"type"=>$type,"instructor_type"=>$instructor_type,"start_stamp"=>$start_stamp,
					"end_stamp"=>$end_stamp,"flag"=>$flag);
			$result = self::makeRequst($serverAry[$i],$params,'get');
			if($result['result'] == false)
				$arryResult[] = $serverAry[$i].",error：".$result['msg'];
		}
		return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$arryResult);
	}
	
	/**
	 * 后台登陆玩家账号
	 * @param unknown_type $user_name
	 * @param unknown_type $serverIdString
	 * md5($username.$time.$GLOBALS['PLANTLOGIN_KEY'].$cm)
	 */
	public static function mentodsLoginPlayer($user_name,$serverIdString)
	{
		$serverAry = self::getServerInfoTOhttprequest(LOGIN_PLAYER,$serverIdString);
		if(count($serverAry) <= 0)
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		$_url = $serverAry[0].LOGIN_PLAYER;
		$username = urlencode($user_name);
		$cm = 1;
		$time = time();
		$sign = md5($username.$time.INTERFACE_KEY.$cm);
		$url = $_url."username=".$username."&time=".$time."&cm=".$cm."&sign=".$sign;
//		$url =  sprintf($_url."username=%s&time=%s&cm=%d&sign=%s",$username,$time,$cm,$sign);
		return new DataResult(ResultStateLevel::SUCCESS,"",$url,NULL);
		//return $url;	
	}
	
	/**
	 * 依据账号ID， 角色名，账号 信息查询玩家信息
	 * @param unknown_type $user_id
	 * @param unknown_type $user_name
	 * @param unknown_type $account
	 * @param unknown_type $serverIdString  格式： 1,2,3,4
	 * 玩家id、玩家角色名、玩家账号三个参数值有且只有一个存在
	 * md5($user_id.$user_name.$account.$time.KEY)
	 */
	public static function mentodsSearchOnePlayer($user_id,$user_name,$account,$serverIdString)
	{
		$serverAry = self::getServerInfoTOhttprequest(USER_INFO_DETAIL,$serverIdString);
		if(count($serverAry) <= 0)
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		$arryResult = Array();
		for($i=0;$i<count($serverAry);++$i)
		{
			$time = time();
			$flag = md5($user_id.$user_name.$account.$time.INTERFACE_KEY);
			$params = array("user_id"=>$user_id,"user_name"=>urlencode($user_name),"account"=>urlencode($account),"time"=>$time,"flag"=>$flag);
			$result = self::makeRequst($serverAry[$i],$params,'get');
			if($result['result'] == false)
				$arryResult[] = $serverAry[$i].",error：".$result['msg'];
		}
		return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$arryResult);
	}
	
	
	
	
	/**
	 * 发放道具请求
	 * @param unknown_type $sendUser  玩家信息 以，间隔
	 * @param unknown_type $sendCondition  账号条件  已是json格式
	 * @param unknown_type $sendMoneyItem 货币物品， 已是json格式
	 * @param unknown_type $sendPropItem 道具物品 ，每个道具以','间隔 （ID|数量|绑定,ID|数量|绑定）PS:1为绑定、0为非绑定
	 * @param unknown_type $requestURL  网关请求的地址
	 * @param unknown_type $sendTitile  邮件标题
	 * @param unknown_type $sendDesc    邮件内容
	 * @param unknown_type $sendRemark  //发送道具的原因
	 * "道具id":{
            "type":"是否绑定(1为绑定、0为非绑定)",(字段保留，用不到)
            "count":"数量",
			"strength":"强化等级"(字段保留，用不到)
        }
        md5($item_info. $user_info. $reason . $time . KEY);
	 */
	private static function mentodsAdminSendGift($sendUser,$sendCondition,$sendMoneyItem,$sendPropItem,$requestURL,$sendTitile,$sendDesc,$sendRemark)
	{
//		 $propItem_json = "";
		 if($sendPropItem == "")
		 {
		 	$sendPropItem = "null";
//		 	 $itemNum_ary = explode(",",$sendPropItem);
//		 	 for($i=0;$i < count($itemNum_ary);++$i)
//		 	 {
//		 	 	$onePropItem = $itemNum_ary[$i];
//		 	 	$propItem_ary = explode("|",$onePropItem);
//		 	 	if(count($propItem_ary) == 3)
//		 	 	{
//		 	 		if($propItem_json != "")
//		 	 			$propItem_json = $propItem_json.",";
//		 	 		$propItem_json = $propItem_json.'\"'.$propItem_ary[0].'\":{\"type\":'.$propItem_ary[2].',\"count\":'.$propItem_ary[1].',\"strength\":0}';
//		 	 	}
//		 	 }
		 }
		 if($sendMoneyItem == "")
		 {
		 	$sendMoneyItem = "null";
		 }
		 if($sendUser == "")
		 {
		 	$sendUser = "null";
		 }
		 
//		 $Item_propItem_json = '\"item\":{'.$propItem_json.'}';
//         //准备发送的item_info -json数据字符串
//		 $sendItemInfo_json = '{'.str_replace("\"","\\\"", $sendMoneyItem) .','.$Item_propItem_json.'}';
//		 //准备发送的玩家信息 -json数据字符串
//		 $sendUserInfo_json = '';
//		 
//		 $userInfo_ary = explode(",",$sendUser);
//		 $accountString = '';
//		  for($j=0;$j < count($userInfo_ary);++$j)
//		  {
//		   	 if($accountString != '')
//		   	 	$accountString = $accountString.',';
//		   	 $accountString = $accountString.'\"'.$userInfo_ary[$j].'\"';
//		  }
//		  if($sendUser == 0)
//		  	$sendUserInfo_json = '"{\"user_name\":['.$accountString.'],\"user_id\":[],'.str_replace("\"","\\\"", $sendCondition).'}"';
//		  else
//		  	$sendUserInfo_json = '"{\"user_name\":[],\"user_id\":['.$accountString.'],'.str_replace("\"","\\\"", $sendCondition).'}"';
		  	
		$params = array("item_info"=>$sendPropItem,"money"=>$sendMoneyItem,"user_info"=>$sendUser,"content"=>$sendDesc,"title"=>$sendTitile);
		$result = self::makeRequst($requestURL,$params,'get');
		if($result['result'] == false)
			return  $requestURL.",error：".$result['msg'];
		else
			return "";
	}
	
	
	

	
	/**
	 * 请求网关
	 * @param unknown_type $url
	 * @param unknown_type $params
	 * @param unknown_type $method
	 * @param unknown_type $protocol
	 */
	private static function makeRequst($url,$params,$method='post',$protocol='http')
	{
		$ret = SnsNetwork::makeRequest($url,$params,array(),$method);
//		$param_url = $url.'?';
//		foreach ($params as $key => $value ) {
//			$param_url .= $key . "=" . $value . "&";
//		}
//		if (strtolower('Success') == strtolower($ret['msg']))
//		{
//			logManageSucInterface($param_url."--".$ret['result']."--".$ret['msg']);
//		}
//		else{
//			logManageErrorInterface($param_url."--".$ret['result']."--".$ret['msg']);
//			$ret = array(
//        		'result' => false,
//            	'msg' => $ret['msg'],
//        	);
//		}
		return $ret;
	}
	
	
	/**
	 * $serverIdString 格式： 1,2,3,4
	 * @param unknown_type $URI
	 * @param unknown_type $serverIdString json结构中 socket 的ip存放是的游戏服对应的域名
	 */
	private static function getServerInfoTOhttprequest($URI,$serverIdString)
	{
		$sql = "SELECT bm_ServerConnString FROM bm_gameserver WHERE bm_ServerID IN(".$serverIdString.")";
		$rs = sql_fetch_rows($sql);
		$resultArray = Array();
		if(!empty($rs)){
			foreach($rs as $k=>$v){
				$servAry = json_decode($v[0],true);
				$host_IP 	= $servAry['socket']['ip'];
				$host_port 	= $servAry['socket']['port'];
				$resultArray[] = "http://".$host_IP.":".$host_port.$URI;
			}
		}
		return $resultArray;
	}
	
	private static function getServerInfoTOhttprequest1($URI,$serverIdString)
	{
		$sql = "SELECT bm_ServerConnString,bm_ServerID FROM bm_gameserver WHERE bm_ServerID IN(".$serverIdString.")";
		$rs = sql_fetch_rows($sql);
		$resultArray = Array();
		if(!empty($rs)){
			foreach($rs as $k=>$v){
				$servAry = json_decode($v[0],true);
				$host_IP 	= $servAry['socket']['ip'];
				$host_port 	= $servAry['socket']['port'];
				$ary = Array();
				$ary[] = "http://".$host_IP.":".$host_port.$URI;
				$ary[] = $v[1];
				$resultArray[] = $ary;
			}
		}
		return $resultArray;
	}
	
	
	/**
	 * $serverIdString 格式： 1,2,3,4
	 * @param unknown_type $URI
	 * @param unknown_type $serverIdString json结构中 socket 的ip存放是的游戏服对应的域名 服务器ID  
	 */
	private static function getServerInfoTOhttprequest2($URI,$serverIdString)
	{
		$sql = "SELECT bm_ServerConnString,bm_ServerID FROM bm_gameserver WHERE bm_ServerID IN(".$serverIdString.")";
		$rs = sql_fetch_rows($sql);
		$resultArray = Array();
		if(!empty($rs)){
			foreach($rs as $k=>$v){
				$servAry = json_decode($v[0],true);
				$host_IP 	= $servAry['socket']['ip'];
				$ary = Array();
				$ary[] = "http://".$host_IP.$URI;
				$ary[] = $v[1];
				$resultArray[] = $ary;
			}
		}
		return $resultArray;
	}
	
	/**
	 * 根据服务器ID得到服务器的名称
	 * @param unknown_type $serverId
	 */
	private static function getServerNameByServerId($serverId)
	{
		$sql = "SELECT bm_ServerName FROM bm_gameserver WHERE bm_ServerID = ".$serverId;
		$rs = sql_fetch_one($sql);
		if($rs != ""){
			return $rs[0];
		}
		else
			return "";
	}
	
	/**
	 * 道具发放申请表中加入数据
	 * @param unknown_type $title  标题
	 * @param unknown_type $desc   详情说明
	 * @param unknown_type $applyRemark  申请说明
	 * @param unknown_type $sendType   发放类型 0=角色名  1=账号
	 * @param unknown_type $userInfo  账号类表以换行间隔
	 * @param unknown_type $condition  账号条件已是接口json格式
	 * @param unknown_type $moneyItem  货币物品 已是接口json格式
	 * @param unknown_type $propItem   道具物品 每个道具以','间隔 （ID|数量|绑定,ID|数量|绑定）
	 * @param unknown_type $serverId  服务器ID 
	 */
    public static function dataMentods_insertApplyItem($title,$desc,$applyRemark,$sendType,$userInfo,$condition,$moneyItem,$propItem,$serverId)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['user']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1"); 
    	}
    	
    	$serverName = self::getServerNameByServerId($serverId);

    	if($serverName == "") return new ExcuteResult(ResultStateLevel::ERROR,"The server is not exit","-1"); 
    	
    	$time = date("Y-m-d H:i:s");
    	$accountID = $_SESSION['user'];
    	$bm_sendUser = str_replace(array("\r", "\n"), array("", ","),(trim($userInfo)));
    	$sql = "INSERT INTO bm_gameapply(bm_serverID,bm_serverName,bm_applyTitle,bm_applyDesc,bm_sendType,bm_sendUser,bm_condition,bm_moneyItem,bm_propItem,bm_applyRemark,bm_applyState,bm_applyTime,bm_applyAccount)";
    	$sql.= "values ($serverId,'$serverName','$title','$desc',$sendType,'$bm_sendUser','$condition','$moneyItem','$propItem','$applyRemark',0,'$time','$accountID')";
    	$r = sql_insert($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    public static function dataMentods_sendCardItem($cardTypeId,$account,$serverId)
    {
    	$sql = 'SELECT a.bm_ItemID,a.cd_CardItemNum,b.cd_CardTypeName FROM cd_cardaffixitem a,cd_cardtype b WHERE b.cd_CardTypeID = '.$cardTypeId.' AND a.cd_CardTypeID = b.cd_CardTypeID AND b.cd_CardTypeState = 1;';
    	$result_sql_applyItem = sql_fetch_one($sql);
    	if($result_sql_applyItem == ""){
    		return new ExcuteResult(ResultStateLevel::ERROR,$sql,NULL); 
    	}
    	$sendPropItem = $result_sql_applyItem[0];
    	$sendPropItemNum = $result_sql_applyItem[1];
    	$sendTitile = $result_sql_applyItem[2];
    	$sendDesc = $result_sql_applyItem[2];
    	///////////////获取接口调用信息
    	$serverAry = self::getServerInfoTOhttprequest("/admin_send_gift2",$serverId);
    	if(count($serverAry) <= 0)
			return new ExcuteResult(ResultStateLevel::ERROR,"获取服务器发送域名信息失败",NULL); 
		
		$sendPropItem = $sendPropItem.'|'.$sendPropItemNum.'|1';
		$account = $account.'|'.$serverId;
	    /**网关请求发送**/
		$request_result = self::mentodsAdminSendGift($account,"","0,0,0,0",$sendPropItem,$serverAry[0],$sendTitile,$sendDesc,"");
		if($request_result != "")
		{
			return new ExcuteResult(ResultStateLevel::ERROR,$request_result,NULL); 
		}
		else
		{
			//成功  修改卡密使用情况	
			return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);					
		}
    }
    
    /**
     * 审核通过
     * @param unknown_type $applyItemId
     * @param unknown_type $checkRemark
     */
    public static function dataMentods_updateApplyItem($applyItemId,$checkRemark)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['user']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1"); 
    	}
    	$accountID = $_SESSION['user'];
    	
    	///////////////获取申请单信息
    	$sql_applyItem = 'SELECT bm_serverID,bm_sendType,bm_sendUser,bm_condition,bm_moneyItem,bm_propItem,bm_applyTitle,bm_applyDesc,bm_applyRemark FROM bm_gameapply  WHERE bm_gameApplayId ='.$applyItemId;
    	$result_sql_applyItem = sql_fetch_one($sql_applyItem);
    	if($result_sql_applyItem == ""){
    		return new ExcuteResult(ResultStateLevel::ERROR,$sql_applyItem,NULL); 
    	}
    	$serverId = $result_sql_applyItem[0];
    	$sendUser = $result_sql_applyItem[2];
    	$sendCondition = $result_sql_applyItem[3];
    	$sendMoneyItem = $result_sql_applyItem[4];
    	$sendPropItem  = $result_sql_applyItem[5];
    	$sendTitile    = $result_sql_applyItem[6];
    	$sendDesc      = $result_sql_applyItem[7];  // 详情
    	$sendRemark    = $result_sql_applyItem[8];  //发送原因
    	
    	///////////////获取接口调用信息
    	$serverAry = self::getServerInfoTOhttprequest("/admin_send_gift",$serverId);
    	if(count($serverAry) <= 0)
			return new ExcuteResult(ResultStateLevel::ERROR,"获取服务器发送域名信息失败",NULL); 

	    /**网关请求发送**/
		$request_result = self::mentodsAdminSendGift($sendUser,$sendCondition,$sendMoneyItem,$sendPropItem,$serverAry[0],$sendTitile,$sendDesc,$sendRemark);
		if($request_result != "")
		{
			return new ExcuteResult(ResultStateLevel::ERROR,$request_result,NULL); 
		}
		else
		{
			//成功  更新申请表单处理状态
			$nowtime = date("Y-m-d H:i:s");
			$sql_update = 'UPDATE bm_gameapply SET bm_applyState = 1 ,bm_checkAccount ="'.$accountID.'",bm_checkRemark="'.$checkRemark.'",bm_checkTime="'.$nowtime.'"  WHERE bm_gameApplayId = '.$applyItemId;
			$result_update = sql_query($sql_update);
 			if($result_update != 0){
    			return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    		}
    		else
    	  		return new ExcuteResult(ResultStateLevel::EXCEPTION,"邮件已成功发放到游戏，后台申请表单状态更新失败，请不要再次审核通过，联系网站管理人员！：）",NULL);
		}
    }
    
    /**
     * 不通过申请单
     * @param unknown_type $applyItemId
     * @param unknown_type $checkRemark
     */
    public  static function dataMentods_unpassApplyItem($applyItemId,$checkRemark)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['user']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1"); 
    	}
    	$accountID = $_SESSION['user'];
    	
    	$nowtime = date("Y-m-d H:i:s");
		$sql_update = 'UPDATE bm_gameapply SET bm_applyState = 2 ,bm_checkAccount ="'.$accountID.'",bm_checkRemark="'.$checkRemark.'",bm_checkTime="'.$nowtime.'"  WHERE bm_gameApplayId = '.$applyItemId;
		$result_update = sql_query($sql_update);
 		if($result_update != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    	}
    	else
    	  	return new ExcuteResult(ResultStateLevel::EXCEPTION,"处理操作失败！",NULL);
    }
    
    /**
     * 获取申请单列表信息
     * @param unknown_type $areaId
     * @param unknown_type $serverId
     * @param unknown_type $state
     * @param unknown_type $offer
     * @param unknown_type $pageSize
     * 申请单编号=0，服务器ID=1，服务器名称=2，标题=3，详情=4，
     * 发送类型=5 账号=6，账号条件=7，货币=8，道具=9，申请原因=10，申请状态=11
     * 申请时间=12，申请账号=13，审核账号=14，审核说明=15，审核时间=16
     */
    public static function dataMentods_ListApplyItem($areaId,$serverId,$state,$offer, $pageSize)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['user']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1"); 
    	}
    	$accountName = $_SESSION['user'];
    	$accountId = $_SESSION['account_ID'];
    	

    	$sql = 'SELECT bm_gameApplayId,a.bm_serverID,bm_serverName,bm_applyTitle,bm_applyDesc,';
    	$sql.= ' bm_sendType,bm_sendUser,bm_condition,bm_moneyItem,bm_propItem,bm_applyRemark,bm_applyState,';
    	$sql.= ' bm_applyTime,bm_applyAccount,bm_checkAccount,bm_checkRemark,bm_checkTime ';
    	
    	$sqlWhere = ' FROM bm_gameapply a,bm_accountgameserver b';
    	if($state == 0)
    		$sqlWhere.= ' WHERE a.bm_serverID = b.bm_ServerID AND b.bm_AccountID = '.$accountId.' AND bm_applyState = '.$state;
    	else
    	 	$sqlWhere.= ' WHERE a.bm_serverID = b.bm_ServerID AND b.bm_AccountID = '.$accountId.' AND bm_applyState >= '.$state;
    	if($areaId != "")
    		$sqlWhere.= '  AND b.bm_AreaID = '.$areaId;
    	if($serverId != "")
    		$sqlWhere.= '  AND  b.bm_ServerID IN ('.$serverId .')';
    		
    	$sql.= $sqlWhere." ORDER BY bm_applyTime DESC LIMIT $offer, $pageSize";
    	
    	$r = sql_fetch_rows($sql);
   		if(!empty($r)){
 			$count = sql_fetch_one_cell("SELECT COUNT(*) as num ". $sqlWhere); 
 			return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$r);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 		} 	
    }
    
   
    
    
    
   
    
 
    
    
}
?>