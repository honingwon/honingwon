<?php
class GoodsTypeMDL
{
	public $type1_id		= 0;
	public $type1_name	= "";
	public $type2_id		= 0;
	public $type2_name	= "";
	public $type3_id		= 0;
	public $type3_name	= "";
	
	public function __construct($_Type1ID,$_Type1Name,$_Type2ID,$_Type2Name,$_Type3ID,$_Type3Name)
	{
		$this->type1_id 					= $_Type1ID;	
		$this->type1_name			= $_Type1Name;
		$this->type2_id 					= $_Type2ID;	
		$this->type2_name			= $_Type2Name;
		$this->type3_id 					= $_Type3ID;	
		$this->type3_name			= $_Type3Name;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMManage.GoodsTypeMDL";
}
class GoodsType1MDL
{
	public $type1_id		= 0;
	public $type1_name	= "";
	public $type1_order = 0;
	
	public function __construct($_Type1ID,$_Type1Name,$_Type1Order)
	{
		$this->type1_id 					= $_Type1ID;	
		$this->type1_name			= $_Type1Name;
		$this->type1_order				= $_Type1Order;
	}
	public function __destruct()
	{}
	
	var $_explicitType = "BMManage.GoodsType1MDL";
}
class GoodsType2MDL
{
	public $type1_id		= 0;
	public $type2_id		= 0;
	public $type2_name	= "";
	public $type2_order = 0;
	
	public function __construct($_Type1ID,$_Type2ID,$_Type2Name,$_Type2Order)
	{
		$this->type1_id 					= $_Type1ID;	
		$this->type2_id 					= $_Type2ID;	
		$this->type2_name			= $_Type2Name;
		$this->type2_order				= $_Type2Order;
	}
	public function __destruct()
	{}
	
	var $_explicitType = "BMManage.GoodsType2MDL";
}
?>