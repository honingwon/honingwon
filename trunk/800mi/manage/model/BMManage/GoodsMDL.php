<?php
class GoodsMDL
{
	public $id		= 0;
	public $account_id		= 0;
	public $brand_id 		= 0;
	public $type3_id			= 0;
	public $goods_barcode=0;
	public $goods_name	= "";
	public $goods_unit = "";
	public $goods_weight	= "";
	public $goods_active_stime	= 0;
	public $goods_active_etime	= 0;
	public $goods_pic_url	= "";
	public $goods_state		= 0;
	public $goods_number	= 0;
	public $goods_price		= 0;
	public $goods_active_price	=0;
	public $goods_remark		= "";
		
	public function __construct($_GoodsID,$_AccountID,$_BrandID,$_Type3ID,$_Barcode,$_Name,$_Unit,$_Weight,$_ActiveSTime,
															$_ActiveETime,$_PicUrl,$_State,$_Number,$_Price,$_ActivePrice,$_Remark)
	{
		$this->id 							= $_GoodsID;	
		$this->account_id							= $_AccountID;
		$this->brand_id 								= $_BrandID;	
		$this->type3_id								= $_Type3ID;
		$this->goods_barcode 					= $_Barcode;	
		$this->goods_name						= $_Name;
		$this->goods_unit							= $_Unit;		
		$this->goods_weight						= $_Weight;
		$this->goods_active_stime			= $_ActiveSTime;
		$this->goods_active_etime			= $_ActiveETime;
		$this->goods_pic_url						= $_PicUrl;
		$this->goods_state						= $_State;
		$this->goods_number					= $_Number;
		$this->goods_price						= $_Price;
		$this->goods_active_price				= $_ActivePrice;
		$this->goods_remark						= $_Remark;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMManage.GoodsMDL";
}
?>