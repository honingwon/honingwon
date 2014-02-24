<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMAccount/EventLog.php');

/**
 *卡库   道具物品维护
 */
class GameItemProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new GameItemProvider();
        }
        return self::$instance;
    }
    
    /**
     * 新增游戏道具
     * @param unknown_type $gameID
     * @param unknown_type $itemName
     * @param unknown_type $itemGID
     * @param unknown_type $itemRank
     * @param unknown_type $itemRemark
     */
    public function AddNewGameItem($gameID,$itemName,$itemGID,$itemRank,$itemRemark)
    {
    	AddBMAccountEventLog("新增游戏道具物品名称：".$itemName.",游戏：".$gameID.",游戏GID：".$itemGID,2);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$check = "SELECT bm_ItemName FROM bm_item WHERE bm_ItemName = '" . $itemName . "' AND bm_GameID = ".$gameID;
 		if(sql_check($check)) return new ExcuteResult(ResultStateLevel::EXCEPTION,"物品名称已存在",$itemName);
 
 		$sql = "insert into bm_item (bm_GameID,bm_ItemName,bm_ItemGID,bm_ItemRank,bm_ItemRemark)";
    	$sql.= "values ($gameID,'$itemName','$itemGID','$itemRank','$itemRemark')";
    	$r = sql_insert($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 更新指定游戏道具物品信息
     * @param $itemIndex
     * @param $itemName
     * @param $itemGID
     * @param $itemRank
     * @param $itemRemark
     */
    public function UpdateGameItem($itemIndex,$itemName,$itemGID,$itemRank,$itemRemark)
    {
    	AddBMAccountEventLog("修改游戏道具物品ID：".$itemIndex.",物品名称：".$itemName.",游戏GID：".$itemGID,2);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "UPDATE bm_item SET bm_ItemName = '".$itemName."',bm_ItemGID = '".$itemGID."'";
    	$sql.= ",bm_ItemRank = '".$itemRank."',bm_ItemRemark = '".$itemRemark."'";
    	$sql.= "  WHERE bm_ItemID =".$itemIndex; 
    	$r = sql_query($sql);
 		if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 删除游戏物品道具信息
     * @param $itemIndex
     */
    public function DelGameItem($itemIndex)
    {
    	AddBMAccountEventLog("删除游戏道具物品ID：".$itemIndex,2);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "DELETE FROM  bm_item WHERE bm_ItemID = ".$itemIndex;
    	$r = sql_query($sql);
 		if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 获取指定游戏道具物品  分页
     * @param unknown_type $offer
     * @param unknown_type $pageSize
     * @param unknown_type $GameID
     * @param unknown_type $itemName
     */
    public function GetAllGameItemByGameID($offer, $pageSize, $GameID,$itemName)
    {
   		if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$sql = "SELECT * FROM bm_item WHERE bm_GameID = ".$GameID." AND bm_ItemName like '%".$itemName."%' ORDER BY bm_ItemID DESC LIMIT $offer, $pageSize";
    	$r = sql_fetch_rows($sql);
   		if(!empty($r)){
 			$ary = Array();
 			foreach($r as $k=>$v){
 				$gameItemMDL = new GameItemMDL($v[0],$v[1],$v[2],$v[3],$v[4],$v[5]);
 				$ary[] = $gameItemMDL;
 			}
 			$count = sql_fetch_one_cell("SELECT COUNT(*) as num FROM bm_item WHERE bm_GameID = ".$GameID." AND bm_ItemName like '%".$itemName."%'"); 
 			return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$ary);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 		} 
    }
    
    /**
     * 根据条件获取物品列表。物品名称满足模糊查询，物品ID是精确查找
     * @param $offer
     * @param $pageSize
     * @param $GameID
     * @param $itemName
     * @param $type
     */
    public function GetAllGameItemByGameIDUpdate($offer, $pageSize, $GameID,$itemName,$type)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	
    	if($type == "1"){
    		$sql = "SELECT * FROM bm_item WHERE bm_GameID = ".$GameID." AND bm_ItemGID > 100 AND bm_ItemName like '%".$itemName."%' ORDER BY bm_ItemID DESC LIMIT $offer, $pageSize";
    		$r = sql_fetch_rows($sql);
   			if(!empty($r)){
 				$ary = Array();
 				foreach($r as $k=>$v){
 					$gameItemMDL = new GameItemMDL($v[0],$v[1],$v[2],$v[3],$v[4],$v[5]);
 					$ary[] = $gameItemMDL;
 				}
 				$count = sql_fetch_one_cell("SELECT COUNT(*) as num FROM bm_item WHERE bm_GameID = ".$GameID." AND bm_ItemName like '%".$itemName."%'"); 
 				return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$ary);
 			}else{
 				return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 			} 
    	}
    	else{
    		$sql_ = "SELECT * FROM bm_item WHERE bm_GameID = ".$GameID." AND bm_ItemGID = '".$itemName."' ORDER BY bm_ItemID DESC LIMIT $offer, $pageSize";
    		$r_ = sql_fetch_rows($sql_);
   			if(!empty($r_)){
 				$ary_ = Array();
 				foreach($r_ as $k=>$v){
 					$gameItemMDL_ = new GameItemMDL($v[0],$v[1],$v[2],$v[3],$v[4],$v[5]);
 					$ary_[] = $gameItemMDL_;
 				}
 				$count_ = sql_fetch_one_cell("SELECT COUNT(*) as num FROM bm_item WHERE bm_GameID = ".$GameID." AND bm_ItemGID = '".$itemName."'"); 
 				return new DataResult(ResultStateLevel::SUCCESS,"1",$count_,$ary_);
 			}else{
 				return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 			} 
    	}
    }
}
?>