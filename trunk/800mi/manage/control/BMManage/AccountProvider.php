<?php
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMManage/EventLog.php'); 


class AccountProvider
{
	private static $instance;
	private function __construct()
    {}
    
	public static function getInstance()
    {
        if(self::$instance == null)
        {
            self::$instance = new AccountProvider();
        }
        return self::$instance;
    }
    
    /**
     * 依据账号获取账号信息
     * @param $Account
     */
    public function getAccount($Account)
    {
		$sql =sprintf("SELECT * FROM bm_account WHERE account= %d ",$Account);
		$r = sql_fetch_one($sql);
    	if($r != ""){
    		$o = Array();
    		$accountMDL = new AccountMDL($r[0],$r[1],$r[2],$r[3],$r[4],
    										$r[5],$r[6],$r[7],$r[8],$r[9],$r[10]);
			$o[] = $accountMDL;
    		return new DataResult(ResultStateLevel::SUCCESS,"1",1,$o);
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
    	}
    }
    
    /**
     * 依据账号ID获取账号信息（屏蔽已删除的）
     * @param unknown_type $AccountID
     */
    public function getAccountByAccountID($AccountID)
    {
    	$sql =sprintf("SELECT * FROM bm_account WHERE account_state < 99 AND account_id = %d ",$AccountID);
		$r = sql_fetch_one($sql);
    	if($r != ""){
    		$o = Array();
    		$accountMDL = new AccountMDL($r[0],$r[1],$r[2],$r[3],$r[4],
    										$r[5],$r[6],$r[7],$r[8],$r[9]);
			$o[] = $accountMDL;
    		return new DataResult(ResultStateLevel::SUCCESS,"1",1,$o);
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
    	}
    }
    
    /**
     * 获取账号列表
     * @param $offer
     * @param $pageSize
     * @param $account
     */
    public function ListAllAccount($offer, $pageSize, $account,$type)
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1",NULL); 
    	}
    	$where = "";
    	if(!empty($account)){
    		if($type == 1)
    			$where = " AND account_id = '" . $account."'";
    		else if($type == 2)
    		    $where = " AND account_name like '%". $account."%'";
    	} 
    	$sql = "SELECT * FROM bm_account WHERE account_state < 99". $where . " ORDER BY account_id DESC LIMIT $offer, $pageSize";
    //	return new DataResult(ResultStateLevel::ERROR,$sql,$sql,NULL);
   		$r = sql_fetch_rows($sql);
   		if(!empty($r)){
 			$ary = Array();
 			foreach($r as $k=>$v){
 				$accountMDL = new AccountMDL($v[0],$v[1],$v[2],$v[3],$v[4],$v[5],$v[6],$v[7],$v[8],$v[9]);
 				$ary[] = $accountMDL;
 			}
 			$count = sql_fetch_one_cell("SELECT COUNT(*) as num FROM bm_account WHERE account_state < 99 "); 
 			return new DataResult(ResultStateLevel::SUCCESS,"1",$count,$ary);
 		}else{
 			return new DataResult(ResultStateLevel::ERROR,"0",$sql,NULL);
 		} 		
    }
    
    /**
     * 新增--------------------------------------
     * @param $account
     * @param $name
     * @param $phone
     * @param $mail
     * @param $QQ
     * @param $adress
     * @param $type
     * @param $reamark
     */
    public  function AddNew($account,$name,$level,$type,$reamark)
    {
    	AddBMAccountEventLog("新增账号：".$account,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1"); 
    	}
    	$check = "SELECT account_id FROM bm_account WHERE account = '" . $account . "';";
 		if(sql_fetch_one_cell($check) != "") return new ExcuteResult(ResultStateLevel::EXCEPTION,"账号[".$account."]已存在",$account);
 		$password = md5("a00000");
 		$sql = "insert into bm_account (account,account_pasword,account_name,account_type,account_money,account_level,account_state,add_time,account_remark)";
    	$sql.= "values ('$account','$password','$name','$type','0','$level','0',UNIX_TIMESTAMP(),'$reamark')";
    	$r = sql_insert($sql);
    	if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$r[0]);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,$sql,NULL);
    }
    
    /**
     * 修改账号信息 ----------------------------------------
     * @param unknown_type $accountID
     * @param unknown_type $ary
     */
    public function Update($accountID,$ary)
    {
   		AddBMAccountEventLog("修改账号信息ID：".$accountID,EventLogTypeEnum::BASEMANGE);
   		if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1"); 
    	}
    	if(empty($accountID)) return new ExcuteResult(ResultStateLevel::EXCEPTION,"不存在此账号",NULL);
 		if(empty($ary)){
 			$sql = "UPDATE bm_account SET account_state = 99 WHERE account_id =".$accountID; 			
 		}else{
 			foreach (array_keys($ary) AS $k=>$v) {
				$attribute[] = "`$v` = '".$ary[$v]."'"; 				
 			}
 			$sql = "UPDATE bm_account SET " . implode(",",$attribute) . " WHERE account_id =".$accountID; 
 		} 	
 		$r = sql_query($sql);
 		if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 修改密码
     * @param unknown_type $accountID
     * @param unknown_type $oldPwd
     * @param unknown_type $newPwd
     */
    public function EditPassWord($oldPwd,$newPwd)
    {
    	AddBMAccountEventLog("修改账号密码，原先密码：".$oldPwd,EventLogTypeEnum::BASEMANGE);

    	if($newPwd == "a00000") return new ExcuteResult(ResultStateLevel::ERROR,"密码不能修改成初始化密码",NULL);
    	if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1"); 
    	}
    	$accountID = $_SESSION['account_ID'];
    	$sqlCheck ="SELECT bm_AccountID FROM bm_account WHERE account_id = ".$accountID." AND account_pasword = '".md5($oldPwd)."'";
    	$check = sql_fetch_one_cell($sqlCheck);

    	if($check == "") return new ExcuteResult(ResultStateLevel::EXCEPTION,"原密码不正确",NULL);
    	$password = md5($newPwd);
    	$sql = "UPDATE bm_account SET account_pasword = '".$password."' WHERE account_id = $accountID";

    	$r = sql_query($sql);
 		if($r != 0){
 			$tag = $oldPwd == "a00000" ? true:false;
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",$tag);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 重置密码
     * @param unknown_type $accountID
     */
    public function ResetPassWord($accountID)
    {
    	AddBMAccountEventLog("重置账号密码账号：".$accountID,EventLogTypeEnum::BASEMANGE);
    	if(!isset($_SESSION['account_ID']))  {
    		return new ExcuteResult(ResultStateLevel::ERROR,"The accounts have been logged out, please re-login account","-1"); 
    	}
    	if(empty($accountID)) return new ExcuteResult(ResultStateLevel::EXCEPTION,"不存在此账号",NULL);
    	$password = md5("a00000");
    	$sql = "UPDATE bm_account SET account_id = '".$password."' WHERE  account_id = $accountID";
    	$r = sql_query($sql);
 		if($r != 0){
    		return new ExcuteResult(ResultStateLevel::SUCCESS,"",1);
    	}
    	else
    	  return new ExcuteResult(ResultStateLevel::EXCEPTION,"执行出错",NULL);
    }
    
    /**
     * 账号登陆
     * @param unknown_type $Account
     * @param unknown_type $PWD
     */
    public function Login($Account,$PWD)
    { 
    	$sql ="SELECT account_id,account_name FROM bm_account WHERE account = '".$Account."' AND account_pasword = '".md5($PWD)."' AND account_state != 99";
		$r = sql_fetch_one($sql);
		
    	if($r != ""){    		
    		//$accountMDL = new AccountMDL($r[0],$r[1]);
    		if(!isset($_SESSION)){
    		session_start();
			}
			$_SESSION['account_ID']   =  $r[0];
			$_SESSION['user']   =  $r[1];//$accountMDL->acct_name;
			AddBMAccountEventLog("账号登陆：".$Account,1);
    		return new DataResult(ResultStateLevel::SUCCESS,"",NULL,NULL);
    	}
    	else{
    		return new DataResult(ResultStateLevel::ERROR,"账号不存在或密码错误",NULL,NULL);
    	}
    }
    
    /**
     * 判断账号是否要强制修改密码
     */
    public function AccountIsEditPWD()
    {
    	if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return "1"; 
    	}
    	$accountID = $_SESSION['account_ID'];
    	$sql =sprintf("SELECT * FROM bm_account WHERE account_state < 99 AND account_id = %d ",$accountID);
		$r = sql_fetch_one($sql);
    	if($r != ""){
    		$o = Array();
    		$accountMDL = new AccountMDL($r[0],$r[1],$r[2],$r[3],$r[4],
    										$r[5],$r[6],$r[7],$r[8],$r[9]);
    		if($accountMDL->bm_Password == md5("a00000"))
    			return "0";
    	    else
    	    	return "1";
    	}
    	else{
    		return "1"; 
    	}
    }
}