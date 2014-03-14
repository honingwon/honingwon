<?php
class GameItemMDL
{
	public $ItemID		= 0;
	public $GameID		= 0;
	public $ItemName	= "";
	public $ItemGID		= "";
	public $ItemRank	= 0;
	public $ItemRemark  = "";
	
	public function __construct($_ItemID,$_GameID,$_ItemName,$_ItemGID,$_ItemRank,$_ItemRemark)
	{
		$this->ItemID 			= $_ItemID;	
		$this->GameID			= $_GameID;
		$this->ItemName			= $_ItemName;
		$this->ItemGID			= $_ItemGID;
		$this->ItemRank			= $_ItemRank;
		$this->ItemRemark		= $_ItemRemark;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMAccount.GameItemMDL";
}
?>