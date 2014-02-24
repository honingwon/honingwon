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
?>