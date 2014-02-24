<?php
class GroupMDL
{
	public $group_id		= 0;
	public $group_name	= "";
	public $group_remark	= "";
	
	public function __construct($_GroupID,$_GroupName,$_RankRemark)
	{
		$this->group_id 				= $_GroupID;	
		$this->group_name			= $_GroupName;
		$this->group_remark			= $_RankRemark;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMManage.GroupMDL";
}
?>