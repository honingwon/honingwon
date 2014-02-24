var _RURL = "../model/BaseData/RightsManageMethod.php";
var _PageSelGame = "selGame";
var _PageSelArea = "selArea";
var _PageServerList = "serverList";
var _GameList = null;
var _AreaList = null;
var _ServList = null;
var _CurrentAccountID = null;
var _CurrentAccountName = "";
var _AccountRight = null;

function initData(AccountID,AccountName)
{
	alert(1);
	_CurrentAccountID = AccountID;
	_CurrentAccountName = AccountName;
	_AccountRight = null;
	$("#"+_PageServerList).html("");
	if(_GameList == null){
		$.ajax({type: "post",url: _RURL,dataType: "json",data: {"method": "game"},
			success: function(result) {
				_GameList = result.DataList[0];
				_AreaList = result.DataList[1];
				_ServList = result.DataList[2];
				intselectData(true);
			},
			error: function(e) {alert(_msgURL);}
		});
	}
	else
		intselectData(true);
	$("#servTitle").html("设置服务器权限&nbsp姓名："+_CurrentAccountName);
	$("#serAllCheck").attr("checked",false);
	$("#serAllCheck").bind("click",function(){$("input[name='servcheckname']").each(function() { this.checked = $("#serAllCheck").attr("checked"); });})
	$("#btnServSave").bind("click",btnUpdateRightClickHandler);
}

function intselectData(tag)
{
	$.ajax({type: "post",url: _RURL,dataType: "json",data: {"method": "sRightList","ID":_CurrentAccountID},
		success: function(result) {
				_AccountRight = result.DataList;
				SelectAddOptions($("#"+_PageSelGame),_GameList,true,"请选择游戏种类");
				SelectAddOptions($("#"+_PageSelArea),_AreaList,true,"请选择游戏分区"); 
				if(tag)
					if(_GameList.length > 0)
						$("#"+_PageSelGame).val(_GameList[0][1]);
				initServerList();
		},
		error: function(e) {alert(_msgURL);}
	});
}

function selGameChange()
{
	var gameValue = $("#"+_PageSelGame).val();
	if(gameValue == -1)
		SelectAddOptions($("#"+_PageSelArea),_AreaList,true,"请选择游戏分区");
	else{
		var object = $("#"+_PageSelArea)[0];
		object.options.length = 0;
		object.options.add(new Option("请选择游戏分区", "-1"));
		if (_AreaList != null && _AreaList.length > 0) {
	        for (var i = 0; i < _AreaList.length; i++) {
	        	var row = _AreaList[i];
	        	if(row[2] == gameValue)
	        		object.options.add(new Option(row[0], row[1]));
	        }
	    }
	}
	initServerList();
}

function selAreaChange()
{
	var areaValue = $("#"+_PageSelArea).val();
	if(areaValue != -1)
	{
		if (_AreaList != null && _AreaList.length > 0) {
			for (var i = 0; i < _AreaList.length; i++) {
				if(_AreaList[i][1] == areaValue){
					$("#"+_PageSelGame).val(_AreaList[i][2]);
				}
			}
		}
	}
	initServerList();
}

function initServerList()
{
	var gameValue = $("#"+_PageSelGame).val();
	var areaValue = $("#"+_PageSelArea).val();
	if(gameValue == -1){
		$("#"+_PageServerList).html("");
	}
	else{
		var html ="";
		if (_ServList != null && _ServList.length > 0) {
			for (var i = 0; i < _ServList.length; i++) {
				var checked = CheckServerISChecked(_ServList[i][0]);
				if(checked){
					if(areaValue == -1 && _ServList[i][3] == gameValue)
						html +="<li><label><input type='checkbox' name='servcheckname' checked='"+checked+"' class='checkbox' id='"+_ServList[i][0]+"' />"+_ServList[i][1]+"</label></li>";
					else if(areaValue == _ServList[i][2] && _ServList[i][3] == gameValue)
						html +="<li><label><input type='checkbox' name='servcheckname' class='checkbox' checked='"+checked+"' id='"+_ServList[i][0]+"' />"+_ServList[i][1]+"</label></li>";
				}
			}
		}
		$("#"+_PageServerList).html(html);
	}
}

function SelectAddOptions(obj, Data, isNull, DefName) {
    var object = obj[0];
    if (!obj[0]) {return;}
    object.options.length = 0;
    if (isNull) {
        if (DefName) {
            object.options.add(new Option(DefName, "-1"));
        }
        else {
            object.options.add(new Option("请选择", "-1"));
        }

    }
    if (Data != null && Data.length > 0) {
        for (var i = 0; i < Data.length; i++) {
        	var row = Data[i];
            object.options.add(new Option(row[0], row[1]));
        }
    }
}

function btnUpdateRightClickHandler()
{
	var gameValue = $("#"+_PageSelGame).val();
	var areaValue = $("#"+_PageSelArea).val();
	var addStr = "";
	var delStr = "";
	l = document.getElementsByTagName("input");
    for (i = 0; i < l.length; i++) {
        if (l[i].type == 'checkbox' && l[i].name == 'servcheckname') {
            if (l[i].checked == true) {
                if(!CheckServerISChecked(l[i].id)){
                	if(areaValue != -1){
                		if(addStr != "")
                    		addStr += ",";
                		addStr += "("+ gameValue +","+ areaValue +","+ l[i].id +","+ _CurrentAccountID +")";
                	}
                	else{
                		var area_Value = returnServrRightsInfo(l[i].id); 
                		if(area_Value != "")
                		{
                			if(addStr != "")
                        		addStr += ",";
                			addStr += "("+gameValue+","+area_Value+","+l[i].id+","+_CurrentAccountID+")";
                		}
                	}
                }
            }
            else{
            	if(CheckServerISChecked(l[i].id)){
            		if(delStr != "")
            			delStr += ",";
            		delStr += l[i].id;
            	}
            }
        }
    }
    updateRight(addStr,delStr);
}

function CheckServerISChecked(serverID)
{
	var re = false;
	if(_AccountRight == null) return re;
	for (var i = 0; i < _AccountRight.length; i++) {
		if(_AccountRight[i][2] == serverID && _AccountRight[i][3] == _CurrentAccountID){
			re = true;
			break;
		}
	}
	return re;
}

function returnServrRightsInfo(serverID)
{
	var re = "";
	if (_ServList != null && _ServList.length > 0) {
		for (var i = 0; i < _ServList.length; ++i) { 
			if(serverID == _ServList[i][0]){
				re = _ServList[i][2];
				break
			}
		}
	}
	return re;
}

function updateRight(strAdd,strDel)
{
	if(strAdd == "" &&  strDel == "") return;
	$.ajax({type: "post",url: _RURL,dataType: "json",data: {"method": "sRightUpdate","ID":_CurrentAccountID,"Add":strAdd,"Del":strDel},
		success: function(result) {
			if(result.Message != ""){
				alert(result.Message);
			}
			else
				alert("保存成功！");
			GetAccountAllServerRight(_CurrentAccountID);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function GetAccountAllServerRight(accountID){
	if(accountID==null) return;
	$.ajax({type: "post",url: _RURL,dataType: "json",data: {"method": "sRightList","ID":accountID},
		success: function(result) {
			if(result.Success){
				_AccountRight = result.DataList;
			}
			else
				_AccountRight = 1;
		},
		error: function(e) {alert(_msgURL);}
	});
}