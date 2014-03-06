<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMAccount/IsLogin.php');	
//   require_once(DATACONTROL . '/BMAccount/IsRights.php');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>游戏服务器管理    模块权限设置</title>
<link href="../css/base.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../css/simple.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/BMClass.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/common.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/table.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/ArrayList.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/CardAffixItemManage.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/Pagination.js"></script>
</head>

<body id="MainPage">
<div class="mdName">
	<h2>模块服务器权限设置，服务器继承账号服务器权限</h2>
</div>
<!--部分JS仅显示方便使用，您真的可以忽视-->
<table class="wrapCol3">
	<tr>
    <td class="it" width="28%">
        <table class="tabSelect" onmouseover="Change(this,1);">
            <thead><tr><th>当前受限制模块 <input type="text" class="input" size="12" id="txtTypeName"  /><button type="button" id="btnSearchCard" >筛选</button></th></tr></thead>
            <tbody id="List_Body" >    	    	
                <tr><td>光音VIP卡</td></tr>
                <tr class="selected"><td>起点幻龙战记新手卡</td></tr>
                <tr><td>酷狗幻龙战记新手卡</td></tr>               
            </tbody>
        </table>
    </td>
    <td class="it" width="42%">
   		<table class="tabSelect" id="itemTb">
            <thead><tr><th colspan="4">游戏种类：<select id="selGame" onchange="selGamechange();"><option value="-1" >选择游戏</option></select>&nbsp;道具名称 <input type="text" class="input" size="15" id="txtName" /><button type="button" id="btnSearchItem" >筛选</button></th></tr></thead>
            <tbody id ="List_Body2" >    	    	
                <tr><td width="50%"><label><input type="checkbox" class="checkbox" />铁十字破坏之盾</label></td><td>数量：<input type="text" class="input" value="1" size="5" /></td></tr>
                <tr><td><label><input type="checkbox" class="checkbox" />星光封印打造卷轴</label></td><td>数量： </td></tr> 
                <tr><td><label><input type="checkbox" class="checkbox" />骑士礼包（25级）</label></td><td>数量：</td></tr>
                <tr><td ><label><input type="checkbox" class="checkbox" />盲之纹章</label></td><td>数量： </td></tr>              
            </tbody>
            <tfoot>
            	<tr><td colspan="4" class="bar"><label><input type="checkbox" class="checkbox" id="selectAll0" onclick="selectAll(this);"  />全选</label> <button type="button" id="btnAddItem">添加</button></td></tr>
            	<tr><td colspan="2">
                <div class="pages" id="divPagination" ></div>
                </td></tr>
            </tfoot>
        </table>
        
    </td>
    <td class="it" width="30%">
    	<table class="tabSelect">
            <thead><tr><th colspan="4">道具所绑定</th></tr></thead>
            <tbody id="List_Body1">    	    	
                <!--  tr><td>新手卡礼包 数量：1  <a href="#">删除</a></td></tr>
                <tr><td>新手卡礼包 数量：1  <a href="#">删除</a></td></tr -->               
            </tbody>
            <tfoot id ="List_tfoot1">
            	<!--  tr><td colspan="2" class="bar"><button type="button">保存</button><button type="button">重置</button></td></tr-->
            </tfoot>
        </table>
    </td>
    </tr>
</table>
</body>
</html>
