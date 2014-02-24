<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMManage/EventLog.php');

/**
 * 功能模块相关
 */
class StoreProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new StoreProvider();
        }
        return self::$instance;
    }
    
    public function ListStore()
    {
    	if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$account_id = $_SESSION['account_ID'];
    	$sql = "SELECT * FROM bm_store_info WHERE account_id = ".$account_id." and shop_state < 99;";
    	$r = sql_fetch_rows($sql);
    	if(!empty($r)){
 			$o = Array();
 			$count = count($r);
    		for ($i = 0 ; $i < $count; $i++){
    			$storeMDL = $r[$i];
    			$storeMDL = new StoreMDL($storeMDL[0],$storeMDL[1],$storeMDL[2],$storeMDL[3],$storeMDL[4],$storeMDL[5],
    															$storeMDL[6],$storeMDL[7],$storeMDL[8],$storeMDL[9]);
    			$o[] = $storeMDL;
    		}
 			return new DataResult(ResultStateLevel::SUCCESS,"1",0,$o);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 		}
    }
    
    public function UpdateStore($storeId,$ary=array())
    {
    	if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	if(empty($storeId)) return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    	$account_id = $_SESSION['account_ID'];
    	if(empty($ary)){
 			$sql = "UPDATE bm_store_info SET shop_state = 99 WHERE shop_id = ".$storeId." and account_id = ".$account_id; 		
 		}else{
 			foreach (array_keys($ary) AS $k=>$v) {
				$attribute[] = "`$v` = '".$ary[$v]."'"; 				
 			}
 			$sql = "UPDATE bm_store_info SET " . implode(",",$attribute) . " WHERE shop_id =  ".$storeId." and account_id = ".$account_id; 
 		} 	
 		$r = sql_query($sql);
 		if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",$sql);
    }
    
    public function AddStore($name,$province,$city,$district,$addr,$contacts,$phone)
    {
    	if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$account_id = $_SESSION['account_ID'];
    	$sql = "INSERT INTO bm_store_info(account_id,shop_name,shop_province,shop_city,shop_district,shop_addr,shop_contacts,shop_phone,shop_state)" .
    			"VALUE('$account_id','$name','$province','$city','$district','$addr','$contacts','$phone',0);";
    	$r = sql_insert($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",$sql);
    }
    
    public function DeleteStore($storeId)
    {
    	if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	if(empty($storeId)) return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    	$account_id = $_SESSION['account_ID'];    	 
    	$sql = "UPDATE bm_store_info SET shop_state = 99 WHERE shop_id = ".$storeId." and account_id = ".$account_id; 
 		$r = sql_query($sql);
 		if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错1",NULL);		
    }
    
}
?>
