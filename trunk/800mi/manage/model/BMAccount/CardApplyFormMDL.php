<?php
class CardApplyFormMDL
{
	public $cardFormID	    = 0;
	public $cardFormName 	= "";
	public $cardFormRemark  = "";
	public $cardApplyer 	= "";
	public $cardFormChecker = "";
	public $cardPicker 	 	= "";
	public $cardApplyTime	= "";
	public $cardPickTime	= "";
	public $cardCheckTime	= "";
	public $cardCheckRemark = "";
	public $cardFormState	= 0;
	
	public function __construct($_cardFormID,$_cardFormName,$_cardFormRemark,$_cardApplyer,
								$_cardFormChecker,$_cardPicker,$_cardApplyTime,$_cardPickTime,
								$_cardCheckTime,$_cardCheckRemark,$_cardFormState)
	{
		$this->cardFormID 			= $_cardFormID;	
		$this->cardFormName			= $_cardFormName;
		$this->cardFormRemark		= $_cardFormRemark;
		$this->cardApplyer			= $_cardApplyer;
		$this->cardFormChecker		= $_cardFormChecker;
		$this->cardPicker			= $_cardPicker;
		$this->cardApplyTime		= $_cardApplyTime;
		$this->cardPickTime			= $_cardPickTime;
		$this->cardCheckTime		= $_cardCheckTime;
		$this->cardCheckRemark		= $_cardCheckRemark;
		$this->cardFormState		= $_cardFormState;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMAccount.CardApplyFormMDL";
}
?>