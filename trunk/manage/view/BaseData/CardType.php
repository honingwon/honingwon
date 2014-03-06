<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMAccount/IsLogin.php');
   require_once(DATACONTROL . '/BMAccount/IsRights.php');	
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>游戏服务器管理 - 卡种类维护</title>
<link href="../css/base.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../css/simple.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/common.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/BMClass.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/jquery.easydrag.handler.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/table.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/CardType.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/BaseData/ArrayList.js"></script>
<script type="text/javascript" src="<?php echo JS_DIR;?>/common/Pagination.js"></script>
</head>

<body id="MainPage">
<form id="cardType" class="inBody">
<div class="mdName">
	<h2> 卡种类维护</h2>
</div>
<div class="mdForm">
	<span class="iconSearch"></span>
    <table>
    	<tr><td colspan="2" >卡  名   称：<input type="text" class="input" size="20" id="searchcardName"  /></td></tr>
        <tr><td><button type="button" id="btnSearch" >查找</button> - <button type="button" id="btnAddCardType" >新增卡种类</button> </td></tr>
    </table>
</div>
<table class="tabData">
    <thead>
    	<tr>
        	<th width="300">卡名称</th>
            <th width="250">卡限制</th>
            <th width="150">卡类型</th>
            <th>操作</th>
        </tr>
    </thead>
    <tbody id="List_Body">    	    	
    	<tr style="display:none">
        	<td>yaowan_gm3</td>
            <td>盛大起点</td>
            <td class="tc_gray"><span class="tc_green">&radic;个人权限</span>、&times;服务器权限</td>
            <td class="operate"><a href="#" onclick="onOpen('perAccount');">设置个人权限</a><a href="#" onclick="onOpen('perServer');">设置服务器权限</a><a href="#" onclick="onOpen('accountEdit');">修改信息</a><a href="#">删除</a></td>
        </tr>
        <tr class="even" style="display:none">
        	<td>qidiangm01</td>
            <td>叶利平</td>
            <td class="tc_gray"><span class="tc_green">&radic;个人权限</span>、<span class="tc_green">&radic;服务器权限</span></td>
            <td class="operate"><a href="#">设置个人权限</a><a href="#">设置服务器权限</a><a href="#">修改信息</a><a href="#">删除</a></td>
        </tr>
        <tr style="display:none">
        	<td colspan="4" class="tc_rad">未搜索到帐号信息</td>
        </tr> 
    </tbody>
</table>
<div class="pages" id="divPagination" ></div>

<div class="fwinly" style="left:50%; margin-left:-250px; top:113px;"  id="CardEdit">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle"><strong id="CardEditTitle">卡种类维护</strong><a href="javascript:void(0);" id="BtncloseCardEdit" class="fclose" >关闭</a></h3>
            <div class="formly" style="width:600px;">
                <table>
                    <tr>
                        <td class="td100 dark">卡名称</td>
                        <td colspan="3">
                            <input type="text" id="txtName" style="width: 200px" maxlength="50" class="txt" />
                        </td>
                    </tr>
                    <tr>
                        <td >游戏种类限制</td>
                        <td >
                            <select id="selGameRestrict" onchange="ChangeRestrict(this.value)">
                                <option value="0">不限制</option>
                                <option value="1">游戏限制</option>
                                <option value="2">游戏分区限制</option>
                                <option value="3">游戏服务器</option>
                            </select>
                        </td>
                        <td > 卡性质</td>
                        <td>
                            <select id="selCardTypeRank">
                                <option value="0">不唯一</option>
                                <option value="1">唯一</option>
                            </select>
                        </td>
                    </tr>
                    <tr id="trRestrict" style="display:none;" >
                        <td > 游戏种类/分区</td>
                        <td colspan="3">
                            <div id="divLimit">
                                <span id="divAddClassList">
                                    <select id="selectClass" onchange="selGameChange();" >
                                    </select>
                                    <input id="ipClass"  type="button" value="添加" onclick="AddClass('selectClass','tb_List');" />
                                </span><span id="divAddAreaList">
                                    <select id="selectArea" onchange="selAreaChange();" >
                                    </select>
                                    <input id="ipArea" type="button" value="添加" onclick="AddArea('selectClass','selectArea','tb_List');" />
                                </span><span id="divAddServerList">
                                    <select id="selectServer" >
                                    </select>
                                    <input id="ipServer" type="button" value="添加" onclick="AddServer('selectClass','selectArea','selectServer','tb_List');" />
                                </span>
                            </div><div>
                                    <table border="0" cellpadding="0" cellspacing="1" width="100%">
                                        <caption id="list_title"></caption>
                                        <tbody id="tb_List">
                                        </tbody>
                                    </table>
                                </div>
                        </td>
                    </tr>
                    <tr>
                        <td >点数</td>
                        <td>
                            <input id="txtPoint" maxlength="8" style="width: 100px" />
                        </td>
                        <td > 面额</td>
                        <td>
                            <input type="text" id="txtPrice" maxlength="8" style="width: 100px" />
                        </td>
                    </tr>
                    <tr>
                        <td >备注</td>
                        <td colspan="3">
                            <textarea name="" rows="5" id="CardRemark" class="txt" style=" width:300px;"></textarea>
                        </td>
                    </tr>
                    <tr class="footer"><td></td><td colspan="3"><button type="button" id="btnCardSave">保存</button></td></tr>
                </table>                
            </div>
            <div class="error" id="DivMessage" style="display:none" ></div>
        </td>
        <td class="m_r"></td></tr>
        <tr><td class="b_l"></td><td class="b_c"></td><td class="b_r"></td>
        </tr>
    </table>
</div>
<div class="fwinly" style="left:50%; margin-left:-250px; top:113px;"  id="CardAstEdit">
	<table class="fwin">
    	<tr><td class="t_l"></td><td class="t_c"></td><td class="t_r"></td></tr>
        <tr><td class="m_l"></td><td class="m_c">
            <h3 class="ftitle"><strong id="CardEditTitle">卡限制维护</strong><a href="javascript:void(0);" id="BtncloseCardAstEdit" class="fclose" >关闭</a></h3>
            <div class="formly" style="width:600px;">
                <table border="0" cellpadding="0" cellspacing="1" class="tb tblist" id="tbEditAst">
                <tbody style="margin: 10px;">
                    <tr>
                    <td width="15%" class="dark">卡名称：</td>
                    <td id="cartnametd" width="15%"></td>
                        <td width="15%" class="dark"> 游戏种类限制</td>
                        <td class="td500">
                            <select id="selGameRestrictAst" onchange="ChangeRestrictAst(this.value)">
                                <option value="0">不限制</option>
                                <option value="1">游戏限制</option>
                                <option value="2">游戏分区限制</option>
                                <option value="3">游戏服务器</option>
                            </select>
                        </td>
                    </tr>
                    <tr id="trRestrictAst">
                        <td class="dark">游戏种类/分区</td>
                        <td class="td500" colspan="3">
                            <div id="divLimitAst">
                                <span id="divAddClassListAst">
                                    <select id="selectClassAst" onchange="selGameChangeAst();"><option value="">游戏种类选择</option></select>
                                    <input id="ipClassAst" class="btn" onclick="AddClass('selectClassAst','tb_ListAst');" type="button" value="添加" />
                                </span>
                                <span id="divAddAreaListAst">
                                    <select id="selectAreaAst" onchange="selAreaChangeAst();"><option value="">游戏大区选择</option></select>
                                    <input id="ipAreaAst" class="btn" onclick="AddArea('selectClassAst','selectAreaAst','tb_ListAst');" type="button" value="添加" />
                                </span>
                                <span id="divAddServerListAst">
                                    <select id="selectServerAst"><option value="">游戏服务器选择</option></select>
                                    <input id="ipServerAst" class="btn" onclick="AddServer('selectClassAst','selectAreaAst','selectServerAst','tb_ListAst');" type="button" value="添加" />
                                </span>
                            </div><div>
                                    <table border="0" cellpadding="0" cellspacing="1" class="tb tblist" width="100%">
                                        <caption id="list_titleAst"></caption>
                                        <tbody id="tb_ListAst">
                                        </tbody>
                                    </table>
                                </div>
                        </td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr class="footer"><td></td><td colspan="3"><button type="button" id="btnCardLimitSave">修改</button></td></tr>
                    
                </tfoot>
            </table>               
            </div>
            <div class="error" id="DivMessageAst" style="display:none" ></div>
        </td>
        <td class="m_r"></td></tr>
        <tr><td class="b_l"></td><td class="b_c"></td><td class="b_r"></td>
        </tr>
    </table>
</div>
<input type="hidden" id="hiddenOldRit" />
</form>
</body>
</html>
