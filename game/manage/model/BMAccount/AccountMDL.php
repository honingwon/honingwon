<?php
class AccountMDL
{
	public $bm_AccountID   = 0;			//�˺�ID
	public $bm_Account 	   = "";	    //�˺�
	public $bm_Password    = "";		//����
	public $bm_AccountName = "";		//����
	public $bm_Phone       = "";		//�绰
	public $bm_Email	   = "";		//����
	public $bm_QQ          = "";		//QQ
	public $bm_Address     = "";		//��ַ
	public $bm_AccountType = 1;			//���͡�0,��������Ա��1,���ܡ�2,��ͨԱ����
	public $bm_AccountState= 0;			//�˺�״̬  0,δ����Ȩ��  1,�ѷ���Ȩ��  99ɾ��
	public $bm_ARemark     = "";        //��ע
	
	public function __construct($_AccountID,$_Account,$_Password,$_AccountName,
								$_Phone,$_Email,$_QQ,$_Address,$_AccountType,
								$_AccountState,$ARemark)
	{
		$this->bm_AccountID 	= $_AccountID;	
		$this->bm_Account		= $_Account;
		$this->bm_Password		= $_Password;
		$this->bm_AccountName	= $_AccountName;
		$this->bm_Phone			= $_Phone;
		$this->bm_Email			= $_Email;
		$this->bm_QQ			= $_QQ;
		$this->bm_Address		= $_Address;
		$this->bm_AccountType	= $_AccountType;
		$this->bm_AccountState	= $_AccountState;
		$this->bm_ARemark		= $ARemark;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMAccount.AccountMDL";
}
?>