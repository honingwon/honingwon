var _URL = "../model/BaseData/CardAffixItemManageMethod.php";
var _msgURL = "链接出错";
var _CardTypeData = null;
var _CardItemData = null;
var _OPIndex = null;
var _CardTbodyObj =null;
var _Currenpage = 1;
var _CurrentPageLine = 12;

function LoadCardType()
{
	var txtTypeName = $("#txtTypeName").val();
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "CardTypeList","txt":txtTypeName},
		success: function(result) {
			FormatCardType(result);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function LoadGame()
{
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "game"},
		success: function(result) {
			var object = $("#selGame")[0];
			object.options.length = 0;
			object.options.add(new Option("请选择卡种类", "-1"));
			var selValue = -1;
			if(result.Success && result.DataList.length > 0)
			{
				 for (var i = 0; i < result.DataList.length; i++) {
			        	var row = result.DataList[i];
			        	object.options.add(new Option(row.bm_GameName, row.bm_GameID));
			        	if(i==0)
			        		selValue = row.bm_GameID;
			     }
			}
			$("#selGame").val(selValue);
			LoadGameItem();
		},
		error: function(e) {alert(_msgURL);}
	});
}
function selGamechange()
{
	LoadGameItem();
}

function LoadGameItem()
{
	var selGame = $("#selGame").val();
	var txtName = $("#txtName").val();
	var TbodyObj = new Tbody(4, 'List_Body2');
    TbodyObj.DelAll();
	if(selGame == -1){
		 TbodyObj.AddRow(new Array('请先选择游戏！'));
	}
	else{
		$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "gameitem","curpage":_Currenpage,"pagesize":_CurrentPageLine,"ID":selGame,"txt":txtName},
			success: function(result) {
				if (result == null || result.IsSuccess == false) {
					TbodyObj.AddRow(new Array('系统忙,请重试！'));
				}
				else {
					 	var DataList = result.DataList;
			            if (DataList == null || DataList.length == 0) {
			                TbodyObj.AddRow(new Array('没有相关数据！'));
			            }
			            else {
			                var i = 0;
			                var row = DataList[i];
			                while (row != null) {
			                    var checkbox = '<input type="checkbox" name="ItemCheckbox" class="checkbox" value=\'' + row.ItemID + '\' onclick="javascript:showInputNum(this,this.checked);" />';

			                    TbodyObj.AddRow(new Array(checkbox, row.ItemName, '', ''));
			                    i++;
			                    row = DataList[i];
			                }
			                var FSumCount = result.Tag;
			                var FPageCount = Math.ceil(FSumCount / _CurrentPageLine);
			                var pagingation = new Pagination("Pagination1", FPageCount, _Currenpage, FSumCount, _CurrentPageLine, "PageChange", "divPagination", 1);
			            }
				}
			},
			error: function(e) {alert(_msgURL);}
		});
	}
}

function PageChange(num)
{
	_Currenpage = num
	LoadGameItem();
}

function btnSearchItemClickHandler()
{
	_Currenpage  = 1;
	LoadGameItem();
}

function Change(obj, type) {
    var atr = obj.getElementsByTagName("tbody")[0].getElementsByTagName("tr");
    for (i = 0; i < atr.length; i++) {
        try {
            var atd = atr[i].getElementsByTagName("td");
            if (atd[0].className == "hint" || atd[1].className == "hint") continue;
        } catch (e) { }
        //if (atr[i].id == "undefined") { return; }
        if (type == 1) {
            atr[i].onclick = function() {
                if (!obj.selectTR) obj.selectTR = this;
                obj.selectTR.className = "";
                if (this.className != "selected") { 
                	LoadCardItemData(this.rowIndex - 1);
                }
                this.className = "selected";
                obj.selectTR = this;

            }
        } else if (type == 2) {
            var cb = atr[i].getElementsByTagName("input")[0];
            cb = cb && cb.type == "checkbox" ? cb : false;
            cb.trselect = cb ? true : false;
            atr[i].onclick = function() {
                this.className = this.className != "selected" ? "selected" : "";
                var _cb = this.getElementsByTagName("input")[0];
                if (_cb && _cb.type == "checkbox") _cb.checked = this.className == "selected" ? true : false;
            }
        }
        atr[i].onmouseover = function() { this.style.cursor = "pointer"; this.className = this.className == "selected" ? "selected" : "hover"; }
        atr[i].onmouseout = function() { this.className = this.className == "selected" ? "selected" : ""; }
    }
}

function LoadCardItemData(index) {
	_OPIndex = _CardTypeData.get(index).CardTypeID;
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "carditem","ID":_OPIndex},
		success: function(result) {
			FormatCardItemData(result,index);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function FormatCardItemData(Data,index) {
    _CardItemData = new CardItemCollection();
    var TbodyObj = new Tbody(2, 'List_Body1');
    _CardTbodyObj = TbodyObj;
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
                var html = '';
                var cardItem = new CardItem(row[0], row[0], row[1], row[2]);
                _CardItemData.add(cardItem);
                html = row[2] + ' 数量：' + row[1] + ' [<a herf="javascript:void(0);" onclick="Del(this,\'' + row[0] + '\');">删除</a>]';
                TbodyObj.AddRow(new Array('', html));
                i++;
                row = DataList[i];
            }
        }
        var TbodyObj1 = new Tbody(2, 'List_tfoot1');
        TbodyObj1.DelAll();
        var html1 = '<input type="button" class="btn" value="保 存" onclick="Modify();" /> <input type="button" class="btn" value="重 置" onclick="LoadCardItemData(' + index + ');" />';
        TbodyObj1.AddRow(new Array('', html1), new Array('nobdb'));
    }
}

function showInputNum(obj, checked) {
    if ($(obj).id == 'selectAll0') {
        return;
    }
    if (checked) {
        $(obj).parent().next("td").next("td").html('<span>数量:</span> <input type=\"text\" class=\"txt\" size=\"5\" maxlength=\"5\" />');
    }
    else {
        $(obj).parent().next("td").next("td").html("");
        $(obj).parent().next("td").next("td").next("td").html("");
    }
}

function selectAll(obj) {
    var acb = $('#itemTb')[0].getElementsByTagName("input");
    for (i = 0; i < acb.length; i++) {
        if (acb[i].type == "checkbox") {
            acb[i].checked = obj.checked;
            if (acb[i].trselect) $match(acb[i], "tr").className = acb[i].checked ? "currenttr" : "";
            showInputNum(acb[i], obj.checked);
        }
    }
}

function ShowMsg(obj, msg) {
    $(obj).parent().next("td").html(msg);
}

function ShowMsg1(obj, msg) {
    $(obj).parent().next("td").next("td").next("td").html(msg);
}

function Sumbit() {
    if (SumbitForCheck()) {
        Add();
        return true; ;
    }
    return false;
}
//提交验证
function SumbitForCheck() {
    var msg = '';
    var temp = true;
    var eles1 = $('#List_Body2').find(":checkbox").each(function(i) {
        if ($(this).attr("checked") && _CardItemData.indexOfKey($(this).val()) != -1) {
            msg = "已经有该道具,如果要修改数目请删除后再添加!";
            ShowMsg1(this, msg);
            temp = false;
        }
        else {
            ShowMsg1(this, '');
        }
    });
    var eles = $('#List_Body2').find(":text").each(function(i) {
        if (($(this).val()) == '' || !/^\d{1,5}$/.test($(this).val())) {
            msg = "数量必须是数字!";
            ShowMsg(this, msg);
            temp = false;
        }
        else if (msg == '') {
            ShowMsg(this, '');
        }
    });
    return temp;
}

function Add() {
    var strIndex = '';
    var strNum = '';
    var thisObj = this; 
    if (_OPIndex == null) { alert('请先选择道具卡种类'); return; }
    $('#List_Body2 :checkbox').each(function(i) {
        if ($(this).attr("checked")) {
            var name = $(this).parent().next("td").html();
            var TbodyObj = new Tbody(2, 'List_Body1');
            var html = '';
            if (_CardItemData.size() == 0) { TbodyObj.DelAll(); }
            var cardItem = new CardItem($(this).val(), $(this).val(), $(this).parent().next("td").next("td").find(":text").val(), name);
            _CardItemData.add(cardItem);

            html = name + ' 数量：' + $(this).parent().next("td").next("td").find(":text").val() + '  [<a herf="javascript:void(0);" onclick="Del(this,\'' + $(this).val() + '\');">删除</a>]';
            TbodyObj.AddRow(new Array('', html));
        }
    });

}

function Del(obj, CardItemID) {
	_CardItemData.removeOfKey(CardItemID);
    $(obj).parent('td').parent('tr').remove();
}

function FormatCardType(Data)
{
	var TbodyObj = new Tbody(2, 'List_Body');
    TbodyObj.DelAll();
    if (Data == null || Data.Success == false) {
        TbodyObj.AddRow(new Array('暂没有道具卡种类！'));
    }
    else {
        var DataList = Data.DataList;
        if (DataList == null || DataList.length == 0) {
            TbodyObj.AddRow(new Array('没有道具卡种类！'));
        }
        else {
            var i = 0;
            var row = DataList[i];
            while (row != null) {
                var cardType = new CardType(row.cardTypeID, row.cardTypeID, row.cardTypeName);
                _CardTypeData.add(cardType);

                TbodyObj.AddRow(new Array(row.cardTypeName))
                i++;
                row = DataList[i];
            }
        }
    }
}

function Modify() {
	if(_OPIndex == null) alert("请刷新后再试");
    var str = '';
    for (var i = 0; i < _CardItemData.size(); i++) {
        if(_CardItemData.get(i).CardItemID == null || _CardItemData.get(i).CardItemNum == null)
        	continue;
        if(str!="")
        	str += ",";
        str += "(NULL,"+_CardItemData.get(i).CardItemID+","+_CardItemData.get(i).CardItemNum+")";
    }
    $.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "updateitem","ID":_OPIndex,"str":str},
		success: function(result) {
			if(result.Success)
				alert("更新成功！");
			else
				alert(result.Message);
			alert(result.Tag);
		},
		error: function(e) {alert(_msgURL);}
	});
}


//------------------------------------------------CLASS-----------------------------
/*
道具卡分配
*/
CardType = BMClass.create();
CardType.prototype = {
    initialize: function(key, CardTypeID, CardTypeName) {
        this.key = key;
        this.CardTypeID = CardTypeID;
        this.CardTypeName = CardTypeName;
    },
    equals: function(card) {
        if (card.key == this.key) {
            return true;
        }
        else return false;
    },
    equalsofkey: function(key) {
        if (key == this.key) {
            return true;
        }
        else return false;
    }
};

CardTypeCollection = BMClass.create();
CardTypeCollection.prototype = {
    initialize: function() {
        this.CardTypes = new ArrayList();
    },
    add: function(cardType) {
        this.CardTypes.add(cardType);
    },
    remove: function(cardType) {
        var it = this.CardTypes.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equals(cardType)) {
                this.CardTypes.remove(p);
                break;
            }
        }
    },
    removeOfKey: function(key) {
        var it = this.CardTypes.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equalsofkey(key)) {
                this.CardTypes.remove(p);
                break;
            }
        }
    },
    size: function() {
        return this.CardTypes.size();
    },
    indexOf: function(cardType) {
        var number = 0;
        var it = this.CardTypes.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equals(cardType)) {
                return number;
            }
            number++;
        }
        return -1;
    },
    indexOfKey: function(key) {
        var number = 0;
        var it = this.CardTypes.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equalsofkey(key)) {
                return number;
            }
            number++;
        }
        return -1;
    },
    get: function(index) {
        return this.CardTypes.get(index);
    }
};

CardItem = BMClass.create();
CardItem.prototype = {
    initialize: function(key, CardItemID, CardItemNum, CardItemName) {
        this.key = key;
        this.CardItemID = CardItemID;
        this.CardItemNum = CardItemNum;
        this.CardItemName = CardItemName;
    },
    equals: function(card) {
        if (card.key == this.key) {
            return true;
        }
        else return false;
    },
    equalsofkey: function(key) {
        if (key == this.key) {
            return true;
        }
        else return false;
    }
};

CardItemCollection = BMClass.create();
CardItemCollection.prototype = {
    initialize: function() {
        this.CardItems = new ArrayList();
    },
    add: function(cardItem) {
        this.CardItems.add(cardItem);
    },
    remove: function(cardItem) {
        var it = this.CardItems.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equals(cardItem)) {
                this.CardItems.remove(p);
                break;
            }
        }
    },
    removeOfKey: function(key) {
        var it = this.CardItems.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equalsofkey(key)) {
                this.CardItems.remove(p);
                break;
            }
        }
    },
    size: function() {
        return this.CardItems.size();
    },
    indexOf: function(cardItem) {
        var number = 0;
        var it = this.CardItems.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equals(cardItem)) {
                return number;
            }
            number++;
        }
        return -1;
    },
    indexOfKey: function(key) {
        var number = 0;
        var it = this.CardItems.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equalsofkey(key)) {
                return number;
            }
            number++;
        }
        return -1;
    },
    get: function(index) {
        return this.CardItems.get(index);
    }

};

//----------------------------------------------------CLASS-----------------------------------
$(document).ready(function() {
	_CardTypeData = new CardTypeCollection();
	_CardItemData = new CardItemCollection();
	LoadCardType();
	LoadGame();
	$("#btnAddItem").bind("click",Sumbit);
	$("#btnSearchItem").bind("click",btnSearchItemClickHandler);
	$("#btnSearchCard").bind("click",function(){
		LoadCardType();
	})
});