<?php

class ModuleMDL{
	public $module_id		= 0;		//模块ID
	public $module_name	= "";		//模块名称
	public $fmodule_id	= 0;		//父模块ID
	public $module_level  = 1;		//模块等级
	public $module_url	= "";		//链接地址
	public $fmodule_url   = "";		//子链接地址
	public $module_pri	= 0;		//模块优先级
	public $module_state	= 0;		//模块状态
	public $module_remark	= "";		//模块备注
	
	public function __construct($_ModuleID,$_ModuleName,$_FModuleID,$_ModuleLevel,
								$_ModuleUrl,$_FModuleUrl,$_ModulePRI,$_ModuleState,$_ModuleRemark)
	{
		$this->module_id 				= $_ModuleID;	
		$this->module_name		= $_ModuleName;
		$this->fmodule_id				= $_FModuleID;
		$this->module_level			= $_ModuleLevel;
		$this->module_url				= $_ModuleUrl;
		$this->fmodule_url			= $_FModuleUrl;
		$this->module_pri				= $_ModulePRI;
		$this->module_state			= $_ModuleState;
		$this->module_remark		= $_ModuleRemark;
	}
	
	public function __destruct()
	{}
	
	var $_explicitType = "BMManage.ModuleMDL";
}

?>