<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMManage/EventLog.php');

/**
 * 功能模块相关
 */
 class GoodsProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new GoodsProvider();
        }
        return self::$instance;
    }
    
    public function ListGoods($lv,$type3_id,$brand_id,$offer,$pageSize)
    {
    	$brand_id = intval($brand_id);
    	if($brand_id > 0)
    		$where = sprintf(" a.brand_id = %d  and  ", $brand_id);
    	else
    		$where = "";    		
    	if	($lv =="1"){
    		$from = " bm_goods a, bm_goods_type3 b, bm_goods_type2 c ";
    		$where = $where."c.type1_id = ".$type3_id." and c.type2_id = b.type2_id and b.type3_id = a.type3_id and goods_state < 99 ";
    	}
    	else if  ($lv =="2"){
    		$from = " bm_goods a, bm_goods_type3 b";
    		$where = $where."b.type2_id  = ".$type3_id." and b.type3_id = a.type3_id and goods_state < 99 ";
    	}
    	else if  ($lv =="3"){
    		$from = " bm_goods a";
    		$where =  $where." a.type3_id  = ".$type3_id."  and goods_state < 99 ";
    	}else{
    		$from = " bm_goods a";
    		$where =  $where."goods_state < 99 ";
    	}
    	$sql = "SELECT a.* FROM".$from." where ".$where."ORDER BY goods_id DESC LIMIT ". $offer.",".$pageSize;
    	$r = sql_fetch_rows($sql);
    	if(!empty($r)){
 			$o = Array();
 			$count = count($r);
    		for ($i = 0 ; $i < $count; $i++){
    			$goodsMDL = $r[$i];
    			$goodsMDL = new GoodsMDL($goodsMDL[0],$goodsMDL[1],$goodsMDL[2],$goodsMDL[3],$goodsMDL[4],
    										$goodsMDL[5],$goodsMDL[6],$goodsMDL[7],$goodsMDL[8],$goodsMDL[9],$goodsMDL[10],
    										$goodsMDL[11],$goodsMDL[12],$goodsMDL[13],$goodsMDL[14],$goodsMDL[15]);
				$o[] = $goodsMDL;
    		}
 			$count = sql_fetch_one_cell("SELECT count() FROM ".$from." where ".$where.";"); 
 			//return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 			return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$o);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 		}
    }
    public function UpdateGoods($goodsId, $ary=array())
    {
    	AddBMAccountEventLog("修改物品信息：".$goodsId,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	if(empty($goodsId)) return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    	$account_id = $_SESSION['account_ID'];
 		if(empty($ary)){
 			$sql = "UPDATE bm_goods SET goods_state = 99 WHERE goods_id = ".$goodsId." and account_id = ".$account_id; 			
 		}else{
 			foreach (array_keys($ary) AS $k=>$v) {
				$attribute[] = "`$v` = '".$ary[$v]."'"; 				
 			}
 			$sql = "UPDATE bm_goods SET " . implode(",",$attribute) . " WHERE goods_id =  ".$goodsId." and account_id = ".$account_id; 
 		} 	
 		$r = sql_query($sql);
 		if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    /**
     * 新增物品
     */
    public function AddGoods($_AccountID,$_BrandID,$_Type3ID,$_Barcode,$_Name,$_Unit,$_Weight,$_ActiveSTime,
															$_ActiveETime,$_PicUrl,$_Number,$_Price,$_ActivePrice,$_Remark)
	{
		AddBMAccountEventLog("新增物品：".$_Name,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "insert into bm_goods(account_id,brand_id,type3_id,goods_barcode,goods_name,goods_unit,goods_weight,goods_active_stime" .
    			",goods_active_etime,goods_pic_url,goods_state,goods_number,goods_price,goods_active_price,goods_remark)";
    	$sql.= "values ('$_AccountID','$_BrandID','$_Type3ID','$_Barcode','$_Name','$_Unit','$_Weight','$_ActiveSTime'," .
    			"'$_ActiveETime','$_PicUrl',0,'$_Number','$_Price','$_ActivePrice','$_Remark')";
    	$r = sql_insert($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",$sql);
	}
	/**
     * 删除物品
     */
     public function DeleteGoods($goodsId)
     {
     	AddBMAccountEventLog("删除物品：".$goodsId,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	if(empty($goodsId)) return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    	$account_id = $_SESSION['account_ID'];
 		$sql = "UPDATE bm_goods SET goods_state = 99 WHERE goods_id = ".$goodsId." and account_id = ".$account_id; 
 		$r = sql_query($sql);
 		if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错1",NULL);		
     }
}
?>
