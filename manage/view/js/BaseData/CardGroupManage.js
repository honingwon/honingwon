var _URL = "../model/BaseData/CardGroupManageMentod.php";
var _msgURL = "链接出错";
var _Currenpage = 1;
var _CurrentPageLine = 20;

$(document).ready(function() {
	_Currenpage = 1;
	LoadData();
	$("#BtnclosecardGrop").bind("click",btnCloseClickHandler);
	$("#btnSave").bind("click",btnSaveClickHandler);
	$("#btnSearch").bind("click",btnSeachClickHandler);
});

function LoadData()
{
	var text = $("#searchcardName").val();
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "list","curpage":_Currenpage,"pagesize":_CurrentPageLine,"name":text},
		success: function(result) {
			FormatData(result);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function FormatData(objData)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body").html("<tr><td colspan='8' class='tc_rad'>暂未有数据信息</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#List_Body").html("<tr><td colspan='8' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    var i = 0;
    var row = DataList[i];
    var html =""; 
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var ophtm = '[<a href="javascript:void(0);" onclick="javascript:showEdite(\'' + row.GroupID + '\')">修改</a>]';
    	var stateHtm = '';
        switch (parseInt(row.GroupState)) {
            case 0: stateHtm = '已生成'; break;
            case 1: stateHtm = '启用'; break;
            case 90: stateHtm = '过期'; break;
            case 91: stateHtm = '锁定'; break;
            case 92: stateHtm = '作废'; break;
            default: stateHtm = '已生成'; break;
        }
        var ticker = row.Titicker == null ? "未提卡" :(row.Titicker == "" ? "未提卡":row.Titicker);
    	html += "<tr class='"+className+"'><td>"+row.FormName+"</td><td>"+row.FormID+"</td>"+
    			"<td>"+row.GroupID+"</td><td>"+row.FormApply+"</td><td>"+row.Checker+"</td><td>"+ticker+"</td><td class='tc_gray'>"+stateHtm+"</td><td class='operate'>"+ophtm+"</td></tr>";;
        i++;
        row = DataList[i];
    }
    var FSumCount = objData.Tag;
    var FPageCount = Math.ceil(FSumCount / _CurrentPageLine);
    var pagingation = new Pagination("Pagination1", FPageCount, _Currenpage, FSumCount, _CurrentPageLine, "PageChange", "divPagination", 1)
    $("#List_Body").html(html);
}

function PageChange(num)
{
	_Currenpage = num
	LoadData();
}

function showEdite(groupID)
{
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "groupinfo","ID":groupID},
		success: function(result) {
			if(result.Success){
				var groupInfo = result.DataList[0];
				$("#indexValue").val(groupInfo.GroupID);
				$("#tdGroupID").html(groupInfo.GroupID);
				$("#tdCardTypeName").html(groupInfo.CardTypeName);
				$("#tdCardNumber").html(groupInfo.CardNum);
				$("#tdApplyer").html(groupInfo.FormApply);
				$("#tdChecker").html(groupInfo.Checker);
				$("#tdCreateTime").html(groupInfo.CreatTime);
				$("#txtDate1").val(groupInfo.ChargeStartTime);
				$("#txtDate2").val(groupInfo.ChargeEndTime);
				$("#selState").val(groupInfo.GroupState);
				$("#divcardGrop").show();
			}
			else
				alert(result.Message);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function btnCloseClickHandler()
{
	$("#tdGroupID").html("");
	$("#tdCardTypeName").html("");
	$("#tdCardNumber").html("");
	$("#tdApplyer").html("");
	$("#tdChecker").html("");
	$("#tdCreateTime").html("");
	$("#txtDate1").val("");
	$("#txtDate2").val("");
	$("#selState").val(0);
	$("#indexValue").val("");
	$("#divcardGrop").hide();
}

function btnSaveClickHandler()
{
	var index = $("#indexValue").val();
	var startTime = $("#txtDate1").val();
	var endTime	= $("#txtDate2").val();
	var state = $("#selState").val(); 
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "update","ID":index,"s":startTime,"e":endTime,"state":state},
		success: function(result) {
			if(result.Success){
				alert("保存成功！");
				LoadData();
			}
			else
				alert(result.Message);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function btnSeachClickHandler()
{
	_Currenpage = 1;
	LoadData();
}