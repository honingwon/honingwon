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
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/calendar.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/CardGroupManage.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/Pagination.js"></script>
</head>

<body id="MainPage">
<form id="cardType">
<div class="mdName">
	<h2> 道具卡批次维护</h2>
</div>
<div class="mdForm">
	<span class="iconSearch"></span>
    <table>
    	<tr><td colspan="2" >申请单名称：<input type="text" class="input" size="20" id="searchcardName"  /></td></tr>
        <tr><td><button type="button" id="btnSearch" >查找</button></td></tr>
    </table>
</div>
<table class="tabData">
    <thead>
    	<tr>
        	<th width="150">申请单名称</th>
        	<th width="100">单号</th>
            <th width="100">批号</th>
            <th width="120">申请人</th>
            <th width="120">审核人</th>
            <th width="120">提卡人</th>
            <th width="100">卡状态</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody id="List_Body">    	    	
    	<tr style="display:none">
        	<td>yaowan_gm3</td>
            <td>盛大起点</td>
            <td class="tc_gray"><span class="tc_green">&radic;个人权限</span>、&times;服务器权限</td>
            <td class="operate"><a href="#" onclick="onOpen('perAccount');">设置个人权限</a><a href="#" onclick="onOpen('perServer');">设置服务器权限</a><a href="#" onclick="onOpen('accountEdit');">修改信息</a><a href="#">删除</a></td>
        </tr>
        <tr class="even" style="display:none">
        	<td>qidiangm01</td>
            <td>叶利平</td>
            <td class="tc_gray"><span class="tc_green">&radic;个人权限</span>、<span class="tc_green">&radic;服务器权限</span></td>
            <td class="operate"><a href="#">设置个人权限</a><a href="#">设置服务器权限</a><a href="#">修改信息</a><a href="#">删除</a></td>
        </tr>
        <tr style="display:none">
        	<td colspan="4" class="tc_rad">未搜索到帐号信息</td>
        </tr> 
    </tbody>
</table>
<div class="pages" id="divPagination" ></div>

<div class="fwinly" style="left:50%; margin-left:-300px; top:113px;" id="divcardGrop">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle"><strong >卡批次信息维护</strong><a href="javascript:void(0);" id="BtnclosecardGrop" class="fclose" >关闭</a></h3>
            <div class="formly" style="width:400px;">
            	<!--div class="error">输入有错误？！</div-->
                <table>
                    <tr>
                        <td width="80">卡批次号:</td><td id="tdGroupID" ></td>
                    </tr>
                    <tr>
                        <td>道具卡种类:</td><td id="tdCardTypeName"></td>
                    </tr>
                    <tr>
                        <td>数量:</td><td  id="tdCardNumber"></td>
                    </tr>
                    <tr>
                        <td>申请人:</td><td id="tdApplyer"></td>
                    </tr>
                    <tr>
                        <td>审核人:</td><td id="tdChecker"></td>
                    </tr>
                    <tr>
                        <td>生成时间:</td><td id="tdCreateTime"></td>
                    </tr>
                    <tr>
                        <td>充值开始时间:</td><td><input id="txtDate1" onclick="SelectDate(this,'yyyy-MM-dd hh:mm')" style="clear:both" readonly="readonly" size ="25"  /></td>
                    </tr>
                    <tr>
                        <td>充值截止时间:</td><td><input id="txtDate2" onclick="SelectDate(this,'yyyy-MM-dd hh:mm')" style="clear:both" readonly="readonly"  size ="25" /></td>
                    </tr>
                    <tr>
                        <td>批次状态:</td><td><select id="selState"><option value="0" selected="selected">已生成</option><option value="1">启用</option>
                <option value="90">过期</option><option value="91">锁定</option><option value="92">作废</option></select></td>
                    </tr>
                    
                     <tr class="footer"><td></td><td ><button type="button" id="btnSave">保存</button></td></tr>
                </table> 
                                   
            </div>
        </td>
        <td class="m_r"></td></tr>
        <tr><td class="b_l"></td><td class="b_c"></td><td class="b_r"></td>
        </tr>
    </table>
</div>
<input type="hidden" id="indexValue" />
</form>
</body>
</html>
