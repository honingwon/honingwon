<?php 
	include_once("../common.php");		
	require_once(DATACONTROL . '/BMAccount/IsLogin.php');
    require_once(DATACONTROL . '/BMAccount/IsRights.php');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><?php echo systemTitle;?></title>
<link href="<?php echo CSS_DIR;?>/base.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/common.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/calendar.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR?>/common/BMClass.js" ></script>
<script type="text/javascript" src="<?php echo JS_DIR?>/common/Pagination.js" ></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/ServerManager/serverRights.js"></script>
<script type="text/javascript" src="js/forbidLoginManage.js"></script>
</head>

<body id="MainPage">
<!--  div class="mdName">
	<h2>解封/封禁玩家登录</h2>
</div -->
<div class="mdForm">
	<span class="iconEdit"></span>
    <form class="inBody">
    <table class="multiple" id="banChatTable"> 
    	<tr>
        	<td width="90">操作类型：</td><td>
            <input type="radio" name="banChatType" checked='checked' value = "0" />禁登&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" name="banChatType" value = "1" />解禁
            </td>
        </tr>       
        <tr id="rowdate" >
        	<td>禁登截止时间：</td><td>
        	<input type="text" class="input" size="20" id="endTime" onclick="SelectDate(this,'yyyy-MM-dd')" value="<?php echo date('Y-m-d',strtotime('7 day'));?>" readonly="readonly" />&nbsp;&nbsp;<span style="color:#F00" >默认封号7天</span>
        	</td>
        </tr>
        <tr>
        	<td>玩家角色名：</td><td><input type="text" id="playerNickName" value=""></input></td>
        </tr>
        <tr>
        	<td width="90">运营代理商：</td><td><select id="sArea" name="sArea"><option value="-1">loading...</option></select></td>
        </tr>
        <tr>
        	<td>服务器：</td>
            <td id="serverInfo">
            </td>	
        </tr>
        <tr><td colspan="2" ><button type="button" id="btnSumbit">提交</button><div class="errorTip" id="msg" style="visibility:hidden" ></div></td></tr>
    </table>
    </form>
</div>


</body>
</html>
