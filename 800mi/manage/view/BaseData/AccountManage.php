<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMManage/IsLogin.php');
   require_once(DATACONTROL . '/BMManage/IsRights.php');
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
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/AccountManage.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/ModuleRights.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/ServerRights.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/AccountGroup.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/AutoCheckTree.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/BMClass.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/Pagination.js"></script>
</head>

<body id="MainPage">
<div class="mdName">
	<h2>账号维护</h2>
</div>
<!--部分JS仅显示方便使用，您真的可以忽视-->
<!--==================================帐号维护==================================-->
<div class="mdForm">
	<span class="iconEdit"></span>
    <form class="inBody">
    <table>
    	<tr><td width="220"><select id="selSearchType">
    	<option value="-1">全部</option>
    	<option value="1">账号</option>
        <option value="2">姓名</option>
    	</select><input type="text" class="input" size="20" id="txtSearchName" /> </td></tr>
        <tr><td><button type="button" id="btnSearch" >查找</button> - <button type="button" id="btnAddAccount" >添加新帐号</button> </td></tr>
    </table>
    </form>
</div>
<table class="tabData">
    <thead>
    	<tr>
        	<th width="150">帐号</th>
            <th width="150">姓名</th>
            <th width="150">类型</th>
            <th width="250">权限</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody id="List_Body">    	    	
    	<tr style="display:none">
        	<td>yaowan_gm3</td>
            <td>盛大起点</td>
            <td>供货商</td>
            <td class="tc_gray"><span class="tc_green">&radic;个人权限</span>、&times;服务器权限</td>
            <td class="operate"><a href="#" onclick="onOpen('perAccount');">设置个人权限</a><a href="#" onclick="onOpen('perServer');">设置服务器权限</a><a href="#" onclick="onOpen('accountEdit');">修改信息</a><a href="#">删除</a></td>
        </tr>
        <tr class="even" style="display:none">
        	<td>qidiangm01</td>
            <td>叶利平</td>
            <td>管理员</td>
            <td class="tc_gray"><span class="tc_green">&radic;个人权限</span>、<span class="tc_green">&radic;服务器权限</span></td>
            <td class="operate"><a href="#">设置个人权限</a><a href="#">设置服务器权限</a><a href="#">修改信息</a><a href="#">删除</a></td>
        </tr>
        <tr style="display:none">
        	<td colspan="4" class="tc_rad">未搜索到帐号信息</td>
        </tr> 
    </tbody>
</table>
<div class="pages" id="divPagination" ></div>
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
<div class="fwinly" style="left:50%; margin-left:-250px; top:113px;" id="perAccount">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle"><strong id="moduleTitle" >设置</strong><a href="#" class="fclose" id="BtnclosePerAccount">关闭</a></h3>
            <div class="perly" style="width:350px;">
            	<div class="noneBox fixed" style="height:320px;">
                	<div class="tree" id ="divAutoCheckTree" style="width:240px;height:300px;text-align:left; overflow:auto; padding:8px 10px;" noWrap="no"></div>
                </div>
                <table width="100%">
                	<tr>
                    	<td style="padding-left:10px;"></td>
                    	<td align="right"><button type="button" id="btnModuleSave">确定保存</button></td>
                    </tr>
                </table>
            	             
            </div>
        </td><td class="m_r"></td></tr>
        <tr><td class="b_l"></td><td class="b_c"></td><td class="b_r"></td>
        </tr>
    </table>
</div>
<div class="fwinly" style="left:50%; margin-left:-250px; top:113px;" id="perGroup"  >
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle"><strong id ="groupTitle">设置所在分组</strong><a href="#" class="fclose" id="BtnclosePerGroup" >关闭</a></h3>
            <div class="perly" style="width:350px;">            	
            	<div class="noneBox fixed" style="height:320px;">
                	<ul class="pureList" id="GroupList">
                    	<li><label><input type="checkbox" class="checkbox" />起点[双线一服]起点一区</label></li>
                    </ul>
                </div>
                <table width="100%">
                	<tr>
                    	<td style="padding-left:10px;"></td>
                    	<td align="right"><button type="button" id="btnGroupSave" >确定保存</button></td>
                    </tr>
                </table>
            	             
            </div>
        </td><td class="m_r"></td></tr>
        <tr><td class="b_l"></td><td class="b_c"></td><td class="b_r"></td>
        </tr>
    </table>
</div>
<div class="fwinly" style="left:50%; margin-left:-300px; top:113px;" id="accountEdit">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle"><strong id="accountEditTitle">修改帐号信息/添加新帐号</strong><a href="javascript:void(0);" id="BtncloseAccountEdit" class="fclose" >关闭</a></h3>
            <div class="formly" style="width:500px;">
            	<!--div class="error">输入有错误？！</div-->
                <table>
                    <tr>
                        <td width="80">*帐号：</td><td><input type="text" class="input" size="20" id="AccountID" onblur="checkAccount();"   /></td>
                        <td colspan="2">(新建帐号密码初始都为a00000)</td>
                    </tr>
                    <tr>
                        <td>*姓名：</td><td colspan="3"><input type="text" class="input" size="20" id="NickName" onblur="checkName();" /></td>
                    </tr>
                    <tr>
                        <td>*帐号类型：</td><td><select id="SelectAccountType" onblur="checkAccountType();" >
                        <option value="-1">--请选择帐号类别--</option>
                        <option value="1">管理员</option>
                        <option value="2" selected="selected">超市</option>
                        <option value="3" >经销商</option></select></td>
                        <td>*帐号等级：</td><td><select id="SelectAccountLevel" onblur="checkAccountLevel();" >
                        <option value="-1">--请选择帐号等级--</option>
                        <option value="1" selected="selected">普通</option>
                        <option value="2" >高级</option> </select></td>
                    </tr>
                    <tr>
                        <td>备注：</td><td colspan="3"><textarea cols="50" rows="4" id="ARemark" onblur="checkRemark();" ></textarea></td>
                    </tr>
                    <tr class="footer"><td></td><td colspan="3"><button type="button" id="btnAccountSave">保存</button><button type="button" id="btnResetPWD">密码初始化</button></td></tr>
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
