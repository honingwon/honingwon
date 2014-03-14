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
		<script type="text/javascript" src="js/userinfoSearch.js"></script>
		<style type="text/css">
		.info{ position:absolute; min-width:50px; padding:5px; border:1px solid #999; background:#fff; font-size:12px; color:#333;}
		</style>
	</head>
	<body>
	<!-- div class="mdName">
	</div -->
	<div class="mdForm">
	<span class="iconSearch"></span>
    <form class="inBody">
   	 <table>
   		<tr>
        	<td width="90">查询类型：</td><td>
            <input type="radio" name="sType" checked='checked' value = "0" />角色&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" name="sType" value = "1" />帐号&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" name="sType" value = "2" />角色模糊查找
            </td>
        </tr>  
        <tr   >
        	<td width="100" id="nick_name_tr">角色名：</td>
        	<td width="100" id="user_name_tr">OPENID：</td>
        	<td> <input type="text" id="user_name" value="" size="50" ></input></td>
        </tr>
         
        <tr>
        	<td width="100">运营代理商：</td><td><select id="sArea" name="sArea"><option value="-1">loading...</option></select></td>
        </tr>
        <tr>
        	<td>服务器：</td>
            <td id="serverInfo">
            </td>
        </tr>   
        <tr><td colspan="2"><button type="button" id="btnSubmit">查询</button>
        </td></tr>
    </table>
	</form>
	</div>
	 <div class="mdForm" id="d1">
     <table>
        <tr> <td width="100">角色名：</td><td id="t1"></td> <td width="100">等级：</td><td id="t2"></td> </tr>
        <tr> <td width="100">总在线时间(S)：</td><td id="t3"></td> <td width="100">最后在线时间：</td><td id="t4"></td> </tr>
        <tr> <td width="100">注册时间：</td><td id="t5"></td> <td width="100">职业：</td><td id="t6"></td> </tr>
        <tr> <td width="100">充值Q点：</td><td id="t7"></td> <td width="100">VIP：</td><td id="t8"></td> </tr>
        <tr> <td width="100">元宝：</td><td id="t9"></td> <td width="100">绑定元宝：</td><td id="t10"></td> </tr>
        <tr> <td width="100">铜币：</td><td id="t11"></td> <td width="100">绑定铜币：</td><td id="t12"></td> </tr>
    </table>
    </div>
    <div class="mdForm" id="d2">
     <table class="tabData">
    <thead>
    	<tr>
    		<th width="50">ID</th>
    		<th width="50">角色名</th>
    		<th width="50">帐号</th>
            <th width="80">等级</th> 
            <th width="50">充值Q点</th>
            <th width="50">操作</th>
        </tr>
    </thead>
    <tbody id="List_Body">
    </tbody>
    </table>
    </div>
	</body>
</html>

