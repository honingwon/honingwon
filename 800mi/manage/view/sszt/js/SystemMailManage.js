var _class_serverRights = null;
var _defaultTab = 0;
var _listData = null;
var _Currenpage = 1;
var _CurrentPageLine = 50;
var _startTime = "";
var _endTime = "";
var _isDoneAjax = false;
$(document).ready(function() {
	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',2);
	$("#listSystemMail").show();
	$("#editSystemMail").hide();
	$("#roleLev").hide();
	$("input[name='systemMailType']:radio").click(function(){
		radioClickValueChange($(this).val());
	});
	$("#btnSumbit").bind("click",btnSumbitOnclickHandler);
	$("#btnSearchSubmit").bind("click",btnSearchSubmitOnclickHandler);
	$("#btnCloseSystemMailInfo").bind("click",btnCloseSystemMailInfoOnclickHandler);
	doSearchData();
});

function typeChange(type,obj)
{
	if(_isDoneAjax) 
	{
		alert("正在执行操作，请稍后！");
		return;
	}
	$(".tagSort a").removeClass();
	$(obj).addClass("selected");
	_defaultTab = type;
	if(_defaultTab == 0)
	{
		$("#listSystemMail").show();
		$("#editSystemMail").hide();
		_Currenpage = 1;
		$("#startTime").val("");
		$("#endTime").val("");
		_startTime = "";
		_endTime = "";
		doSearchData();
	}
	else if(_defaultTab == 1)
	{
		$("#listSystemMail").hide();
		$("#editSystemMail").show();
		radioClickValueChange("1");
	}
}

function radioClickValueChange(value)
{
	$("#systemNickName").val('');
	$("#systemMinLev").val('');
	$("#systemMaxLev").val('');
	switch(value)
	{
		case "1":
			$("#roleName").show();
			$("#roleLev").hide();
			_class_serverRights.updateBoxStateInt(2);
			break;
		case "2":
			$("#roleLev").show();
			$("#roleName").hide();
			_class_serverRights.updateBoxStateInt(1);
			break;
		case "3":
			$("#roleLev").hide();
			$("#roleName").hide();
			_class_serverRights.updateBoxStateInt(1);
			break;
	}
}

function btnSumbitOnclickHandler()
{
	if(_class_serverRights == null) return;
	var sendType = $("input[name='systemMailType']:checked").val(); 
	var userInfo = "";
	var min_lev = "0";
	var max_lev = "0";
	var title = Trim($("#systemMailTitle").val());
	var desc = $("#systemMailDesc").val();
	var selectValue = _class_serverRights.getBoxValue();
	
	if(sendType == "1")
	{
		userInfo = $("#systemNickName").val();
		if(strlen(userInfo) == 0)
		{
			showCommonMsg(false,"请输入玩家角色名！",'msg');
			return;
		}
	}
	else if(sendType == "2")
	{
		min_lev = Trim($("#systemMinLev").val());
		max_lev = Trim($("#systemMaxLev").val());
		if(strlen(min_lev) == 0 || strlen(max_lev) == 0)
		{
			showCommonMsg(false,"请输入玩家角色等级区域！",'msg');
			return;
		}
		if(strlen(min_lev)  > 0 && !ck_int(min_lev)){
			showCommonMsg(false,"角色最小等级必须是整数！",'msg');
			return;
		}
		if(strlen(max_lev)  > 0 && !ck_int(max_lev)){
			showCommonMsg(false,"角色最小等级必须是整数！",'msg');
			return;
		}
	}
	if(strlen(title) == 0 || strlen(title) > 50){
		showCommonMsg(false,"邮件标题在50个字符以内！",'msg');
		return;
	}
	if(strlen(desc) == 0 || strlen(desc) > 500){
		showCommonMsg(false,"邮件内容在500个字符以内！",'msg');
		return;
	}
	if(selectValue == null || selectValue == "")
	{
		showCommonMsg(false,"请选择合作商！",'msg');
		return;
	}

	$("#btnSumbit").hide();
	showCommonMsg(false,"正在提交... 请耐心等待，不要刷新页面!",'msg');
	$.ajax({type: "post",url: 'interface/AdminManageMethod.php',
		dataType: "json",
		data: {
				"method":"system_send_mail",
				"userinfo":userInfo,
				"title":title,
				"reamark":desc,
				"action":sendType,
				"min_lev":min_lev,
				"max_lev":max_lev,
				"server":selectValue},
		success: function(result) {
					if(result.Success){
						var error = "";
						if(result.DataList.length > 0)
						{
							for (var i = 0; i < result.DataList.length; i++) {
								error +=  result.DataList[i]+"<br />";
							}
						}
						if(error != ""){
							if(result.Tag == true)
								error = "部分请求出错，请查看错误日志<br />" + error;
							else
								error = "请联系管理人员，发送日志保存失败，请查看错误日志<br />" + error;
							alert(error);
							document.location.reload(); 
							showCommonMsg(true,"",'msg');
						}
						else{
							if(result.Tag == true)
								alert("操作成功!");
							else
								alert("游戏内发送邮件成功，但是后台发送日志保存失败，请联系管理员!");
							document.location.reload(); 
							showCommonMsg(true,"",'msg');

						}
					}
					else
						showCommonMsg(false,"操作失败!",'msg');
					 $("#btnSumbit").show();
		},
		error: function(e) {
			//alert("链接出错");
			$("#btnSumbit").show(); showCommonMsg(true,"",'msg');}
	});
}

function btnShowSystemMail(index)
{
	if(_isDoneAjax) 
	{
		alert("正在执行操作，请稍后！");
		return;
	}
	if(index >= 0 && index < _listData.length)
	{
		var mailInfp = _listData[index];
		$("#s_Account").html(mailInfp[9]);
		$("#s_CreatTime").html(mailInfp[3]);
		$("#s_MailTitle").html(mailInfp[1]);
		$("#s_desc").html(mailInfp[2]);
		$("#s_users").html(subStringSearchCondition(mailInfp[5]));
		$("#s_log").html(mailInfp[6]);
		$("#systemMailInfo").show();
		_isDoneAjax = true;
		$.ajax({type: "post",url: 'interface/AdminManageMethod.php',
			dataType: "json",
			data: {
					"method":"commonServerName",
					"server":mailInfp[7]},
			success: function(result) {
				if(result.Success){
					var serverList = result.DataList;
					var serverName = "发送的服务器：<br/>";
					for (var i = 0; i < result.DataList.length; i++) {
						serverName +=  result.DataList[i][1]+",&nbsp;&nbsp;&nbsp;";
					}
					$("#s_server").html(serverName);
					$("#s_state").html(getErrorPostserverName(result.DataList,mailInfp[8]));
				}
				else{
					$("#s_server").html(mailInfp[7]);
					$("#s_state").html(8);
				}
				_isDoneAjax = false;
			},
			error: function(e) {
				$("#s_server").html(mailInfp[7]);
				$("#s_state").html(8);
				_isDoneAjax = false;
			}
		});
	}
}

function btnReSendingMail(index)
{
	if(_isDoneAjax) 
	{
		alert("正在执行操作，请稍后！");
		return;
	}
	if(index >= 0 && index < _listData.length)
	{
		_isDoneAjax = true;
		var mailInfp = _listData[index];
		$.ajax({type: "post",url: 'interface/AdminManageMethod.php',
			dataType: "json",
			data: {
					"method":"reSendingSystemMail",
					"mailId":mailInfp[0]},
			success: function(result) {
				if(result.Success){
					var resultList = result.Tag;
					var error = "";
					if(resultList.length > 0)
					{
						for (var i = 0; i < resultList.length; i++) {
							error +=  resultList[i]+"<br />";
						}
					}
					if(error == "")
						alert('操作成功！');
					else
						alert("同步后还有问题："+error);
				}
				else{
					alert(result.Message);
				}
				document.location.reload(); 
				_isDoneAjax = false;
			},
			error: function(e) {
				//alert("数据连接异常！");
				document.location.reload(); 
				_isDoneAjax = false;
			}
		});
	}
	else
		alert("请刷新后再试！");
}

function btnCloseSystemMailInfoOnclickHandler()
{
	$("#systemMailInfo").hide();
}

function btnSearchSubmitOnclickHandler()
{
	if(_isDoneAjax) 
	{
		alert("正在执行操作，请稍后！");
		return;
	}
	_Currenpage = 1;
	_startTime = $("#startTime").val();
	_endTime = $("#endTime").val();
	doSearchData();
}

function doSearchData()
{
	_listData = new Array();
	$.ajax({type: "post",url: 'interface/AdminManageMethod.php',
		dataType: "json",
		data: {
				"method":"systemMailList",
				"startTime":_startTime,
				"ednTime":_endTime,
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
	if(_isDoneAjax) 
	{
		alert("正在执行操作，请稍后！");
		return;
	}
	_Currenpage = num
	doSearchData();
}

function FormatData(objData)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body").html("<tr><td colspan='5' class='tc_rad'>暂未有数据信息</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#List_Body").html("<tr><td colspan='5' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    _listData = DataList;
    var i = 0;
    var row = DataList[i];
    var html =""; 
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var stateName = row[4] == 1 ? '正常':row[4] == 2 ? '<span style="color:#F00" >需同步</span>':'正常';
    	var ophtm = '[<a href="javascript:void(0);" onclick="javascript:btnShowSystemMail(\'' + i + '\')">详情查看</a>]';
    	if(row[4] == 2)
    		ophtm += '&nbsp;&nbsp;&nbsp;&nbsp;[<a href="javascript:void(0);" onclick="javascript:btnReSendingMail(\'' + i + '\')">同步</a>]';

    	html += "<tr class='"+className+"'><td>"+row[3]+"</td><td>"+row[9]+"</td>"+
    			"<td>"+row[1]+"</td><td>"+stateName+"</td><td>"+ophtm+"</td></tr>";;
        i++;
        row = DataList[i];
    }
    var FSumCount = objData.Tag;
    var FPageCount = Math.ceil(FSumCount / _CurrentPageLine);
    var pagingation = new Pagination("Pagination1", FPageCount, _Currenpage, FSumCount, _CurrentPageLine, "PageChange", "divPagination", 1)
    $("#List_Body").html(html);
}
/**
 * 需要同步的服务器名称
 * @param serverList
 * @param error
 * @return
 */
function getErrorPostserverName(serverList,error)
{
	if(error == "") return error;
	var errorAry = error.split(',');
	var serverName = "";
	for(var m=0;m < errorAry.length;++m)
	{
		var serverID = errorAry[m];
		for (var i = 0; i < serverList.length; i++) {
			if(errorAry[m] == serverList[i][0])
			{
				serverName += serverList[i][1]+",&nbsp;&nbsp;&nbsp;";
				break;
			}
		}
	}
	return "需同步的服务器：<br/>" + serverName;
}

/**
 * 发放对象的json格式解析
 * @param condition
 * {"name_list":[""],"action":"1","min_lv":"","max_lv":""}
 * @return
 */
function subStringSearchCondition(condition)
{
	var subString = ""; 
	ConditionObj = parseObj( condition);
	if(ConditionObj.action  == "3")
		subString += "全服邮件";
	else if(ConditionObj.action  == "2")
	{
		subString += "某一等级段里的所有玩家邮件:<br/>";
		subString += "最小等级："+ConditionObj.min_lv +";&nbsp;&nbsp;&nbsp;最大等级："+ConditionObj.max_lv;
	}
	else if(ConditionObj.action  == "1")
	{
		subString += "指定玩家发送：玩家昵称如下：<br/>"; 
		subString += ConditionObj.name_list;
	}
	else
	{
		subString = condition;
	}
	return subString;
}
