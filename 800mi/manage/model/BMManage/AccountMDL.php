<?php
class AccountMDL
{
	public $acct_id   				= 0;			//
	public $account 				= "";
	public $acct_pasword 	   	= "";	    //
	public $acct_name    			= "";		//
	public $acct_type 				= 1;		//
	public $acct_money	   		= 0;		//
	public $acct_level         		= 0;		//
	public $acct_state     			= 0;		//
	public $add_time 				= 0;			//
	public $acct_remark    		= "";        //
	
	public function __construct($_AccountID,$_Account,$_Password,$_AccountName,$_AccountType,
								$AccountMoney,$_AccountLevel,$_AccountState,$AddTime,$ARemark)
	{
		$this->acct_id 				= $_AccountID;	
		$this->account				= $_Account;
		$this->acct_pasword		= $_Password;
		$this->acct_name			= $_AccountName;
		$this->acct_type				= $_AccountType;
		$this->acct_money	 		= $AccountMoney;
		$this->acct_level 			= $_AccountLevel;
		$this->acct_state 			= $_AccountState;
		$this->add_time 			= $AddTime;
		$this->acct_remark 		= $ARemark;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMManage.AccountMDL";
}
?>