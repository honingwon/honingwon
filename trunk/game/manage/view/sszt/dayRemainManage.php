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
<script type="text/javascript" src="js/dayRemainManage.js"></script>

</head>

<body id="MainPage">
<!--  div class="mdName">
	<h2>留存统计</h2>
</div -->
<div  >
<div class="mdForm">
	<span class="iconSearch"></span>
    <table>
    	<tr><td colspan="2"><b>留存统计</b></td></tr>
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
        <tr><td colspan="2"><button type="button" id="btnSubmit">查询</button>  <button type="button" id="btnSubmit1">重置</button>
        </td></tr>
    </table>
    </div>
<table class="tabData">
    <thead>
    	<tr>
    		<th width="50">服名</th>
            <th width="80">时间</th>             
            <th width="50">新用户</th>
            <th width="50">次日留存</th>
            <th width="50">第三日留存</th>
            <th width="50">第四日留存</th>
            <th width="50">第五日留存</th>
            <th width="50">第六日留存</th>
            <th width="50">第七日留存</th>
            <th width="50">第八日留存</th>
            <th width="50">第十六日留存</th>
            <th width="40">操作</th>          
            <!--<th width="90">操作</th>-->
        </tr>
    </thead>
    <tbody id="List_Body">
    </tbody>
</table>
</div>
</body>
</html>
