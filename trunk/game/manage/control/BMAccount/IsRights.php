<?php
	require_once(dirname(__FILE__).'/../../view/common.php');
	require_once(DATACONTROL . '/BMAccount/ModuleManageProvider.php');
	require_once(DATAMODEL . '/BMAccount/ModuleMDL.php');

	$isUpdate_hlqs = true;   //幻龙骑士是否维护中
	$isoutLogin_hlqs = true; //维护中是否强制退出系统
	$isTime_hlqs = "2012-4-16 14:00:00 ~ 2012-4-16 15:00:00";  //维护时间段
	$url_this =  $_SERVER['PHP_SELF'];
	$url_array = explode("/",$url_this);
	if($isUpdate_hlqs){
		/////////////管理员账号在维护期间不受限制//////////////
		if(!isset($_SESSION)){
    		session_start();
		}
		if(isset($_SESSION['account_ID'])){
			$AccountID = $_SESSION['account_ID'];
			if($AccountID == 1){
			   return;
			}
		}
		/////////////管理员账号在维护期间不受限制//////////////
		for($u = 0;$u < count($url_array);$u++)
		{
			if(strtolower($url_array[$u]) == "hlqs"  || strtolower($url_array[$u] == "hlcs"))
			{
			   //幻龙骑士 是否开启维护
			   if($isUpdate_hlqs){
			   	   echo $isTime_hlqs." 系统升级维护中 ,请稍后登陆";
			   	   if($isoutLogin_hlqs)
			   	   {
			   	  	 	if(!isset($_SESSION)){
    				  		session_start();
				    	}
				   		if(isset($_SESSION['account_ID'])) {
					  		$_SESSION=array();
        			  		session_destroy();
	 				  		echo '<SCRIPT language="javascript" >window.alert("点击确认退出系统"); window.parent.top.location=top.location="'.MANAGER_PATH.'/view/default/Login.php";</SCRIPT>';exit;
				   		}
			   	   }
			   	   else
			   	   		exit;  
			   }
			}
		}
	}
	
	//开始判断权限
	if(isset($_GET['r']))
 	{
    		$paramRight = $_GET['r'] ; 
    		$rightModule_result = ModuleManageProvider::getInstance()->IsMoudleHasRights($paramRight);
	 	    if($rightModule_result->Success){
	 	    	$right_moduleList= $rightModule_result->DataList;
	 	    	if(count($right_moduleList) > 0){
                   ;
	 	    	}
	 	    	else
	 	    	{
	 	    		echo "please call manage :( ...";
					exit;
	 	    	}
	 	    }
	 	    else
	 	    {
	 	    	echo "please call manage...";
				exit;
	 	    }
	}
	else
	{
	$isHas = false;
	if(isset($_SESSION['AY_Module'])){
		$moduleSide = $_SESSION['AY_Module'];
		for($j = 0;$j < count($moduleSide);$j++)
		{
			if($url_this == MANAGER_PATH.$moduleSide[$j][2]){
				$isHas = true;
				break;
			}	
		}
	}
	if(!$isHas){
		echo "you has no rights...";
		exit;
	}
	}
?>