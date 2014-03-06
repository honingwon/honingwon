<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMAccount/IsLogin.php');
   require_once(DATACONTROL . '/BMAccount/IsRights.php');	
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>游戏服务器管理 - 基础数据维护</title>
<link href="../css/base.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../css/simple.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/common.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/BMClass.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/table.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/CardItemManage.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/Pagination.js"></script>
</head>

<body id="MainPage">
<div class="mdName">
	<h2>道具维护</h2>
</div>
<div class="mdForm">
	<span class="iconSearch"></span>
    <form class="inBody">
    <table>
    	<tr><td width="220">游戏种类：<select id="selGame">
    	</select></td></tr>
    	<tr><td>道具名称：<input type="text" class="input" size="20" id="txtSearchName" /> </td></tr>
        <tr><td><button type="button" id="btnSearch" >查找</button> - <button type="button" id="btnAddGameItem" >添加新道具</button> </td></tr>
    </table>
    </form>
</div>
<table class="tabData">
    <thead>
    	<tr>
        	<th width="250">道具名称</th>
            <th width="150">道具性质</th>
            <th width="300">道具游戏ID</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody id="List_Body">    	    	
    </tbody>
</table>
<div class="pages" id="divPagination" ></div>
<div class="fwinly" style="left:50%; margin-left:-300px; top:113px;" id="ItemEdit">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle"><strong >道具信息修改</strong><a href="javascript:void(0);" id="BtncloseItemEdit" class="fclose" >关闭</a></h3>
            <div class="formly" style="width:500px;">
                <table>
                    <tr>
                        <td width="80" colspan="3">游戏种类：</td><td><select id="selGame1"></select></td>
                    </tr>
                    <tr>
                        <td>道具名称：</td><td colspan="3"><input type="text" class="input" size="20" id="itemName" /></td>
                    </tr>
                    <tr>
                        <td>道具游戏中的ID：</td><td colspan="3"><input type="text" class="input" size="20" id="GameitemName"  /></td>
                    </tr>
                    <tr>
                        <td colspan="3">道具是否有叠加：</td><td><select id="SelectItemRank"  >
                        <option value="99">有叠加</option>
                        <option value="1" selected="selected">无叠加</option></select></td>
                    </tr>
                    <tr>
                        <td>描述：</td><td colspan="3"><textarea cols="50" rows="4" id="ARemark"  ></textarea></td>
                    </tr>
                    <tr class="footer"><td></td><td colspan="3"><button type="button" id="btnItemSave">保存</button></td></tr>
                </table>                
            </div>
        </td>
        <td class="m_r"></td></tr>
        <tr><td class="b_l"></td><td class="b_c"></td><td class="b_r"></td>
        </tr>
    </table>
</div>
</body>
</html>