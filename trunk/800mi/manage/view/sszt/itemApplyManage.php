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
<script type="text/javascript" src="<?php echo JS_LANGUAGE;?>"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/common.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/calendar.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR?>/common/BMClass.js" ></script>
<script type="text/javascript" src="<?php echo JS_DIR?>/common/Pagination.js" ></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/ServerManager/serverRights.js"></script>
<script type="text/javascript" src="js/itemApplyManage.js"></script>

</head>

<body id="MainPage">
<!--  div class="mdName">
	<h2>道具申请</h2>
</div -->
<div class="mdForm">
	<span class="iconEdit"></span>
    <form class="inBody">
    <table class="multiple"> 
    	<tr>
        	<td>发放标题：</td><td><input type="text" id="appItemTitle" value=""></input>&nbsp;&nbsp;&nbsp;<span style="color:#F00" >40个字符之内</span></td>
        </tr>
        <tr>
        	<td>发放说明：</td><td><textarea cols="80" rows="4" id="appItemDesc" name="appItemDesc"></textarea>&nbsp;&nbsp;&nbsp;<span style="color:#F00" >400个字符之内</span></td>
        </tr>  
        <tr>
        	<td>申请原因：</td><td><textarea cols="80" rows="4" id="appRemark" name="appRemark"></textarea></td>
        </tr> 
        <tr>
        	<td>发放对象：</td>
        	<td><input type="radio" name="appPlayerType" checked='checked' value = "0" />角色名</td>
        </tr>
        <tr>
        	<td>角色名：</td><td><textarea cols="80" rows="4" id="appPlayerInfo" name="appPlayerInfo"></textarea>&nbsp;&nbsp;&nbsp;<span style="color:#F00" >多账号以换行隔开</span></td>
        </tr>
      <!--  <tr>
        	<td>角色等级：</td><td>大于等于：<input type="text" id="appRoleLevup" value=""></input>&nbsp;&nbsp;&nbsp;&nbsp;小于等于：<input type="text" id="appRoleLevlow" value=""></input></td>
        </tr>
        <tr>
        	<td>最后登录：</td><td>起始时间：<input type="text" class="input" size="20" id="startTime" onclick="SelectDate(this,'yyyy-MM-dd hh:mm:ss')"  readonly="readonly" />&nbsp;&nbsp;&nbsp;&nbsp;
        	结束时间：<input type="text" class="input" size="20" id="endTime" onclick="SelectDate(this,'yyyy-MM-dd hh:mm:ss')"  readonly="readonly" /></td>
        </tr> -->
        <tr>
        	<td>货币信息：</td><td>
        	元宝：<input type="text" id="moneyGold" value=""></input>
        	绑定元宝：<input type="text" id="moneyLJ" value=""></input>
        	铜钱：<input type="text" id="moneyTQ" value=""></input>
        	绑定铜钱：<input type="text" id="moneyTQ1" value=""></input></td>
        </tr>
        <tr>
        	<td>道具信息：</td><td>
        			<div class="noneBox fixed" style="height:100px;width:400px;"  >
                	<ul class="pureList" id ="app_AllItemInfo">	
                    </ul>
                </div><button type="button" id="btnAddItemApp">添加发放道具</button></td>
        </tr>
        <tr>
        	<td width="100">运营代理商：</td><td><select id="sArea" name="sArea"><option value="-1">loading...</option></select></td>
        </tr>
        <tr>
        	<td>服务器：</td>
            <td id="serverInfo">
            </td>
        </tr>
        <tr><td></td><td ><button type="button" id="btnSumbitApply">确认申请</button><div class="errorTip" id="msg" style="visibility:hidden" ></div></td></tr>
    </table>
    </form>
    
    <div class="fwinly" style="left:50%; margin-left:-340px; top:300px;" id="appItemChooseDiv">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle"><strong id="accountEditTitle">发放的道具信息</strong><a href="javascript:void(0);" id="BtncloseItemChoose" class="fclose" >关闭</a></h3>
            <div class="formly" style="width:400px;">
                <table>
                    <tr>
                        <td>是否绑定:</td><td ><input type="radio" name="isBind" checked='checked' value = "0" />非绑定&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="isBind" value = "1" />绑定</td>
                    </tr>
                     <tr>
                        <td width="80">道具ID:</td><td><input type="text" id="itemID" value="" maxlength="8"></input></td>
                    </tr>
                    <tr>
                        <td>数量:</td><td ><input type="text" id="itemNum" value="" maxlength="4"></input></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td><td>&nbsp;&nbsp;&nbsp;&nbsp;<button type="button" id="btnAddItem" >&nbsp;&nbsp;&nbsp;&nbsp;添加&nbsp;&nbsp;&nbsp;&nbsp;</button> <span style="color:#F00"  id="item_msg"></span></td>
                    </tr>
                </table>                
            </div>
        </td>
        <td class="m_r"></td></tr>
        <tr><td class="b_l"></td><td class="b_c"></td><td class="b_r"></td>
        </tr>
    </table>
</div>
</div>


</body>
</html>
