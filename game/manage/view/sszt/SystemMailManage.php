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
<script type="text/javascript" src="js/SystemMailManage.js"></script>

</head>

<body id="MainPage">
<!--  div class="mdName">
	<h2>系统邮件</h2>
</div -->
<div class="tagSort">
	<a href="javascript:void(0);" id="tab_uncheck" onclick="typeChange(0,this);" class="selected"><strong>系统邮件发送列表</strong></a>
	<a href="javascript:void(0);" id="tab_check" onclick="typeChange(1,this);"><strong>系统邮件发送</strong></a>
</div>
<div class="mdForm" id="editSystemMail">
	<span class="iconEdit"></span>
    <form class="inBody">
    <table class="multiple"> 
    	<tr>
        	<td>邮件类型：</td><td><input type="radio" name="systemMailType" checked='checked' value = "1" />指定玩家
        	&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="systemMailType" value = "2" />等级段玩家
        	&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="systemMailType" value = "3" />全服玩家</td>
        </tr>
        <tr id="roleLev">
        	<td>角色等级：</td><td>最小等级：<input type="text" id="systemMinLev" value=""></input>&nbsp;&nbsp;&nbsp;&nbsp;最大等级：<input type="text" id="systemMaxLev" value=""></input></td>
        </tr>
        <tr id="roleName">
        	<td>角色名：</td><td><textarea cols="80" rows="4" id="systemNickName" name="systemNickName"></textarea>&nbsp;&nbsp;&nbsp;<span style="color:#F00" >多角色以换行隔开</span></td>
        </tr>
         <tr><td>邮件标题：</td><td><input type="text" id="systemMailTitle" value="" size="80" ></input></td>
        </tr>
        <tr>
        	<td>邮件内容：</td><td><textarea cols="80" rows="10" id="systemMailDesc" name="systemMailDesc"></textarea></td>
        </tr>  

        <tr>
        	<td width="100">运营代理商：</td><td><select id="sArea" name="sArea"><option value="-1">loading...</option></select></td>
        </tr>
        <tr>
        	<td>服务器：</td>
            <td id="serverInfo">
            </td>
        </tr>
        <tr><td></td><td ><button type="button" id="btnSumbit">确认发送</button><div class="errorTip" id="msg" style="visibility:hidden" ></div></td></tr>
    </table>
    </form>
</div>

<div id="listSystemMail" >
<div class="mdForm">
	<span class="iconSearch"></span>
    <table>
        <tr>
        	<td width="100">开始时间：</td><td>
        	<input type="text" class="input" size="20" id="startTime" onclick="SelectDate(this,'yyyy-MM-dd hh:mm:ss')"  readonly="readonly" />
        	</td>
        </tr>
        <tr>
        	<td>结束时间：</td>
            <td >
            <input type="text" class="input" size="20" id="endTime" onclick="SelectDate(this,'yyyy-MM-dd hh:mm:ss')"  readonly="readonly" />
            </td>
        </tr>      
        <tr><td colspan="2"><button type="button" id="btnSearchSubmit">查询</button>
        </td></tr>
    </table>
    <div class="error" style="display:none;"></div>
    </div>
<table class="tabData">
    <thead>
    	<tr>
        	<th width="90">发送时间</th>
            <th width="80">发送人</th>
            <th width="150">邮件标题</th>
            <th width="80">状态</th>
            <th width="120">操作</th>           
            <!--<th width="90">操作</th>-->
        </tr>
    </thead>
    <tbody id="List_Body">
    </tbody>
</table>
<div class="pages" id="divPagination" ></div>
</div>
<div class="fwinly" id="systemMailInfo" style="display:none;left:50%; margin-left:-340px; top:20px;">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle">
            <strong><span id="serverDialogTitle">系统邮件信息查看</span></strong><a href="javascript:void(0);" id="btnCloseSystemMailInfo" class="fclose"><?php echo systemClose;?></a></h3>
            <div class="formly" style="width:600px;">
                <table>
                    <tr>
                        <td width="100">操作人员：</td><td width="170" id="s_Account"></td>
                        <td width="80">操作时间：</td><td id="s_CreatTime"></td>
                    </tr>
                    <tr>
                        <td>邮件标题：</td><td id="s_MailTitle"></td>
                        <td>&nbsp;</td><td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>邮件内容：</td><td colspan="3">
                        <div class="noneBox fixed" style="height:20px;width:480px;"  >
                		<ul class="pureList" id ="s_desc" ></ul></div></td>
                    </tr>
                    <tr>
                        <td>接收对象</td>
                        <td colspan="3" >
                        <div class="noneBox fixed" style="height:50px;width:480px;"  >
                		<ul class="pureList" id ="s_users">	</ul></div>
                        </td>
                    </tr>
                    <tr>                       
                        <td>游戏服：</td><td colspan="3" id="bm_ItemName" >
                        <div class="noneBox fixed" style="height:50px;width:480px;"  >
                		<ul class="pureList" id ="s_server">	</ul>
                		</div>
                        </td>
                    </tr>
                    <tr>                       
                        <td>操作日志：</td><td colspan="3" id="bm_ItemName" >
                        <div class="noneBox fixed" style="height:50px;width:480px;"  >
                		<ul class="pureList" id ="s_log">	</ul>
                		</div>
                        </td>
                    </tr>
                    <tr>
                        <td>当前状态：</td><td colspan="3">
                        <div class="noneBox fixed" style="height:50px;width:480px;"  >
                		<span style="color:#F00" ><ul class="pureList" id ="s_state">	</ul></span></div></td>
                    </tr>
                    
                    <tr class="footer"><td colspan="4" align="center" id="hu_result">操作日志与当前状态无内容表示一次性发送成功
                    </td></tr>
                    <tr>
                        <td colspan="4" id="errorMsg" style="color:#F00;"></td>
                    </tr>
                </table>             
            </div>
        </td><td class="m_r" ></td></tr>
        <tr><td class="b_l"></td><td class="b_c"></td><td class="b_r"></td>
        </tr>
    </table>
</div>
</body>
</html>
