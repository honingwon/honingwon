<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMAccount/EventLog.php');

/**
 * 基础权限相关
 */
class RightsProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new RightsProvider();
        }
        return self::$instance;
    }
    
    /**
     * 游戏列表 、分区列表、服务器列表
     */
    public function getGameData()
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$sqlGame = "SELECT * FROM bm_game ORDER BY bm_GameID DESC ";
    	$sqlArea = "SELECT * FROM bm_gamearea WHERE bm_AreaState < 99 ";
    	$sqlServ = "SELECT * FROM bm_gameserver WHERE bm_ServerState < 99 ";
 		$rsGame = sql_fetch_rows($sqlGame);
 		$rsArea = sql_fetch_rows($sqlArea);
 		$rsServ = sql_fetch_rows($sqlServ);
 		$array = Array();
 		$aryGame = Array();
 		$aryArea = Array();
 		$aryServ = Array();
 		if(!empty($rsGame)){
 			for ($i = 0 ; $i < count($rsGame); $i++){
    			$gameMDL = $rsGame[$i];
    			$gameArray = Array();
    			$gameArray[] = $gameMDL[1];
    			$gameArray[] = $gameMDL[0];
				$aryGame[] = $gameArray;
    		}
 		}
    	if(!empty($rsArea)){
    		for ($m = 0 ; $m < count($rsArea); $m++){
    			$areaMDL = $rsArea[$m];
    			$areaArray = Array();
    			$areaArray[] = $areaMDL[2];
    			$areaArray[] = $areaMDL[0];
    			$areaArray[] = $areaMDL[1];
				$aryArea[] = $areaArray;
    		}
 		}
    	if(!empty($rsServ)){
    		for ($n = 0 ; $n < count($rsServ); $n++){
    			$servMDL = $rsServ[$n];
    			$servArray = Array();
    			$servArray[] = $servMDL[0];  //服务器ID
    			$servArray[] = $servMDL[3];  //服务器名称
    			$servArray[] = $servMDL[2];   //分区ID
    			$servArray[] = $servMDL[1];   //游戏ID
				$aryServ[] = $servArray;
    		}
 		}
		$array[] = $aryGame;
		$array[] = $aryArea;
		$array[] = $aryServ;
 		return new DataResult(ResultStateLevel::SUCCESS,"",null,$array);;
    }
    
    /**
     * 获取指定账号服务器权限信息
     * @param unknown_type $AccountID
     */
    public function GetServerRightsByAccount($AccountID)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$sql = "SELECT bm_GameID,bm_AreaID,bm_ServerID,bm_AccountID FROM BM_AccountGameServer where bm_AccountID = ".$AccountID;
    	$r = sql_fetch_rows($sql);
    	$array = Array();
    	if(!empty($r)){
 			for ($i = 0 ; $i < count($r); $i++){
    			$rightsServ = $r[$i];
    			$rights = Array();
    			$rights[] = $rightsServ[0];
    			$rights[] = $rightsServ[1];
    			$rights[] = $rightsServ[2];
    			$rights[] = $rightsServ[3];
				$array[] = $rights;
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,"1",count($r),$array);
 		}
 		else
 			return new DataResult(ResultStateLevel::ERROR,"",NULL,NULL);
    }
    
    /**
     * 获取当前登陆账号服务器权限
     */
    public function GetCurrentAccountServerRights($gameID = -1)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$AccountID = $_SESSION['account_ID'];
    	$sql = "SELECT b.bm_ServerID,b.bm_ServerName,b.bm_AreaID  FROM bm_accountgameserver a,bm_gameserver b WHERE a.bm_ServerID = b.bm_ServerID AND b.bm_ServerState < 99 AND a.bm_AccountID = ".$AccountID;
    	if($gameID != -1)
    		$sql.=" AND a.bm_GameID = ".$gameID;
    	$sql.= " ORDER BY bm_ServerPRI";
    	$r = sql_fetch_rows($sql);
    	$array = Array();
    	if(!empty($r)){
 			for ($i = 0 ; $i < count($r); $i++){
    			$rightsServ = $r[$i];
    			$rights = Array();
    			$rights[] = $rightsServ[0];
    			$rights[] = $rightsServ[1];
    			$rights[] = $rightsServ[2];
				$array[] = $rights;
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,"1",count($r),$array);
 		}
 		else
 			return new DataResult(ResultStateLevel::ERROR,"",NULL,NULL);
    }
    
    /**
     * 获取服务器 当前登陆账号有权限的服务器
     * @param $serverID
     */
    public function GetCurrentServerByID($serverID)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$AccountID = $_SESSION['account_ID'];
    	$sql = "SELECT b.bm_ServerID,b.bm_ServerName,b.bm_ServerConnString FROM bm_accountgameserver a,bm_gameserver b WHERE a.bm_ServerID = b.bm_ServerID AND b.bm_ServerState < 99 AND a.bm_AccountID = ".$AccountID." AND b.bm_ServerID = ".$serverID;
    	$r = sql_fetch_rows($sql);
    	$array = Array();
    	if(!empty($r)){
 			for ($i = 0 ; $i < count($r); $i++){
    			$rightsServ = $r[$i];
    			$rights = Array();
    			$rights[] = $rightsServ[0];
    			$rights[] = $rightsServ[1];
    			$rights[] = $rightsServ[2];
				$array[] = $rights;
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,"1",count($r),$array);
 		}
 		else
 			return new DataResult(ResultStateLevel::ERROR,"",NULL,NULL);
    }
    
    /**
     * 更新指定账号服务器权限
     * @param unknown_type $AccountID
     * @param unknown_type $addStr
     * @param unknown_type $delStr
     */
    public function UpdateServerRight($AccountID,$addStr,$delStr)
    {
    	AddBMAccountEventLog("更新服务器权限ID：".$AccountID."，新增：".$addStr.",删除：".$delStr,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	try{
    		$msg = "";
    		if(!empty($delStr)){
    			$sqldel ="delete from BM_AccountGameServer where bm_AccountID = ".$AccountID." AND bm_ServerID IN (".$delStr.")";
    			$r = sql_query($sqldel);
    			if($r == 0)
    		  	  $msg ="删除服务器权限失败！";
    		}
    		if(!empty($addStr)){
    			$sqladd = "insert into BM_AccountGameServer (bm_GameID,bm_AreaID,bm_ServerID,bm_AccountID) values ".$addStr;
    			$add = sql_query($sqladd);
    			if($add == 0)
    				$msg.="新增账号服务器失败！";
    		}
    		return new ExcuteResult(ResultStateLevel::SUCCESS,$msg,NULL);
    	}
    	catch(Exception $e)
 		{
 			return new ExcuteResult(ResultStateLevel::ERROR,"异常抛出",NULL);
 		}
    }
    
    /**
     * 获取指定账号功能模块权限
     * @param unknown_type $Account
     */
    public function GetModuleRightsByAccountID($Account)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$sql = "SELECT b.bm_ModuleID";
    	$sql.= " FROM bm_accountgroup a,bm_groupmodule b";
    	$sql.= " WHERE a.bm_GroupID = b.bm_GroupID AND a.bm_AccountID = ".$Account;
    	$sql.= " UNION";
    	$sql.= " SELECT bm_ModuleID FROM bm_accountmodule WHERE bm_AccountID = ".$Account;
    	$r = sql_fetch_rows($sql);
    	$rights = Array();
    	if(count($r) > 0){
 			for ($i = 0 ; $i < count($r); $i++){
 				$arry =Array();
    			$arry[] = $r[$i][0];
				$rights[] = $arry; 
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,"",count($r),$rights);
 		}
 		return new DataResult(ResultStateLevel::SUCCESS,"异常错误",NULL,$rights);
    } 
    
    /**
     * 更新指定账号功能模块权限
     * @param unknown_type $AccountID
     * @param unknown_type $addStr
     * @param unknown_type $delStr
     */
    public function UpdateModuleRight($AccountID,$addStr,$delStr)
    {
    	AddBMAccountEventLog("更新模块权限ID：".$AccountID."，新增：".$addStr.",删除：".$delStr,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	try{
    		$msg = "";
    		if(!empty($delStr)){
    			$sqldel ="delete from BM_AccountModule where bm_AccountID = ".$AccountID." AND bm_ModuleID IN (".$delStr.")";
    			$r = sql_query($sqldel);
    			if($r == 0)
    		  	  $msg ="删除模块权限失败！";
    		}
    		if(!empty($addStr)){
    			$sqladd = "insert into BM_AccountModule (bm_AccountID,bm_ModuleID) values ".$addStr;
    			$add = sql_query($sqladd);
    			if($add == 0)
    				$msg.="新增模块权限失败！";
    		}
    		return new ExcuteResult(ResultStateLevel::SUCCESS,$msg,NULL);
    	}
    	catch(Exception $e)
 		{
 			return new ExcuteResult(ResultStateLevel::ERROR,"异常抛出",NULL);
 		}
    }
    
    /**
     * 获取指定账号所在分组
     * @param unknown_type $AccountID
     */
    public function GetGroupInfoByAccount($AccountID)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$sql = "SELECT bm_GroupID from BM_AccountGroup where bm_AccountID = ".$AccountID;
    	$r = sql_fetch_rows($sql);
    	$array = Array();
    	if(count($r) > 0){
 			for ($i = 0 ; $i < count($r); $i++){
 				$arry =Array();
    			$arry[] = $r[$i][0];
				$rights[] = $arry; 
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,"",count($r),$rights);
 		}
 		return new DataResult(ResultStateLevel::SUCCESS,"异常错误",NULL,$array);
    }
    
    /**
     * 更新指定账号所在分组
     * @param $AccountID
     * @param $addStr
     * @param $delStr
     */
    public function UpdateAccountGroup($AccountID,$addStr,$delStr)
    {
    	AddBMAccountEventLog("更新账号分组ID：".$AccountID."，新增：".$addStr.",删除：".$delStr,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	try{
    		$msg = "";
    		if(!empty($delStr)){
    			$sqldel ="delete from BM_AccountGroup where bm_AccountID = ".$AccountID." AND bm_GroupID IN (".$delStr.")";
    			$r = sql_query($sqldel);
    			if($r == 0)
    		  	  $msg ="删除账号所在分组失败！";
    		}
    		if(!empty($addStr)){
    			$sqladd = "insert into BM_AccountGroup (bm_AccountID,bm_GroupID) values ".$addStr;
    			$add = sql_query($sqladd);
    			if($add == 0)
    				$msg.="新增账号所在分组失败！";
    		}
    		return new ExcuteResult(ResultStateLevel::SUCCESS,$msg,NULL);
    	}
    	catch(Exception $e)
 		{
 			return new ExcuteResult(ResultStateLevel::ERROR,"异常抛出",NULL);
 		}
    }
    
    /**
     * 获取指定分组功能模块权限
     * @param $GroupID
     */
    public function GetGroupModuleRightsByGroup($GroupID)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$sql = "SELECT bm_ModuleID from BM_GroupModule where bm_GroupID = ".$GroupID;
    	$r = sql_fetch_rows($sql);
    	$array = Array();
    	if(count($r) > 0){
 			for ($i = 0 ; $i < count($r); $i++){
 				$arry =Array();
    			$arry[] = $r[$i][0];
				$rights[] = $arry; 
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,"",count($r),$rights);
 		}
 		return new DataResult(ResultStateLevel::SUCCESS,"异常错误",NULL,$array);
    }
    
    /**
     * 更新指定分组功能模块权限
     * @param unknown_type $GroupID
     * @param unknown_type $addStr
     * @param unknown_type $delStr
     */
    public function UpdateGroupMoudleRights($GroupID,$addStr,$delStr)
    {
    	AddBMAccountEventLog("更新分组模块权限ID：".$GroupID."，新增：".$addStr.",删除：".$delStr,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	try{
    		$msg = "";
    		if(!empty($delStr)){
    			$sqldel ="delete from BM_GroupModule where bm_GroupID = ".$GroupID." AND bm_ModuleID IN (".$delStr.")";
    			$r = sql_query($sqldel);
    			if($r == 0)
    		  	  $msg ="删除分组模块权限失败！";
    		}
    		if(!empty($addStr)){
    			$sqladd = "insert into BM_GroupModule (bm_GroupID,bm_ModuleID) values ".$addStr;
    			$add = sql_query($sqladd);
    			if($add == 0)
    				$msg.="新增分组模块权限失败！";
    		}
    		return new ExcuteResult(ResultStateLevel::SUCCESS,$msg,NULL);
    	}
    	catch(Exception $e)
 		{
 			return new ExcuteResult(ResultStateLevel::ERROR,"异常抛出",NULL);
 		}
    }
    
    /**
     * 获取当前登陆账号指定游戏 区权限信息 区ID，区名称
     * @param $game
     */
    public function GetAccountAreaRights($game){
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$AccountID = $_SESSION['account_ID'];
    	$sql = "SELECT a.bm_AreaID ,a.bm_AreaName FROM (SELECT DISTINCT bm_AreaID FROM bm_accountgameserver WHERE bm_AccountID = ".$AccountID." AND bm_GameID = ".$game.") b,bm_gamearea a  WHERE a.bm_AreaID = b.bm_AreaID ORDER BY a.bm_AreaID";
    	$r = sql_fetch_rows($sql);
    	$array = Array();
    	if(!empty($r)){
 			for ($i = 0 ; $i < count($r); $i++){
    			$rightsServ = $r[$i];
    			$rights = Array();
    			$rights[] = $rightsServ[0];
    			$rights[] = $rightsServ[1];
				$array[] = $rights;
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,"1",count($r),$array);
 		}
 		else
 			return new DataResult(ResultStateLevel::ERROR,"",NULL,NULL);
    }
}