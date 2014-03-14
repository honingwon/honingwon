<?php
class GroupMDL
{
	public $bm_GroupID		= 0;
	public $bm_GroupName	= "";
	public $bm_RankRemark	= "";
	
	public function __construct($_GroupID,$_GroupName,$_RankRemark)
	{
		$this->bm_GroupID 			= $_GroupID;	
		$this->bm_GroupName			= $_GroupName;
		$this->bm_RankRemark		= $_RankRemark;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMAccount.GroupMDL";
}
?>