<?php

class ModuleMDL{
	public $bm_ModuleID		= 0;		//模块ID
	public $bm_ModuleName	= "";		//模块名称
	public $bm_FModuleID	= 0;		//父模块ID
	public $bm_ModuleLevel  = 1;		//模块等级
	public $bm_ModuleUrl	= "";		//链接地址
	public $bm_FModuleUrl   = "";		//子链接地址
	public $bm_ModulePRI	= 0;		//模块优先级
	public $bm_ModuleState	= 0;		//模块状态
	public $bm_ModuleRemark	= "";		//模块备注
	
	public function __construct($_ModuleID,$_ModuleName,$_FModuleID,$_ModuleLevel,
								$_ModuleUrl,$_FModuleUrl,$_ModulePRI,$_ModuleState,$_ModuleRemark)
	{
		$this->bm_ModuleID 			= $_ModuleID;	
		$this->bm_ModuleName		= $_ModuleName;
		$this->bm_FModuleID			= $_FModuleID;
		$this->bm_ModuleLevel		= $_ModuleLevel;
		$this->bm_ModuleUrl			= $_ModuleUrl;
		$this->bm_FModuleUrl		= $_FModuleUrl;
		$this->bm_ModulePRI			= $_ModulePRI;
		$this->bm_ModuleState		= $_ModuleState;
		$this->bm_ModuleRemark		= $_ModuleRemark;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMAccount.ModuleMDL";
}

?>