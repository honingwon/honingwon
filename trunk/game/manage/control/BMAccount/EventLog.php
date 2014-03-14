<?php
require_once(dirname(__FILE__).'/../../view/common.php');
require_once(dirname(__FILE__).'/../../utils/Utils.php');
require_once(DATALIB . '/SqlResult.php');
require_once('EventLogTypeEnum.php');

/**
 * 增加后台基本模块操作日志
 * @param $Remark
 * @param $EventType=1 后台基础信息 2=卡库  10=幻龙骑士
 */
function AddBMAccountEventLog($Remark,$EventType)
{
	if(!isset($_SESSION)){
    		session_start();
	}
	if(!isset($_SESSION['account_ID']))  {
    		return;
    }
    else{
    	$accountID 		= $_SESSION['account_ID'];
    	$accountName 	= "";
    	if(isset($_SESSION['user']))  {
    		$accountName 	= $_SESSION['user']."操作：";
    	}	
    	if(defined('TIMEZONE')) { 
    		$timezone = TIMEZONE;
		    if(function_exists('date_default_timezone_set')) date_default_timezone_set($timezone);
		}
    	$Time 			= date("Y-m-d H:i:s");
		$OperateIP   = Utils::get_client_ip();
		$Remark = $accountName.$Remark;
		$sql = "INSERT INTO bm_eventlog(bm_EventType, bm_AccountID, bm_OperateIP, bm_EventDesc, bm_CreateTime) 
			VALUES ($EventType, $accountID, '$OperateIP', '$Remark', '$Time')";			
		sql_insert($sql);
    } 	
}

?>