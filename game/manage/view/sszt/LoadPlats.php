<?php

	include_once("../common.php");
	/*
	$fileName = "Cache/plats".date("Y-m-d").".txt";
	if(file_exists($fileName))
	{
		$file = fopen($fileName,"r");
		$str = fgets($file);
		fclose($file);
	}
	else
	{
	*/
		if(!isset($_SESSION))  session_start();
    	if(!isset($_SESSION['account_ID']))  {
    		return new DataResult(ResultStateLevel::ERROR,"账号已登出，请重新登录","-1",NULL); 
    	}
    	$AccountID = $_SESSION['account_ID'];
		$sql = "SELECT DISTINCT(b.bm_AreaID),a.bm_AreaName FROM bm_gamearea a,bm_accountgameserver b WHERE a.bm_AreaID = b.bm_AreaID AND b.bm_AccountID = ".$AccountID." AND b.bm_GameID = 1 AND a.bm_AreaState < 99 ORDER BY b.bm_AreaID";
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
