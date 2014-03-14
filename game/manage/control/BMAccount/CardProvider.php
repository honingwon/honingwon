<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMAccount/EventLog.php'); 

/**
 *卡库  卡相关
 */
class CardProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new CardProvider();
        }
        return self::$instance;
    }
    
    public function SearchCardinfo($cardSN,$cardPassword)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$where = "";
    	if(!empty($cardSN))
    		$where.= " AND a.cd_CardSN = '".$cardSN."'";
    	if(!empty($cardPassword))
    		$where.= " AND cd_CardPassword = '".$cardPassword."'";
    	if(empty($where))
    		 return new DataResult(ResultStateLevel::ERROR,"卡信息错误，请重新输入",NULL,NULL);
    	$sql = "SELECT c.cd_CardTypeName,b.cd_GroupState,b.cd_ChargeStartTime,b.cd_ChargeEndTime,a.* ";
    	$sql.= " FROM cd_card a, cd_cardgroup b, cd_cardtype c ";
    	$sql.= " WHERE a.cd_CardTypeID = c.cd_CardTypeID AND a.cd_CroupID = b.cd_CroupID  ".$where;
    	$r = sql_fetch_one($sql);
    	if($r != ""){
    		$o = Array();
    		$cardMDL = new CardMDL($r[0],$r[1],$r[2],$r[3],$r[4],$r[5],$r[6],$r[7],$r[8],$r[9],$r[10]);
			$o[] = $cardMDL;
    		return new DataResult(ResultStateLevel::SUCCESS,"",1,$o);
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"卡不存在",NULL,NULL);
    	}
    }
}
?>