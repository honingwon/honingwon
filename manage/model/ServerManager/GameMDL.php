<?php
class GameMDL
{
	public $bm_GameID 	= 0;		//游戏ID
	public $bm_GameName = '';	//游戏名称
	
	public function __construct($bm_GameID, $bm_GameName){
		$this->bm_GameID = $bm_GameID;
		$this->bm_GameName = $bm_GameName;
	}
	
	public function __destruct(){}
	
//	var $_explicitType = "ServerManager.GameMDL";
}	

?>	