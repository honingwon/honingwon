<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMAccount/EventLog.php');

/**
 * 卡库  道具卡申请流程   申请  审核  提卡
 */
class CardApplyProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new CardApplyProvider();
        }
        return self::$instance;
    }
    
    /**
     * 创建道具卡申请订单
     * @param unknown_type $cd_CAFormName
     * @param unknown_type $cd_CAFormRemark
     * @param unknown_type $CardStr
     * @param unknown_type $EmailBody
     */
    public function CreatCardApplyInfo($cd_CAFormName, $cd_CAFormRemark, $CardStr, $EmailBody)
    {
        if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']) || !isset($_SESSION['user']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$AccountName = $_SESSION['user'];
    	$Time = date("Y-m-d H:i:s");
    	$sql_apply = "insert into CD_CardApplyForm (cd_CAFormName,cd_CAFormRemark,cd_CardApplyer,cd_CardApplyTime,cd_CAFormState)";
    	$sql_apply.= " values ('$cd_CAFormName','$cd_CAFormRemark','$AccountName','$Time',-1)";
    	$r = sql_insert($sql_apply);
    	if($r != 0){
    		$applyID = $r;
    		$arr = array("NULL"=>$applyID);
    		$addCardInfo = strtr($CardStr,$arr);
    		$sql_apply_card = "insert into CD_CAFormCardInfo(cd_CAFormID,cd_CardTypeID,cd_CardNum) values ".$addCardInfo;
    		$add_card = sql_query($sql_apply_card);
    		if($add_card != 0){
    			$sql_apply_update = "UPDATE CD_CardApplyForm set cd_CAFormState = 0 where cd_CAFormID = ".$applyID;
    			$sql_update = sql_query($sql_apply_update);
    			if($r != 0){
    				return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
    			}
    			else
    				return new ExcuteResult(ResultStateLevel::SUCCESS,"卡更新状态失败！",NULL);
    		}
    		else
    			return new ExcuteResult(ResultStateLevel::ERROR,"CD_CAFormCardInfo 新增失败",NULL);
    	}
    	else
    		return new ExcuteResult(ResultStateLevel::ERROR,"CD_CardApplyForm 新增失败",NULL);
    }
    
    /**
     * 查询不同状态的道具卡订单列表
     * @param $cardFormState
     * @param $offer
     * @param $pageSize
     */
    public function GetCardFormListByState($cardFormState,$offer, $pageSize)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "SELECT * FROM CD_CardApplyForm WHERE cd_CAFormState = ".$cardFormState." ORDER BY cd_CardApplyTime DESC LIMIT $offer, $pageSize";
    	$r = sql_fetch_rows($sql);
   		if(!empty($r)){
 			$ary = Array();
 			foreach($r as $k=>$v){
 				$cardApplyFormMDL = new CardApplyFormMDL($v[0],$v[1],$v[2],$v[3],$v[4],$v[5],$v[6],$v[7],$v[8],$v[9],$v[10]);
 				$ary[] = $cardApplyFormMDL;
 			}
 			$count = sql_fetch_one_cell("SELECT COUNT(*) as num FROM CD_CardApplyForm WHERE cd_CAFormState = ".$cardFormState); 
 			return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$ary);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,$sql,NULL,NULL);
 		} 		
    }
    
    /**
     * 依据卡订单获取卡详情
     * @param unknown_type $cardFormID
     */
    public function GetCardTypeInfoByCardFormID($cardFormID)
    {
    	$sqlForm = "SELECT * FROM CD_CardApplyForm WHERE cd_CAFormID = ".$cardFormID;
    	$row = sql_fetch_one($sqlForm);
    	$returnArry = Array();
    	if($row != ""){
    		$o = Array();
    		$cardApplyFormMDL = new CardApplyFormMDL($row[0],$row[1],$row[2],$row[3],$row[4],
    										$row[5],$row[6],$row[7],$row[8],$row[9],$row[10]);
			$o[] = $cardApplyFormMDL;
			$returnArry[] = $o;
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"卡不存在",NULL,NULL);
    	}
    	$sql = "SELECT a.*,b.cd_CardTypeName FROM CD_CAFormCardInfo a,CD_CardType b";
    	$sql.= " WHERE a.cd_CardTypeID = b.cd_CardTypeID AND a.cd_CAFormID = ".$cardFormID;
    	$r = sql_fetch_rows($sql);
    	if(!empty($r)){
    		$array = Array();
    		for ($i = 0 ; $i < count($r); $i++){
    			$rightsServ = $r[$i];
    			$rights = Array();
    			$rights[] = $rightsServ[0];
    			$rights[] = $rightsServ[1];
    			$rights[] = $rightsServ[2];
    			$rights[] = $rightsServ[3];
				$array[] = $rights;
    		}
    		$returnArry[] =$array;
 			return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$returnArry);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"",NULL,NULL);
 		} 		
    }
    
    /**
     * 道具卡审核(不通过)
     * @param unknown_type $cardFormID
     * @param unknown_type $remmark
     */
    public function UnPassCardForm($cardFormID,$remmark)
    {
    	AddBMAccountEventLog("道具卡申请审核不通过订单号：".$cardFormID.",审核备注：".$remmark,EventLogTypeEnum::CARDMANAGE);
    	if(!isset($_SESSION['account_ID']) || !isset($_SESSION['user']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出,请重新登陆！","-1");
    	}
    	$AccountName = $_SESSION['user'];
    	if(defined('TIMEZONE')) { 
    		$timezone = TIMEZONE;
		    if(function_exists('date_default_timezone_set')) date_default_timezone_set($timezone);
		} 
    	$Time = date("Y-m-d H:i:s");
    	$sql = "UPDATE CD_CardApplyForm SET cd_CAFormState = 11, cd_CAFormCheckRemark = '".$remmark."'";
    	$sql.= ", cd_CAFormChecker = '".$AccountName."', cd_CAFormCheckTime = '".$Time."'";
    	$sql.= " WHERE cd_CAFormState = 0 AND cd_CAFormID = ".$cardFormID;
    	$r = sql_query($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 道具卡审核（通过）
     * @param unknown_type $FromCardID
     * @param unknown_type $Reamrk
     */
    public function DoPassCardInfo($FromCardID,$Reamrk)
    {
    	AddBMAccountEventLog("道具卡申请审核通过订单号：".$FromCardID.",审核备注：".$Reamrk,EventLogTypeEnum::CARDMANAGE);
    	if(!isset($_SESSION['account_ID']) || !isset($_SESSION['user']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出,请重新登陆！","-1");
    	}
    	$Account = $_SESSION['user'];
    	$sql = sprintf("CALL CreateCardGroup(%d,'%s','%s');",$FromCardID,$Account,$Reamrk);
    	$r = sql_fetch_one_cell($sql);
		if($r == 1)
			return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
		else
			return new ExcuteResult(ResultStateLevel::EXCEPTION,"",NULL);
    }
    
    /**
     * 获取卡订单申请中卡种类信息
     * @param unknown_type $FormID
     */
    public function getCardListByFormID($FormID)
    {
    	$sql_group = "SELECT a.cd_CroupID,b.cd_CardTypeName FROM CD_CardGroup a,CD_CardType b WHERE a.cd_CardTypeID = b.cd_CardTypeID AND a.cd_CAFormID = ".$FormID;
    	$r_group = sql_fetch_rows($sql_group);
    	if(!empty($r_group)){
    		$ListCard = Array();
 			for ($i = 0 ; $i < count($r_group); $i++){
    			$rightsServ = $r_group[$i];
    			$sql_card ="SELECT cd_CardSN,cd_CardPassword FROM cd_card WHERE cd_CroupID = ".$rightsServ[0];
    			$r_card = $r_group = sql_fetch_rows($sql_card);
    			if(!empty($r_card)){
    				$objList = Array();
    				for ($j = 0 ; $j < count($r_card); $j++){
    					$card = Array();
    					$card[] = $r_card[$j][0];
    					$card[] = $r_card[$j][1];
    					$card[] = $rightsServ[1];
    					$objList[] = $card;
    				}
    				$ListCard[] = $objList;
    			}
    		}
    		return new DataResult(ResultStateLevel::SUCCESS,"",NULL,$ListCard);
 		}
 		else
 			return new DataResult(ResultStateLevel::EXCEPTION,"执行错误",NULL,NULL);
    }
    
    /**
     * 提取卡，更新订单状态
     * @param $FormID
     */
    public function UpdateCardFormState($FormID)
    {
    	AddBMAccountEventLog("提取卡订单号：".$FormID,EventLogTypeEnum::CARDMANAGE);
    	if(!isset($_SESSION['account_ID']) || !isset($_SESSION['user']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出,请重新登陆！","-1");
    	}
    	$Account = $_SESSION['user'];
    	$Time = date("Y-m-d H:i:s");
    	$sql = "UPDATE CD_CardApplyForm SET cd_CAFormState = 2, cd_CardPicker = '".$Account."'";
    	$sql.= ", cd_CardPickTime = '".$Time."'";
    	$sql.= " WHERE cd_CAFormState = 1 AND cd_CAFormID = ".$FormID;
    	$r = sql_query($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
}
?>