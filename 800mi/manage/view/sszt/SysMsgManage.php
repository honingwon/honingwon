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
<script type="text/javascript" src="js/SysMsgManage.js"></script>

</head>

<body id="MainPage">
<!--  div class="mdName">
	<h2>公告器管理</h2>
</div -->
<div class="tagSort">
	<a href="javascript:void(0);" id="tab_uncheck" onclick="typeChange(0,this);" class="selected"><strong>发布公告</strong></a>
	<a href="javascript:void(0);" id="tab_check" onclick="typeChange(1,this);"><strong>公告列表</strong></a>
</div>
<div class="mdForm" id="editAnnouncemment">
	<span class="iconEdit"></span>
    <form class="inBody">
    <table class="multiple">    	
        <tr>
        	<td>公告类型：</td><td>
            <select id="Announcetype" name="sAnnounceType">
            <option value="1">即时公告</option>
            <option value="2">间隔公告</option>
            <!--  option value="3">浮动栏公告</option>
            <option value="4">警告框公告</option>
            <option value="5">系统公告、滚动栏</option>
            <option value="6">传闻</option>
            <option value="7">聊天栏 |浮动栏</option>
            <option value="8">活动公告专用</option-->
            </select>
            </td>
        </tr>
        <tr>
        	<td>开始时间：</td><td><input type="text" class="input" size="20" id="releasTime1" onclick="SelectDate(this,'yyyy-MM-dd hh:mm')" readonly="readonly" value="" /></td>
        </tr>
        <tr>
        	<td>截止时间：</td><td><input type="text" class="input" size="20" id="releasTime2" onclick="SelectDate(this,'yyyy-MM-dd hh:mm')" readonly="readonly" value="" /></td>
        </tr>
        <tr>
        	<td>播放间隔：</td><td><input type="text" id="announceInterval" value=""></input>&nbsp;&nbsp;单位秒</td>
        </tr>
        <tr>
        	<td>公告内容：</td><td><textarea cols="80" rows="10" id="announceContent" name="announceContent"></textarea></td>
        </tr>
        <tr>
        	<td width="90">运营代理商：</td><td><select id="sArea" name="sArea"><option value="-1">loading...</option></select></td>
        </tr>
        <tr>
        	<td>服务器：</td>
            <td id="serverInfo">
            </td>	
        </tr>
        <tr><td colspan="2" ><button type="button" id="btnSumbit">发布</button><div class="errorTip" id="msg" style="visibility:hidden" ></div></td></tr>
    </table>
    </form>
</div>

<div id="listAnnouncement" >
<div class="mdForm">
	<span class="iconSearch"></span>
    <table>
        <tr>
        	<td width="100">发布时间：</td><td>
        	<input type="text" class="input" size="20" id="startTime" onclick="SelectDate(this,'yyyy-MM-dd hh:mm:ss')"  readonly="readonly" /> -
        	<input type="text" class="input" size="20" id="endTime" onclick="SelectDate(this,'yyyy-MM-dd hh:mm:ss')"  readonly="readonly" />
        	</td>
        </tr>
        <tr>
        	<td>运营代理商：</td>
            <td >
           <select id="ListArea" name="ListArea"><option value="-2">loading...</option></select>
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
        	<th width="50">发布时间</th>
            <th width="50">操作人员</th>
            <th width="50">类型</th>
            <th width="200">内容</th>
            <th width="40">状态</th>
            <th width="40">操作</th>           
            <!--<th width="90">操作</th>-->
        </tr>
    </thead>
    <tbody id="List_Body">
    </tbody>
</table>
<div class="pages" id="divPagination" ></div>
</div>
<div class="fwinly" id="showAnouceInfo" style="display:none;left:50%; margin-left:-340px; top:20px;">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle">
            <strong><span id="DialogTitle">公告查看</span></strong><a href="javascript:void(0);" id="btnCloseAnouceInfo" class="fclose"><?php echo systemClose;?></a></h3>
            <div class="formly" style="width:660px;">
                <table>
                    <tr>
                        <td width="100">操作人员：</td><td width="170" id="s_Account"></td>
                        <td width="80">操作时间：</td><td id="s_CreatTime"></td>
                    </tr>
                    <tr>
                        <td width="100">开始时间：</td><td width="170" ><input type="text" class="input" size="20" id="e_releasTime1" onclick="SelectDate(this,'yyyy-MM-dd hh:mm')" readonly="readonly" value="" /></td>
                        <td width="80">截止时间：</td><td><input type="text" class="input" size="20" id="e_releasTime2" onclick="SelectDate(this,'yyyy-MM-dd hh:mm')" readonly="readonly" value="" /></td>
                    </tr>
                    <tr>
                        <td>播放间隔：</td><td colspan="3"><input type="text" id="e_announceInterval" value=""></input></td>
                    </tr>
                    <tr>   
                       <td>公告内容：</td><td colspan="3"><textarea cols="86" rows="4" id="e_announceContent" name="announceContent"></textarea></td>                    
                    </tr>
                    <tr>                       
                        <td colspan="4" id="bm_ItemName" >
                        <table class="tabData" style="width:650px;">
    					<thead>
    						<tr>
        						<th width="50">服务器</th>
           						 <th width="50">状态</th>
            					<th width="50">操作</th>           
       							</tr>
    							</thead>
						</table>
                        <div class="noneBox fixed" style="height:150px;width:640px;"  >
                		<table class="tabData" style="width:630px;">
    							<tbody id="e_List_Body">
   								 </tbody>
						</table>
                		</div>
                        </td>
                    </tr>
                    <tr class="footer"><td colspan="4" align="center" id="hu_result">
                    <input type="hidden" id="e_announceId"/>
                    <button type="button" id="btnEditeUpdate">修改</button> &nbsp;&nbsp;&nbsp;<button type="button" id="btnEditedelete">删除</button>&nbsp;&nbsp;&nbsp;<button type="button" id="btnEditeResend">全部同步</button>
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
