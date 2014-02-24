<?php
class GoodsBrandMDL
{
	public $brand_id		= 0;
	public $brand_name	= "";
	public $brand_order	= 0;
	public $brand_state	= "";
		
	public function __construct($_BrandID,$_Name,$_Order,$_State)
	{
		$this->brand_id 					= $_BrandID;	
		$this->brand_name			= $_Name;
		$this->brand_order 			= $_Order;	
		$this->brand_state				= $_State;
	}
			
	public function __destruct()
	{}
	
	var $_explicitType = "BMManage.GoodsBrandMDL";
}
?>