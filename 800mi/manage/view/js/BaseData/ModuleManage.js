var _URL = "../model/BaseData/ModuleManageMethod.php";
var _CurrentParentNode = null;
var _CurrentNode = null;
var _CurentNodeInfo = null;
var _EditOrAdd = null;
var autoTree = null;
$(document).ready(function() {
	getModuleList();
	$("#BtnclosePerServer").bind("click",function(){$("#perServer").hide();})
}); 

function getModuleList(){
	var dataStr = {"method": "Mlist" };
	$.ajax({
		type: "post",
		url: _URL,
		dataType: "json",
		data: dataStr,
		success: function(result) {
			if(result.Success){				
				initTree(result.DataList);
			}
			else
				alert(result.Message);
		},
		error: function(e) {
			alert("链接出错");
		}
	});
}

function initTree(obj)
{
	var array = new Array();
	for(var i = 0; i< obj.length; ++i){
		var ob = new Array();
		ob[0] = obj[i].module_id;
		ob[1] = obj[i].module_name;
		ob[2] = obj[i].fmodule_id;
		array.push(ob);
	}
	var rootNode = new TreeNode("0", "技术部", 1, null, null);
	AppendTreeChildNodes(rootNode, array);
    autoTree = new AutoTree(rootNode, "divAutoTree", "autoTree", null);
    autoTree.CreateTree();
}

function AppendTreeChildNodes(node, childArray) {
    var value = node.Level == 1 ? "0" : node.Value
    for (var i = 0; i < childArray.length; i++){
        if (childArray[i][2] == value){
            child = new TreeNode(childArray[i][0], childArray[i][1], node.Level + 1, null, node);
            node.AppendChildNode(child);
            AppendTreeChildNodes(child, childArray);
        }
    } 
}

function LoadNodeInformation(node) {//_CurrentParentNode
	if(node.Level == 1){
		_CurrentParentNode = null;
		_CurrentNode = node;
	}
	else if(node.Level > 1){
		_CurrentParentNode =node.ParentNode;
		_CurrentNode = node;
	}
	else{
		_CurrentParentNode = null;
		_CurrentNode = null;
	}
	$('#del').show();
    $('#edit').show();
    $('#add').show();
    $('#ser').show();
    $('#save').hide();
	
	LoadonemoduleData(node.Value);
}

function LoadonemoduleData($value)
{
	var dataStr = {"method": "row","ID": $value};
	$.ajax({
		type: "post",
		url: _URL,
		dataType: "json",
		data: dataStr,
		success: function(result) {
		     FormatData(result);
		},
		error: function() {
			alert("链接出错");
		}
	});
}

function FormatData(ListData)
{
	if (ListData == null || ListData.Success == false) {
		HideTable();
    }
    else {
        var DataList = ListData.DataList;
        if (DataList == null || DataList.length == 0) {
        	HideTable();
            //this.state = 0;
        }
        else {
            //this.state = 1;
        	_CurentNodeInfo = DataList[0];
            $('#SModuleFName').html(_CurrentParentNode.Text);
        	$('#SModuleName').html(_CurentNodeInfo.module_name);
        	var SModuleLevel = _CurentNodeInfo.module_level == 0 ? "总模块" : _CurentNodeInfo.module_level == 1 ? "分模块" : "其他";
            $('#SModuleLevel').html(SModuleLevel);
            $('#SModuleLinkPath').html(_CurentNodeInfo.module_url);
            $('#SModuleHander').html(_CurentNodeInfo.module_pri);
            var SModuleState = _CurentNodeInfo.module_state == 0 ? "普通显示" : _CurentNodeInfo.module_state == 1 ? "权限显示" : _CurentNodeInfo.module_state == 2 ? "隐藏" : _CurentNodeInfo.module_state == 99 ? "删除" : "其他";
            $('#SModuleState').html(SModuleState);
            $('#SModuleRemark').html(_CurentNodeInfo.module_remark);
            $('#newSModuleLinkPath').html(_CurentNodeInfo.fmodule_url);
            ShowOrHideTable(1, 0);
        }
    }
}

function AddData() {
	_EditOrAdd = "Add";
    $('#ShowModuleManageTable').hide();
    $('#EditModuleManageTable').show();
    $('#save').show();
    $('#edit').show();
    $('#EModuleName').val("");
    $('#newEModuleLinkPath').val("");
    $('#EModuleLinkPath').val("");
    $('#EModulePic').val("");
    $('#EModuleHander').val("");
    $('#EModuleRemark').val("");
    if (_CurrentNode.Level == 1)
        $('#EModuleFName').val("无");
    else
        $('#EModuleFName').html(_CurrentNode.Text);
    //清空错误消息
//    this.ShowMsg("EModuleName", "");
//    this.ShowMsg("newEModuleLinkPath", "");
//    this.ShowMsg("EModuleLinkPath", "");
//    this.ShowMsg("EModuleHander", "");
//    this.ShowMsg("EModuleRemark", "");
}

function EditData() {
	_EditOrAdd = "Edit";
    $('#EditModuleManageTable').show();
    $('#ShowModuleManageTable').hide();
    $('#save').show();
    $('#EModuleName').val(_CurentNodeInfo.module_name);
    $('#EModuleFName').html(_CurrentParentNode.Text);
    $('#EModuleLevel').val(_CurentNodeInfo.module_level);
    $('#newEModuleLinkPath').val(_CurentNodeInfo.fmodule_url);
    $('#EModuleLinkPath').val(_CurentNodeInfo.module_url);
    $('#EModuleHander').val(_CurentNodeInfo.module_pri);
    $('#EModuleState').val(_CurentNodeInfo.module_state);
    $('#EModuleRemark').val(_CurentNodeInfo.module_remark);
//    //清空错误消息
//    this.ShowMsg("EModuleName", "");
//    this.ShowMsg("newEModuleLinkPath", "");
//    this.ShowMsg("EModuleLinkPath", "");
//    this.ShowMsg("EModuleHander", "");
//    this.ShowMsg("EModuleRemark", "");
}

function SaveData() {
    var bm_ModuleName = $('#EModuleName').val();
    var bm_ModuleLevel = $('#EModuleLevel').val();
    var bm_FModuleUrl = $('#newEModuleLinkPath').val();
    var bm_ModuleUrl = $('#EModuleLinkPath').val();
    var bm_ModulePRI = $('#EModuleHander').val();
    var bm_ModuleState = $('#EModuleState').val();
    var bm_ModuleRemark = $('#EModuleRemark').val();


    if (_EditOrAdd == "Add") {
        var dataStr = {"method": _EditOrAdd,"name":bm_ModuleName,"lev":bm_ModuleLevel,"furl":bm_FModuleUrl,
        		       "url":bm_ModuleUrl,"pri":bm_ModulePRI,"state":bm_ModuleState,"dec":bm_ModuleRemark,"ID":_CurrentNode.Value};
    	$.ajax({
    		type: "post",
    		url: _URL,
    		dataType: "json",
    		data: dataStr,
    		success: function(result) {
    			if(result.Success){
    				alert("新增成功");
    				var aNewNodeLevel = _CurrentNode.Level + 1;
    		        var aNewnode = new TreeNode(result.Tag, bm_ModuleName, aNewNodeLevel, null, _CurrentNode);
    		        autoTree.InsertNode(aNewnode);
    		        LoadonemoduleData(_CurrentNode);
    			}
    		},
    		error: function(e) {
    			alert("链接出错");
    		}
    	});
    }
    //编辑的情况保存

    if (_EditOrAdd == "Edit") {
        var dataStr1 = {"method": _EditOrAdd,"name":bm_ModuleName,"lev":bm_ModuleLevel,"furl":bm_FModuleUrl,
 		       "url":bm_ModuleUrl,"pri":bm_ModulePRI,"state":bm_ModuleState,"dec":bm_ModuleRemark,"ID":_CurrentNode.Value};
        $.ajax({
        	type: "post",
        	url: _URL,
        	dataType: "json",
        	data: dataStr1,
        	success: function(result) {
				if(result.Success){
					$('#ShowModuleManageTable').hide();
					$('#EditModuleManageTable').hide();
					$('#save').hide();
					$('#edit').show();
					$('#del').show();
					$('#add').show();
					autoTree.currentSpan.innerHTML = bm_ModuleName;
					autoTree.currentNode.Text = bm_ModuleName;
					LoadonemoduleData(_CurrentNode.Value);
				}
			},
			error: function(e) {
				alert("链接出错");
			}
        }); 
    }
}

function DelData()
{
	if(_CurrentNode.ChildNodes != null){
		alert("该模块下有子模块,无法删除!");
	}
	else{
		if (!confirm("您确定删除?"))
            return;
		else{
			var dataStr = {"method": "Del","ID":_CurrentNode.Value};
			$.ajax({
	        	type: "post",
	        	url: _URL,
	        	dataType: "json",
	        	data: dataStr,
	        	success: function(result) {
				   	if(result.Success){
					   alert("删除成功！");
					   autoTree.RemoveNode();
					   LoadNodeInformation(_CurrentNode.ParentNode);
				   	}
				   	else
				   		alert(result.Message);
				},
				error: function(e) {
					alert("链接出错");
				}
	        }); 
		}
	}
}

function ShowOrHideTable(ModuleTable, EditTable) {
    if (ModuleTable == 0) {
        $('#ShowModuleManageTable').hide();
    } else {
        $('#ShowModuleManageTable').show();
    }

    if (EditTable == 0) {
        $('#EditModuleManageTable').hide();
    }
    else {
        $('#EditModuleManageTable').show();
    }
}

function HideTable()
{
	$('#ShowModuleManageTable').hide();
    $('#EditModuleManageTable').hide();
    $('#save').hide();
    $('#edit').hide();
    $('#del').hide();
    $('#ser').hide();
}

function DoServerRight()
{
//	$("#perServer").show();
//	alert(_CurrentNode.Value);
//	initData(_CurrentNode.Value,_CurentNodeInfo.bm_ModuleName);
}
