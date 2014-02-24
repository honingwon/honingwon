<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMManage/EventLog.php');

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
    	$sql =sprintf("SELECT * FROM bm_module where module_state < 99 ORDER BY module_pri");
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
    	$sql =sprintf("SELECT * FROM bm_module where module_state  = 3 ORDER BY module_id DESC LIMIT $offer, $pageSize");
    	$r = sql_fetch_rows($sql);
    	if(!empty($r)){
 			$o = Array();
 			$count = count($r);
    		for ($i = 0 ; $i < $count; $i++){
    			$moduleMDL = $r[$i];
    			$moduleMDL = new ModuleMDL($moduleMDL[0],$moduleMDL[1],$moduleMDL[2],$moduleMDL[3],$moduleMDL[4],
    										$moduleMDL[5],$moduleMDL[6],$moduleMDL[7],$moduleMDL[8]);
				$o[] = $moduleMDL;
    		}
 			$count = sql_fetch_one_cell("SELECT COUNT(1) as num FROM bm_module where module_state  = 3 "); 
 			return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$o);
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
    	$sql =sprintf("SELECT * FROM bm_module where module_id = %d ",$moduleID);
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
 			$sql = "UPDATE bm_module SET module_state = 99 WHERE module_id = $moduleId"; 			
 		}else{
 			foreach (array_keys($ary) AS $k=>$v) {
				$attribute[] = "`$v` = '".$ary[$v]."'"; 				
 			}
 			$sql = "UPDATE bm_module SET " . implode(",",$attribute) . " WHERE module_id = $moduleId"; 
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
    	$sql = "insert into bm_module (module_name,fmodule_id,module_level,module_url,fmodule_url,module_pri,module_state,module_remark)";
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
 		$sql = "UPDATE bm_module SET module_state = 99 WHERE module_id = $moduleID"; 	
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
    	// echo'<SCRIPT language="JavaScript">window.alert("'.$User.'");</SCRIPT>';	
    	$sql = "SELECT a.module_id,a.module_name,a.module_url,a.fmodule_id";
    	$sql.= "  FROM bm_module a,(";
    	$sql.= "  SELECT b.module_id";
    	$sql.= "  FROM bm_account_group a,bm_group_module b";
    	$sql.= "  WHERE a.group_id = b.group_id AND a.account_id = ".$User." UNION ";
    	$sql.= "  SELECT module_id FROM bm_account_module WHERE account_id = ".$User." ) b";
    	$sql.= "  WHERE a.module_id = b.module_id AND a.module_state < 99 ORDER BY a.module_pri";
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
    	$sql = "SELECT a.module_id,a.module_name,a.module_url,a.fmodule_id";
    	$sql.= "  FROM bm_module a,(";
    	$sql.= "  SELECT b.module_id";
    	$sql.= "  FROM bm_account_group a,bm_group_module b";
    	$sql.= "  WHERE a.group_id = b.group_id AND a.account_id = ".$User." UNION ";
    	$sql.= "  SELECT module_id FROM bm_account_module WHERE account_id = ".$User." ) b";
    	$sql.= "  WHERE a.module_id = b.module_id AND a.module_state < 99 AND a.fmodule_id = ".$fmoduleID." ORDER BY a.module_pri";
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
    	$sql = "SELECT a.module_id,a.module_name,a.module_url,a.fmodule_id";
    	$sql.= "  FROM bm_module a,(";
    	$sql.= "  SELECT b.module_id";
    	$sql.= "  FROM bm_account_group a,bm_group_module b";
    	$sql.= "  WHERE a.group_id = b.group_id AND a.account_id = ".$User." UNION ";
    	$sql.= "  SELECT module_id FROM bm_account_module WHERE account_id = ".$User." ) b";
    	$sql.= "  WHERE a.module_id = b.module_id AND a.module_state < 99 < 99 AND a.module_id = ".$moduleID;
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