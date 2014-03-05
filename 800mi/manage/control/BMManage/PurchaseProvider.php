<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMManage/EventLog.php');

/**
 * 功能模块相关
 */
 
 class PurchaseProvider
 {
 	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new PurchaseProvider();
        }
        return self::$instance;
    }
    //到时候需要增加类别条件
    public function ListPurchase()
    {
    	if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$account_id = $_SESSION['account_ID'];
    	$sql = "SELECT a.shopping_cart_id,a.purchase_id,a.goods_id,c.goods_name,c.goods_unit,c.goods_weight,a. goods_num,c.goods_price,
a.purchase_goods_price,a.goods_active_etime,b.add_time,b.return_time, a.purchase_state FROM bm_purchase_info a,bm_purchase_list b, bm_goods c 
WHERE a.purchase_id = b.purchase_id AND a.goods_id = c.goods_id AND b.account_id = ".$account_id." and a.purchase_state < 99 and b.purchase_state < 99;";
    	$r = sql_fetch_rows($sql);
    	if(!empty($r)){
 			$o = Array();
 			$count = count($r);
    		for ($i = 0 ; $i < $count; $i++){
    			$purchaseInfoMDL = $r[$i];
    			$purchaseInfoMDL = new PurchaseInfoMDL($purchaseInfoMDL[0],$purchaseInfoMDL[1],$purchaseInfoMDL[2],$purchaseInfoMDL[3],$purchaseInfoMDL[4],$purchaseInfoMDL[5],
    															$purchaseInfoMDL[6],$purchaseInfoMDL[7],$purchaseInfoMDL[8],$purchaseInfoMDL[9],$purchaseInfoMDL[10],$purchaseInfoMDL[11],$purchaseInfoMDL[12]);
    			$o[] = $purchaseInfoMDL;
    		}
 			return new DataResult(ResultStateLevel::SUCCESS,"1",0,$o);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 		}
    	
    }
    public function AddPurchase($storeID,$remark,$ary=array())
    {
    	if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$account_id = $_SESSION['account_ID'];
    	$purchaseID = sql_fetch_one_cell("SELECT IFNULL(MAX(purchase_id), 0) + 1 FROM bm_purchase_list;") ;
    	$sql = "INSERT INTO bm_purchase_list(purchase_id,account_id,shop_id,add_time,purchase_state,return_time,purchase_price,purchase_remark)" .
    			" VALUES ('$purchaseID','$account_id','$storeID',UNIX_TIMESTAMP(),0,0,0,'$remark')";
    	$r = sql_query($sql);
    	if($r != 0){
    		return self::AddPurchaseInfo($purchaseID,$ary);
    	}    		
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错".$r,$sql);
    }
    
    //修改支付状态
    public function UpdatePurchaseState($purchaseID,$state)
	{
		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$account_id = $_SESSION['account_ID'];
    	$sql = "SELECT account_id,purchase_state FROM bm_purchase_list WHERE purchase_id = ".$purchaseID;
    	$row = sql_fetch_one($sql);
    	if($row == null){
    		return new ExcuteResult(ResultStateLevel::ERROR,"订单编号不存在！","-1"); 
    	}
    	else if($row[0] != $account_id and $_SESSION['account_type'] == "1"){
    		return new ExcuteResult(ResultStateLevel::ERROR,"您没有权限修改该订单状态！","-1"); 
    	}
    	else if($row[1] == "98"){
    		return new ExcuteResult(ResultStateLevel::ERROR,"订单已关闭不能再修改！","-1"); 
    	}
    	$sql = "UPDATE bm_purchase_list SET purchase_state =".$state.", return_time = UNIX_TIMESTAMP() WHERE  purchase_id = ".$purchaseID;
    	$r = sql_query($sql);
    	if($r != 0){
    			return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    		}
    		else{
    			return new ExcuteResult(ResultStateLevel::EXCEPTION,"error",$sql);    			
    		}   
	}
	//修改某商品数量
	public function UpdatePurchaseInfoNum($cartID,$num)
	{		
	}
	
	//在添加进货单后增加进货单明细此处设计到一个进货单回滚
	public function AddPurchaseInfo($purchaseID,$ary=array())
	{
		$Time = time();
		foreach (array_keys($ary) AS $k=>$v) {
				$attribute[] = "$v"; 				
 			}
 		$sql = "SELECT goods_id,goods_active_etime,goods_number,goods_price,goods_active_price FROM bm_goods" .
 				" WHERE goods_id IN (" . implode(",",$attribute) . ") AND goods_state < 99;";
 		$r = sql_fetch_rows($sql);
 		$count = count($r);
 		$purchaseList = null;
 		for ($i = 0 ; $i < $count; $i++){
 			$row = $r[$i];
 			foreach (array_keys($ary) AS $k=>$v) {
 				if ($v == $row[0] and $ary[$v] <=  $row[2]){
 					
 					if ($row[1] == 0 or $row[1] <= $Time){
 						$price = $row[3];
 						$active_etime = 0;
 					} 						
 					else{
 						$price = $row[4];
 						$active_etime = $row[1];
 					}
 					$sql = "UPDATE bm_goods SET goods_number = goods_number - ".$ary[$v]." WHERE goods_id =  ".$row[0].";";
 					sql_query($sql);//即时更新物品库存数量
 					$purchaseList[] = "('$purchaseID','$row[0]','$ary[$v]','$active_etime','$price',0)";
 					break;
 				} 				
 			}
 		}
 			if ($purchaseList != null){
 				$sql = "INSERT INTO bm_purchase_info(purchase_id,goods_id,goods_num,goods_active_etime,purchase_goods_price,purchase_state)VALUES " . implode(",",$purchaseList) . " ;";
 				$r = sql_query($sql);
 				//$r = 0;
 			}
 			else{
 				$r = 0; 		
 			}
 			 					
 			if($r != 0){
    			return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    		}
    		else{
    			$del = "DELETE FROM bm_purchase_list WHERE purchase_id =  ".$purchaseID.";"; 
    			$r = sql_query($del);
    			return new ExcuteResult(ResultStateLevel::EXCEPTION,"error",$sql);    			
    		}   
	}
 }
 
?>
