<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMManage/EventLog.php');

/**
 * 功能模块相关
 */
 class ShoppingCartProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new ShoppingCartProvider();
        }
        return self::$instance;
    }
    
    public function ListShoppingCart()
    {
    	if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$account_id = $_SESSION['account_ID'];
    	$sql = "SELECT a.shopping_cart_id,a.account_id,a.goods_num,a.add_time,
b.goods_id,b.goods_barcode,b.goods_name,b.goods_unit,b.goods_weight,b.goods_active_stime,b.goods_active_etime,b.goods_pic_url,b.goods_number,b.goods_price,b.goods_active_price
 FROM bm_shopping_cart a,bm_goods b WHERE a.account_id = ".$account_id." AND a.goods_id = b.goods_id AND b.goods_state < 99 ORDER BY a.shopping_cart_id;";
 		$r = sql_fetch_rows($sql);
    	if(!empty($r)){
 			$o = Array();
 			$count = count($r);
    		for ($i = 0 ; $i < $count; $i++){
    			$shoppingCartMDL = $r[$i];
    			$goodsSimpleMDL = new GoodsSimpleMDL($shoppingCartMDL[4],
    										$shoppingCartMDL[5],$shoppingCartMDL[6],$shoppingCartMDL[7],$shoppingCartMDL[8],$shoppingCartMDL[9],$shoppingCartMDL[10],
    										$shoppingCartMDL[11],$shoppingCartMDL[12],$shoppingCartMDL[13],$shoppingCartMDL[14]);
    			$shoppingCartMDL = new ShoppingCartMDL($shoppingCartMDL[0],$shoppingCartMDL[1],$shoppingCartMDL[2],$shoppingCartMDL[3],$goodsSimpleMDL);
				$o[] = $shoppingCartMDL;
    		}
 			return new DataResult(ResultStateLevel::SUCCESS,"1",0,$o);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 		}
    }
	/**
     * 添加到购物车
     */
	public function AddShoppingCart($_GoodsId,$_GoodsNum)
	{
		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$account_id = $_SESSION['account_ID'];	
    	$sql = "insert into bm_shopping_cart(account_id,goods_id,goods_num,add_time) values('$account_id','$_GoodsId','$_GoodsNum',now())";
    	$r = sql_insert($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",$sql);
	}
	/**
     * 删除购物车中商品
     */
	public function DelShoppingCart($_ShoppingCartId)
	{
		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	if(empty($_ShoppingCartId)) return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    	$account_id = $_SESSION['account_ID'];	
    	$sql = "DELETE FROM bm_shopping_cart WHERE shopping_cart_id = ".$_ShoppingCartId." and account_id = ".$account_id; 
 		$r = sql_query($sql);
 		if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错1",NULL);	
	}
}
?>
