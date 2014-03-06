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
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.cookie.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/common.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/BMClass.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.easydrag.handler.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/table.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/ArrayList.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/CardApply.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/Pagination.js"></script>
</head>

<body id="MainPage">
<div class="mdName">
	<h2>道具卡申请管理</h2>
</div>
<div class="tagSort">
	<a  class="selected" onclick="selectSortMenu(this,0);" id="a_one" ><strong>申请中</strong></a>
	<a  onclick="selectSortMenu(this,1);" ><strong>申请道具卡</strong></a>	
	<a  onclick="selectSortMenu(this,2);" ><strong>已通过</strong></a>	
	<a  onclick="selectSortMenu(this,3);" ><strong>未通过</strong></a>	
	<a  onclick="selectSortMenu(this,4);" ><strong>已提取</strong></a>	
</div>
<div class="mdForm"  style="display: none;"  id="tbEdit">
	<span class="iconEdit"></span>
     <table  >
                <tr>
                    <td >
                        <table style="width: 400px" >
                            <tr><td >道具卡种类：</td><td><select id="selCardTypeID" ></select><input type="hidden" id="txtCardRebate" /><input type="hidden" id="txtItemCardCode" />
                                <br />
                           </td><td></td></tr>
                            <tr><td >数目*选0为不定量：</td><td><input id="txtNum" type="text" maxlength="8" size="5" /><input type="button" value="添加" id="btnAddCard"  /></td><td></td></tr>
                            <tr><td >申请名称：</td><td><input id="txtName" type="text" size="18" />*</td><td></td></tr>
                            <tr><td >其它信息：</td><td><textarea rows="10" id="txtDesc" style="width: 200px"></textarea>*</td><td></td></tr>
                        </table>
                    </td>
                    <td valign="top" class="bdbox"> 
                        <table >
                            <tr ><th colspan="2">添加的道具卡种类列表</th></tr>
                            <tbody id="tbodyApplyList">
                            </tbody>
                        </table>
                    </td>
                </tr>    
                <tr><td colspan="2">
                    <input id="btnSave" type="button" value="保 存" />
                    <input id="btnCancel" type="reset"  value="清 空" /></td></tr>         
            </table>            
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
    <tbody id ="List_Body1">    	    	
    	<tr style="display: none;">
        	<td>yaowan_gm3</td>
            <td>盛大起点</td>
            <td class="tc_gray"><span class="tc_green">&radic;个人权限</span>、&times;服务器权限</td>
            <td class="operate"><a href="#" onclick="onOpen('perAccount');">设置个人权限</a><a href="#" onclick="onOpen('perServer');">设置服务器权限</a><a href="#" onclick="onOpen('accountEdit');">修改信息</a><a href="#">删除</a></td>
        </tr>
        <tr class="even" style="display: none;">
        	<td>qidiangm01</td>
            <td>叶利平</td>
            <td class="tc_gray"><span class="tc_green">&radic;个人权限</span>、<span class="tc_green">&radic;服务器权限</span></td>
            <td class="operate"><a href="#">设置个人权限</a><a href="#">设置服务器权限</a><a href="#">修改信息</a><a href="#">删除</a></td>
        </tr>
    </tbody>
</table>
<table class="tabData"  id="list2" >
    <thead>
    	<tr>
        	<th width="250">申请名称</th>
            <th width="150">申请人</th>
            <th width="150">申请时间</th>
            <th width="150">审核人</th>
            <th width="150">审核时间</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody id="List_Body2">    	    	
    </tbody>
</table>
<table class="tabData"  id="list3" >
    <thead >
    	<tr>
        	<th width="250">申请名称</th>
            <th width="150">申请人</th>
            <th width="150">申请时间</th>
            <th width="150">审核人</th>
            <th width="150">审核时间</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody id="List_Body3">    	    	
    </tbody>
</table>
<table class="tabData"  id="list4" >
    <thead id="List_Body3">
    	<tr>
        	<th width="250">申请名称</th>
            <th width="150">申请人</th>
            <th width="150">申请时间</th>
            <th width="150">审核人</th>
            <th width="150">审核时间</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody id="List_Body4">    	    	
    </tbody>
</table>
<div class="pages" id="divPagination" ></div>
<div class="fwinly" style="left:50%; margin-left:-300px; top:113px;" id="CardFormInfo">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle"><strong id="accountEditTitle">道具卡信息查看</strong><a href="javascript:void(0);" id="BtncloseCardFormInfo" class="fclose" >关闭</a></h3>
            <div class="formly" style="width:300px;">
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
                        <td>道具卡:</td><td id="cardInfo"></td>
                    </tr>
                    <tr>
                        <td>审核人:</td><td id="tdChecker"></td>
                    </tr>
                    <tr>
                        <td>审核时间:</td><td id="tdCheckTime"></td>
                    </tr>
                    <tr>
                        <td>审核备注:</td><td id="tdCheckRemark"></td>
                    </tr>
                    <tr>
                        <td>申请备注:</td><td id="tdRemark"></td>
                    </tr>
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
