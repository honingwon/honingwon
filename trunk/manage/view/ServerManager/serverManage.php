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
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/ServerManager/serverManage.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR?>/common/BMClass.js" ></script>
<script type="text/javascript" src="<?php echo JS_DIR?>/common/Pagination.js" ></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/common.js"></script>

<script type="text/javascript" language="javascript">
</script>
</head>

<body id="MainPage">
<form id="serverManage">
<div class="mdName">
	<h2>游戏服务器管理</h2>
</div>
<div class="tagSort">
	<a  href="javascript:void(0);" onclick="typeChange(1,this)" class="selected"><strong>游戏管理</strong></a>
    <a  href="javascript:void(0);" onclick="typeChange(2,this)" ><strong>分区维护</strong></a>
    <a  href="javascript:void(0);" onclick="typeChange(3,this)" ><strong>服务器维护</strong></a>
</div>

<!--==================================游戏管理==================================-->
<div id="gameDiv">
<div class="mdForm">
	<span class="iconEdit" id="gameIconEdit" ></span>
    <table id="addGame">
    	<tr><td colspan="2" class="tag" id="gameTile">添加新游戏</td></tr>
    	<tr><td width="420">游戏名称：<input type="text" id="gameName" class="input" size="20" /></td></tr>
        <tr><td colspan="2"><button type="button" id="btnAddGame" >提交</button><button type="button" id="btncanleGame" style="display:none" >取消</button></td></tr>
    </table>
</div>
<table class="tabData">
    <thead>
    	<tr>
        	<th width="250">游戏名称</th>            
            <th></th>
        </tr>
    </thead>
    <tbody id="gameBody">
    </tbody>
</table>
</div>

<!--=========================分区维护======================================--->
<div id="areaDiv" style="display:none">
<div class="mdForm">
	<span class="iconEdit" id="areaIconEdit" title="收起" onclick="onFold(this,'新增游戏分区');"></span>
    <table id="addArea">
    	<tr><td colspan="2" class="tag" id="areaTile" >新增游戏分区</td></tr>
    	<tr>
        	<td>游戏种类：</td><td colspan="3"><select id="AreaselectGame" style= "width:150px " onchange="AreaselGameChange();" ><option value="-1">请选择游戏种类</option></select></td>            
        </tr>
    	<tr>
        	<td width="85">分区名称：</td><td width="220"><input type="text" id="areaName" class="input" size="20" /></td>
            <td width="80">优先级：</td><td>
            <input type="text" id="areaPRI" class="input" size="20" />
            </td>
        </tr>
        <tr>
        	<td>简             介：</td><td colspan="3"><textarea id="areaDesc" cols="50" rows="3"></textarea></td>
        </tr>
        <tr><td></td><td colspan="3"><button type="button"  id="btnAddArea" >提交</button><button type="button"  id="btnCanelArea"  style="display:none" >取消</button></td></tr>
    </table> 
</div>
<table class="tabData">
    <thead>
    	<tr>
        	<th width="80">优先级号</th>
            <th width="100">游戏种类</th>
            <th width="200">分区名称</th>
            <th width="300">描述</th>
            <th></th>
        </tr>
    </thead>
    <tbody id="areaBody">
    </tbody>
</table>
</div>

<!--=================================服务器维护=====================================-->
<div id="serverDiv" style="display:none">
<div class="mdForm">
	<span class="iconSearch" ></span>
    <table>
    	<tr>
        	<td>
                <select onchange="serSelGameChange()" id="serSelGame" style= "width:150px " ><option value="-1">请选择游戏种类</option></select>
                <select id="serSelArea" style= "width:150px " ><option value="-1">请选择游戏分区</option></select>
            </td>
        </tr>
        <tr>
        	<td>
        		<button type="button" id="btnSerSearch">查询</button> 
                <input type="hidden" id="seach" />
        		<button type="button" id="btnSerAddServer" >添加新服务器</button>
            </td>
       </tr>
    </table>   
</div>
<table class="tabData">
    <thead>
    	<tr>
            <th width="100">游戏种类</th>
            <th width="120">游戏分区</th>
            <th width="230">服务器名</th>
            <th width="70">优先级号</th>
            <th >连接地址</th>            
            <th width="180" ></th>
        </tr>
    </thead>
    <tbody id="serverBody"> 
    </tbody>
</table>
<div class="pages" id="divPagination" ></div>
</div>


<div class="fwinly" id="editServer" style="left:50%; margin-left:-300px; top:113px;">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle">
            <strong><span id="serverDialogTitle">新增服务器</span></strong><a href="javascript:void(0);" id="btnCoseServerEdit" class="fclose">关闭</a></h3>
            <div class="formly" style="width:660px;">
            	<div class="error" id="serverError" style="display:none;"></div>
                <table>
                    <tr>
                        <td width="100">游戏种类：</td><td width="170">
                        	<select id="serEditSelGame" onchange="serEditSelGameChange();" style= "width:150px " ></select></td>
                        <td width="80">分区名称：</td><td>
                        	<select id="serEditSelSelect" style= "width:150px " ><option value="0">请选择游戏分区</option></select></td>
                    </tr>
                    <tr>
                        <td>服务器名：</td><td><input type="text" id="serverName" class="input" size="40" value="" /></td>
                        <td>优先级号：</td><td><input type="text" id="serverPRI" class="input" size="20" value="" /></td>
                    </tr>                    
                    <tr>
                        <td>socket IP：</td><td >
                       <input type="text"  id="socketIP" value="" size="40" />&nbsp;&nbsp;  </td>
                       <td>端&nbsp;&nbsp;&nbsp;&nbsp;口：</td><td><input type="text" id="socketPort" size="20" value="" />                       
                        </td>
                    </tr>
                    <tr>
                        <td width="60">服务端：</td><td colspan="3">I&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;P：<input type="text" id="serverIP" size="35" value="" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 用户名：<input type="text" id="serverUser" size="20" value="" />&nbsp;<br /><br />
                                                             数据库：<input type="text" id="serverDataName" size="35" value="" />&nbsp; &nbsp;&nbsp;&nbsp;
                         	 密&nbsp;&nbsp;码：<input type="text" id="serverPSW" size="20" value="" />                              
                        </td>
                    </tr>
                    <tr>
                        <td width="60">游戏Log：</td><td colspan="3">
                        I&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;P：<input type="text" id="logIP" size="35" value="" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 用户名：<input type="text" id="logUser" size="20" value="" />&nbsp;<br /><br />
                                                       数据库：<input type="text" id="logDataName" size="35" value=""/>  &nbsp; &nbsp;&nbsp;&nbsp;
                       	   密&nbsp;&nbsp;码：<input type="text" id="logPSW" size="20" value="" />                           
                        </td>
                    </tr>
                    <tr>
                        <td width="60">配置：</td><td colspan="3">
                        数据库端口：<input type="text" id="dataport" size="35" value="" />                           
                        </td>
                    </tr>
                    <tr>
                        <td>更新工具配置：</td><td colspan="3"><textarea id="shh" cols="80" rows="4" ></textarea></td>
                    </tr>
                    <tr>
                        <td>备注：</td><td colspan="3"><textarea id="serverRemark" cols="80" rows="4" ></textarea></td>
                    </tr>
                    <tr class="footer"><td></td><td colspan="3">
                    	<button id="btnSerSaveServer" type="button">提交</button>
                    	<button id="btnCancelAddServer" type="button" >取消</button>
                    </td></tr>
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
