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
		<script type="text/javascript" src="js/shopSellManage.js"></script>
		<style type="text/css">
		.info{ position:absolute; min-width:50px; padding:5px; border:1px solid #999; background:#fff; font-size:12px; color:#333;}
		</style>
	</head>
	<body>
	<!-- div class="mdName">
	<h2>商城出售统计</h2>
	</div -->
	<div class="mdForm">
	<span class="iconSearch"></span>
    <form class="inBody">
   	 <table>
   	 	<tr>
        	<td width="90">商城类型：</td><td>
            <input type="radio" name="shopType" checked='checked' value = "1" />游戏商城&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" name="shopType" value = "2" />神秘商城&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" name="shopType" value = "3" />副本商店&nbsp;&nbsp;&nbsp;&nbsp; 
            <input type="radio" name="shopType" value = "4" />优惠商品&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" name="shopType" value = "5" />类型统计
            </td>
        </tr> 	
        <tr>
        	<td width="100">时间：</td><td>
        	<input id = "beginDate" onclick = "SelectDate(this,'yyyy-MM-dd')" style = "clear:both" readonly = "readonly" value="<?php echo date('Y-m-d',strtotime('-7 day'));?>"/>
		~ <input id = "endDate" onclick = "SelectDate(this,'yyyy-MM-dd')" style = "clear:both" readonly = "readonly" value="<?php echo date('Y-m-d');?>"/>
        	</td>
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
	<table class="tabData">
    <thead>
    	<tr>
    		<th width="50">物品ID</th>
            <th width="80">物品名称</th> 
            <th width="50">购买数量</th>
            <th width="50">购买人数</th>
            <th width="50">购买次数</th>
            <th width="50">总银两</th>
            <th width="50">总绑定银两</th>
        </tr>
    </thead>
    <tbody id="List_Body">
    </tbody>
</table>
	</body>
</html>

