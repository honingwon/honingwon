<?php
class CardMDL
{
	public $cardIndex	    	= 0;
	public $cardTypeID 			= 0;
	public $cardSN				= "";
	public $cardPassword 		= "";
	public $cardState 			= 0;
	public $cardChargeTime 		= "";
	public $cardTypeName		= "";
	public $cardGroupID			= 0;
	public $cardGroupState		= 0;
	public $cardGroupStartTime  = "";
	public $cardGroupEndTime	= "";
	
	public function __construct($_cardTypeName,
								$_cardGroupState,$_cardGroupStartTime,$_cardGroupEndTime,
								$_cardIndex,$_cardTypeID,$_cardGroupID,$_cardSN,$_cardPassword,$_cardState,$_cardChargeTime)
	{
		$this->cardIndex 			= $_cardIndex;	
		$this->cardTypeID			= $_cardTypeID;
		$this->cardSN				= $_cardSN;
		$this->cardPassword			= $_cardPassword;
		$this->cardState			= $_cardState;
		$this->cardChargeTime		= $_cardChargeTime;
		$this->cardTypeName			= $_cardTypeName;
		$this->cardGroupID			= $_cardGroupID;
		$this->cardGroupState		= $_cardGroupState;
		$this->cardGroupStartTime	= $_cardGroupStartTime;
		$this->cardGroupEndTime		= $_cardGroupEndTime;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMAccount.CardMDL";
}
/*卡状态
 * 0,未充值
1，充值
91,锁定
92,作废
 */
?>