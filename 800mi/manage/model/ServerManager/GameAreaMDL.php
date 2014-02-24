<?php
class GameAreaMDL
{
	public $bm_AreaID 	= 0; 		//游戏地区ID
	public $bm_GameID 	= 0;		//游戏ID
	public $bm_AreaName = '';		//地区名称
	public $bm_AreaPRI  = '';		//分区优先级号	 	
	public $bm_AreaDesc = '';		//分区简介
	public $bm_AreaState = '';		//分区状态
	public $bm_GameName = '';		//游戏名称
	
	public function __construct($bm_AreaID, $bm_GameID , $bm_AreaName, $bm_AreaPRI, 
								$bm_AreaDesc, $bm_AreaState, $bm_GameName){
		$this->bm_AreaID 	= $bm_AreaID;
		$this->bm_GameID 	= $bm_GameID;
		$this->bm_AreaName	= $bm_AreaName;
		$this->bm_AreaPRI 	= $bm_AreaPRI;
		$this->bm_AreaDesc  = $bm_AreaDesc;
		$this->bm_AreaState = $bm_AreaState;
		$this->bm_GameName = $bm_GameName;
	}
	
	public function __destruct(){}
	
//	var $_explicitType = "ServerManager.GameAreaMDL";
}
?>