<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMManage/EventLog.php');

/**
 * 基础信息   分组
 */
class GoodsTypeProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new GoodsTypeProvider();
        }
        return self::$instance;
    }
    
    /**
     * 新增物品类别(1,2,3)
     * @param $index
     * @param $name
     * @param $order
     */
     public function AddGoodsType($index,$name,$order)
     {
     	AddBMAccountEventLog("新增类别".$index."：".$name,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	switch($index)
    	{
    		case 1:
    			$sql = "insert into bm_goods_type1(type1_name, type1_order)";break;
    		case 2:
    			$sql = "insert into bm_goods_type2(type2_name, type2_order)";break;
    		case 3:
    			$sql = "insert into bm_goods_type3(type3_name, type3_order)";break;
    	}
    	$sql.= " values ('$name','$order')";
    	$r = sql_insert($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);     	
     }
     
     /**
     * 修改物品类别1
     * @param $id
     * @param $name
     * @param $order
     * @param $state
     */
     public function  updateGoodsType1($id, $name,$order,$state)
     {
    	AddBMAccountEventLog("修改商品类别1：".$name,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "UPDATE bm_goods_type1 SET type1_name = $name, type1_order =  $order, type1_state = $state  WHERE type1_id = $id"; 
 		$r = sql_query($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    } 

     /**
     * 修改物品类别2
     * @param $id
     * @param $type1_id
     * @param $name
     * @param $order
     * @param $state
     */
    public function  updateGoodsType2($id,$type1_id,$name,$order,$state)
    {
    	AddBMAccountEventLog("修改商品类别2：".$name,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "UPDATE bm_goods_type2 SET type1_id = $type1_id, type2_name = $name, type2_order =  $order , type2_state = $state WHERE type2_id = $id"; 
 		$r = sql_query($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    } 

     /**
     * 修改物品类别3
     * @param $id
     * @param $type2_id
     * @param $name
     * @param $order
     * @param $state
     */
    public function  updateGoodsType3($id,$type2_id,$name,$order,$state)
    {
    	AddBMAccountEventLog("修改商品类别3：".$name,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "UPDATE bm_goods_type3 SET type2_id = $type2_id, type3_name = $name, type3_order =  $order , type3_state = $state WHERE type3_id = $id"; 
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
    	$sql =sprintf("select a.type1_id,a.type1_name,b.type2_id,b.type2_name,c.type3_id,c.type3_name" .
    			" from bm_goods_type1 a, bm_goods_type2 b, bm_goods_type3 c" .
    			" where a.type1_id = b.type1_id and b.type2_id = c.type2_id" .
    			" order by a.type1_order, b.type2_order, c.type3_order");
    	$r = sql_fetch_rows($sql);
    	if($r != ""){
    		$o = Array();
    		$count = count($r);
    		for ($i = 0 ; $i < $count; $i++){
    			$goodsTypeMDL = $r[$i];
    			$goodsTypeMDL = new GoodsTypeMDL($goodsTypeMDL[0],$goodsTypeMDL[1],$goodsTypeMDL[2],
    																				$goodsTypeMDL[3],$goodsTypeMDL[4],$goodsTypeMDL[5]);
				$o[] = $goodsTypeMDL;
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,1,$count,$o);
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
    	}
    }
}
?>