var _URL = "../model/BaseData/CardCheckMethod.php";
var _msgURL = "链接出错";
var _Currenpage = 1;
var _CurrentPageLine = 20;

$(document).ready(function() {
	_Currenpage = 1;
	LoadData();
	$("#BtncloseCardCheck").bind("click",btnCloseClickHandler);
	$("#btnClose").bind("click",btnCloseClickHandler);
	$("#btnPass").bind("click",btnDopassClickHandler);
	$("#btnUnPass").bind("click",btnDoUnpassClickHandler);
});

function LoadData()
{
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "List","curpage":_Currenpage,"pagesize":_CurrentPageLine},
		success: function(result) {
			FormatData(result);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function FormatData(objData)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body").html("<tr><td colspan='4' class='tc_rad'>暂未有数据信息</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#List_Body").html("<tr><td colspan='4' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    var i = 0;
    var row = DataList[i];
    var html ="";
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var ophtm = '[<a href="javascript:void(0);" onclick="javascript:ShowCardCheck(\'' + row.cardFormID + '\')">审核</a>]';
    	html += "<tr class='"+className+"'><td>"+row.cardFormName+"</td><td>"+row.cardApplyer+"</td><td class='tc_gray'>"+row.cardApplyTime+"</td><td class='operate'>"+ophtm+"</td></tr>";;
        i++;
        row = DataList[i];
    }
    var FSumCount = objData.Tag;
    var FPageCount = Math.ceil(FSumCount / _CurrentPageLine);
    var pagingation = new Pagination("Pagination1", FPageCount, _Currenpage, FSumCount, _CurrentPageLine, "PageChange", "divPagination", 1)
    $("#List_Body").html(html);//divcardCheck
}
function PageChange(num)
{
	_Currenpage = num
	LoadData();
}

function ShowCardCheck(value)
{
	$.ajax({type: "post",url: "../model/BaseData/CardApplyMethod.php",dataType: "json",data: {"method": "cardInfo","ID":value},
		success: function(result) {
			if(result.Success){
				if(result.DataList.length >=1){
					var cardInfo = result.DataList[0][0];
					$("#indexValue").val(cardInfo.cardFormID);
					$("#tdFormName").html(cardInfo.cardFormName);
					$("#tdApplyer").html(cardInfo.cardApplyer);
					$("#tdApplyerTime").html(cardInfo.cardApplyTime);
					$("#tdRemark").html(cardInfo.cardFormRemark);
					$("#divcardCheck").show();
				}
				var html ="";
				if(result.DataList.length >=2){
					var itemInfo = result.DataList[1];
					for(var i = 0;i< itemInfo.length;++i){
						if(html!="")
							html += "</br>";
						html += itemInfo[i][3] + "&nbsp;"+itemInfo[i][2]+"张;";
					}
				}
				$("#cardInfo").html(html);
			}
			else{
				if(result.Message != "")
					alert(result.Message);
				else
					alert("请检查道具卡是否绑定道具信息！");
			}
		},
		error: function(e) {alert(_msgURL);}
	});
}

function btnCloseClickHandler()
{
	$("#indexValue").val("");
	$("#tdFormName").html("");
	$("#tdApplyer").html("");
	$("#tdApplyerTime").html("");
	$("#tdRemark").html("");
	$("#cardInfo").html("");
	$("#divcardCheck").hide();
}

function btnDopassClickHandler()
{
	var remark = $('#CheckApperTitleDesc').val();
	if (strlen(Trim(remark)) < 1 || strlen(Trim(remark)) > 128) {
        setOnbur("CheckApperTitleDesc","审核说明在1-128个字符之内！");
        return;
    }
	var index = $("#indexValue").val();
	if(index == ""){
		alert("请刷新后再试！");
		return;
	}
	if (!confirm("您确认要通过吗？")) return;
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "done","ID":index,"dec":remark},
		success: function(result) {
			if(!result.Success)
				alert(result.Tag);
			else{
				btnCloseClickHandler();
				LoadData();
			}
		},
		error: function(e) {alert(_msgURL);}
	});
}

function btnDoUnpassClickHandler()
{
	var remark = $('#CheckApperTitleDesc').val();
	if (strlen(Trim(remark)) < 1 || strlen(Trim(remark)) > 128) {
        setOnbur("CheckApperTitleDesc","审核说明在1-128个字符之内！");
        return;
    }
	var index = $("#indexValue").val();
	if(index == ""){
		alert("请刷新后再试！");
		return;
	}
	if (!confirm("您确认要不通过吗？")) return;
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "Undone","ID":index,"dec":remark},
		success: function(result) {
			if(!result.Success)
				alert(result.Tag);
			else{
				btnCloseClickHandler();
				LoadData();
			}
		},
		error: function(e) {alert(_msgURL);}
	});
	
}