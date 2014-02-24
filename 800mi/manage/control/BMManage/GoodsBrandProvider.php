<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMManage/EventLog.php');

/**
 * 基础信息   品牌
 */
class GoodsBrandProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new GoodsBrandProvider();
        }
        return self::$instance;
    }
    
    /**
     * 新增品牌
     * @param $name
     * @param $order
     */
     public function AddGoodsBrand($name,$order)
     {
     	AddBMAccountEventLog("新增品牌：".$name,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "insert into bm_goods_brand(brand_name, brand_order)";
    	$sql.= " values ('$name','$order')";
    	$r = sql_insert($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);     	
     }
     
     /**
     * 修改品牌
     * @param $id
     * @param $name
     * @param $order
     * @param $state
     */
     public function  updateGoodsBrand($id, $name,$order,$state)
     {
    	AddBMAccountEventLog("修改品牌：".$name,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "UPDATE bm_goods_brand SET brand_name = $name, brand_order =  $order, brand_state = $state  WHERE brand_id = $id"; 
 		$r = sql_query($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    } 
    
    /**
     * 获取所有品牌信息
     */
    public function ListAll()
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$sql =sprintf("select * from bm_goods_brand where brand_state < 99 order by brand_order ;");
    	$r = sql_fetch_rows($sql);
    	if($r != ""){
    		$o = Array();
    		$count = count($r);
    		for ($i = 0 ; $i < $count; $i++){
    			$goodsBrandMDL = $r[$i];
    			$goodsBrandMDL = new GoodsBrandMDL($goodsBrandMDL[0],$goodsBrandMDL[1],$goodsBrandMDL[2],$goodsBrandMDL[3]);
				$o[] = $goodsBrandMDL;
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,1,$count,$o);
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
    	}
    }
    public function ListBuyType($lv,$type3_id)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	if	($lv =="1")
    		$sql =sprintf("SELECT DISTINCT a.* FROM  bm_goods_brand a, bm_goods_type3 b, bm_goods_type2 c, bm_brand_type3 d where c.type1_id = %d and" .
    				"c.type2_id = b.type2_id and b.type3_id = d.type3_id and a.brand_id = d.brand_id  and a.brand_state < 99 ORDER BY brand_order;",$type3_id);
    	else if  ($lv =="2")
    		$sql =sprintf("SELECT DISTINCT a.* FROM bm_goods_brand a, bm_goods_type3 b, bm_brand_type3 d  where b.type2_id =%d " .
    				" and a.brand_id = d.brand_id and a.brand_state < 99 ORDER BY a.brand_order;",$type3_id);
    	else if  ($lv =="3")
    		$sql =sprintf("SELECT a.* FROM bm_goods_brand a, bm_brand_type3 b where b.type3_id = %d and a.brand_id = b.brand_id and a.brand_state < 99 ORDER BY a.brand_order;",$type3_id);
    	else 
    		$sql =sprintf("SELECT * FROM bm_goods_brand where brand_state < 99 ORDER BY brand_order;");
    		
    	$r = sql_fetch_rows($sql);
    	if($r != ""){
    		$o = Array();
    		$count = count($r);
    		for ($i = 0 ; $i < $count; $i++){
    			$goodsBrandMDL = $r[$i];
    			$goodsBrandMDL = new GoodsBrandMDL($goodsBrandMDL[0],$goodsBrandMDL[1],$goodsBrandMDL[2],$goodsBrandMDL[3]);
				$o[] = $goodsBrandMDL;
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,1,$count,$o);
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
    	}
    }    
}
?>