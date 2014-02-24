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
		<script type="text/javascript" src="js/PlayerItemLogManage.js"></script>
		<style type="text/css">
		.info{ position:absolute; min-width:50px; padding:5px; border:1px solid #999; background:#fff; font-size:12px; color:#333;}
		</style>
	</head>
	<body>
	<!-- div class="mdName">
	<h2>玩家物品操作日志</h2>
	</div -->
	<div class="mdForm">
	<span class="iconSearch"></span>
    <form class="inBody">
   	 <table>
   	 	<tr>
        	<td>玩家角色名：</td><td><input type="text" id="playerNickName" value=""></input></td>
        </tr> 	
        <tr>
        	<td>物品编号类型：</td>
        	<td>
        	<input type="radio" name="IDType" checked='checked' value = "1" />物品模板编号 &nbsp;&nbsp;&nbsp;&nbsp;
        	<input type="radio" name="IDType" value = "2" />物品唯一编号
        	</td>
        </tr> 
        <tr id="templateType">
        	<td>物品模板编号</td><td>        	
        	<input type="text" id="templateID" value=""></input></td>
        </tr>
         <tr id="itemType">
        	<td>物品唯一编号</td><td>        	
        	<input type="text" id="itemID" value=""></input></td>
        </tr>
        <tr>
        	<td width="90">物品操作类型：</td><td>
        	<input type="radio" name="itemOpType" checked='checked' value = "" />无限制 &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" name="itemOpType" value = "5" />物品出售 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "6" />物品丢弃 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "7" />物品喂养 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "8" />物品使用 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "9" />强化 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "10" />镶嵌 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "11" />合成 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "12" />分解 &nbsp;&nbsp;&nbsp;&nbsp;
		</td></tr><tr><td/>
			<td>			
			<input type="radio" name="itemOpType" value = "13" />融合 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "14" />洗炼 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "15" />PK掉落 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "16" />升级品阶 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "17" />任务扣除 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "18" />移动覆盖 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "19" />整理消失 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "20" />回收 &nbsp;&nbsp;&nbsp;&nbsp;
			<input type="radio" name="itemOpType" value = "21" />邮件
        	</td>
        </tr> 
        <tr>
        	<td width="100">时间：</td><td>
        	<input type ="checkbox" id = "DateCheck" >不限日期</input>
        	<input id = "beginDate" onclick = "SelectDate(this,'yyyy-MM-dd')" style = "clear:both" readonly = "readonly" value="<?php echo date('Y-m-d',strtotime('-6 day'));?>"/>
		~ <input id = "endDate" onclick = "SelectDate(this,'yyyy-MM-dd')" style = "clear:both" readonly = "readonly" value="<?php echo date('Y-m-d',strtotime('+1 day'));?>"/>
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
    		<th width="30">物品模板编号</th>
    		<th width="30">物品唯一编号</th>
            <th width="50">物品名称</th> 
            <th width="30">物品操作类型</th>
            <th width="30">物品数量</th>
            <th width="30">使用数量</th>
            <th width="50">时间</th>
        </tr>
    </thead>
    <tbody id="List_Body">
    </tbody>
</table>
	</body>
</html>

