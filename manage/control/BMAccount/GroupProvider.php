<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMAccount/EventLog.php');

/**
 * 基础信息   分组
 */
class GroupProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new GroupProvider();
        }
        return self::$instance;
    }
    
    /**
     * 新增分组
     * @param $name
     * @param $remark
     */
    public function AddGroup($name,$remark)
    {
    	AddBMAccountEventLog("新增分组：".$name,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "insert into BM_Group (bm_GroupName,bm_RankRemark)";
    	$sql.= " values ('$name','$remark')";
    	$r = sql_insert($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 更新指定分组信息
     * @param $groupId
     * @param $ary
     */
    public function UpdateGroup($groupId,$ary=array())
    {
    	AddBMAccountEventLog("修改分组ID：".$groupId,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	foreach (array_keys($ary) AS $k=>$v) {
				$attribute[] = "`$v` = '".$ary[$v]."'"; 				
 		}
 		$sql = "UPDATE BM_Group SET " . implode(",",$attribute) . " WHERE bm_GroupID = $groupId"; 
 		$r = sql_query($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 获取所有分组信息
     */
    public function ListAll()
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$sql =sprintf("SELECT * FROM BM_Group");
    	$r = sql_fetch_rows($sql);
    	if($r != ""){
    		$o = Array();
    		$count = count($r);
    		for ($i = 0 ; $i < $count; $i++){
    			$groupMDL = $r[$i];
    			$groupMDL = new GroupMDL($groupMDL[0],$groupMDL[1],$groupMDL[2]);
				$o[] = $groupMDL;
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$o);
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
    	}
    }
}
?>