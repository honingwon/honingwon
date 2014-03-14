<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMAccount/IsLogin.php');	
   require_once(DATACONTROL . '/BMAccount/IsRights.php');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>游戏服务器管理 - 卡种类维护</title>
<link href="../css/base.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../css/simple.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/common.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/BMClass.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/CardQuery.js"></script>
</head>

<body id="MainPage">
<form id="cardType" class="inBody">
<div class="mdName">
	<h2> 卡查询</h2>
</div>
<div class="mdForm">
	<span class="iconSearch"></span>
    <table>
    	<tr><td colspan="2" >查询条件:<select id="seltype" >
                                <option value="0" >卡密</option>
                                <option value="1">卡号</option>
                            </select><input type="text" class="input" size="20" id="searchcardtext"  /></td></tr>
        <tr><td><button type="button" id="btnSearch" >查找</button></td></tr>
    </table>
</div>
<table class="tabData" style="display:none" id="card">
    <thead>
    	<tr>
        	<th colspan="4" id ="cardTypeName">卡信息</th>
        </tr>
    </thead>
    <tbody id="List_Body">    	    	
    	<tr >
        	<td width="150">卡号</td>
            <td id="cardNumber"></td>
            <td width="150">卡密</td>
            <td id="cardPassword"></td>
        </tr>
        <tr class="even" >
        	<td width="150">卡状态</td>
            <td id="cardState"></td>
            <td width="150">充值时间</td>
            <td id="cardChangeTime"></td>
        </tr>
        <tr >
        	<td width="150">批次号</td>
            <td id="groupNumber"></td>
            <td width="150">批次状态</td>
            <td id="groupState"></td>
        </tr>
        <tr class="even" >
        	<td width="150">有效开始时间</td>
            <td id="groupchangeTimeStart"></td>
            <td width="150">有效截止时间</td>
            <td id="groupchangeTimeEnd"></td>
        </tr>
    </tbody>
</table>
</form>
</body>
</html>
