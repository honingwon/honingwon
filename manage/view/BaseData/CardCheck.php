<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMAccount/IsLogin.php');
   require_once(DATACONTROL . '/BMAccount/IsRights.php');	
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>游戏服务器管理  基础数据维护</title>
<link href="../css/base.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../css/simple.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/common.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/BMClass.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/CardCheck.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/Pagination.js"></script>
</head>

<body id="MainPage">
<div class="mdName">
	<h2>道具卡审核管理</h2>
</div>
<table class="tabData"  id="list1" >
    <thead>
    	<tr>
        	<th width="250">申请名称</th>
            <th width="250">申请人</th>
            <th width="150">申请时间</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody id ="List_Body" >    	    	
    	<tr style="display:none;">
        	<td>yaowan_gm3</td>
            <td>盛大起点</td>
            <td class="tc_gray"><span class="tc_green">&radic;个人权限</span>、&times;服务器权限</td>
            <td class="operate"><a href="#" onclick="onOpen('perAccount');">设置个人权限</a><a href="#" onclick="onOpen('perServer');">设置服务器权限</a><a href="#" onclick="onOpen('accountEdit');">修改信息</a><a href="#">删除</a></td>
        </tr>
        <tr class="even" style="display:none;">
        	<td>qidiangm01</td>
            <td>叶利平</td>
            <td class="tc_gray"><span class="tc_green">&radic;个人权限</span>、<span class="tc_green">&radic;服务器权限</span></td>
            <td class="operate"><a href="#">设置个人权限</a><a href="#">设置服务器权限</a><a href="#">修改信息</a><a href="#">删除</a></td>
        </tr>
    </tbody>
</table>
<div class="pages" id="divPagination" ></div>

<div class="fwinly" style="left:50%; margin-left:-300px; top:113px;" id="divcardCheck">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle"><strong id="accountEditTitle">道具卡申请详单查看</strong><a href="javascript:void(0);" id="BtncloseCardCheck" class="fclose" >关闭</a></h3>
            <div class="formly" style="width:400px;">
            	<!--div class="error">输入有错误？！</div-->
                <table>
                    <tr>
                        <td width="80">申请名称:</td><td id="tdFormName" ></td>
                    </tr>
                    <tr>
                        <td>申请人:</td><td id="tdApplyer"></td>
                    </tr>
                    <tr>
                        <td>申请时间:</td><td  id="tdApplyerTime"></td>
                    </tr>
                    <tr>
                        <td>申请备注:</td><td id="tdRemark"></td>
                    </tr>
                    <tr>
                        <td>道具卡:</td><td id="cardInfo"></td>
                    </tr>
                    <tr>
                        <td>审核说明:</td><td ><textarea rows="6" id="CheckApperTitleDesc" style="width: 300px"></textarea></td>
                    </tr>
                    
                     <tr class="footer"><td></td><td ><button type="button" id="btnPass">通过</button><button type="button" id="btnUnPass">不通过</button><button type="button" id="btnClose">关闭</button></td></tr>
                </table> 
                                   
            </div>
        </td>
        <td class="m_r"></td></tr>
        <tr><td class="b_l"></td><td class="b_c"></td><td class="b_r"></td>
        </tr>
    </table>
</div>
<input type="hidden" id="indexValue" />
</body>
</html>
