var _AGURL = "../model/BaseData/GroupManageMethod.php";
var _GroupList = null;
var _AGcurrentID = null;
var _AGcurrentName = null;
var _AccountGroupList = null;


function initAccountGroupData(AccountID,AccountName)
{
	_AGcurrentID = AccountID;
	_AGcurrentName = AccountName;
	if(_GroupList == null)
	{
		$.ajax({type: "post",url: _AGURL,dataType: "json",data: {"method": "List"},
			success: function(result) {
				if(result.Success){
					_GroupList = result.DataList;
					FormatGroupAccountData();
				}
				else
					alert(result.Message);
				},
			error: function(e) {alert(_msgURL);}
		});
	}
	else{
		FormatGroupAccountData();
	}
	$("#groupTitle").html("设置所在分组&nbsp姓名："+_AGcurrentName);
	$("#btnGroupSave").bind("click",btnUpdateAccountGroupClickHandler);
}

function FormatGroupAccountData()
{
	$.ajax({type: "post",url: _RURL,dataType: "json",data: {"method": "sGroupList","ID":_AGcurrentID},
		success: function(result) {
		   _AccountGroupList  = result.DataList;
			var html ="";
			if(_GroupList == null)
				$("#GroupList").html(html);
			else{
				if (_GroupList != null && _GroupList.length > 0) {
					for (var i = 0; i < _GroupList.length; i++) {
						if(!isHasInGroup(_GroupList[i].bm_GroupID))
							html +="<li><label><input type='checkbox' name='groupcheckname' class='checkbox' id='"+_GroupList[i].bm_GroupID+"' />"+_GroupList[i].bm_GroupName+"</label></li>";
						else
							html +="<li><label><input type='checkbox' name='groupcheckname' class='checkbox' checked='checked' id='"+_GroupList[i].bm_GroupID+"' />"+_GroupList[i].bm_GroupName+"</label></li>";
					}
				}
			}
			$("#GroupList").html(html);	
		},
		error: function(e) {alert(_msgURL);}
	});
}

function btnUpdateAccountGroupClickHandler()
{
	var addStr = "";
	var delStr = "";
	l = document.getElementsByTagName("input");
    for (i = 0; i < l.length; i++) {
        if (l[i].type == 'checkbox' && l[i].name == 'groupcheckname') {
            if (l[i].checked == true) {
                if(!isHasInGroup(l[i].id)){
                	if(addStr != "")
                    	addStr += ",";
            		addStr += "("+_AGcurrentID+","+l[i].id+")";
                }
            }
            else{
            	if(isHasInGroup(l[i].id)){
            		if(delStr != "")
            			delStr += ",";
            		delStr += l[i].id;
            	}
            }
        }
    }
    UpdateAccountGroup(addStr,delStr);
}

function isHasInGroup(groupID)
{
	var re = false;
	if(_AccountGroupList == null) return re;
	for (var i = 0; i < _AccountGroupList.length; i++) {
		if(groupID == _AccountGroupList[i][0]){
			re = true;
			break;
		}
	}
	return re;
}

function GetAccountAllGroup()
{
	if(_AGcurrentID == null) return;
	$.ajax({type: "post",url: _RURL,dataType: "json",data: {"method": "sGroupList","ID":_AGcurrentID},
		success: function(result) {
		   _AccountGroupList  = result.DataList;
		},
		error: function(e) {alert(_msgURL);}
	});
}

function UpdateAccountGroup(strAdd,strDel)
{
	if(strAdd == "" &&  strDel == "") return;
	$.ajax({type: "post",url: _RURL,dataType: "json",data: {"method": "sAGUpdate","ID":_AGcurrentID,"Add":strAdd,"Del":strDel},
		success: function(result) {
			if(result.Message != ""){
				alert(result.Message);
			}
			else
				alert("保存成功！");
			GetAccountAllGroup();
		},
		error: function(e) {alert(_msgURL);}
	});
}