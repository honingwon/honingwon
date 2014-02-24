<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMAccount/EventLog.php');

/**
 * 功能模块相关
 */
class ModuleManageProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new ModuleManageProvider();
        }
        return self::$instance;
    }
    
    /**
     * 获取所有模块
     */
    public function ListAllModule()
    {
    	$sql =sprintf("SELECT * FROM bm_module where bm_ModuleState < 99 ORDER BY bm_ModulePRI");
    	$r = sql_fetch_rows($sql);
    	if($r != ""){
    		$o = Array();
    		$count = count($r);
    		for ($i = 0 ; $i < $count; $i++){
    			$moduleMDL = $r[$i];
    			$moduleMDL = new ModuleMDL($moduleMDL[0],$moduleMDL[1],$moduleMDL[2],$moduleMDL[3],$moduleMDL[4],
    										$moduleMDL[5],$moduleMDL[6],$moduleMDL[7],$moduleMDL[8]);
				$o[] = $moduleMDL;
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$o);
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
    	}
    }
    
    /**
     * 获取受到服务器特殊限制的功能模块
     */
    public function ListServerMoudule($offer,$pageSize)
    {
    	$sql =sprintf("SELECT * FROM bm_module where bm_ModuleState  = 3 ORDER BY bm_ModuleID DESC LIMIT $offer, $pageSize");
    	$r = sql_fetch_rows($sql);
    	if(!empty($r)){
 			$o = Array();
    		for ($i = 0 ; $i < $count; $i++){
    			$moduleMDL = $r[$i];
    			$moduleMDL = new ModuleMDL($moduleMDL[0],$moduleMDL[1],$moduleMDL[2],$moduleMDL[3],$moduleMDL[4],
    										$moduleMDL[5],$moduleMDL[6],$moduleMDL[7],$moduleMDL[8]);
				$o[] = $moduleMDL;
    		}
 			$count = sql_fetch_one_cell("SELECT COUNT(*) as num FROM bm_module where bm_ModuleState  = 3 "); 
 			return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$ary);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 		}
    }
    
    /**
     * 获取指定模块信息
     * @param $moduleID
     */
    public function GetOneModule($moduleID)
    {
    	$sql =sprintf("SELECT * FROM bm_module where bm_ModuleID = %d ",$moduleID);
    	$r = sql_fetch_one($sql);
    	if($r != ""){
    		$o = Array();
    		$moduleMDL = new ModuleMDL($r[0],$r[1],$r[2],$r[3],$r[4],
    										$r[5],$r[6],$r[7],$r[8]);
			$o[] = $moduleMDL;
    		return new DataResult(ResultStateLevel::SUCCESS,"1",1,$o);
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
    	}
    }
    
    /**
     * 修改指定的功能模块信息
     * @param $moduleId
     * @param $ary
     */
    public function UpdateModule($moduleId, $ary=array())
    {
    	AddBMAccountEventLog("修改功能模块ID：".$moduleId,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	if(empty($moduleId)) return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
 		if(empty($ary)){
 			$sql = "UPDATE bm_module SET bm_ModuleState = 99 WHERE bm_ModuleID = $moduleId"; 			
 		}else{
 			foreach (array_keys($ary) AS $k=>$v) {
				$attribute[] = "`$v` = '".$ary[$v]."'"; 				
 			}
 			$sql = "UPDATE bm_module SET " . implode(",",$attribute) . " WHERE bm_ModuleID = $moduleId"; 
 		} 	
 		$r = sql_query($sql);
 		if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 新增功能模块
     * @param $moduleName
     * @param $fmoduleId
     * @param $moduleLevel
     * @param $moduleUrl
     * @param $moduleFurl
     * @param $modulePri
     * @param $moduleState
     * @param $moduleRemark
     */
    public function AddModule($moduleName,$fmoduleId,$moduleLevel,
          $moduleUrl,$moduleFurl,$modulePri,$moduleState,$moduleRemark)
    {
    	AddBMAccountEventLog("新增功能模块：".$moduleName,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "insert into bm_module (bm_ModuleName,bm_FModuleID,bm_ModuleLevel,bm_ModuleUrl,bm_FModuleUrl,bm_ModulePRI,bm_ModuleState,bm_ModuleRemark)";
    	$sql.= "values ('$moduleName','$fmoduleId','$moduleLevel','$moduleUrl','$moduleFurl','$modulePri','$moduleState','$moduleRemark')";
    	$r = sql_insert($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 删除功能模块
     * @param $moduleID
     */
    public function DelModule($moduleID)
    {
    	AddBMAccountEventLog("删除功能模块ID：".$moduleID,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	if(empty($moduleID)) return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
 		$sql = "UPDATE bm_module SET bm_ModuleState = 99 WHERE bm_ModuleID = $moduleID"; 	
 		$r = sql_query($sql);
 		if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错1",NULL);		
    }
    
    /**
     * 获取当前登录账号的所有功能模块权限
     */
    public function GetModuleRights()
    {
    	if(!isset($_SESSION)){
    		session_start();
		}
    	if(!isset($_SESSION['account_ID'])) {
    		return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);	
    	}
    	if(isset($_SESSION['AY_Fmodule']) && isset($_SESSION['AY_Module'])) {
    		return new DataResult(ResultStateLevel::SUCCESS,"0","-1",NULL);	
    	}
    	$User = $_SESSION['account_ID'];
    	$sql = "SELECT a.bm_ModuleID,a.bm_ModuleName,a.bm_ModuleUrl,a.bm_FModuleID";
    	$sql.= "  FROM bm_module a,(";
    	$sql.= "  SELECT b.bm_ModuleID";
    	$sql.= "  FROM bm_accountgroup a,bm_groupmodule b";
    	$sql.= "  WHERE a.bm_GroupID = b.bm_GroupID AND a.bm_AccountID = ".$User." UNION ";
    	$sql.= "  SELECT bm_ModuleID FROM bm_accountmodule WHERE bm_AccountID = ".$User." ) b";
    	$sql.= "  WHERE a.bm_ModuleID = b.bm_ModuleID AND a.bm_ModuleState < 99 ORDER BY a.bm_ModulePRI";
    	$r = sql_fetch_rows($sql);
    	$FModuleList = Array();
    	$ModuleList = Array();
    	if(count($r) > 0){
 			for ($i = 0 ; $i < count($r); $i++){
 				$arry =Array();
    			$arry[] = $r[$i][0];  //模块ID
    			$arry[] = $r[$i][1];  //模块名称
    			$arry[] = $r[$i][2];  //模块地址
    			$arry[] = $r[$i][3];  //父模块ID
				if($r[$i][3] == 0)
					$FModuleList[] = $arry; 
				else
					$ModuleList[] = $arry; 
				
    		}
    		$_SESSION['AY_Fmodule']   =  $FModuleList;
			$_SESSION['AY_Module']   =  $ModuleList;
    		return new DataResult(ResultStateLevel::SUCCESS,"",count($r),$FModuleList);
 		}
 		return new DataResult(ResultStateLevel::SUCCESS,"账号未有权限或者执行失败",NULL,NULL);
    }
    
    /**
     * 获取一个模块子模块的列表
     * @param $fmoduleID
     */
    public function GetModuleRightsByFmoduleId($fmoduleID)
    {
    	if(!isset($_SESSION)){
    		session_start();
		}
    	if(!isset($_SESSION['account_ID'])) {
    		return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);	
    	}
    	$User = $_SESSION['account_ID'];
    	$sql = "SELECT a.bm_ModuleID,a.bm_ModuleName,a.bm_ModuleUrl,a.bm_FModuleID";
    	$sql.= "  FROM BM_Module a,(";
    	$sql.= "  SELECT b.bm_ModuleID";
    	$sql.= "  FROM bm_accountgroup a,bm_groupmodule b";
    	$sql.= "  WHERE a.bm_GroupID = b.bm_GroupID AND a.bm_AccountID = ".$User." UNION ";
    	$sql.= "  SELECT bm_ModuleID FROM bm_accountmodule WHERE bm_AccountID = ".$User." ) b";
    	$sql.= "  WHERE a.bm_ModuleID = b.bm_ModuleID AND a.bm_ModuleState < 99 AND a.bm_FModuleID = ".$fmoduleID." ORDER BY a.bm_ModulePRI";
    	$r = sql_fetch_rows($sql);
    	$ModuleList = Array();
    	if(count($r) > 0){
 			for ($i = 0 ; $i < count($r); $i++){
 				$arry =Array();
    			$arry[] = $r[$i][0];  //模块ID
    			$arry[] = $r[$i][1];  //模块名称
    			$arry[] = $r[$i][2];  //模块地址
    			$arry[] = $r[$i][3];  //父模块ID
				$ModuleList[] = $arry; 
				
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,"",count($r),$ModuleList);
 		}
 		return new DataResult(ResultStateLevel::ERROR,"账号未有权限或者执行失败",NULL,NULL);
    }
    
    /**
     * 判断一个模块是否当前账号有权限
     * @param $moduleID
     */
    public function IsMoudleHasRights($moduleID)
    {
    	if(!isset($_SESSION)){
    		session_start();
		}
    	if(!isset($_SESSION['account_ID'])) {
    		return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);	
    	}
    	$User = $_SESSION['account_ID'];
    	$sql = "SELECT a.bm_ModuleID,a.bm_ModuleName,a.bm_ModuleUrl,a.bm_FModuleID";
    	$sql.= "  FROM BM_Module a,(";
    	$sql.= "  SELECT b.bm_ModuleID";
    	$sql.= "  FROM bm_accountgroup a,bm_groupmodule b";
    	$sql.= "  WHERE a.bm_GroupID = b.bm_GroupID AND a.bm_AccountID = ".$User." UNION ";
    	$sql.= "  SELECT bm_ModuleID FROM bm_accountmodule WHERE bm_AccountID = ".$User." ) b";
    	$sql.= "  WHERE a.bm_ModuleID = b.bm_ModuleID AND a.bm_ModuleState < 99 AND a.bm_ModuleID = ".$moduleID;
    	$r = sql_fetch_rows($sql);
    	$ModuleList = Array();
    	if(count($r) > 0){
 			for ($i = 0 ; $i < count($r); $i++){
 				$arry =Array();
    			$arry[] = $r[$i][0];  //模块ID
    			$arry[] = $r[$i][1];  //模块名称
    			$arry[] = $r[$i][2];  //模块地址
    			$arry[] = $r[$i][3];  //父模块ID
				$ModuleList[] = $arry; 
				
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,"",count($r),$ModuleList);
 		}
 		return new DataResult(ResultStateLevel::ERROR,"账号未有权限或者执行失败",NULL,NULL);
    }
}
?>