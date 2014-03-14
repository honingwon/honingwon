<?php
class CardTypeMDL
{
	public $cardTypeID	 = 0;
	public $cardTypeName = "";
	public $cardRestrict = 0;
	public $cardPoint 	 = 0;
	public $cardPrice 	 = 0;
	public $cardUnique 	 = 1;
	public $cardState	 = 0;
	public $Remark		 = "";
	
	public function __construct($_cardTypeID,$_cardTypeName,$_cardRestrict,$_cardPoint,
								$_cardPrice,$_cardUnique,$_cardState,$_remark)
	{
		$this->cardTypeID 			= $_cardTypeID;	
		$this->cardTypeName			= $_cardTypeName;
		$this->cardRestrict			= $_cardRestrict;
		$this->cardPoint			= $_cardPoint;
		$this->cardPrice			= $_cardPrice;
		$this->cardUnique			= $_cardUnique;
		$this->cardState			= $_cardState;
		$this->Remark				= $_remark;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMAccount.CardTypeMDL";
}
?>