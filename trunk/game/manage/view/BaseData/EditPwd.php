<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMAccount/IsLogin.php');	
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>游戏服务器管理   游戏数据管理_</title>
<link href="../css/base.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../css/simple.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/BMClass.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/common.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/EditPwd.js"></script>
</head>

<body id="MainPage">
<form id="GroupManage" class="inBody">
<div class="mdName">
	<h2>修改密码</h2>
</div>
<div class="mdForm">
	<span class="iconEdit"></span>
    <table>
    	<tr><td colspan="2" >原密码&nbsp;&nbsp;&nbsp;：<input type="password" size="20" id="oldpwd" /></td></tr>
    	<tr><td colspan="2" >新密码&nbsp;&nbsp;&nbsp;：<input type="password" size="20" id="newpwd" /></td></tr>
    	<tr><td colspan="2" >确认密码：<input type="password"  size="20" id="reNewpwd" /></td></tr>
        <tr><td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button type="button" id="btnSave">提交</button>&nbsp;&nbsp;<button type="button" id="btnCancel" >重置</button></td></tr>
    </table>
</div>
</form>
</body>
</html>
