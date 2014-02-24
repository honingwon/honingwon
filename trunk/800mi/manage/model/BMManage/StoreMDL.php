<?php
class StoreMDL
{
	public $shop_id				= 0;
	public $account_id			= 0;
	public $shop_name		= "";
	public $shop_province	= "";
	public $shop_city			= "";
	public $shop_district		= "";
	public $shop_addr			= "";
	public $shop_contacts	= "";
	public $shop_phone		= "";
	public $shop_state			= 0;
		
	public function __construct($_ShopID,$_AccountID,$_Name,$_Province,$_City,$_District,$_Addr,$_Contacts,$_phone,$_State)
	{
		$this->shop_id 						= $_ShopID;	
		$this->account_id					= $_AccountID;
		$this->shop_name 				= $_Name;	
		$this->shop_province			= $_Province;
		$this->shop_city 					= $_City;	
		$this->shop_district				= $_District;		
		$this->shop_addr					= $_Addr;
		$this->shop_contacts				= $_Contacts;
		$this->shop_phone				= $_phone;
		$this->shop_state					= $_State;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMManage.StoreMDL";
}
?>