var _class_serverRights = null;
var _itemInfoArray = null;
$(document).ready(function() {
	_itemInfoArray = new Array();
	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',2);
	$("#btnSumbitApply").bind("click",btnSumbitApplyOnclickHandler);
	$("#btnAddItemApp").bind("click",btnAddItemAppOnclickHandler);
	$("#BtncloseItemChoose").bind("click",BtncloseItemChooseOnclickHandler);
	$("#btnAddItem").bind("click",btnAddItemOnclickHandler);
});


function addOneItemInApplay(bindType,itemId,itemValue)
{
	var bindName = bindType == 0 ? '非绑定' :'绑定';
	var objctId = "item_"+itemId;
	var str = '<li id="'+objctId+'"><label>道具ID：'+itemId+'&nbsp;&nbsp;数量：'+itemValue+'&nbsp;&nbsp;&nbsp;&nbsp'+bindName+'&nbsp;&nbsp;&nbsp;&nbsp[<a href="javascript:void(0);" onclick="javascript:btnRemoveItemOnclickHandler(\'' + objctId + '\')">删除</a>]</label></li>';
	$("#app_AllItemInfo").append(str);
}

function btnSumbitApplyOnclickHandler()
{
	var title = Trim($("#appItemTitle").val());
	var desc  = Trim($("#appItemDesc").val());
	var applyRemark  = $("#appRemark").val();
	var userType = $("input[name='appPlayerType']:checked").val(); // 0=角色名  1=账号
	var userInfo = $("#appPlayerInfo").val();
//	var roleLevLow = Trim($("#appRoleLevlow").val());
//	var roleLevUp = Trim($("#appRoleLevup").val());
//	var startTime = $("#startTime").val();
//	var endTime = $("#endTime").val();
	var moneyGold = Trim($("#moneyGold").val());
	var moneyLJ = Trim($("#moneyLJ").val());
	var moneyTQ = Trim($("#moneyTQ").val());
	var moneyTQ1 = Trim($("#moneyTQ1").val());
	var moneyItemString = getMoneyItemInfo(moneyGold,moneyLJ,moneyTQ,moneyTQ1);
	var propItemString = getItemInfoArry();
	var propConditionString = getUserCondition(0,0,0,0);
	var selectValue = _class_serverRights.getBoxValue();
	
	if(strlen(title) == 0 || strlen(title) > 50){
		showMsg(false,"发放标题必须要在50个字符之内！",'msg');
		return;
	}
	if(strlen(desc) == 0 || strlen(desc) > 200){
		showMsg(false,"发放说明必须要在200个字符之内！",'msg');
		return;
	}
	if(applyRemark == ""){
		showMsg(false,"请输入申请原因！",'msg');
		return;
	}
//	if(userInfo == ""){
//		showMsg(false,"请输入要操作的账号或者角色名！",'msg');
//		return;
//	}
//	if(strlen(roleLevLow)  > 0 && !ck_int(roleLevLow)){
//		showMsg(false,"角色等级 小于等级必须是整数！",'msg');
//		return;
//	}
//	if(strlen(roleLevUp)  > 0 && !ck_int(roleLevUp)){
//		showMsg(false,"角色等级 大于等级必须是整数！",'msg');
//		return;
//	}
	if(userInfo == "" )
	{
		showMsg(false,"请输入发放的账号或者至少输入一条发放对象的条件！",'msg');
		return;
	}
	if(strlen(moneyGold)  > 0 && !ck_int(moneyGold)){
		showMsg(false,"元宝数量必须是整数！",'msg');
		return;
	}
	if(strlen(moneyLJ)  > 0 && !ck_int(moneyLJ)){
		showMsg(false,"礼金数量必须是整数！",'msg');
		return;
	}
	if(strlen(moneyTQ)  > 0 && !ck_int(moneyTQ)){
		showMsg(false,"铜钱数量必须是整数！",'msg');
		return;
	}
	if(strlen(moneyGold) == 0 && strlen(moneyLJ) == 0 && strlen(moneyTQ) == 0 && strlen(propItemString) ==0)
	{
		showMsg(false,"请添加货币或者道具物品信息！",'msg');
		return;
	}
	
	if(selectValue == null || selectValue == "")
	{
		showMsg(false,"请选择合作商！",'msg');
		return;
	}
	$("#btnSumbitApply").hide();
	showMsg(false,"正在提交... 请耐心等待，不要刷新页面!",'msg');
	$.ajax({type: "post",url: 'interface/AdminManageMethod.php',
		dataType: "json",
		data: {
				"method":"itemApply",
				"title":title,
				"desc":desc,
				"remark":applyRemark,
				"userType":userType,
				"userInfo":userInfo,
				"condition":propConditionString,
				"moneyItem":moneyItemString,
				"propItem":propItemString,
				"server":selectValue},
		success: function(result) {
			if(result.Success){
					showMsg(true,"",'msg');
					$("#btnSumbitApply").show();
					alert("操作成功!");
					$("#appItemTitle").val('');
					$("#appItemDesc").val('');
					$("#appRemark").val('');
					$("#appPlayerInfo").val('');
					$("#appRoleLevlow").val('');
					$("#appRoleLevup").val('');
					$("#startTime").val('');
					$("#endTime").val('');
					$("#moneyGold").val('');
					$("#moneyLJ").val('');
					$("#moneyTQ").val('');
					$("#moneyTQ1").val('');
					$("#app_AllItemInfo").html('');
					_itemInfoArray = null;
					_itemInfoArray = new Array();
			}
			else
				showMsg(false,"操作失败!"+result.Message,'msg');
		},
		error: function(e) {
			//alert("链接出错");
			$("#btnSumbitApply").show();showMsg(true,"",'msg');}
	});
}

function btnRemoveItemOnclickHandler(objectID)
{
	var objectArray = objectID.split('_');
	if(objectArray.length != 2)
	{
		alert('系统错误！');
		return;
	}
	var isHasIndex = -1;
	for(var i=0;i<_itemInfoArray.length;++i)
	{
		var myItemInfo = _itemInfoArray[i];
		if(myItemInfo.ItemID == objectArray[1])
		{
			isHasIndex = i;
			break;
		}
	}
	if(isHasIndex != -1)
	{
		_itemInfoArray.splice(isHasIndex,1);
		$("#"+objectID).remove();
	}
}

/**
 * 道具选择层 添加单个道具信息按钮事件
 * @return
 */
function btnAddItemOnclickHandler()
{

	var bindType = $("input[name='isBind']:checked").val(); 
	var itemIDValue = $("#itemID").val();
	var itemNumValue = $("#itemNum").val();
	if(!ck_int(itemIDValue) || itemIDValue == ""){
		showMsg(false,'请输入正确的道具ID,！','item_msg');
		return;
	}
	if(!ck_int(itemNumValue) || itemNumValue == ""){
		showMsg(false,'请输入正确的道具数量！','item_msg');
		return;
	}
	if(itemNumValue == 0){
		showMsg(false,'道具数量不能为0！','item_msg');
		return;
	}
	if(isArrayHasItemInfo(itemIDValue))
	{
		showMsg(false,'此道具ID已被添加过！','item_msg');
		return;
	}
	showMsg(true,'','item_msg');
	
	var ob = new itemInfo(itemIDValue,itemNumValue,bindType);
	_itemInfoArray.push(ob);
	addOneItemInApplay(bindType,itemIDValue,itemNumValue);
	$("#itemID").val('');
	$("#itemNum").val('');
	$("input[type=radio][name=isBind][value=0]").attr("checked",'checked');
}

function btnAddItemAppOnclickHandler()
{
	$("#itemID").val('');
	$("#itemNum").val('');
	$("input[type=radio][name=isBind][value=0]").attr("checked",'checked');
	showMsg(true,'','item_msg');
	$("#appItemChooseDiv").show();
}

function BtncloseItemChooseOnclickHandler()
{
	$("#appItemChooseDiv").hide();
}

function showMsg(falg,msg,obj){
	if(!falg){
		document.getElementById(obj).innerHTML =msg;
		document.getElementById(obj).style.visibility="visible";
	}
	else
		document.getElementById(obj).style.visibility="hidden";
}

function itemInfo(itemId,itemNum,itemBind)
{
	this.ItemID = itemId;
	this.ItemNum = itemNum;
	this.ItemBind = itemBind;
}

/**
 * 是否数据中已含有这个元素对象 是返回true
 * @param itemId
 * @return
 */
function isArrayHasItemInfo(itemId)
{
	var isHasing = false;
	for(var i=0;i<_itemInfoArray.length;++i)
	{
		var myItemInfo = _itemInfoArray[i];
		if(myItemInfo.ItemID == itemId)
		{
			isHasing = true;
			break;
		}
	}
	return isHasing;
}

/**
 * 从数组中得到道具信息，每个道具以','间隔 （ID|数量|绑定）
 * @return
 */
function getItemInfoArry()
{
	var itemInfoString = "";
	for(var i=0;i<_itemInfoArray.length;++i)
	{
		var myItemInfo = _itemInfoArray[i];
		var oneItemString = myItemInfo.ItemID+'|'+myItemInfo.ItemNum+'|'+myItemInfo.ItemBind;
		if(itemInfoString == "")
			itemInfoString += oneItemString;
		else
			itemInfoString += ','+oneItemString;
	}
	return itemInfoString;
}

/**
 * "money":{
        "gold":"元宝数量",
        "bind_gold":"礼金数量",
        "copper":"铜钱数量",
        "bind_copper":"绑定铜币或者银两数量"(字段保留，用不到)
    }
 * @param m_gold
 * @param m_lj
 * @param m_tq
 * @return
 */
function getMoneyItemInfo(m_gold,m_lj,m_tq,m_tq1)
{
	if(m_gold=='') m_gold =0;
	if(m_lj=='') m_lj =0;
	if(m_tq=='') m_tq =0;
	if(m_tq1=='') m_tq1 =0;
	return parseInt(m_gold)+','+parseInt(m_lj)+','+parseInt(m_tq)+','+parseInt(m_tq1);
}

/**
 * "condition":{
        "level_up":"大于或者等于的等级",
        "level_low":"小于或者等于的等级",
        "country":"国家id",(字段保留，用不到)
        "last_load_start":"最后登录起始时间",
"last_load_end":"最后登录结束时间",
        "faction":"帮派名称"(字段保留，用不到)
    }
 * @return
 */
function getUserCondition(level_up,level_low,last_load_start,last_load_end)
{
	return '"condition":{"level_up":'+level_up+',"level_low":'+level_low+',"country":"","last_load_start":"'+last_load_start+'","last_load_end":"'+last_load_end+'"}';
}
