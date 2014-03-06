var _URL = "../model/BaseData/CardItemManageMethod.php";
var _msgURL = "链接出错";
var _ItemID = null;
var _Currenpage = 1;
var _CurrentPageLine = 10;

$(document).ready(function() {
	LoadGameInfo();
	$("#btnAddGameItem").bind("click",btnAddGameItemClickHandler);
	$("#BtncloseItemEdit").bind("click",btnCloseItemEditClickHandler);
	$("#btnItemSave").bind("click",btnItemSaveClickHandler);
	$("#btnSearch").bind("click",function(){
		LoadCardList();
	})
});

function LoadGameInfo()
{
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "game"},
		success: function(result) {
			var object  = $("#selGame")[0];
			var object1 = $("#selGame1")[0];
			object.options.length = 0;object1.options.length = 0;
			object1.options.add(new Option("--请选择卡种类--", "-1"));
			if(result.Success && result.DataList.length > 0)
			{
				var selValue = -1;
				 for (var i = 0; i < result.DataList.length; i++) {
			        	var row = result.DataList[i];
			        	object.options.add(new Option(row.bm_GameName, row.bm_GameID));
			        	object1.options.add(new Option(row.bm_GameName, row.bm_GameID));
			        	if(i == 0)
			        		selValue = row.bm_GameID;
			     }
				 $("#selGame").val(selValue);
				 LoadCardList();
			}
			else
				object.options.add(new Option("--请选择卡种类--", "-1"));
		},
		error: function(e) {alert(_msgURL);}
	});
}

function LoadCardList()
{
	var gameID = $("#selGame").val();
	var itemName = $("#txtSearchName").val();
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "itemList","curpage":_Currenpage,"pagesize":_CurrentPageLine,"ID":gameID,"txt":itemName},
		success: function(result) {
			FormatData(result);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function FormatData(Data) {
    var TbodyObj = new Tbody(4, 'List_Body');
    TbodyObj.DelAll();
    if (Data == null || Data.IsSuccess == false) {
        TbodyObj.AddRow(new Array('系统忙,请重试！'));
    }
    else {
        var DataList = Data.DataList;
        if (DataList == null || DataList.length == 0) {
            TbodyObj.AddRow(new Array('没有相关数据！'));
        }
        else {
            var i = 0;
            var row = DataList[i];
            while (row != null) {
                var ophtm = '[<a href="javascript:void(0);" onclick="OPModify(\'' + row.ItemID + '\',\'' + row.GameID + '\',\'' + escape(row.ItemName) + '\',\'' + row.ItemGID + '\',\'' + escape(row.ItemRemark) + '\',\'' + row.ItemRank + '\')">修改</a>]';
                ophtm += ' [<a href="javascript:void(0);" onclick="Del(\'' + row.ItemID + '\')">删除</a>]';
                TbodyObj.AddRow(new Array(row.ItemName, row.ItemRank == 99 ? "有叠加" : "无叠加", row.ItemGID, ophtm), null, null)
                i++;
                row = DataList[i];
            }
        }
        var FSumCount = Data.Tag;
        var FPageCount = Math.ceil(FSumCount / _CurrentPageLine);
        var pagingation = new Pagination("Pagination1", FPageCount, _Currenpage, FSumCount, _CurrentPageLine, "PageChange", "divPagination", 1);
    }
}

function PageChange(num)
{
	_Currenpage = num
	LoadCardList();
}

function OPModify(index,gameID,itemName,itemGID,remark,rank)
{
	_ItemID = index;
	$('#selGame1').attr('disabled', 1);
	initEditData(gameID,itemName,itemGID,remark,rank);
	$("#ItemEdit").show();
}

function Del(index)
{
	if (!confirm("您确定删除?"))
        return;
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "del","ID":index},
		success: function(result) {
		   if(result.Success){
			    alert("删除成功");
			    btnCloseItemEditClickHandler();
				_Currenpage = 1;
				LoadCardList();
			}
		},
		error: function(e) {alert(_msgURL);}
	});
}

function initEditData(gameID,itemName,itemGID,remark,rank)
{
	$("#selGame1").val(gameID == null ? -1 : gameID);
	$("#itemName").val(itemName == null ? "" : unescape(itemName));
	$("#GameitemName").val(itemGID == null ? "" : itemGID);
	$("#SelectItemRank").val(rank == null ? 1 :rank);
	$("#ARemark").val(remark == null ? "" : unescape(remark));
}

function btnAddGameItemClickHandler()
{
	_ItemID = null;
	$('#selGame1').attr('disabled', 0);
	initEditData(null,null,null,null,null);
	$("#ItemEdit").show();
}

function btnCloseItemEditClickHandler()
{
	_ItemID = null;
	$("#ItemEdit").hide();
}

function btnItemSaveClickHandler()
{
	var gameValue = $("#selGame1").val();
	var itemName = $("#itemName").val();
	var gameItemName = $("#GameitemName").val();
	var itemRank =	$("#SelectItemRank").val();
	var remark = $("#ARemark").val();
	if(gameValue == -1){
		setOnburPline('selGame1',"请选择游戏种类！");
		return;
	}
	setOnburPline('selGame1',"");
	
	if(strlen(Trim(itemName)) < 0 || strlen(Trim(itemName)) > 50){
		setOnburPline('itemName',"物品名称在1-50个字符内！");
		return;
	}
	setOnburPline('itemName',"");
	
	if(strlen(Trim(gameItemName)) < 0 || strlen(Trim(gameItemName)) > 50){
		setOnburPline('GameitemName',"游戏中物品ID编号在1-50个字符内！");
		return;
	}
	setOnburPline('GameitemName',"");
	
	if(strlen(Trim(remark)) > 200){
		setOnburPline('ARemark',"说明在200个字符内！");
		return;
	}
	setOnburPline('ARemark',"");
	
	if(_ItemID == null){
		$.ajax({type: "post",url: _URL,dataType: "json",
			data: {"method": "add","ID":gameValue,"name":itemName,"gid":gameItemName,"rank":itemRank,"dec":remark},
			success: function(result) {
				if(result.Success){
					alert("新增成功");
					btnCloseItemEditClickHandler();
					_Currenpage = 1;
					LoadCardList();
				}
				else
					alert("新增失败："+result.Message);
			},
			error: function(e) {alert(11);}
		});
	}
	else{
		$.ajax({type: "post",url: _URL,dataType: "json",
			data: {"method": "update","ID":_ItemID,"name":itemName,"gid":gameItemName,"rank":itemRank,"dec":remark},
			success: function(result) {
				if(result.Success){
					alert("修改成功");
					_Currenpage = 1;
					LoadCardList();
				}
				else
					alert("修改失败："+result.Message);
			},
			error: function(e) {alert(11);}
		});
	}
}