<?php
class PurchaseInfoMDL
{
	public $shopping_cart_id 			= 0;
	public $purchase_id					= 0;
	public $goods_id						= 0;
	public $goods_name					= "";
	public $goods_unit					= "";
	public $goods_weight				= "";
	public $goods_num					= 0;
	public $goods_price					= 0;	//物品原价
	public $purchase_price				= 0;	//物品购买价格
	public $active_etime					= 0;  //活动动结束时间
	public $add_time						= 0; 	//订单生成时间
	public $update_time					= 0;	//状态更新时间比如发货，退款，关闭
	public $purchase_state				= 0;
	
	public function __construct($_CartID,$_PurchaseID,$_GoodsID,$_GoodsName,$_GoodsUnit,$_GoodsWeight,
													$_GoodsNum,$_GoodsPrice,$_Price,$_ETime,$_AddTime,$_UpTime,$_State)
	{
		$this->shopping_cart_id					= $_CartID;
		$this->purchase_id							= $_PurchaseID;
		$this->goods_id									= $_GoodsID;
		$this->goods_name							= $_GoodsName;
		$this->goods_unit								= $_GoodsUnit;
		$this->goods_weight							= $_GoodsWeight;
		$this->goods_num								= $_GoodsNum;
		$this->goods_price							= $_GoodsPrice;
		$this->purchase_price						= $_Price;
		$this->active_etime							= $_ETime;
		$this->add_time									= $_AddTime;
		$this->update_time							= $_UpTime;
		$this->purchase_state						= $_State;				
	}
	
	public function __destruct()
	{}
			
	var $_explicitType = "BMManage.PurchaseMDL";
}
?>
