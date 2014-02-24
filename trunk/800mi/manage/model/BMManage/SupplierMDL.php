<?php
class SupplierMDL
{
	public $account_id				= 0;
	public $supplier_name		= "";
	public $supplier_province	= "";
	public $supplier_city			= "";
	public $supplier_district		= "";
	public $supplier_addr		= "";
	public $supplier_person	= "";
	public $supplier_type			= 0;
	public $supplier_level		= 0;
	public $supplier_phone		="";
	public $supplier_remark	= "";
		
	public function __construct($_ShopID,$_AccountID,$_Name,$_Province,$_City,$_District,$_Addr,$_Person,$_type,$_level,$_phone,$_Remark)
	{
		$this->account_id						= $_AccountID;
		$this->supplier_name 				= $_Name;	
		$this->supplier_province			= $_Province;
		$this->supplier_city 					= $_City;	
		$this->supplier_district				= $_District;		
		$this->supplier_addr					= $_Addr;
		$this->supplier_person				= $_Person;
		$this->supplier_type					= $_type;
		$this->supplier_level					= $_level;
		$this->supplier_phone				= $_phone;
		$this->supplier_remark				= $_Remark;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMManage.SupplierMDL";
}
?>