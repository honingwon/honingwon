<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMAccount/IsLogin.php');
   echo '<SCRIPT>var header_en = "'.MANAGER_PATH.'"</SCRIPT>';	
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><?php echo systemTitle;?></title>
<link href="../css/base.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.js"></script>
<script>
   function btnOut()
   {
	   if (!confirm("<?php echo loginconfirm;?>"))
	        return;
       top.location="LoginOut.php";;
   }

	 function change(ob)
	 {
		 $("#Navigate").find('a').removeClass();
		 $(ob).addClass("selected");
//		 parent.frames["mainFrame"].location = "../test.php";
	 }

	 function test(obj)
		{
			var a = document.getElementById('select').value;
			top.location= header_en +"/language/Language.php?en="+a;
		}

</script>
</head>

<body id="HeaderPage">
	<div id="sysLogo">
	</div>
    <div id="Navigate">
    	<!--  a href="side.php?p=1" target="leftFrame" class="selected" onclick="change(this);"  ><strong>充值与消费</strong></a><i>|</i>
        <a href="side.php?p=2" target="leftFrame" onclick="change(this);"  ><strong>在线注册</strong></a><i>|</i>
        <a href="side.php?p=3" target="leftFrame" onclick="change(this);"  ><strong>玩家管理</strong></a><i>|</i>
        <a href="side.php?p=4" target="leftFrame" onclick="change(this);"  ><strong>数据分析</strong></a><i>|</i>
        <a href="side.php?p=5" target="leftFrame" onclick="change(this);"  ><strong>其它</strong></a -->
<?php
	 $continue = true;   //=false没有任何权限
if(!isset($_SESSION)){
    		session_start();
		}
	 if(!isset($_SESSION['AY_Fmodule'])) {
	 	echo "<a href='javascript:void(0);' target='leftFrame' class='selected'  ><strong>无权限</strong></a>";
	} 
	else
	{
		$objectList = $_SESSION['AY_Fmodule'];
		$javascriptStr = "";
		for($i = 0;$i < count($objectList);$i++)
		{
			$moduleObj = $objectList[$i];
			if($javascriptStr != ""){
				$javascriptStr.="<i>|</i>";
			    $javascriptStr.="<a href='side.php?p=".$moduleObj[0]."' target='leftFrame'  onclick='change(this);'  ><strong>".$moduleObj[1]."</strong></a>";
			}
			else
				$javascriptStr.="<a href='side.php?p=".$moduleObj[0]."' target='leftFrame' class='selected'  onclick='change(this);'  ><strong>".$moduleObj[1]."</strong></a>";
		}
		echo $javascriptStr;
	}
?>
    </div>
    <div class="userLine">
     <!-- select size="1" id="select" name="select" onchange="test(this);">
    					<option value="-1">Language</option>
                        <option value="1">China</option>
                        <option value="2">Japan</option>
      </select -->
    	<?php echo systemwelcome;?>，<strong>
    	<?php
    	if(isset($_SESSION['user'])) {
    		$userName = $_SESSION['user'];
    		echo $userName;
    	}
    	?>
    	</strong> [<a href="<?php echo MANAGER_PATH;?>/view/BaseData/EditPwd.php" target="mainFrame" ><?php echo systemEditPWD;?></a>]&nbsp;&nbsp;&nbsp;&nbsp;[<a href="javascript:btnOut();" ><?php echo loginOut;?></a>]
    </div>	
</body>
</html>
