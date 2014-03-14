<?php
class CardGroupMDL
{
	public $GroupID 		= 0;
	public $FormID			= 0;
	public $CardTypeID		= 0;
	public $CardNum			= 0;
	public $GroupState		= 0;
	public $CreatTime		= "";
	public $ChargeStartTime	= "";
	public $ChargeEndTime	= "";
	public $GroupRemark		= "";
	public $FormName 		= "";
	public $FormApply		= "";
	public $Checker			= "";
	public $Titicker		= "";
	public $CardTypeName	= "";
	
	public function __construct($_GroupID,$_FormID,$_CardTypeID,$_CardNum,
								$_GroupState,$_CreatTime,$_ChargeStartTime,$_ChargeEndTime,
								$_GroupRemark,$_FormName,$_FormApply,$_Checker,
								$_Titicker,$_CardTypeName)
	{
		$this->GroupID 				= $_GroupID;	
		$this->FormID				= $_FormID;
		$this->CardTypeID			= $_CardTypeID;
		$this->CardNum				= $_CardNum;
		
		$this->GroupState			= $_GroupState;
		$this->CreatTime			= $_CreatTime;
		$this->ChargeStartTime		= $_ChargeStartTime;
		$this->ChargeEndTime		= $_ChargeEndTime;
		
		$this->GroupRemark			= $_GroupRemark;
		$this->FormName				= $_FormName;
		$this->FormApply			= $_FormApply;
		$this->Checker				= $_Checker;
		
		$this->Titicker				= $_Titicker;
		$this->CardTypeName			= $_CardTypeName;
	}
	
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMAccount.CardGroupMDL";
}
?>