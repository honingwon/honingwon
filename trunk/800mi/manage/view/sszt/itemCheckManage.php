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
<script type="text/javascript" src="js/itemCheckManage.js"></script>

</head>

<body id="MainPage">
<!-- div class="mdName">
	<h2>道具发放审核界面</h2>
</div -->
<div class="tagSort">
	<a href="javascript:void(0);" id="tab_uncheck" onclick="typeChange(0,this);" class="selected"><strong>待审核发放道具申请</strong></a>
	<a href="javascript:void(0);" id="tab_check" onclick="typeChange(1,this);"><strong>已审核发放道具申请</strong></a>
</div>
<div id="announce_search">
<div class="mdForm">
	<span class="iconSearch"></span>
    <form class="inBody">
    <table>
        <tr>
        	<td width="100">运营代理商：</td><td><select id="sArea" name="sArea"><option value="-1">loading...</option></select></td>
        </tr>
        <tr>
        	<td>服务器：</td>
            <td id="serverInfo">
            </td>
        </tr>      
        <tr><td colspan="2"><button type="button" id="btnSubmit">查询</button>
        </td></tr>
    </table>
    <div class="error" style="display:none;"></div>
    </form>
</div>
<table class="tabData">
    <thead>
    	<tr>
        	<th width="90">服名称</th>
            <th width="80">申请时间</th>
            <th width="80">申请人</th>
            <th width="120">申请标题</th>
            <th width="120">申请原因</th>           
            <th width="90">操作</th>
            <!--<th width="90">操作</th>-->
        </tr>
    </thead>
    <tbody id="List_Body">
    </tbody>
</table>
<div class="pages" id="divPagination" ></div>
</div>

<!-- 查看详情 style="color:#F06"-->
<div class="fwinly" id="itemApplyInfo" style="display:none;left:50%; margin-left:-340px; top:20px;">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle">
            <strong><span id="serverDialogTitle">发放道具审核详情查看</span></strong><a href="javascript:void(0);" id="btnCloseItemApplyInfo" class="fclose"><?php echo systemClose;?></a></h3>
            <div class="formly" style="width:600px;">
                <table>
                    <tr>
                        <td width="100">申请人：</td><td width="170" id="u_Account"></td>
                        <td width="80">申请时间：</td><td id="u_CreatTime"></td>
                    </tr>
                    <tr>
                        <td>游戏服名称：</td><td id="u_ServerName"></td>
                        <td>&nbsp;</td><td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>发放标题：</td><td colspan="3" id="u_title"></td> 
                    </tr>
                    <tr>
                        <td>发放说明：</td><td colspan="3">
                        <div class="noneBox fixed" style="height:20px;width:480px;"  >
                		<ul class="pureList" id ="u_desc" ></ul></div></td>
                    </tr>
                    <tr>
                        <td>申请说明：</td><td colspan="3">
                        <div class="noneBox fixed" style="height:20px;width:480px;"  >
                		<ul class="pureList" id ="u_remark">	</ul></div></td>
                    </tr>
                    <tr>
                        <td>发放对象</td>
                        <td colspan="3" >
                        <div class="noneBox fixed" style="height:50px;width:480px;"  >
                		<ul class="pureList" id ="u_users">	</ul></div>
                        </td>
                    </tr>
                    <tr>                       
                        <td>道具信息：</td><td colspan="3" id="bm_ItemName" >
                        <div class="noneBox fixed" style="height:50px;width:480px;"  >
                		<ul class="pureList" id ="u_items">	</ul>
                		</div>
                        </td>
                    </tr>
                    <tr>
                        <td>审核说明：</td><td colspan="3"><textarea id="u_CheckRemark" cols="80" rows="2"></textarea></td>
                    </tr>
                    
                    <tr class="footer"><td colspan="4" align="center">
                    	<button type="button"  id="btnpass">通过</button>&nbsp; &nbsp; 
                        <button type="button"  id="btnunpass">不通过</button>
                        <input type="hidden" id="checkApplyID" value="" />
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
<div class="fwinly" id="itemApplyInfoHasCheck" style="display:none;left:50%; margin-left:-340px; top:20px;">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle">
            <strong><span id="serverDialogTitle">道具发放审核单查看</span></strong><a href="javascript:void(0);" id="btnCloseHItemApplyInfo" class="fclose"><?php echo systemClose;?></a></h3>
            <div class="formly" style="width:600px;">
                <table>
                    <tr>
                        <td width="100">申请人：</td><td width="170" id="hu_Account"></td>
                        <td width="80">申请时间：</td><td id="hu_CreatTime"></td>
                    </tr>
                    <tr>
                        <td>游戏服名称：</td><td id="hu_ServerName"></td>
                        <td>&nbsp;</td><td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>发放标题：</td><td colspan="3" id="u_title"></td> 
                    </tr>
                    <tr>
                        <td>发放说明：</td><td colspan="3">
                        <div class="noneBox fixed" style="height:20px;width:480px;"  >
                		<ul class="pureList" id ="hu_desc" ></ul></div></td>
                    </tr>
                    <tr>
                        <td>申请说明：</td><td colspan="3">
                        <div class="noneBox fixed" style="height:20px;width:480px;"  >
                		<ul class="pureList" id ="hu_remark">	</ul></div></td>
                    </tr>
                    <tr>
                        <td>发放对象</td>
                        <td colspan="3" >
                        <div class="noneBox fixed" style="height:50px;width:480px;"  >
                		<ul class="pureList" id ="hu_users">	</ul></div>
                        </td>
                    </tr>
                    <tr>                       
                        <td>道具信息：</td><td colspan="3" id="bm_ItemName" >
                        <div class="noneBox fixed" style="height:50px;width:480px;"  >
                		<ul class="pureList" id ="hu_items">	</ul>
                		</div>
                        </td>
                    </tr>
                    <tr>
                        <td>审核说明：</td><td colspan="3">
                        <div class="noneBox fixed" style="height:50px;width:480px;"  >
                		<ul class="pureList" id ="hu_CheckRemark">	</ul></div></td>
                    </tr>
                    
                    <tr class="footer"><td colspan="4" align="center" id="hu_result">
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
