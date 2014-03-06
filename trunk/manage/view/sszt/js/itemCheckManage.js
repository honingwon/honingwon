var _class_serverRights = null;
var _listData = null;
var _Currenpage = 1;
var _CurrentPageLine = 50;
var _searchArea = "";
var _searchValue = "";
var _defaultTab = 0;

$(document).ready(function() {

	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',1);
	_class_serverRights.setCheckBoxUnCheck();
	$("#btnSubmit").bind("click",btnSubmitOnclickHandler);
	$("#btnCloseItemApplyInfo").bind("click",btnCloseItemApplyInfoOnclickHandler);
	$("#btnCloseHItemApplyInfo").bind("click",btnCloseHItemApplyInfoOnclickHandler);
	$("#btnpass").bind("click",btnpassOnclickHandler);
	$("#btnunpass").bind("click",btnunpassOnclickHandler);
	searchListData();
});

function typeChange(type,obj)
{
	$(".tagSort a").removeClass();
	$(obj).addClass("selected");
	_defaultTab = type;
	btnSubmitOnclickHandler();
}


function searchListData()
{
	_listData = new Array();
	$.ajax({type: "post",url: 'interface/AdminManageMethod.php',
		dataType: "json",
		data: {
				"method":"itemApplyList",
				"areaId":_searchArea,
				"server":_searchValue,
				"state":_defaultTab,
				"pagesize":_CurrentPageLine,
				"curpage":_Currenpage},
		success: function(result) {
			FormatData(result);	
		},
		error: function(e) {
			//alert("链接出错");
			}
	});
}

function PageChange(num)
{
	_Currenpage = num
	searchListData();
}

function FormatData(objData)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body").html("<tr><td colspan='6' class='tc_rad'>暂未有数据信息</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#List_Body").html("<tr><td colspan='6' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    _listData = DataList;
    var i = 0;
    var row = DataList[i];
    var html =""; 
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var ophtm = "";
    	var stateName = row[11] == 1 ? '通过':row[11] == 2 ? '不通过':'';
    	if(_defaultTab == 0)
    		ophtm = '[<a href="javascript:void(0);" onclick="javascript:btnShowApplyItem(\'' + i + '\')">审核</a>]';
    	else
    		ophtm = stateName + '&nbsp;&nbsp;[<a href="javascript:void(0);" onclick="javascript:btnShowApplyItem(\'' + i + '\')">查看详情</a>]';

    	html += "<tr class='"+className+"'><td>"+row[2]+"</td><td>"+row[12]+"</td>"+
    			"<td>"+row[13]+"</td><td>"+row[3]+"</td><td>"+row[10]+"</td><td>"+ophtm+"</td></tr>";;
        i++;
        row = DataList[i];
    }
    var FSumCount = objData.Tag;
    var FPageCount = Math.ceil(FSumCount / _CurrentPageLine);
    var pagingation = new Pagination("Pagination1", FPageCount, _Currenpage, FSumCount, _CurrentPageLine, "PageChange", "divPagination", 1)
    $("#List_Body").html(html);
}

function btnShowApplyItem(index)
{
	if(index >= 0 && index < _listData.length)
	{
		var applyItem = _listData[index];
		if(_defaultTab == 0)
		{
			$("#checkApplyID").val(applyItem[0]);
			$("#u_Account").html(applyItem[13]);
			$("#u_CreatTime").html(applyItem[12]);
			$("#u_ServerName").html(applyItem[2]);
			$("#u_title").html(applyItem[3]);
			$("#u_desc").html(applyItem[4]);
			$("#u_remark").html(applyItem[10]);
			$("#u_users").html(subStringPlayerUser(applyItem[5],applyItem[6],applyItem[7]));
			$("#u_items").html(subStringItemInfo(applyItem[8],applyItem[9]));
			$("#itemApplyInfo").show();
		}
		else
		{
			$("#hu_Account").html(applyItem[13]);
			$("#hu_CreatTime").html(applyItem[12]);
			$("#hu_ServerName").html(applyItem[2]);
			$("#hu_title").html(applyItem[3]);
			$("#hu_desc").html(applyItem[4]);
			$("#hu_remark").html(applyItem[10]);
			$("#hu_users").html(subStringPlayerUser(applyItem[5],applyItem[6],applyItem[7]));
			$("#hu_items").html(subStringItemInfo(applyItem[8],applyItem[9]));
			var stateName = applyItem[11] == 1 ? '通过':applyItem[11] == 2 ? '<span style="color:#F06">不通过 </span>':'';
			$("#hu_CheckRemark").html(applyItem[15]);
			$("#hu_result").html("审核状态："+stateName+";&nbsp;&nbsp;审核人："+applyItem[14]+";&nbsp;&nbsp;审核时间："+applyItem[16]);
			$("#itemApplyInfoHasCheck").show();
		}
	}
}

function doCheckApply(method)
{
	var applyId = $("#checkApplyID").val();
	var checkRemark = $("#u_CheckRemark").val();
	if(applyId == ""){
		alert("请刷新后再试!");
		return;
	}
	if(strlen(checkRemark) == 0 || strlen(checkRemark) > 200){
		alert("审核说明必须要在200个字符之内!");
		return;
	}
	$.ajax({type: "post",url: 'interface/AdminManageMethod.php',
		dataType: "json",
		data: {
				"method":method,
				"applyId":applyId,
				"applyRemark":checkRemark},
		success: function(result) {
			if(result.Success)
			{
				alert('操作成功');
				btnCloseItemApplyInfoOnclickHandler();
				btnSubmitOnclickHandler();
			}
			else
			{
				alert("操作失败!"+result.Message);
			}
		},
		error: function(e) {
			//alert("链接出错");
			}
	});
}

function btnSubmitOnclickHandler()
{
	_Currenpage = 1;
	if(_class_serverRights != null)
	{
		var areaID = _class_serverRights.getAreaValue();
		if(areaID != "-1")
			_searchArea = areaID;
		_searchValue = _class_serverRights.getBoxValue();
	}
	searchListData();
}

function btnpassOnclickHandler()
{
	doCheckApply("itemCheckPass");
}

function btnunpassOnclickHandler()
{
	doCheckApply("itemCheckUnPass");
}

function btnCloseItemApplyInfoOnclickHandler()
{
	$("#itemApplyInfo").hide();
	$("#checkApplyID").val("");
	$("#u_Account").html("");
	$("#u_CreatTime").html("");
	$("#u_ServerName").html("");
	$("#u_title").html("");
	$("#u_desc").html("");
	$("#u_remark").html("");
	$("#u_users").html("");
	$("#u_items").html("");
	$("#u_CheckRemark").val("");
}

function btnCloseHItemApplyInfoOnclickHandler()
{
	$("#itemApplyInfoHasCheck").hide();
	$("#hu_result").html("");
	$("#hu_Account").html("");
	$("#hu_CreatTime").html("");
	$("#hu_ServerName").html("");
	$("#hu_title").html("");
	$("#hu_desc").html("");
	$("#hu_remark").html("");
	$("#hu_users").html("");
	$("#hu_items").html("");
	$("#hu_CheckRemark").val("");
}

/**
 * 字符串格式化显示发送对象的信息
 * @param sendType
 * @param user
 * @param condition
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
function subStringPlayerUser(sendType,user,condition)
{
	var subString = "";
//	conditionObj = parseObj( "{"+condition+"}");
//	if(conditionObj.condition.level_up != "")
//		subString += "角色等级>= " + conditionObj.condition.level_up +"&nbsp;&nbsp;&nbsp;&nbsp;;";
//	if(conditionObj.condition.level_low != "")
//		subString += "角色等级<= " + conditionObj.condition.level_low +"&nbsp;&nbsp;&nbsp;&nbsp;;<br />";
//	if(conditionObj.condition.last_load_start != "")
//		subString += "最后登录起始时间： " + conditionObj.condition.last_load_start +"&nbsp;&nbsp;&nbsp;&nbsp;;<br />";
//	if(conditionObj.condition.last_load_end != "")
//		subString += "最后登录结束时间： " + conditionObj.condition.last_load_end +"&nbsp;&nbsp;&nbsp;&nbsp;;<br />";
	
		
	if(user != "")
	{
//		var sendTypeName = sendType == 0 ? '发放账号类型：角色名':'发放账号类型：账号';
		subString += "角色名:";
		var userArry = user.split(',');
		for(var i = 0;i< userArry.length;++i)
		{
			subString += "<br />"+userArry[i];
		}
	}
	return subString;
}

/**
 * 字符串格式化显示 道具信息
 * @param moneyItem
 * @param propItem
 * @return
 */
function subStringItemInfo(moneyItem,propItem)
{
	var subString = "";
//	moneyObj = parseObj( "{"+moneyItem+"}");
//	if(moneyObj.money.gold != "")
//		subString += "元宝：" + moneyObj.money.gold+"&nbsp;&nbsp;";
//	if(moneyObj.money.bind_gold != "")
//		subString += "礼金：" + moneyObj.money.bind_gold+"&nbsp;&nbsp;";
//	if(moneyObj.money.copper != "")
//		subString += "铜钱：" + moneyObj.money.copper+"";
	var moneyArry = moneyItem.split(',');
	if(moneyArry.length==4)
	{
		subString += "元宝：" + moneyArry[0]+"&nbsp;&nbsp;";
		subString += "绑元宝：" + moneyArry[1]+"&nbsp;&nbsp;";
		subString += "铜钱：" + moneyArry[2]+"&nbsp;&nbsp;";
		subString += "绑铜钱：" + moneyArry[3];
	}
	
	if(propItem != "")
	{
		var propArry = propItem.split(',');
		for(var i = 0;i< propArry.length;++i)
		{
			var itemInfo = propArry[i];
			var itemArry = itemInfo.split('|');//（ID|数量|绑定,ID|数量|绑定）
			if(itemArry.length == 3)
			{
				var isBind = itemArry[2] == "0" ? '非绑定':'绑定';
				var itemString = "<br />ID:"+itemArry[0]+"&nbsp;&nbsp;&nbsp;&nbsp;数量："+itemArry[1]+"&nbsp;&nbsp;&nbsp;&nbsp;"+isBind;
				subString += itemString;
			}
		}
	}
	return subString;
}


