<?php
class PurchaseMDL
{
	public $purchase_id			= 0;
	public $account_id				= 0;
	public $shop_id					= 0;
	public $add_time				= 0;
	public $pay_type				= 0;	//支付类型
	public $purchase_state		= 0;
	public $return_time			= 0;
	public $purchase_price		= 0;
	public $purchase_remark	= "";
	
	public function __construct($_PurchaseID,$_AccountID,$_ShopID,$_AddTime,$_PayType,$_State,$_ReturnTime,$_Price,$_Remark)
	{
		$this->purchase_id				= $_PurchaseID;
		$this->account_id					= $_AccountID;
		$this->shop_id						= $_ShopID;
		$this->add_time						= $_AddTime;
		$this->pay_type						= $_PayType;
		$this->purchase_state			= $_State;
		$this->return_time					= $_ReturnTime;
		$this->purchase_price			= $_Price;
		$this->purchase_remark		= $_Remark;
	}
	public function __destruct()
	{}
		
	var $_explicitType = "BMManage.PurchaseMDL";
}
?>
