<?php 
	include_once("../common.php");
	 require_once(DATACONTROL . '/BMAccount/IsLogin.php');
	require_once(DATACONTROL . '/BMAccount/AccountProvider.php');
 	require_once(DATAMODEL . '/BMAccount/AccountMDL.php');	
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><?php echo systemTitle;?></title>
<link href="../css/base.css" rel="stylesheet" type="text/css" />
<base target="mainFrame" />
<script type="text/javascript" src="<?php echo JS_DIR?>/common/jquery.js" ></script>
<script type="text/javascript" language="javascript">
function selectMenu(obj){	
	$(".sideMenu a").removeClass();
	$(obj).addClass("selected");
}

</script>

</head>

<body id="SidePage">
	<div class="sideMenu">
<?php
 $result = AccountProvider::getInstance()->AccountIsEditPWD();
 if($result == 0){
 	
?>
		 <script type="text/javascript" language="javascript">
		 parent.frames["mainFrame"].location = "/view/BaseData/EditPwd.php";
		  </script>
<?php 
   return;
 }
 else
 {
 if(isset($_GET['p']))
 {
    $param = $_GET['p'] ; //一级菜单的ID参数
 }
 else
 {
 	if(!isset($_SESSION)){
    		session_start();
	}
 	if(isset($_SESSION['AY_Fmodule'])){
 		$moduleHead = $_SESSION['AY_Fmodule'];
 		if(count($moduleHead) > 0)
 			$param = $moduleHead[0][0];
 		else
 		  $param = "-1";
 	}
 	else
 		$param = "-2";
 }
 if($param >= 0)
 {
 	if(!isset($_SESSION)){
    		session_start();
	}
 	if(isset($_SESSION['AY_Module'])){
    	$moduleSide = $_SESSION['AY_Module'];
    	$sideStr = "";
		for($j = 0;$j < count($moduleSide);$j++)
		{
			if($param != $moduleSide[$j][3])
				continue;
				$name = $moduleSide[$j][1];
				if(isset($module_name[$moduleSide[$j][0]]))
					$name = $module_name[$moduleSide[$j][0]];
			if($sideStr == ""){
			    
			    $sideStr.= "<a onclick='selectMenu(this)' class='selected' href='".MANAGER_PATH.$moduleSide[$j][2].'?p='.$moduleSide[$j][0]."' >".$name."</a>";
			    	
			}
			else
				$sideStr.= "<a onclick='selectMenu(this)'  href='".MANAGER_PATH.$moduleSide[$j][2].'?p='.$moduleSide[$j][0]."' >".$name."</a>";	
		}
		echo $sideStr;
		?>
		 <script type="text/javascript" language="javascript">
		  if($(".sideMenu").find('a').length > 0)
			 parent.frames["mainFrame"].location =$(".sideMenu").find('a').eq(0).attr("href");
		  else
			 parent.frames["mainFrame"].location = "<?php echo MANAGER_PATH;?>/view/default/default.php";
		  </script>
		<?php 
    }
    else{
       echo "";
    }
 }
 else{
 	 echo "";
 }
 }
?>    
</div>   
</body>
</html>
