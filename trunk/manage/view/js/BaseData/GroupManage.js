var _URL = "../model/BaseData/GroupManageMethod.php";
var _msgURL = "链接出错";
var _List = null;
var _CurrentInfo = null;

$(document).ready(function() {
	initInputData("","");
	LoadData();
	$("#btnSave").bind("click",btnSaveClick);
	$("#btnCancel").bind("click",btnCancelClick);
	$("#BtncloseGModule").bind("click",function(){$("#perGModule").hide();})
	pageLoadingTree();
}); 

function LoadData()
{
	var dataStr = {"method": "List" };
	$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
		success: function(result) {
			if(result.Success){
				FormatData(result);
			}
			else
				alert(result.Message);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function FormatData(ListData)
{
	_List = null;
	var TbodyObj = new Tbody(4, 'List_Body');
    TbodyObj.DelAll();
    if (ListData == null || ListData.IsSuccess == false) {
        TbodyObj.AddRow(new Array('系统忙,请重试！'));
    }
    else {
        var DataList = ListData.DataList;
        _List = DataList;
        if (DataList == null || DataList.length == 0) {
            TbodyObj.AddRow(new Array('没有相关数据！'));
        }
        else {
            var i = 0;
            var row = DataList[i];
            while (row != null) {
            	      
            	var ophtm = '[<a href="javascript:void(0);" onclick="javascript:Update(\'' + row.bm_GroupID + '\',this)">修改</a>]'+
            				'[<a href="javascript:void(0);" onclick="javascript:DoGroupModuleRights(\'' + row.bm_GroupID + '\',\'' + row.bm_GroupName + '\')">设置功能权限</a>]';
            	var className = new Array();
            	className.push("");className.push("");className.push("operate");
                TbodyObj.AddRow(new Array(row.bm_GroupID, row.bm_GroupName, row.bm_RankRemark, ophtm),className,null,null,null,null,"even");
                i++;
                row = DataList[i];
                $("tr").addClass("even");  
            }
        }
    }
}

function Update(value,obj)
{
	_CurrentInfo = null;
	if(_List != null){
		for(var i = 0 ;i < _List.length ; ++i){
		   if(value == _List[i].bm_GroupID){
			   _CurrentInfo = _List[i];
			   break;
		   }
		}
		if(_CurrentInfo != null){
			initInputData(_CurrentInfo.bm_GroupName,_CurrentInfo.bm_RankRemark);
		}
	}
}

function btnSaveClick()
{
	var falgName = checkName();
	var falgDesc = checkRemark();
	if(falgName && falgDesc){
		if(_CurrentInfo == null){
			var dataStr = {"method": "Add","name": $("#name").val(),"dec":$("#dec").val()};
			$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
				success: function(result) {
					if(result.Success){
						alert("新增成功");
						initInputData("","");
						LoadData();
					}
					else
						alert(result.Message);
				},
				error: function(e) {alert(_msgURL);}
			});
		}
		else{
			var dataStr = {"method": "edit","name": $("#name").val(),"dec":$("#dec").val(),"ID":_CurrentInfo.bm_GroupID};
			$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
				success: function(result) {
					if(result.Success){
						alert("修改成功");
						initInputData("","");
						_CurrentInfo = null;
						LoadData();
					}
					else
						alert(result.Message);
				},
				error: function(e) {alert(_msgURL);}
			});
		}
	}
}

function btnCancelClick(){
	initInputData("","");
	_CurrentInfo = null;
}

function checkName()
{
	var name = $("#name").val();
	if(name.length <= 0 || name.length >32){
		setOnbur("name","请您输入分组的名称，在0-32个字符之内！");
		return false;
	}
	else{
		setOnbur("name","");
		return true;
	}
}

function checkRemark()
{
	var dec = $("#dec").val();
	if(dec.length <= 0 || dec.length > 128){
		setOnbur("dec","请您输入分组的描述，在0-128个字符之内！");
		return false;
	}
	else{
		setOnbur("dec","");
		return true;
	}
}

function initInputData(name,remark)
{
	$("#name").val(name);
	$("#dec").val(remark);
	if(name == "")
		$("#btnCancel").hide();
	else
		$("#btnCancel").show();
}
function setOnbur(id, message) {
    if ($("#" + id).parent().find("#check" + id).size() == 0)
        $("#" + id).after("<span id=\"check" + id + "\"  class=\"tc_rad\"/>");
    $("#check" + id).html(message);
}

function DoGroupModuleRights(groupID,groupName)
{
	initMouldeRightData(groupID,groupName);
	$("#perGModule").show();
}