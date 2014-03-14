<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMAccount/EventLog.php');

/**
 * 卡库  卡种类维护
 */
class CardTypeProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new CardTypeProvider();
        }
        return self::$instance;
    }
    /**
     * 新增卡种类
     * @param unknown_type $name
     * @param unknown_type $restrict
     * @param unknown_type $point
     * @param unknown_type $price
     * @param unknown_type $unique
     * @param unknown_type $remark
     * @param unknown_type $gameStr
     */
    public function AddCardType($name,$restrict,$point,$price,$unique,$remark,$gameStr)
    {
    	AddBMAccountEventLog("新增卡种类名称：".$name.",限制：".$restrict,EventLogTypeEnum::CARDMANAGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "insert into CD_CardType (cd_CardTypeName,cd_GameRestrict,cd_CardPoint,cd_CardPrice,cd_CardTypeUnique,cd_CardTypeState,cd_Remark)";
    	$sql.= " values ('$name','$restrict','$point','$price','$unique',0,'$remark')";
    	$r = sql_insert($sql);
    	if($r != 0){
    		$msg = "卡种类新增成功";
    		$cardTypeID = $r[0];
    		$arr = array("NULL"=>$cardTypeID);
    		$addStr = strtr($gameStr,$arr);
    		$sqladd = "insert into CD_CardGameType (cd_CardTypeID,bm_GameID,bm_AreaID,bm_ServerID) values ".$addStr;
    		$add = sql_query($sqladd);
    		if($add == 0)
    			$msg.="，卡限制新增失败";
    		return new ExcuteResult(ResultStateLevel::SUCCESS,$msg,$sqladd);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::ERROR,"执行出错",NULL);
    }
    
    /**
     * 修改卡信息
     * @param unknown_type $cardID
     * @param unknown_type $ary
     */
    public function UpdateCardInfo($cardID,$ary)
    {
   		AddBMAccountEventLog("修改卡种类信息ID：".$cardID,EventLogTypeEnum::CARDMANAGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	if(empty($cardID)) return new ExcuteResult(ResultStateLevel::EXCEPTION,"不存在此卡",NULL);
    	$sql = "";
    	if(empty($ary)){
    		$sql = "UPDATE CD_CardType SET cd_CardTypeState = 99 WHERE cd_CardTypeID =".$cardID; 	
    	}
    	else{
    		foreach (array_keys($ary) AS $k=>$v) {
				$attribute[] = "`$v` = '".$ary[$v]."'"; 				
 			}
 			$sql = "UPDATE CD_CardType SET ".implode(",",$attribute)." WHERE cd_CardTypeID =".$cardID; 
    	}
 		$r = sql_query($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 卡种类开启
     * @param unknown_type $cardID
     */
    public function openCardStart($cardID)
    {
    	AddBMAccountEventLog("开启卡种类ID：".$cardID,EventLogTypeEnum::CARDMANAGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	if(empty($cardID)) return new ExcuteResult(ResultStateLevel::EXCEPTION,"不存在此卡",NULL);
    	$sql = "UPDATE CD_CardType SET cd_CardTypeState = 1 WHERE cd_CardTypeID =".$cardID; 
    	$r = sql_query($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 修改卡种类游戏限制
     * @param unknown_type $cardID
     * @param unknown_type $limit
     * @param unknown_type $gameStr
     */
    public function UpdateCardLimit($cardID,$limit,$gameStr)
    {
    	$sqlCheck ="SELECT cd_CardTypeID FROM CD_CardType WHERE cd_CardTypeID = ".$cardID."AND cardState < 99 ";
    	$check = sql_check($sqlCheck);
    	if($check) return new ExcuteResult(ResultStateLevel::EXCEPTION,"卡不存在",$cardID);
    	
   		AddBMAccountEventLog("修改卡种类限制ID：".$cardID.",限制：".$limit,EventLogTypeEnum::CARDMANAGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sqlDel = "delete from CD_CardGameType where cd_CardTypeID = ".$cardID;
    	$r = sql_query($sqlDel);
    	$msg = "";
    	if($r == 0){
    		$msg.= "卡原先的限制清除失败!";
    	}
    	if(!empty($gameStr)){
    		$arr = array("NULL"=>$cardID);
    		$addStr = strtr($gameStr,$arr);
    		$sqladd = "insert into CD_CardGameType (cd_CardTypeID,bm_GameID,bm_AreaID,bm_ServerID) values ".$addStr;
    		$add = sql_query($sqladd);
    		if($add == 0){
    			$msg.="卡限制修改失败!";
    		}
    	}
    	if($limit != ""){
    			$sqlUpdate = "UPDATE CD_CardType SET cd_GameRestrict = ".$limit." WHERE cd_CardTypeID = $cardID";
    			$r_update = sql_query($sqlUpdate);
    			if($r_update == 0)
    				$msg.="更改卡状态信息失败!";
    	}
    	return new ExcuteResult(ResultStateLevel::SUCCESS,$msg,NULL);
    }
    
//    public function SetCardActive($cardID)
//    {
//    	$sql = "UPDATE CD_CardType SET cd_CardTypeState = 1 WHERE cd_CardTypeID = $cardID"; 
//    	$r = sql_query($sql);
//    	if($r != 0){
//    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
//    	}
//    	else
//    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
//    }
    
    /**
     * 删除卡种类
     * @param unknown_type $cardID
     */
    public function DelCardType($cardID)
    {
    	AddBMAccountEventLog("删除卡种类ID：".$cardID,EventLogTypeEnum::CARDMANAGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "UPDATE CD_CardType SET cd_CardTypeState = 99 WHERE cd_CardTypeID = $cardID"; 
    	$r = sql_query($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 获取卡种类列表 分页
     * @param unknown_type $offer
     * @param unknown_type $pageSize
     * @param unknown_type $cardName
     */
    public function ListCardType($offer, $pageSize, $cardName)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$where = "";
    	if(!empty($cardName)){
    		    $where = " AND cd_CardTypeName like '%".$cardName."%'";
    	} 
    	$sql = "SELECT * FROM CD_CardType WHERE cd_CardTypeState < 99". $where . " ORDER BY cd_CardTypeID DESC LIMIT $offer, $pageSize";
   		$r = sql_fetch_rows($sql);
   		if(!empty($r)){
 			$ary = Array();
 			foreach($r as $k=>$v){
 				$cardTypeMDL = new CardTypeMDL($v[0],$v[1],$v[2],$v[3],$v[4],$v[5],$v[6],$v[7]);
 				$ary[] = $cardTypeMDL;
 			}
 			$count = sql_fetch_one_cell("SELECT COUNT(*) as num FROM CD_CardType WHERE cd_CardTypeState < 99 "); 
 			return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$ary);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"执行出错",NULL,NULL);
 		} 		
    }
    
    /**
     * 所有卡种类列表 无分页
     * @param unknown_type $cardName
     */
    public function ListAllCardType($cardName ="")
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$sql = "SELECT * FROM CD_CardType WHERE cd_CardTypeState = 1 AND cd_CardTypeName like '%".$cardName."%'";
    	$r = sql_fetch_rows($sql);
   		if(!empty($r)){
 			$ary = Array();
 			foreach($r as $k=>$v){
 				$cardTypeMDL = new CardTypeMDL($v[0],$v[1],$v[2],$v[3],$v[4],$v[5],$v[6],$v[7]);
 				$ary[] = $cardTypeMDL;
 			}
 			return new DataResult(ResultStateLevel::SUCCESS,"1",NULL,$ary);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"执行出错",NULL,NULL);
 		} 		
    }
    
    /**
     * 由卡ＩＤ获取卡种类信息
     * @param unknown_type $cardID
     */
    public function GetCardTypeByCardID($cardID)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
   	    $sql = "SELECT * FROM CD_CardType WHERE cd_CardTypeState < 99 AND cd_CardTypeID = ".$cardID;
		$r = sql_fetch_one($sql);
    	if($r != ""){
    		$o = Array();
    		$cardTypeMDL = new CardTypeMDL($r[0],$r[1],$r[2],$r[3],$r[4],$r[5],$r[6],$r[7]);
			$o[] = $cardTypeMDL;
    		return new DataResult(ResultStateLevel::SUCCESS,"1",1,$o);
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
    	}
    }
    
    /**
     * 由卡ＩＤ获取卡种类信息(包括卡限制的所有信息)
     * @param unknown_type $cardID
     */
    public function getCardAllInfoByCardID($cardID)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$sql = "SELECT * FROM CD_CardType WHERE cd_CardTypeState < 99 AND cd_CardTypeID = ".$cardID;
		$r = sql_fetch_one($sql);
    	if($r != ""){
    		$o = Array();
    		$cardTypeMDL = new CardTypeMDL($r[0],$r[1],$r[2],$r[3],$r[4],$r[5],$r[6],$r[7]);
			$o[] = $cardTypeMDL;
			
			$sqlLimit = "SELECT * FROM CD_CardGameType WHERE cd_CardTypeID = ".$cardID;
    		$rLimit = sql_fetch_rows($sqlLimit);
   			if(!empty($rLimit)){
 				$ary = Array();
 				foreach($rLimit as $k=>$v){
					$l_arry = Array();
					$l_arry[] = $v[0];
					$l_arry[] = $v[1];
					$l_arry[] = $v[2];
					$l_arry[] = $v[3];
					$l_arry[] = $v[4];
 					$ary[] = $l_arry;
 				}
 				$o[] = $ary; 
 			}
    		return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$o);
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"执行出错",NULL,NULL);
    	}
    }
    
    /**
     * 根据卡种类获取绑定的道具信息
     * @param $cardTypeID
     */
    public function GetCardItemByCardType($cardTypeID)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
   		$sql = "SELECT b.bm_ItemID,b.cd_CardItemNum,a.bm_ItemName FROM  bm_item a, cd_cardaffixitem b ";
   		$sql.= " WHERE a.bm_ItemID = b.bm_ItemID AND b.cd_CardTypeID = ".$cardTypeID;
   		$r = sql_fetch_rows($sql);
   		if(!empty($r)){
 			$ary = Array();
 			foreach($r as $k=>$v){
 				$ob = Array();
 				$ob[] = $v[0];
 				$ob[] = $v[1];
 				$ob[] = $v[2];
 				$ary[] = $ob;
 			}
 			return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$ary);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"执行出错",NULL,NULL);
 		} 
    }
    
    /**
     * 更新卡的道具绑定信息
     * @param $cardTypeID
     * @param $gameStr
     */
    public function UpdateCardItemInfo($cardTypeID,$gameStr)
    {
    	$sqlCheck ="SELECT cd_CardTypeID FROM CD_CardType WHERE cd_CardTypeID = ".$cardTypeID." AND cd_CardTypeState < 99 ";
    	$check = sql_fetch_one($sqlCheck);
    	if($check == "") return new ExcuteResult(ResultStateLevel::EXCEPTION,"卡不存在",$cardTypeID);
    	
    	AddBMAccountEventLog("删除卡种类ID：".$cardTypeID,EventLogTypeEnum::CARDMANAGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	
    	$sqldel ="delete from cd_cardaffixitem where cd_CardTypeID = ".$cardTypeID;
    	$rDell = sql_query($sqldel);
    	if($rDell == 0)
    		return new ExcuteResult(ResultStateLevel::ERROR,"更新卡道具失败");
    	if(empty($gameStr)) 
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);			
			
    	$arr = array("NULL"=>$cardTypeID);
    	$addStr = strtr($gameStr,$arr);	
   		$sqladd = "insert into cd_cardaffixitem (cd_CardTypeID,bm_ItemID,cd_CardItemNum) values ".$addStr;
    	$add = sql_query($sqladd);
    	if($add == 0)
    		return new ExcuteResult(ResultStateLevel::ERROR,"非常抱歉，更新卡道具失败,原先的道具绑定已删除！",$sqladd);
        else
        	return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
    	
    }
}
?>