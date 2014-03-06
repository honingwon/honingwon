<?php
require_once( DATALIB . '/SqlResult.php');

require_once('SnsNetwork.php');

class ServerManageProvider
{
	private static $instance;
	private function __construct(){}

	public static function getInstance()
	{
		if(self::$instance == null)
		{
			self::$instance = new ServerManageProvider();
		}
		return self::$instance;
	}


	//获取游戏分页数据
	public function getGameList(){
		$sql = "SELECT * FROM bm_game";
		$rs = sql_fetch_rows($sql);
		if(!empty($rs)){
			$ary = Array();
			foreach($rs as $k=>$v){
				$bm_Game = new GameMDL($v[0],$v[1]);
				$ary[] = $bm_Game;
			}
			return new DataResult(ResultStateLevel::SUCCESS,"1",NULL,$ary);
		}else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}

	/**
	 * 新增游戏种类
	 * @param unknown_type $gameName
	 */
	public function addNewGame($gameName)
	{
		if(empty($gameName)) return new ExcuteResult(ResultStateLevel::ERROR,"游戏名称不能为空！",NULL);
		$sql_check = "SELECT bm_GameID FROM bm_game WHERE bm_GameName = '" . $gameName . "'";
		$r_check = sql_check($sql_check);
		if($r_check)  return new ExcuteResult(ResultStateLevel::ERROR,"游戏名称已存在！",NULL);
		$sql_insert = "INSERT INTO bm_game(bm_GameName) values('" . $gameName . "')";
		$r_insert = sql_insert($sql_insert);
		if($r_insert != 0){
			return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r_insert[0]);
		}
		else
		return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
	}

	/**
	 * 修改游戏种类信息
	 * @param $gameName
	 * @param $gameID
	 */
	public function upDateGame($gameName,$gameID)
	{
		if(empty($gameName) || empty($gameID)) return new ExcuteResult(ResultStateLevel::ERROR,"更新失败，请刷新后再试！",NULL);
		$sql_check = "SELECT bm_GameName FROM bm_game WHERE bm_GameID = " .$gameID ;
		$r_check = sql_fetch_one($sql_check);
		if($r_check == ""){
			return new ExcuteResult(ResultStateLevel::ERROR,"更新失败：此游戏不存在或已被删除！",NULL);
		}
		if($r_check == $gameName)
		return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
		$count = sql_fetch_one_cell("SELECT COUNT(*) AS num FROM bm_game WHERE bm_GameName ='".$gameName."'");
		if($count > 0)
		return new ExcuteResult(ResultStateLevel::ERROR,"更新失败：游戏名称已存在！",NULL);
		$sql_update = "UPDATE bm_game SET bm_GameName = '" . $gameName . "' WHERE bm_GameID = ".$gameID;
		$r_update = sql_query($sql_update);
		if($r_update != 0){
			return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
		}
		else
		return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
	}

	/**
	 * 删除游戏信息
	 * @param unknown_type $gameID
	 */
	public function deleteGame($gameID)
	{
		if(empty($gameID)) return new ExcuteResult(ResultStateLevel::ERROR,"删除失败，请刷新后再试！",NULL);
		$sql_check = "SELECT bm_GameName FROM bm_game WHERE bm_GameID = " .$gameID ;
		$r_check = sql_fetch_one($sql_check);
		if($r_check == ""){
			return new ExcuteResult(ResultStateLevel::ERROR,"此游戏不存在或已被删除！",NULL);
		}
		$count = sql_fetch_one_cell("SELECT  COUNT(*) AS num FROM bm_gamearea WHERE bm_AreaState < 99 AND bm_GameID = ".$gameID);
		if($count > 0)
		return new ExcuteResult(ResultStateLevel::ERROR,"此游戏种类下存在游戏分区信息不能删除！",NULL);
		$sql_del = "DELETE FROM bm_game WHERE bm_GameID = $gameID";
		$r_del = sql_update_delete($sql_del);
		if($r_del)
		return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
		else
		return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
	}

	/**
	 * 根据游戏种类查询游戏分区
	 * @param unknown_type $gameID
	 */
	public function gameAreaList($gameID)
	{
		$sql_check = "SELECT bm_GameName FROM bm_game WHERE bm_GameID = " .$gameID ;
		$r_check = sql_fetch_one($sql_check);
		if($r_check == ""){
			return new DataResult(ResultStateLevel::SUCCESS,"",NULL,Array());
		}
		$sql = "SELECT a.*, g.bm_GameName FROM bm_gamearea a LEFT JOIN bm_game g  ON a.bm_GameID = g.bm_GameID WHERE a.bm_AreaState < 99 AND a.bm_GameID = " . $gameID;
		$rs = sql_fetch_rows($sql);
		if(!empty($rs)){
			$ary = Array();
			foreach($rs as $k=>$v){
				$bm_Area = new GameAreaMDL($v[0],$v[1],$v[2],$v[3],$v[4],$v[5],$v[6]);
				$ary[] = $bm_Area;
			}
			return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$ary);
		}else{
			return new DataResult(ResultStateLevel::SUCCESS,"",NULL,NULL);
		}
	}

	/**
	 * 获取所有游戏分区
	 */
	public function gameAreaAllList()
	{
		$sql = "SELECT a.*, g.bm_GameName FROM bm_gamearea a LEFT JOIN bm_game g  ON a.bm_GameID = g.bm_GameID WHERE a.bm_AreaState < 99";
		$rs = sql_fetch_rows($sql);
		if(!empty($rs)){
			$ary = Array();
			foreach($rs as $k=>$v){
				$bm_Area = new GameAreaMDL($v[0],$v[1],$v[2],$v[3],$v[4],$v[5],$v[6]);
				$ary[] = $bm_Area;
			}
			return new DataResult(ResultStateLevel::SUCCESS,"1",1,$ary);
		}else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}

	/**
	 * 新增游戏分区
	 * @param unknown_type $gameID
	 * @param unknown_type $areaName
	 * @param unknown_type $areaARI
	 * @param unknown_type $areaDesc
	 */
	public function AddGameArea($gameID,$areaName,$areaARI,$areaDesc)
	{
		if(empty($gameID) || empty($areaName) || empty($areaARI))
		return new ExcuteResult(ResultStateLevel::ERROR,"新增，请刷新后再试！",NULL);
		$sql_check = "SELECT bm_GameName FROM bm_game WHERE bm_GameID = " .$gameID ;
		$r_check = sql_fetch_one($sql_check);
		if($r_check == ""){
			return new ExcuteResult(ResultStateLevel::ERROR,"新增游戏分区失败：此游戏不存在或已被删除！",NULL);
		}
		$sql_count = "SELECT COUNT(*) AS num FROM bm_gamearea WHERE bm_GameID = ".$gameID." AND bm_AreaName = '".$areaName."'";
		$count = sql_fetch_one_cell($sql_count);
		if($count > 0)
		return new ExcuteResult(ResultStateLevel::ERROR,"此游戏种类下存在同名的分区，请换一个分区名称！",NULL);
		$sql_insert = "INSERT INTO bm_gamearea (bm_GameID,bm_AreaName,bm_AreaPRI,bm_AreaDesc,bm_AreaState)";
		$sql_insert.= " values ($gameID,'$areaName',$areaARI,'$areaDesc','0')";
		$r_insert = sql_insert($sql_insert);
		if($r_insert != 0){
			return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r_insert[0]);
		}
		else
		return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
	}

	/**
	 * 修改游戏分区信息
	 * @param unknown_type $areaID
	 * @param unknown_type $areaName
	 * @param unknown_type $areaARI
	 * @param unknown_type $areaDesc
	 */
	public function UpdateGameArea($areaID,$areaName,$areaARI,$areaDesc)
	{
		if(empty($areaName) || empty($areaID) || empty($areaARI))
		return new ExcuteResult(ResultStateLevel::ERROR,"更新失败，请刷新后再试！",NULL);
		$sql_check = "SELECT * FROM bm_gamearea WHERE bm_AreaID = " .$areaID ;
		$r_check = sql_fetch_one($sql_check);
		if($r_check == ""){
			return new ExcuteResult(ResultStateLevel::ERROR,"此游戏分区不存在或已被删除！",NULL);
		}
		if($r_check[2] != $areaName)
		{
			$count = sql_fetch_one_cell("SELECT COUNT(*) AS num FROM bm_gamearea WHERE bm_ServerState < 99 AND bm_GameID= ".$r_check[1]." AND bm_AreaName ='".$areaName."'");
			if($count > 0)
			return new ExcuteResult(ResultStateLevel::ERROR,"此游戏种类下存在同名的分区，请换一个分区名称！",NULL);
		}
		$sql_update = "UPDATE bm_gamearea SET bm_AreaName = '" . $areaName . "', bm_AreaPRI = ".$areaARI;
		$sql_update.=" , bm_AreaDesc = '".$areaDesc."' WHERE bm_AreaID = ".$areaID;
		$r_update = sql_query($sql_update);
		if($r_update != 0){
			return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
		}
		else
		return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
	}

	/**
	 * 删除游戏分区
	 * @param unknown_type $areaID
	 */
	public function deleteGameArea($areaID)
	{
		if(empty($areaID))
		return new ExcuteResult(ResultStateLevel::ERROR,"删除失败，请刷新后再试！",NULL);
		$sql_check = "SELECT bm_AreaName FROM bm_gamearea WHERE bm_AreaID = " .$areaID ;
		$r_check = sql_fetch_one($sql_check);
		if($r_check == ""){
			return new ExcuteResult(ResultStateLevel::ERROR,"此游戏分区不存在或已被删除！",NULL);
		}
		$count = sql_fetch_one_cell("SELECT COUNT(*) AS num FROM bm_gameserver WHERE bm_ServerState < 99 AND bm_AreaID = ".$areaID);
		if($count > 0)
		return new ExcuteResult(ResultStateLevel::ERROR,"此游戏分区下存在服务器信息不能删除！",NULL);
		$sql_update = "UPDATE bm_gamearea SET bm_AreaState = 99 WHERE bm_AreaID = ".$areaID;
		$r_update = sql_query($sql_update);
		if($r_update != 0){
			return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
		}
		else
		return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
	}

	/**
	 * 新增游戏服务器
	 * @param unknown_type $gameID
	 * @param unknown_type $areaID
	 * @param unknown_type $servName
	 * @param unknown_type $servRPI
	 * @param unknown_type $servDesc
	 * @param unknown_type $servCon
	 */
	public function AddGameServer($gameID,$areaID,$servName,$servRPI,$servDesc,$servCon,$servSHH)
	{
		if(empty($gameID) || empty($areaID) || empty($servName)|| empty($servRPI))
		return new ExcuteResult(ResultStateLevel::ERROR,"新增失败，请刷新后再试！",NULL);
		$sql_check = "SELECT bm_GameName FROM bm_game WHERE bm_GameID = " .$gameID ;
		$r_check = sql_fetch_one($sql_check);
		if($r_check == ""){
			return new ExcuteResult(ResultStateLevel::ERROR,"新增服务器失败：此游戏不存在或已被删除！",NULL);
		}
			
		$sql_areaCheck = "SELECT bm_AreaID FROM bm_gamearea WHERE bm_AreaID = ".$areaID;
		$r_areaCheck = sql_fetch_one($sql_areaCheck);
		if($r_areaCheck == ""){
			return new ExcuteResult(ResultStateLevel::ERROR,"新增服务器失败：此分区不存在或已被删除！",NULL);
		}
			
		$sql_count = "SELECT COUNT(*) AS num FROM bm_gameserver WHERE bm_ServerState < 99 AND bm_ServerName = '".$servName."'";
		$count = sql_fetch_one_cell($sql_count);
		if($count > 0)
		return new ExcuteResult(ResultStateLevel::ERROR,"此分区下存在同名的服务器，请换一个服务器名称！",NULL);
			
		$sql_insert = "INSERT INTO bm_gameserver (bm_GameID,bm_AreaID,bm_ServerName,bm_ServerPRI,bm_ServerConnString,bm_ServerState,bm_ServerRemark,bm_SshInfo,bm_ServerInfo1)";
		$sql_insert.= " values ($gameID,$areaID,'$servName',$servRPI,'$servCon','0','$servDesc','$servSHH',$servRPI)";
		$r_insert = sql_insert($sql_insert);
		if($r_insert != 0){
			return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r_insert[0]);
		}
		else
		return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
	}

	/**
	 * 修改游戏服务器
	 * @param unknown_type $serverID
	 * @param unknown_type $servName
	 * @param unknown_type $servRPI
	 * @param unknown_type $servDesc
	 * @param unknown_type $servCon
	 */
	public function UpdateGameServer($serverID,$servName,$servRPI,$servDesc,$servCon,$servSHH)
	{
		if(empty($serverID) || empty($servName)|| empty($servRPI))
		return new ExcuteResult(ResultStateLevel::ERROR,"更新失败，请刷新后再试！",NULL);
		$sql_check = "SELECT * FROM bm_gameserver WHERE bm_ServerID = " .$serverID ;
		$r_check = sql_fetch_one($sql_check);
		if($r_check == ""){
			return new ExcuteResult(ResultStateLevel::ERROR,"此游戏服务器不存在或已被删除！",NULL);
		}
		if($r_check[3] != $servName)
		{
			$count = sql_fetch_one_cell("SELECT COUNT(*) AS num FROM bm_gameserver WHERE bm_ServerState < 99 AND bm_AreaID =".$r_check[2]." AND bm_ServerName = '".$servName."'");
			if($count > 0)
			return new ExcuteResult(ResultStateLevel::ERROR,"此游戏分区下存在同名的服务器名，请换一个服务器名称！",NULL);
		}
		$sql_update = "UPDATE bm_gameserver SET bm_ServerName = '" . $servName . "', bm_ServerPRI = ".$servRPI;
		$sql_update.=" , bm_ServerRemark = '".$servDesc."', bm_ServerConnString = '".$servCon."' ,bm_SshInfo = '".$servSHH."',bm_ServerInfo1 = ".$servRPI."  WHERE bm_ServerID = ".$serverID;
		$r_update = sql_query($sql_update);
		if($r_update != 0){
			return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
		}
		else
		return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错！",NULL);
	}

	/**
	 * 删除游戏服务器
	 * @param unknown_type $serverID
	 */
	public function deleteGameServer($serverID)
	{
		if(empty($serverID))
		return new ExcuteResult(ResultStateLevel::ERROR,"删除失败，请刷新后再试！",NULL);
		$sql_check = "SELECT bm_ServerName FROM bm_gameserver WHERE bm_ServerID = " .$serverID ;
		$r_check = sql_fetch_one($sql_check);
		if($r_check == ""){
			return new ExcuteResult(ResultStateLevel::ERROR,"此游戏服务器不存在或已被删除！",NULL);
		}
			
		$sql_update = "UPDATE bm_gameserver SET bm_ServerState = 99 WHERE bm_ServerID = ".$serverID;
		$r_update = sql_query($sql_update);
		if($r_update != 0){
			return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
		}
		else
		return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
	}

	/**
	 * 服务器列表
	 * @param unknown_type $offer
	 * @param unknown_type $pageSize
	 * @param unknown_type $bm_GameID
	 * @param unknown_type $bm_AreaID
	 */
	public function gameServList($offer, $pageSize, $bm_GameID = -1, $bm_AreaID = -1)
	{
		$where = "";
		if($bm_GameID != -1) $where  = " AND g.bm_GameID = $bm_GameID ";
		if($bm_AreaID != -1) $where .= " AND a.bm_AreaID = $bm_AreaID ";

		$sql = "SELECT s.*, g.bm_GameName, a.bm_AreaName FROM bm_gameserver s LEFT JOIN bm_game g ";
		$sql .= " ON s.bm_GameID = g.bm_GameID LEFT JOIN bm_gamearea a ON a.bm_AreaID = s.bm_AreaID WHERE bm_ServerState != 99 " . $where;
		$sql .= " ORDER BY bm_ServerPRI LIMIT $offer, $pageSize";
		$rs = sql_fetch_rows($sql);
		if(!empty($rs)){
			$ary = Array();
			foreach($rs as $k=>$v){
				$bm_Server = new GameServerMDL($v[0],$v[1],$v[2],$v[3],$v[4],json_decode($v[5]),$v[6],$v[7],$v[8],$v[9],$v[10],$v[11],$v[12]);
				$ary[] = $bm_Server;
			}
			$count = sql_fetch_one_cell("SELECT COUNT(*) AS num FROM bm_gameserver WHERE bm_ServerState < 99 ".$where);
			return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$ary);
		}else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}
	
	/**
	 * 合服时 处理被合服服务器数据  
	 * @param unknown_type $serverID
	 * @param unknown_type $serverInfo1  被合到的目标服的 服务器标记
	 * @param unknown_type $remark
	 */
	public function updateGameServerHE($serverID,$serverInfo1,$remark,$gameID)
	{
		if(empty($serverID))
		return new ExcuteResult(ResultStateLevel::ERROR,"删除失败，请刷新后再试！",NULL);
		$sql_areaCheck1 = "SELECT bm_AreaID FROM bm_gameserver WHERE bm_ServerState <99 AND bm_ServerID = " .$serverID." AND bm_GameID = ".$gameID;
		$sql_areaCheck2 = "SELECT bm_AreaID FROM bm_gameserver WHERE bm_ServerState <99 AND bm_ServerPRI = " .$serverInfo1." AND bm_GameID = ".$gameID;
		$r_areaCheck1 = sql_fetch_one($sql_areaCheck1);
		$r_areaCheck2 = sql_fetch_one($sql_areaCheck2);
		if($r_areaCheck1 == "" || $r_areaCheck2 == "" || $r_areaCheck1 != $r_areaCheck2)
			return new ExcuteResult(ResultStateLevel::ERROR,"不存在的服务器 或者 服务器不是同一个区的不能合服！",NULL);
		
		$sql_check = "SELECT bm_ServerPRI FROM bm_gameserver WHERE bm_ServerState <99 AND bm_ServerID = " .$serverID ;
		$r_check = sql_fetch_one($sql_check);
		if($r_check == ""){
			return new ExcuteResult(ResultStateLevel::ERROR,"此游戏服务器不存在或已被删除！",NULL);
		}	
		$sql_update = "UPDATE bm_gameserver SET bm_ServerState = 99,bm_ServerInfo1 = ".$serverInfo1." , bm_ServerRemark = '".$remark."' WHERE bm_ServerID = ".$serverID;
		$r_update = sql_query($sql_update);
		if($r_update != 0){
			$sql = "SELECT bm_ServerID,bm_ServerName,bm_ServerPRI,bm_ServerInfo1,bm_ServerInfo2 ";
			$sql .= " FROM bm_gameserver ";
			$sql .= " WHERE bm_ServerState = 99 AND bm_ServerInfo1 = ".$r_check[0];
			$rs = sql_fetch_rows($sql);
			if(!empty($rs)){
				$isTrue= true;
				$sql_update_server = "";
				foreach($rs as $k=>$v){
					$sql_update_server = "UPDATE bm_gameserver SET bm_ServerInfo1 = ".$serverInfo1." WHERE bm_ServerID = ".$v[0];
					$rs_server = sql_fetch_rows($sql_update_server);
					if(empty($rs_server))
						$isTrue = false;
				}
				return new ExcuteResult(ResultStateLevel::SUCCESS,$sql,$isTrue);
			}
			else{
				return new ExcuteResult(ResultStateLevel::SUCCESS,$sql,true);
		    }
		}
		else
			return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
			
	}
	
	/**
	 * 当前服的原合服前的服务器信息
	 * @param unknown_type $serverID  当前合服务器ID
	 * @param unknown_type $serverInfo1  当前合服务器的合服标记
	 */
	public function gameServListHE($serverID,$serverInfo1)
	{
		$sql = "SELECT bm_ServerID,bm_GameID,bm_AreaID,bm_ServerName,bm_ServerPRI,bm_ServerConnString,bm_ServerRemark,bm_SshInfo,bm_ServerInfo1,bm_ServerInfo2 ";
		$sql .= " FROM bm_gameserver ";
		$sql .= " WHERE bm_ServerState = 99 AND bm_ServerInfo1 = ".$serverInfo1." AND bm_ServerID != ".$serverID;
		$rs = sql_fetch_rows($sql);
		if(!empty($rs)){
			$ary = Array();
			foreach($rs as $k=>$v){
				$bm_Server = new GameServerMDL($v[0],$v[1],$v[2],$v[3],$v[4],json_decode($v[5]),99,$v[6],$v[7],$v[8],$v[9],'','');
				$ary[] = $bm_Server;
			}
			return new DataResult(ResultStateLevel::SUCCESS,"1",NULL,$ary);
		}else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}
	
	/**
	 * 依据服务器字符串ID  得到对应的名称
	 * @param unknown_type $serverIdString
	 * 返回的结果是数组对像 0=ID，1=name
	 */
	public function getServerNameByServerIdString($serverIdString)
	{
		$sql = "SELECT bm_ServerID,bm_ServerName FROM bm_gameserver WHERE bm_ServerID IN(".$serverIdString.")";
		$rs = sql_fetch_rows($sql);
		if(!empty($rs)){
			return new DataResult(ResultStateLevel::SUCCESS,"1",1,$rs);
		}else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}
	
	public function updateCloseGameServer($serverIdString)
	{
		
		$serverAry = self::getServerInfoTOhttprequest1("/safe_quit",$serverIdString);
		if(count($serverAry) <= 0)
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		$arryResult = Array();
		for($i=0;$i<count($serverAry);++$i)
		{
			$ary = $serverAry[$i];
			$params = array();
			$result = self::makeRequst($ary[0],$params,'get');
			if($result['result'] == false)
				$arryResult[] = $serverAry[$i][0].",error：".$result['msg'];
		}
		return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$arryResult);
		
	}
	
	
	private static function getServerInfoTOhttprequest1($URI,$serverIdString)
	{
		$sql = "SELECT bm_ServerConnString,bm_ServerID FROM bm_gameserver WHERE bm_ServerID IN(".$serverIdString.")";
		$rs = sql_fetch_rows($sql);
		$resultArray = Array();
		if(!empty($rs)){
			foreach($rs as $k=>$v){
				$servAry = json_decode($v[0],true);
				$host_IP 	= $servAry['socket']['ip'];
				$host_port 	= $servAry['socket']['port'];
				$ary = Array();
				$ary[] = "http://".$host_IP.":".$host_port.$URI;
				$ary[] = $v[1];
				$resultArray[] = $ary;
			}
		}
		return $resultArray;
	}
	
/**
	 * 请求网关
	 * @param unknown_type $url
	 * @param unknown_type $params
	 * @param unknown_type $method
	 * @param unknown_type $protocol
	 */
	private static function makeRequst($url,$params,$method='post',$protocol='http')
	{
		$ret = SnsNetwork::makeRequest($url,$params,array(),$method);
//		$param_url = $url.'?';
//		foreach ($params as $key => $value ) {
//			$param_url .= $key . "=" . $value . "&";
//		}
//		if (strtolower('Success') == strtolower($ret['msg']))
//		{
//			logManageSucInterface($param_url."--".$ret['result']."--".$ret['msg']);
//		}
//		else{
//			logManageErrorInterface($param_url."--".$ret['result']."--".$ret['msg']);
//			$ret = array(
//        		'result' => false,
//            	'msg' => $ret['msg'],
//        	);
//		}
		return $ret;
	}
}
?>