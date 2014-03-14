var _MURL = "../model/BaseData/ModuleManageMethod.php";
var _autoCheckTree = null;
var _McurrentAccountID = null;
var _McurrentAccountName = null;

function pageLoading()
{
	getAllModuleList();
}

function initMouldeRightData(AccountID,AccountName)
{
	_McurrentAccountID = AccountID;
	_McurrentAccountName = AccountName;
	GetModuleRights();
	$("#moduleTitle").html("设置功能权限&nbsp姓名："+_McurrentAccountName);
	$("#btnModuleSave").bind("click",btnUpdateModuleRightClickHandler)
}

function getAllModuleList()
{
	$.ajax({type: "post",url: _MURL,dataType: "json",data: {"method": "Mlist" },
		success: function(result) {
			if(result.Success){
				initAutoCheckTree(result.DataList);
			}
			else
				alert(result.Message);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function initAutoCheckTree(obj)
{
	var array = new Array();
	for(var i = 0; i< obj.length; ++i){
		var ob = new Array();
		ob[0] = obj[i].bm_ModuleID;
		ob[1] = obj[i].bm_ModuleName;
		ob[2] = obj[i].bm_FModuleID;
		array.push(ob);
	}
	var rootNode = new TreeCheckNode("0", "页游部", 1, null, null);
	AppendTreeChildNodes(rootNode, array);
    _autoCheckTree = new AutoCheckTree(rootNode, "divAutoCheckTree", "autoCheckTree", null);
    _autoCheckTree.CreateTree();
}

function AppendTreeChildNodes(node, childArray) {
    var value = node.Level == 1 ? "0" : node.Value
    for (var i = 0; i < childArray.length; i++){
        if (childArray[i][2] == value){
            child = new TreeCheckNode(childArray[i][0], childArray[i][1], node.Level + 1, null, node);
            node.AppendChildNode(child);
            AppendTreeChildNodes(child, childArray);
        }
    } 
}

function GetModuleRights()
{
	$.ajax({type: "post",url: _RURL,dataType: "json",data: {"method": "sModuleList","ID":_McurrentAccountID},
		success: function(result) {
			if(result.Success){
				if(result.DataList != null)
					_autoCheckTree.InitializeCheck(result.DataList);
			}
		},
		error: function(e) {alert(_msgURL);}
	});
}

function btnUpdateModuleRightClickHandler()
{
	var rightArray = _autoCheckTree.GetRightChangeArray();
	var strAdd = rightArray[0].join();
	var strDel = rightArray[1].join();
	if(strAdd == "" && strDel == "") return;
	$.ajax({type: "post",url: _RURL,dataType: "json",data: {"method": "sModuleUpdate","ID":_McurrentAccountID,"Add":strAdd,"Del":strDel},
		success: function(result) {
			if(result.Message != ""){
				alert(result.Message);
			}
			else
				alert("保存成功！");
			GetModuleRights();
		},
		error: function(e) {alert(_msgURL);}
	});
}