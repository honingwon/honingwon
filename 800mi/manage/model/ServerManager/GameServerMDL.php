<?php
class GameServerMDL
{
	public $bm_ServerID 	= 0;		//服务器ID
	public $bm_GameID		= 0;		//游戏ID
	public $bm_AreaID		= 0;		//分区ID
	public $bm_ServerName   = '';		//服务器名
	public $bm_ServerPRI 	= 0;		//服务器优先级
	public $bm_ServerConnString = array();	//服务器数据库连接信息
	public $bm_ServerState = 0;			//服务器状态	0:普通  99:删除
	public $bm_ServerRemark = '';		//备注
	public $bm_ServerSHH = '';          //游戏后台更新工具地址
	public $bm_ServerInfo1 = 0;         //合服标记
	public $bm_ServerInfo2 = '';        //备用字段  加合服标记时 新增  目前未用
	
	public $bm_GameName = '';			//游戏名称
	public $bm_AreaName = '';			//地区名称
	
	public function __construct($bm_ServerID, $bm_GameID, $bm_AreaID, $bm_ServerName, 
								$bm_ServerPRI, $bm_ServerConnString, $bm_ServerState, $bm_ServerRemark,
								$bm_ServerSHH,$bm_ServerInfo1,$bm_ServerInfo2,$bm_GameName, $bm_AreaName){
		$this->bm_ServerID 		= $bm_ServerID;
		$this->bm_GameID 		= $bm_GameID;
		$this->bm_AreaID 		= $bm_AreaID;
		$this->bm_ServerName 	= $bm_ServerName;
		$this->bm_ServerPRI 	= $bm_ServerPRI;
		$this->bm_ServerConnString = $bm_ServerConnString;
		$this->bm_ServerState 	= $bm_ServerState;
		$this->bm_ServerRemark 	= $bm_ServerRemark;
		$this->bm_ServerSHH 	= $bm_ServerSHH;
		$this->bm_ServerInfo1 	= $bm_ServerInfo1;
		$this->bm_ServerInfo2 	= $bm_ServerInfo2;
		$this->bm_GameName 		= $bm_GameName;
		$this->bm_AreaName 		= $bm_AreaName;
	}
	

	
	public function __destruct(){
		
	}
	
//	var $_explicitType = "ServerManager.GameServerMDL";
	
}
?>