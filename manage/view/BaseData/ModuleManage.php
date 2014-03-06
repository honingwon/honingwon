<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMAccount/IsLogin.php');
   //require_once(DATACONTROL . '/BMAccount/IsRights.php');	
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>游戏服务器管理  游戏数据管理_</title>
<link href="../css/base.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/ModuleManage.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/AutoTree.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/ModuleServerRights.js"></script>
</head>
<body id="MainPage">
<form id="ModuleManage" >
<div class="mdName">
	<h2>功能模块维护</h2>
</div>
<div class="mdForm">
<table width ="100%" border="0" cellpadding="0" cellspacing="4" >
  <tr>
  	<td width="12%" valign="top" id="depTree1" class="depTree">
   			<div class="tree" id ="divAutoTree" style="width:240px;height:560px;text-align:left; overflow:auto; padding:8px 10px;" noWrap="no"></div>

    </td>
    <td valign="top">
		<div class="funBTList">    
		    <!--  a href="javascript:void(0);" class="ser" onclick="DoServerRight();"  id="ser"  >服务器限制</a -->  	
            <a href="javascript:void(0);" class="edit" onclick="EditData();" id="edit" >编辑</a>
            <a href="javascript:void(0);" class="add" onclick="AddData();"  id="add"  >新增</a>
            <a href="javascript:void(0);" class="del" onclick="DelData();"  id="del"  >删除</a>
            <a href="javascript:void(0);" class="save" onclick="SaveData();"   id="save"  style="display:none;">保存</a>
        </div>
        <div class="mdForm">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabStyleForm" id ="ShowModuleManageTable" >
          <tr class="lightBC">
            <td width="20%">模块名称</td>
            <td id ="SModuleName">&nbsp;</td>
          </tr>
          <tr>
            <td>上级模块名称</td>
            <td id="SModuleFName">&nbsp;</td>
          </tr>
          <tr>
            <td>模块等级</td>
            <td id="SModuleLevel">&nbsp;</td>
          </tr>
          <tr class="lightBC">
            <td>链接地址(新)</td>
            <td id="newSModuleLinkPath">&nbsp;</td>
          </tr>
          <tr class="lightBC">
            <td>链接地址(旧)</td>
            <td id="SModuleLinkPath">&nbsp;</td>
          </tr>
          <tr class="lightBC">
            <td>模块优先级</td>
            <td id="SModuleHander">&nbsp;</td>
          </tr>
          <tr>
            <td>模块状态</td>
            <td id="SModuleState">&nbsp;</td>
          </tr>
          <tr class="lightBC">
            <td>模块描述</td>
            <td id="SModuleRemark">&nbsp;</td>
          </tr>
      </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabStyleForm" id="EditModuleManageTable" style="display:none;">
          <tr class="lightBC">
            <td width="20%">模块名称</td>
            <td><input name="username" type="text" class="txt" id ="EModuleName"   style="width: 139px" tabindex ="1" onkeypress="return event.keyCode!=124&&event.keyCode!=44;"/></td>
            <td class="hint"></td>
          </tr>
          <tr>
          <td width="20%">上级模块名称</td>
          <td id ="EModuleFName" ></td>
          <td class="hint"></td>
          </tr>
          <tr>
         <td width="20%">模块等级</td>
         <td>
          <select name="EModuleLevel"  id="EModuleLevel" style ="width :151;align:absmiddle">
				                    <option value="0"  selected="selected"> 总模块</option>
				                    <option value="1" >分模块</option>
				                    </select></td>
				                    <td class="hint"></td>
          </tr>
          <tr class="lightBC">
              <td width="20%">链接地址(新)</td>
              <td><input name="username" type="text" class="txt" id ="newEModuleLinkPath" style="width: 139px" tabindex ="1"/></td>
              <td class="hint"></td>
          </tr>
          <tr class="lightBC">
          <td width="20%">链接地址(旧)</td>
          <td><input name="username" type="text" class="txt" id ="EModuleLinkPath"  style="width: 139px" tabindex ="1"/></td>
          <td class="hint"></td>
          </tr>

          <tr class="lightBC">
          <td width="20%">模块优先级</td>
          <td><input name="username" type="text" class="txt" id ="EModuleHander"  style="width: 139px" tabindex ="1"/></td>
          <td class="hint"></td>
          </tr>
          <tr>
           <td width="20%">模块状态</td>
           <td>
           <select name="EModuleState" id="EModuleState" style ="width :151;align:absmiddle;">
				                    <option value="0"  selected="selected"> 普通显示</option>
				                    <option value="1" >权限显示</option>
				                    <option value="2" >隐藏</option>
				                    <option value="3" >特殊服务器权限</option>
				                    </select>
           </td>
           </tr>
            <tr class="lightBC">
            <td width="20%" style="height: 210px">模块描述</td>
             <td style="height: 210px"><textarea id="EModuleRemark" class="textbox" style="width: 392px; height: 200px;font-family:宋体;vertical-align:middle"  tabindex="2"></textarea></td>
            <td class="hint"></td>
            </tr>
           </table>
           </div>
    </td>
  </tr>
</table>
</div>
<div class="fwinly" style="left:50%; margin-left:-250px; top:113px;" id="perServer"  >
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle"><strong id ="servTitle">设置服务器权限</strong><a href="#" class="fclose" id="BtnclosePerServer" >关闭</a></h3>
            <div class="perly" style="width:350px;">            	
                <div class="perHead">游戏：<select id="selGame" onchange="selGameChange();" ></select> &nbsp;&nbsp;分区：<select id="selArea" onchange="selAreaChange();" ></select></div>
            	<div class="noneBox fixed" style="height:320px;">
                	<ul class="pureList" id="serverList">
                    	<li><label><input type="checkbox" class="checkbox" />起点[双线一服]起点一区</label></li>
                    </ul>
                </div>
                <table width="100%">
                	<tr>
                    	<td style="padding-left:10px;"><label><input type="checkbox" class="checkbox" id="serAllCheck" name="allservCheck" />全选</label></td>
                    	<td align="right"><button type="button" id="btnServSave" >确定保存</button></td>
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