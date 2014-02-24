<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMAccount/EventLog.php');

/**
 * 卡库  卡批次
 */
class CardGroupManageProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new CardGroupManageProvider();
        }
        return self::$instance;
    }
    
    /**
     * 获取卡批次列表
     * @param unknown_type $FormName 卡申请单名称
     * @param unknown_type $offer
     * @param unknown_type $pageSize
     */
    public function ListCardGroup($FormName,$offer, $pageSize)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$sql = "SELECT b.cd_CAFormName,b.cd_CardApplyer,b.cd_CAFormChecker,b.cd_CardPicker,a.*,c.cd_CardTypeName";
    	$sql.= " FROM CD_CardGroup a,CD_CardApplyForm b,CD_CardType c";
    	$sql.= " WHERE a.cd_CAFormID = b.cd_CAFormID AND a.cd_CardTypeID = c.cd_CardTypeID AND b.cd_CAFormName like '%". $FormName."%'  ORDER BY cd_Createtime DESC LIMIT $offer, $pageSize";
    	$r = sql_fetch_rows($sql);
   		if(!empty($r)){
 			$ary = Array();
 			foreach($r as $k=>$v){
 				$cardGroupMDL = new CardGroupMDL($v[4],$v[5],$v[6],$v[7],$v[8],$v[9],$v[10],$v[11],$v[12],
 												$v[0],$v[1],$v[2],$v[3],$v[13]);
 				$ary[] = $cardGroupMDL;
 			}
 			$count = sql_fetch_one_cell("SELECT COUNT(1) AS num FROM CD_CardGroup a,CD_CardApplyForm b WHERE a.cd_CAFormID = b.cd_CAFormID AND b.cd_CAFormName like '%". $FormName."%'"); 
 			return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$ary);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 		} 		
    }
    
    /**
     * 获取指定卡批次的卡的相关信息
     * @param unknown_type $GroupID
     */
    public function GetCardGroupInfo($GroupID)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$sql = "SELECT b.cd_CAFormName,b.cd_CardApplyer,b.cd_CAFormChecker,b.cd_CardPicker,a.*,c.cd_CardTypeName";
    	$sql.= " FROM CD_CardGroup a,CD_CardApplyForm b,CD_CardType c";
    	$sql.= " WHERE a.cd_CAFormID = b.cd_CAFormID AND a.cd_CardTypeID = c.cd_CardTypeID AND a.cd_CroupID = ".$GroupID;
    	$r = sql_fetch_one($sql);
    	if($r != ""){
    		$o = Array();
    		$cardGroupMDL = new CardGroupMDL($r[4],$r[5],$r[6],$r[7],$r[8],$r[9],$r[10],$r[11],$r[12],
    										$r[0],$r[1],$r[2],$r[3],$r[13]);
			$o[] = $cardGroupMDL;
    		return new DataResult(ResultStateLevel::SUCCESS,"1",1,$o);
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
    	}
    }
    
    /**
     * 更改卡批次状态 以及有效期
     * @param unknown_type $GroupID
     * @param unknown_type $State
     * @param unknown_type $StartTime
     * @param unknown_type $EndTime
     */
    public function UpdateCardGroupInfo($GroupID,$State,$StartTime,$EndTime)
    {
    	AddBMAccountEventLog("修改卡批次信息ID：".$GroupID.",状态：".$State.",时间：".$StartTime."-".$EndTime,EventLogTypeEnum::CARDMANAGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$sql = "UPDATE CD_CardGroup SET cd_GroupState = ".$State.", cd_ChargeStartTime = '".$StartTime."'";
    	$sql.= ", cd_ChargeEndTime = '".$EndTime."'  where cd_CroupID = ".$GroupID;
    	$r = sql_query($sql);
 		if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",NULL);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
}
?>