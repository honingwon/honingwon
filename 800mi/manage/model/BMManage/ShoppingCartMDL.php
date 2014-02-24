<?php
class ShoppingCartMDL
{
	public $shopping_id		= 0;
	public $account_id			= 0;
	public $goods_num		= 0;
	public $add_time			= 0;
	public $goods_info;//GoodsSimpleMDL
		
	public function __construct($_ShoppingID,$_AccountID,$_GoodsNum,$_AddTime,$_Info)
	{
		$this->shopping_id 				= $_ShoppingID;	
		$this->account_id					= $_AccountID;
		$this->goods_num					= $_GoodsNum;
		$this->add_time 					= $_AddTime;	
		$this->goods_info					= $_Info;		
	}
	
	public function __destruct()
	{}
		
	var $_explicitType = "BMManage.ShoppingCartMDL";
}
?>
