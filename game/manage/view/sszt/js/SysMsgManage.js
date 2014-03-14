var _class_serverRights = null;
var _ListData = null;
var _ListserverData = null;
var _isDoneAjax = false;
var _postAjaxPath = "interface/AdminManageMethod.php";

$(document).ready(function() {
	_ListData = new Array();
	_ListserverData = new Array();
	$("#listAnnouncement").hide();
	$("#startTime").val(getDateMinuteDay());
	$("#endTime").val(getMDateMinuteDay());
	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',1);
	$("#btnSumbit").bind("click",btnSumbitOnclickHandler);
	$("#btnSearchSubmit").bind("click",btnSearchSubmitOnclickHandler);
	$("#btnCloseAnouceInfo").bind("click",btnCloseAnouceInfoOnclickHandler);
	$("#btnEditeResend").bind("click",btnEditeResendOnclickHandler);
	$("#btnEditedelete").bind("click",btnEditedeleteOnclickHandler);
	$("#btnEditeUpdate").bind("click",btnEditeUpdateOnclickHandler);
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
		$("#editAnnouncemment").show();
		$("#listAnnouncement").hide();
	}
	else if(_defaultTab == 1)
	{
		$("#editAnnouncemment").hide();
		$("#listAnnouncement").show();
		if($("#ListArea").val() == "-2")
			initListAreaRights();
	}
}

function btnSumbitOnclickHandler()
{
	if(_class_serverRights == null) return;
	var sendType = $("#Announcetype").val();
	var content = Trim($("#announceContent").val());
	var startTime = $("#releasTime1").val();
	var endTime = $("#releasTime2").val();
	var interval = $("#announceInterval").val();
	var areaValue = _class_serverRights.getAreaValue();
	var selectValue = _class_serverRights.getBoxValue();
	if(strlen(content) == 0){
		setOnburPline("btnSumbit","请输入公告内容！");
		return;
	}
	if(strlen(content) > 1000){
		setOnburPline("btnSumbit","公告内容不能超过1000字符，请重新输入！");
		return;
	}
	if(strlen(interval)  > 0 && !ck_int(interval)){
		setOnburPline("btnSumbit","时间间隔必须是整数！");
		return;
	}
	if(interval <= 0)
	{
		setOnburPline("btnSumbit","时间间隔必须是大于零！");
		return;
	}
	if(strlen(startTime) == 0){
		setOnburPline("btnSumbit","请输入公告的开始时间！");
		return;
	}	
	if(strlen(endTime) == 0){
		setOnburPline("btnSumbit","请输入公告的截止时间！");
		return;
	}	
	if(selectValue == null || selectValue == "")
	{
		setOnburPline("btnSumbit","请选择发送的服");
		return;
	}
	$("#btnSumbit").hide();
	_isDoneAjax = true;
	setOnburPline("btnSumbit","正在提交... 请耐心等待，不要刷新页面!");
	$.ajax({type: "post",url: _postAjaxPath,
		dataType: "json",
		data: {"method":"newBulletinAdd",
			   "sendType":sendType,
			   "startTime":startTime,
			   "endTime":endTime,
			   "interval":interval,
			   "content":content,
			   "server":selectValue,
			   "area":areaValue,
			   },
		success: function(result) {
				   if(result.Success){
						if(result.Message == "")
						{
							alert("操作成功！");
						}
						else
						{
							alert(result.Message);
						}
						$("#announceContent").val('');
						$("#releasTime1").val('');
						$("#releasTime2").val('');
						$("#announceInterval").val('');
					}
					else
						alert(result.Message);
				   $("#btnSumbit").show();
				   setOnburPline("btnSumbit","");
				   _isDoneAjax = false;
		},
		error: function(e) {$("#btnSumbit").show();_isDoneAjax= false;
		setOnburPline("btnSumbit","");
		}
	});
}

function btnSearchSubmitOnclickHandler()
{
	doSearchList();
}

function initListAreaRights()
{
	if(_class_serverRights != null)
	{
		var object = $("#ListArea")[0];
		object.options.length = 0;
		var areaAry = _class_serverRights.getAreaDataArray();
		if(areaAry == null)
		{
			object.options.add(new Option("loading...", "-2"));
			return;
		}
		if (areaAry != null && areaAry.length > 0) {
			for (var i = 0; i < areaAry.length; i++) {
				var row = areaAry[i]; 
				object.options.add(new Option(row[1], row[0]));
			}
		}
		else
			object.options.add(new Option("请选择运营代理商", "-1"));
	}
}


function doSearchList()
{
	if(_isDoneAjax) 
	{
		alert("正在执行操作，请稍后！");
		return;
	}
	var startTime = $("#startTime").val();
	var endTime   = $("#endTime").val();
	var areaID    = $("#ListArea").val();
	
	if(startTime == "" || endTime == "")
	{
		setOnburPline("btnSearchSubmit","请输入公告发布时间段！");
		return;
	}
	if(areaID <= 0)
	{
		setOnburPline("btnSearchSubmit","请选择合作商！");
		return;
	}
	
	$("#btnSearchSubmit").hide();
	_isDoneAjax = true;
	setOnburPline("btnSearchSubmit","正在查询... 请耐心等待，不要刷新页面！");
	$.ajax({type: "post",url: _postAjaxPath,
		dataType: "json",
		data: {
				"method":"bulletinList",
				"startTime":startTime,
				"ednTime":endTime,
				"area":areaID},
		success: function(result) {
			if(result.Success){
				FormatData(result);
				setOnburPline("btnSearchSubmit","");
			}
			else{
				setOnburPline("btnSearchSubmit",result.Message);
			}
			$("#btnSearchSubmit").show();
			_isDoneAjax = false;
		},
		error: function(e) {
			$("#btnSearchSubmit").show();
			setOnburPline("btnSearchSubmit",'out data config 检查这个服配置信息');
			_isDoneAjax = false;
		}
	});
}

function btnShowAnnouceInfo(index)
{
	if(index >= 0 && index < _ListData.length)
	{
		var bulleinInfo = _ListData[index];
		$("#e_announceId").val(bulleinInfo[2]);
		$("#s_Account").html(bulleinInfo[5]);
		$("#s_CreatTime").html(bulleinInfo[6]);
		$("#e_releasTime1").val(bulleinInfo[7]);
		$("#e_releasTime2").val(bulleinInfo[8]);
		$("#e_announceInterval").val(bulleinInfo[9]);
		$("#e_announceContent").val(bulleinInfo[4]);
		doEditAnnouceButton(bulleinInfo[3]);
		$("#showAnouceInfo").show();
		$.ajax({type: "post",url: _postAjaxPath,
			dataType: "json",
			data: {
					"method":"bulletinServerInfo",
					"bulletinId":bulleinInfo[2]},
			success: function(result) {
				FormatServerData(result);
			},
			error: function(e) {
				//alert("数据连接异常！");
			}
		});
	}
	else
		alert("请刷新后再试！");
}

function doEditAnnouceButton(bulletinState)
{
	switch(bulletinState)
	{
		case "0":
			$("#btnEditeResend").hide();
			$("#btnEditedelete").show();
			$("#btnEditeUpdate").show();
			break;
		case "1":
			$("#btnEditeResend").show();
			$("#btnEditedelete").show();
			$("#btnEditeUpdate").hide();
			break;
		case "2":
			$("#btnEditeResend").show();
			$("#btnEditedelete").show();
			$("#btnEditeUpdate").hide();
			break;
		default:
			$("#btnEditeResend").hide();
			$("#btnEditedelete").hide();
			$("#btnEditeUpdate").hide();
			break;
	}
}

function btnCloseAnouceInfoOnclickHandler()
{
	$("#showAnouceInfo").hide();
	$("#e_announceId").val("");
	$("#s_Account").html("");
	$("#s_CreatTime").html("");
	$("#e_releasTime1").val("");
	$("#e_releasTime2").val("");
	$("#e_announceInterval").val("");
	$("#e_announceContent").val("");
}
/**
 * 全部同步
 * @param index
 * @return
 */
function btnReSendingAnnouncement(index)
{
	$.ajax({type: "post",url: _postAjaxPath,
		dataType: "json",
		data: {"method":"reSendingAllbulletin",
			   "bulletinId":index},
		success: function(result) {
			if(result.Success){
				if(result.Message == "")
				{
					alert("操作成功！");
				}
				else
				{
					alert(result.Message);
				}
				btnCloseAnouceInfoOnclickHandler();
				doSearchList();
			}
			else{
				alert(result.Message);
			}
		},
		error: function(e) {
//			alert(2222);
		}
	});
}


/**
 * 删除某个已发送的公告（单服操作）
 * @param serverId
 * @return
 */
function btndelSendingOne(serverId)
{
	var index = $("#e_announceId").val();
	if(index == "")
		alert("请刷新后重试！");
	else{
	$.ajax({type: "post",url: _postAjaxPath,
		dataType: "json",
		data: {"method":"newBulletinDeleteone",
			   "bulletinId":index,
			   "server":serverId},
		success: function(result) {
			if(result.Success){
				if(result.Message == "")
				{
					alert("操作成功！");
				}
				else
				{
					alert(result.Message);
				}
				btnCloseAnouceInfoOnclickHandler();
				doSearchList();
			}
			else
				alert(result.Message);
		},
		error: function(e) {
		}
	});
	}
}
/**
 * 全部同步
 * @return
 */
function btnEditeResendOnclickHandler()
{
	var index = $("#e_announceId").val();
	if(index == "")
		alert("请刷新后重试！");
	else
		btnReSendingAnnouncement(index);
}

/**
 * 删除公告
 * @return
 */
function btnEditedeleteOnclickHandler()
{
	var index = $("#e_announceId").val();
	if(index == "")
		alert("请刷新后重试！");
	else
	{
		$.ajax({type: "post",url: _postAjaxPath,
			dataType: "json",
			data: {"method":"newBulletinDelete",
				   "bulletinId":index},
			success: function(result) {
				if(result.Success){
					if(result.Message == "")
					{
						alert("操作成功！");
					}
					else
					{
						alert(result.Message);
					}
					btnCloseAnouceInfoOnclickHandler();
					doSearchList();
				}
				else
					alert(result.Message);
			},
			error: function(e) {
			}
		});
	}
}

/**
 * 编辑公告
 * @return
 */
function btnEditeUpdateOnclickHandler()
{
	var index = $("#e_announceId").val();
	if(index == "")
		alert("请刷新后重试！");
	else
	{
		var startTime = $("#e_releasTime1").val();
		var endTime   = $("#e_releasTime2").val();
		var interval  = $("#e_announceInterval").val();
		var desc      = $("#e_announceContent").val();
		if(strlen(desc) == 0){
			setOnburPline("btnEditeUpdate","请输入公告内容！");
			return;
		}
		if(strlen(desc) > 1000){
			setOnburPline("btnEditeUpdate","公告内容不能超过1000字符，请重新输入！");
			return;
		}
		if(strlen(interval)  > 0 && !ck_int(interval)){
			setOnburPline("btnEditeUpdate","时间间隔必须是整数！");
			return;
		}
		if(interval <= 0)
		{
			setOnburPline("btnEditeUpdate","时间间隔必须是大于零！");
			return;
		}
		if(strlen(startTime) == 0){
			setOnburPline("btnEditeUpdate","请输入公告的开始时间！");
			return;
		}	
		if(strlen(endTime) == 0){
			setOnburPline("btnEditeUpdate","请输入公告的截止时间！");
			return;
		}	
		if (!confirm("您确定修改公告，公告修改后，将更新所有的服务器?"))
	        return;
		$.ajax({type: "post",url: _postAjaxPath,
			dataType: "json",
			data: {"method":"newBulletinUpdate",
				   "bulletinId":index,
				   "startTime":startTime,
				   "endTime":endTime,
				   "desc":desc,
				   "interval":interval},
			success: function(result) {
				if(result.Success){
					if(result.Message == "")
					{
						alert("操作成功！");
					}
					else
					{
						alert(result.Message);
					}
					btnCloseAnouceInfoOnclickHandler();
					doSearchList();
				}
				else
					alert(result.Message);
			},
			error: function(e) {
				
			}
		});
	}
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
    _ListData = DataList;
    var i = 0;
    var row = DataList[i];
    var html =''; 
    var arryType = ["","即时公告","间隔公告","浮动栏公告","警告框公告","系统,滚动栏","传闻","聊天栏 |浮动栏","活动公告","type9","type10","type11"];
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var stateName = row[3] == 0 ? '正常':row[3] == 99 ? '删除':'<span style="color:#F00" >需同步</span>';
    	var ophtm = '[<a href="javascript:void(0);" onclick="javascript:btnShowAnnouceInfo(\'' + i + '\')">详情查看</a>]';
    	if(row[3] >= 1 && row[3] < 99)
    		ophtm += '&nbsp;&nbsp;&nbsp;&nbsp;[<a href="javascript:void(0);" onclick="javascript:btnReSendingAnnouncement(\'' + row[2] + '\')">同步</a>]';
    	var desc =row[4];
    	if(strlen(row[4])  > 100)
    		desc = desc.substr(0,100)+"...";
    	html += "<tr class='"+className+"'><td>"+row[6]+"</td><td>"+row[5]+"</td>"+
    			"<td>"+arryType[row[1]]+"</td><td><span title='"+row[4]+"'>"+desc+"</span></td><td>"+stateName+"</td><td>"+ophtm+"</td></tr>";;
        i++;
        row = DataList[i];
    }
    $("#List_Body").html(html);

}

function FormatServerData(objData)
{
	if(objData == null)
	{
		$("#e_List_Body").html("");
        return;
	}
	if (objData.Success == false) {
        $("#e_List_Body").html("<tr><td colspan='3' class='tc_rad'>暂未有数据信息</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#e_List_Body").html("<tr><td colspan='3' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    
    _ListserverData = DataList;
    var i = 0;
    var row = DataList[i];
    var html =""; 
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var stateName = row[2] == 1 ? '<span style="color:#F00" >需同步</span>':row[2] == 0 ? '正常':row[2] == 99 ? "<span style='color:#F00' >已删除</span>":"";
    	var ophtm = '';
    	if(row[2] == 0)
    		ophtm = '[<a href="javascript:void(0);" onclick="javascript:btndelSendingOne(\'' + row[0] + '\')">删除</a>]';
    	html += "<tr class='"+className+"'><td width='50'>"+row[1]+"</td><td width='50'>"+stateName+"</td><td width='50'>"+ophtm+"</td></tr>";
        i++;
        row = DataList[i];
    }
    $("#e_List_Body").html(html);
}
