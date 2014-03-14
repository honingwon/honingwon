<?php
	
	include_once("../common.php");
	
	if(!isset($_SESSION))  session_start();
    if(!isset($_SESSION['account_ID']))  {
    	return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    }
    $AccountID = $_SESSION['account_ID'];
    
	$plat = $_POST["plat"];
//	$fileName = "Cache/".$plat."_servers".date("Y-m-d").".txt";
//	if(file_exists($fileName))
//	{
//		$file = fopen($fileName,"r");
//		$str = fgets($file);
//		fclose($file);
//	}
//	else
//	{
		$sql = "SELECT b.bm_ServerID,b.bm_ServerName FROM bm_accountgameserver a,bm_gameserver b WHERE a.bm_ServerID = b.bm_ServerID AND b.bm_ServerState < 99 AND a.bm_AccountID = ".$AccountID." AND b.bm_GameId = 1 AND a.bm_AreaID = ".$plat;
		$dbData = sql_fetch_rows($sql);
		$str = "";
		for($i = 0;$i != count($dbData);$i++){
			$row = $dbData[$i];
			$line = $row[0].",".$row[1];
			$str .= "|".$line;
		}
		$str = substr($str,1);
//		$file = fopen($fileName,"w");
//		fwrite($file,$str);
//		fclose($file);
//	}
	echo $str;
	
?>
