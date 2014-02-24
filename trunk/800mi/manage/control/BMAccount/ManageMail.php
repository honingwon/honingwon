<?php
/**
 * 管理后台邮件管理 ycchen
 */
require_once( DATALIB . '/SqlResult.php');
require_once(DATALIB . '/DynamicSqlHelper.php');
require_once(DATACONTROL . '/BMAccount/EventLog.php');

class ManageMail
{
	private static $instance;
 	private function __construct(){}
 	
 	public function getInstance(){
 		return self::$instance == null ? (self::$instance = new ManageMail()) : self::$instance;
 	}
 	
 	/**
 	 * 新增邮件申请
 	 * @param unknown_type $serverID
 	 * @param unknown_type $users
 	 * @param unknown_type $title
 	 * @param unknown_type $desc
 	 * @param unknown_type $remark
 	 * @param unknown_type $delTime
 	 * @param unknown_type $ApplyDesc
 	 */
 	public function AddMailApplay($gameID,$serverID,$users,$title,$desc,$delTime,$ApplyDesc,$sendType,$attchID,$attNum)
 	{
 	    if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
 		$sql_check = "SELECT bm_AreaID, bm_ServerConnString, bm_ServerName FROM bm_gameserver WHERE bm_ServerID = " .$serverID ;
 		$r_check = sql_fetch_one($sql_check);
 		if($r_check == ""){
 			return new ExcuteResult(ResultStateLevel::ERROR,"此游戏服务器不存在或已被删除！",NULL);
 		}
 		$AreaID = $r_check[0];
 		$ServerName = $r_check[2];
 		$AccessoriesFlag = 1;
 		$GameMailTarget = '全服发送';
 		$GameMailNickName = '全服发送';
 		$now = date("Y-m-d H:i:s");
 		if($attchID == 0 && $attNum == 0)
 			$AccessoriesFlag = 0;
 		$markAry['mailExpired']  = $delTime;
 		$markAry['attachID']     = $attchID;
 		$markAry['attachNum']    = $attNum;
 		$markAry['type']    	 = $sendType;
 		$markAry['note']    	 = $ApplyDesc;
 		$mailApplyRemark = json_encode($markAry);
 		$currentUser = $_SESSION['user'];
 		
 		if(!empty($users)){ 		
 			$usernames = str_replace(array("\r", "\n"), array("", ","),(trim($users)));
 			if($sendType == 0){  //passport
 				$GameMailTarget = $usernames;
 				$GameMailNickName = '';
 			}else{
 				$GameMailTarget = '';
 				$GameMailNickName = $usernames;
 			}
 		}
 		$sql = "INSERT INTO bm_gamemail( bm_GameID, bm_AreaID, bm_ServerID, bm_ServerName, bm_GameMailTitle, bm_GameMailDesc,
 				bm_GameMailTarget, bm_GameMailNickName, bm_MailApplyRemark, bm_MailApplyFlag, bm_AccessoriesFlag,  
 				bm_GameMailSendState, bm_ApplyState, bm_Account, bm_CreatTime) VALUES( $gameID, $AreaID, $serverID, 
 				'$ServerName', '$title', '$desc', '$GameMailTarget', '$GameMailNickName', 
 				'$mailApplyRemark', 1, $AccessoriesFlag, 0, 0, '$currentUser', '$now')";
 		$insertID = sql_insert($sql);
 		if($insertID && $attchID!=0 && $attNum != 0){
 				$sqladd = "INSERT INTO bm_gamemailaffixitem(bm_GameMailID, bm_ItemID, bm_ItemNum) VALUES($insertID, $attchID,$attNum)";
 				$r_add = sql_query($sqladd);
    			if($r_add == 0)
    				return new ExcuteResult(ResultStateLevel::ERROR,"订单生成，道具信息插入失败！",NULL);
    			else
    				return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
 		}
 		return new ExcuteResult(ResultStateLevel::ERROR,"生成订单失败",$sql);
 		
 	}
 	
 	/**
 	 * 审核通过
 	 * @param unknown_type $mailID
 	 * @param unknown_type $remark
 	 */
 	public function CheckMailApplay($mailID,$remark)
 	{
 		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
 		$sql = "SELECT g.bm_GameMailTarget, g.bm_GameMailNickName, g.bm_GameMailTitle, g.bm_GameMailDesc, g.bm_MailApplyRemark,   
 				s.bm_ServerConnString,g.bm_ServerID FROM bm_gamemail g LEFT JOIN bm_gameserver s ON g.bm_ServerID = s.bm_ServerID
 			    WHERE g.bm_GameMailID = $mailID";
 		$rs = sql_fetch_rows($sql); 	
 		if(empty($rs))
 			return new ExcuteResult(ResultStateLevel::ERROR,"邮件已经不存在或者出错","-1"); 
 		$connAry = json_decode($rs[0][5],true);
 		$ser_ID     = $rs[0][6];
 		$ser_IP 	= $connAry['server']['serverIP'];
 		$ser_User	= $connAry['server']['serverUser'];
 		$ser_PWD	= $connAry['server']['serverPSW'];
 		$ser_Name   = $connAry['server']['serverDataName'];
 		$ser_port   = $connAry['server']['port'];
 		
 		$mailInforAry = json_decode($rs[0][4],true); 		
 		$mailExpired	= $mailInforAry['mailExpired'];
 		$attachID		= $mailInforAry['attachID'];
 		$attachNum		= $mailInforAry['attachNum'];
 		$sendType		= $mailInforAry['type'];
 		
 		$passportStr = $rs[0][0];
 		$nickNameStr = $rs[0][1];
 		$mailTitle	= $rs[0][2];
 		$maiContent	= $rs[0][3];
 		if(defined('TIMEZONE')) { 
    	   $timezone = TIMEZONE;
		   if(function_exists('date_default_timezone_set')) date_default_timezone_set($timezone);
		} 
 		$dateline=strtotime($mailExpired);
 		if($attachID == 0 || $attachNum == 0)
 			return new ExcuteResult(ResultStateLevel::ERROR,"邮件不存在附件","-1"); 
 		$usernames = $passportStr;
 		$sqlWhere = " where passport IN(";
 		if($nickNameStr != ""){
 			$usernames = $nickNameStr;
 			$sqlWhere = " where nickname IN(";
 		}
 		$sql_mail = "";
 		if($usernames != ""){
 			$resArray = explode(',',$usernames);
			$resName = "";
			for($i = 0;$i < count($resArray);$i++){
				if($resName != "")
					$resName.= ",";
				if($resArray[$i] != "")
					$resName.= "'".$resArray[$i]."'";
			}
 			$sql_mail = "insert into user_mail(sender, sender_name, reciever, reciever_name, subject, content, attachments, unget_attachment, mail_date, expired_time, state, type) 
						select '系统', '系统', a.user_id, a.nickname, '".$mailTitle."', '".$maiContent."', '".$attachID.":".$attachNum."', 0, unix_timestamp(now()), '".$dateline."', 0, 101
						from mem_user a ".$sqlWhere.$resName.")";
 			
 			
 		}
 		else{
 			$sql_mail = "INSERT INTO sys_global_mail(TYPE, sender_name, SUBJECT, content, attachment, send_time, expired_time)
						VALUES( 100, '系统', '".$mailTitle."', '".$maiContent."', '".$attachID.":".$attachNum."', unix_timestamp(now()), '".$dateline."');";
 			
 		}
 		$r_result = sql_insertNoCellDyn($sql_mail,$ser_IP,$ser_User,$ser_PWD,$ser_Name,"data_".$ser_ID,$ser_port);
 		if($r_result != 0)
 		{
 			$dataAry['bm_ApplyState']  = 1;
			$dataAry['bm_CheckRemark'] = $remark;
			$dataAry['bm_CheckTime']   = date("Y-m-d H:i:s");		
			$dataAry['bm_SendTime']   		   = date("Y-m-d H:i:s");
			$dataAry['bm_GameMailSendState']   = 1;
			$dataAry["bm_Checker"]=$_SESSION['account_ID'];
			foreach (array_keys($dataAry) AS $k=>$v) {
				$attribute[] = "`$v` = '".$dataAry[$v]."'"; 				
 			}
 			$r_updatesql = "UPDATE bm_gamemail SET " . implode(",",$attribute) . " WHERE bm_GameMailID = $mailID";
 			$r_checkUpdate = sql_query($r_updatesql);
 			if($r_checkUpdate != 0){
    			return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    		}
    		else
    	  		return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
 		}
 		else
 			return new ExcuteResult(ResultStateLevel::EXCEPTION,"发送邮件失败",NULL);
 	}
 	
 	/**
 	 * 不通过
 	 * @param unknown_type $mailID
 	 * @param unknown_type $remark
 	 */
 	public function UnCheckMailApplay($mailID,$remark){
 		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
 		$sql = "SELECT g.bm_GameMailTarget, g.bm_GameMailNickName, g.bm_GameMailTitle, g.bm_GameMailDesc, g.bm_MailApplyRemark,   
 				s.bm_ServerConnString,g.bm_ServerID FROM bm_gamemail g LEFT JOIN bm_gameserver s ON g.bm_ServerID = s.bm_ServerID
 			    WHERE g.bm_GameMailID = $mailID";
 		$rs = sql_fetch_rows($sql); 	
 		if(empty($rs))
 			return new ExcuteResult(ResultStateLevel::ERROR,"邮件已经不存在或者出错","-1"); 
 		$dataAry['bm_ApplyState']  = 11;
		$dataAry['bm_CheckRemark'] = $remark;
		$dataAry['bm_CheckTime']   = date("Y-m-d H:i:s");		
		$dataAry["bm_Checker"]=$_SESSION['account_ID'];
		foreach (array_keys($dataAry) AS $k=>$v) {
			$attribute[] = "`$v` = '".$dataAry[$v]."'"; 				
 		}
 		$r_updatesql = "UPDATE bm_gamemail SET " . implode(",",$attribute) . " WHERE bm_GameMailID = $mailID";
 		$r_checkUpdate = sql_query($r_updatesql);
 		if($r_checkUpdate != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    	}
    	else
    	  	return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
 	}
	
}
?>