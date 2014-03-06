<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMAccount/IsLogin.php');
   require_once(DATACONTROL . '/BMAccount/IsRights.php');	
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>游戏服务器管理  游戏数据管理_</title>
<link href="../css/base.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../css/simple.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/BMClass.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/table.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/GroupManage.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/GroupRights.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/AutoCheckTree.js"></script>
</head>

<body id="MainPage">
<form id="GroupManage" class="inBody">
<div class="mdName">
	<h2>分组维护</h2>
</div>
<div class="mdForm">
	<span class="iconEdit"></span>
    <table>
    	<tr><td colspan="2" class="tag">添加分组</td></tr>
    	<tr><td colspan="2" >名   称：<input type="text" class="input" size="20" id="name" onblur="checkName()"  /></td></tr>
    	<tr><td colspan="2" >描   述：<textarea rows="4" id="dec" cols="38" onblur="checkRemark()" ></textarea></td></tr>
        <tr><td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button type="button" id="btnSave">提交</button>&nbsp;&nbsp;<button type="button" id="btnCancel" >取消</button></td></tr>
    </table>
</div>
<table class="tabData">
    <thead>
    	<tr>
    	    <th width="60" >ID</th>
        	<th width="150">分组名称</th>
            <th width="600">分组说明</th>
            <th></th>
        </tr>
    </thead>
    <tbody id="List_Body">    	    	
    	<tr style="visibility:hidden">
    	    <td>1</td>
        	<td>幻龙战记</td>
            <td><a href="http://web.4399.com/hlzj/" target="_blank">http://web.4399.com/hlzj/</a></td>
            <td class="operate"><a href="#">修改</a><a href="#">删除</a></td>
        </tr>
        <tr class="even" style="visibility:hidden">
            <td>2</td>
        	<td>水晶之忍</td>
            <td><a href="http://web.4399.com/hlzj/" target="_blank">http://web.4399.com/hlzj/</a></td>
            <td class="operate"><a href="#">修改</a><a href="#">删除</a></td>
        </tr>
        <tr style="visibility:hidden">
        	<td colspan="4" class="tc_gray">未添加分组</td>
        </tr> 
    </tbody>
</table>

<div class="pages" style="visibility:hidden">
	<span>共2页/19条</span>
	<a href="#" class="prev">上一页</a>
    <strong>1</strong>
    <a href="#">2</a>
    <a href="#" class="next">下一页</a>
</div>
<div class="fwinly" style="left:50%; margin-left:-250px; top:113px;" id="perGModule">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle"><strong id="GroupModuleTitle" >设置个人权限</strong><a href="#" class="fclose" id="BtncloseGModule">关闭</a></h3>
            <div class="perly" style="width:350px;">
            	<div class="noneBox fixed" style="height:320px;">
                	<div class="tree" id ="divAutoCheckTree" style="width:240px;height:300px;text-align:left; overflow:auto; padding:8px 10px;" noWrap="no"></div>
                </div>
                <table width="100%">
                	<tr>
                    	<td style="padding-left:10px;"></td>
                    	<td align="right"><button type="button" id="btnGroupModuleSave">确定保存</button></td>
                    </tr>
                </table>
            	             
            </div>
        </td><td class="m_r"></td></tr>
        <tr><td class="b_l"></td><td class="b_c"></td><td class="b_r"></td>
        </tr>
    </table>
</div>
</form>
</body>
</html>
