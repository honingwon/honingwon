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
		<script type="text/javascript" src="js/QPaySearch.js"></script>
		<style type="text/css">
		.info{ position:absolute; min-width:50px; padding:5px; border:1px solid #999; background:#fff; font-size:12px; color:#333;}
		</style>
	</head>
	<body>
	<!-- div class="mdName">
	<h2>当日充值记录</h2>
	</div -->
	<div class="mdForm">
	<span class="iconSearch"></span>
    <form class="inBody">
   	 <table>
   	 	
        <tr>
        	<td width="100">时间：</td><td>
        	<input id = "beginDate" onclick = "SelectDate(this,'yyyy-MM-dd')" style = "clear:both" readonly = "readonly" value="<?php echo date('Y-m-d');?>"/>
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
    		<th width="50">RMB</th>
    		<th width="50">Q点总值</th>
            <th width="80">元宝总值</th> 
            <th width="50">点卷总值</th>
        </tr>
    </thead>
    <tbody id="List_Body_Total">
    </tbody>
</table>
	<br/><br/><br/>
	<table class="tabData">
    <thead>
    	<tr>
    	<th width="50">帐号</th>
    		<th width="50">Q点</th>
            <th width="80">元宝</th> 
            <th width="50">点卷</th>
            <th width="50">时间</th>
        </tr>
    </thead>
    <tbody id="List_Body">
    </tbody>
</table>
<div class="pages" id="divPagination" ></div>
	</body>
</html>

