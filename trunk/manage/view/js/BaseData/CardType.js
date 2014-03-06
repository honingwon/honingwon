var _URL = "../model/BaseData/CardTypeMethod.php";
var _msgURL ="链接出错"
var _PageSelGame = "selectClass";
var _PageSelArea = "selectArea";
var _PageSelServ = "selectServer";
var _GameList = null;
var _AreaList = null;
var _ServList = null;
var _CGData   = null;
var _ClassTbodyObj = null;
var _Currenpage = 1;
var _CurrentPageLine = 20;
var _CardTypeID = null;

$(document).ready(function() {
	LoadCard();
	_CGData = new LG.CardGTCollection();
	$("#btnAddCardType").bind("click",function(){ 
		_CardTypeID = null;
		$('#selGameRestrict').attr('disabled', 0);
		$("#CardEditTitle").html("新增卡种类信息");
		initEditData(null);
		$("#CardEdit").show();
		});
	$("#BtncloseCardEdit").bind("click",function(){$("#CardEdit").hide();});
	$("#BtncloseCardAstEdit").bind("click",function(){$("#CardAstEdit").hide();});
	$("#btnCardSave").bind("click",btnSaveCardTypeClickHandler);
	$("#btnCardLimitSave").bind("click",btnSaveCardAstClickHandler);
	$("#btnSearch").bind("click",btnSearchClickHandler);
	LoadBaseData();
});

function LoadCard()
{
	var name = $("#searchcardName").val();
	var dataStr = {"method": "cardList","name":name,"pagesize":_CurrentPageLine,"curpage":_Currenpage};
	$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
		success: function(result) {
			FormatData(result);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function FormatData(objData)
{
	if (objData == null || objData.IsSuccess == false) {
        $("#List_Body").html(TableBodyRow(1,null,"系统忙，请稍后"));
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#List_Body").html(TableBodyRow(1,null,"暂未有卡信息"));
        return;
    }
    var i = 0;
    var row = DataList[i];
    var html ="";
    while (row != null) {
    	var num = i + 1;
    	html += TableBodyRow(num,row,"");
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
	LoadCard();
}

function TableBodyRow(rowNum,data,msg){
	if(data == null) return "<tr><td colspan='4' class='tc_rad'>"+msg+"</td></tr>";
	var className = rowNum % 2 == 0 ? "even":"";
	var ophtm = "";
	if(parseInt(data.cardState) == 0)
		ophtm += '[<a href="javascript:void(0);" onclick="javascript:SetStart(\'' + data.cardTypeID + '\')">开启</a>]';
	ophtm += '[<a href="javascript:void(0);" onclick="javascript:EditShow(\'' + data.cardTypeID + '\')">修改信息</a>]'+
			 '[<a href="javascript:void(0);" onclick="javascript:EditCardLimitShow(\'' + data.cardTypeID + '\')">修改限制</a>]'+
			 '[<a href="javascript:void(0);" onclick="javascript:DelCard(\'' + data.cardTypeID + '\')">删除</a>]';
	var strArray = ["不限制","游戏限制","游戏分区限制","游戏服务器"];
	var strRank = ["不唯一","唯一"];
	var html = "<tr class='"+className+"'><td>"+data.cardTypeName+"</td><td>"+strArray[data.cardRestrict]+"</td><td class='tc_gray'>"+strRank[data.cardUnique]+"</td><td class='operate'>"+ophtm+"</td></tr>";
   return  html;
}

function EditShow(value)
{
	var dataStr = {"method": "oneFo","ID":value};
	$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
		success: function(result) {
		   if(result.Success){
			   $('#selGameRestrict').attr('disabled', 1);
			   _CardTypeID = value;
				initEditData(result.DataList[0]);
				$("#CardEditTitle").html("修改卡种类信息");
				$("#CardEdit").show(); 
			}
		},
		error: function(e) {alert(_msgURL);}
	});
}

function EditCardLimitShow(cardID)
{
	var dataStr = {"method": "AllFo","ID":cardID};
	$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
		success: function(result) {
		   if(result.Success){
			   if(result.DataList.length >= 1){
				   var cardInfo = (result.DataList)[0];
				   _CardTypeID = cardInfo.cardTypeID;
				   $("#cartnametd").html(cardInfo.cardTypeName);
				   $("#selGameRestrictAst").val(cardInfo.cardRestrict);
				   $("#hiddenOldRit").val(cardInfo.cardRestrict);
				   if(result.DataList.length == 2){
					   var cardtypeObj = (result.DataList)[1];
					   ChangeRestrictAst(cardInfo.cardRestrict);
					    var i = 0;
		                var row = cardtypeObj[i];
		                var html = '';
		                var GameAreaServerList = "";
		                while (row != null) {
		                    if (cardInfo.cardRestrict == 1) {
		                        $('#selectClassAst').val(row[2]);
		                        var gameName = $("#selectClassAst").find("option:selected").text();
		                        if (row[2] != null) {
		                            var cardGameType = new LG.CardGameType(row[2], row[2], null, null, gameName, null, null);
		                            _CGData.add(cardGameType);
		                        }
		                        $('#list_titleAst').html("选择的游戏种类列表");
		
		                        var ophtm = "游戏种类:" + gameName;
		                        GameAreaServerList += '<tr><td style=\'width:30px;\'><input id=\'ifClass' + row[2] + '\' class="btn" onclick="DelClass(this.id,\'' + row[2] + '\')" type="button" value="删除" /></td><td>' + ophtm + '</td></tr>';
		                    }
		                    else if (cardInfo.cardRestrict == 2) {
		                        $('#selectClassAst').val(row[2]);
		                        var gameName = $("#selectClassAst").find("option:selected").text();
		                        selGameChangeAst();
		                        $('#selectAreaAst').val(row[3]);
		                        var gameArea = $("#selectAreaAst").find("option:selected").text();
		                        if (row[3] != null) {
		                            var cardGameType = new LG.CardGameType(row[3], row[2], row[3], null, gameName, gameArea, null);
		                            _CGData.add(cardGameType);
		                        }
		                        $('#list_titleAst').html("选择的游戏分区列表");
		                        var ophtm = "游戏种类:" + gameName + " 游戏分区:" + gameArea;
		                        GameAreaServerList += '<tr><td style=\'width:30px;\'><input id=\'ifarea' + row[3] + '\' class="btn" onclick="DelClass(this.id,\'' + row[3] + '\')" type="button" value="删除" /></td><td>' + ophtm + '</td></tr>';
		                    }
		                    else if (cardInfo.cardRestrict == 3) {
		                        $('#selectClassAst').val(row[2]);
		                        var gameName = $("#selectClassAst").find("option:selected").text();
		                        selGameChangeAst();
		                        $('#selectAreaAst').val(row[3]);
		                        var gameArea = $("#selectAreaAst").find("option:selected").text();
		                        selAreaChangeAst();
		                        $('#selectServerAst').val(row[4]);
		                        var gameServer = $("#selectServerAst").find("option:selected").text();
		                        
		                        var cardGameType = new LG.CardGameType(row[4], row[2], row[3], row[4], gameName, gameArea, gameServer);
		                        _CGData.add(cardGameType);
		                        $('#list_titleAst').html("选择的游戏服务器列表");
		                        
		                        var ophtm = "游戏种类:" + gameName + " 游戏分区:" + gameArea + " 游戏服务器:" + gameServer;
		                        GameAreaServerList += '<tr><td style=\'width:30px;\'><input id=\'ifserver' + row[4] + '\' class="btn" onclick="DelClass(this.id,\'' + row[4] + '\')" type="button" value="删除" /></td><td>' + ophtm + '</td></tr>';
		                    }
		                    i++;
		                    row = cardtypeObj[i];
		                }
		                $('#tb_ListAst').html(GameAreaServerList);
				   }
				   else
					   ChangeRestrictAst(cardInfo.cardRestrict); 
				   $("#CardAstEdit").show();
			   }
			   else
				   alert('无数据！');
			}
		   else
		   {
			   alert('系统忙,请重试！');
		   }
		},
		error: function(e) {alert(_msgURL);}
	});
}

function DelCard(cardID)
{
	if (!confirm("您确定删除?"))
        return;
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "del","ID":cardID},
		success: function(result) {
		   if(result.Success){
			    alert("删除成功");
				_Currenpage = 1;
				LoadCard();
			}
		   else
			   alert(result.Message);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function SetStart(cardID)
{
	if (!confirm("您确定要开启，卡开启就会正式使用?"))
        return;
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "open","ID":cardID},
		success: function(result) {
		   if(result.Success){
				LoadCard();
			}
		   else
			   alert(result.Message);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function initEditData(data)
{
	$("#txtName").val(data == null ? "" : data.cardTypeName);
	$("#selGameRestrict").val(data == null ? "0" : data.cardRestrict);
	$('#selCardTypeRank').val(data == null ? "0" : data.cardUnique);
	$("#txtPoint").val(data == null ? "" : data.cardPoint);
	$("#txtPrice").val(data == null ? "" : data.cardPrice);
	$("#CardRemark").val(data == null ? "" : data.Remark);
	$("#DivMessageAst").html("");
	
}

function btnSaveCardTypeClickHandler()
{
	var name = $('#txtName').val();
    var GameRestrict = $('#selGameRestrict').val();
    var CardTypeRank = parseInt($('#selCardTypeRank').val());
    var CardPoint = ($('#txtPoint').val() == '' || isNaN($('#txtPoint').val())) ? 0 : parseInt($('#txtPoint').val());
    var CardPrice = ($('#txtPrice').val() == '' || isNaN($('#txtPrice').val())) ? 0 : parseFloat($('#txtPrice').val());
    var remark = $('#CardRemark').val(); 
	if(SumbitForCheck())
	{
		if(_CardTypeID == null){
			var ga_GameIDS, ga_AreaIDS, ga_ServerIDS, ga_GameNameS, ga_AreaNameS, ga_ServerNameS;
			var gameStr = "";
			if(_CGData.size() > 0){
				for (var i = 0; i < _CGData.size(); i++) {
					if(gameStr != "")
						gameStr += ",";
					var ga_GameIDS = _CGData.get(i).GameID == null?"''":_CGData.get(i).GameID;
					var ga_AreaIDS = _CGData.get(i).AreaID == null?"''":_CGData.get(i).AreaID;
					var ga_ServerIDS = _CGData.get(i).ServerID == null?"''":_CGData.get(i).ServerID;
					gameStr += "(NULL,"+ga_GameIDS+","+ga_AreaIDS+","+ga_ServerIDS+")";
				}
			}
			var dataStr = {
				"method": "Add",
				"name":name,
				"rict":GameRestrict,//游戏限制
				"point":CardPoint,//点数
				"price":CardPrice,//面值
				"rank":CardTypeRank,//卡性质
				"dec":remark,
				"str":gameStr};
			$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
				success: function(result) {
					if(result.Success){
						alert(result.Message);
						$("#CardEdit").hide();
					    LoadCard();
					}
					else
						alert(result.Message);
				},
				error: function(e) {alert(_msgURL);}
			});
		}
		else{
			var dataStr = {"method": "updateBase","name":name,"point":CardPoint,"price":CardPrice,"rank":CardTypeRank,
					"dec":remark,"ID":_CardTypeID};
			$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
				success: function(result) {
					if(result.Success){
						alert("修改成功！");
					    $("#CardEdit").hide();
					    LoadCard();
					}
					else
						alert(result.Message);
				},
				error: function(e) {alert(_msgURL);}
			});
		}
	}
}

function btnSaveCardAstClickHandler()
{
	var temp = true;
    var message = '';

    if ($('#selGameRestrictAst').val() == "1" && _CGData.size() == 0) {
        message += "游戏种类未选择!<br />";
        temp = false;
    }

    else if ($('#selGameRestrictAst').val() == "2" && _CGData.size() == 0) {
        message += "游戏分区未选择!<br />";
        temp = false;
    }

    else if ($('#selGameRestrictAst').val() == "3" && _CGData.size() == 0) {
        message += "游戏服务器未选择!<br />";
        temp = false;
    }

    var HTML = "保存没有成功，请按照以下提示信息检查输入是否正确：<br />" + message;
    if (!temp) {
        $("#DivMessageAst").html(HTML);
        $("#DivMessageAst").show();
    }
    else {
        $("#DivMessageAst").hide();
    }
    if (temp) {
        //执行保存
    	if(_CardTypeID != null){
			var ga_GameIDS, ga_AreaIDS, ga_ServerIDS, ga_GameNameS, ga_AreaNameS, ga_ServerNameS;
			var gameStr = "";
			if(_CGData.size() > 0){
				for (var i = 0; i < _CGData.size(); i++) {
					if(gameStr != "")
						gameStr += ",";
					var ga_GameIDS = _CGData.get(i).GameID == null?"''":_CGData.get(i).GameID;
					var ga_AreaIDS = _CGData.get(i).AreaID == null?"''":_CGData.get(i).AreaID;
					var ga_ServerIDS = _CGData.get(i).ServerID == null?"''":_CGData.get(i).ServerID;
					gameStr += "(NULL,"+ga_GameIDS+","+ga_AreaIDS+","+ga_ServerIDS+")";
				}
			}
			var GameRestrict = $('#selGameRestrictAst').val(); 
			if($("#hiddenOldRit").val() == GameRestrict)
				GameRestrict = "";
			var dataStr = {"method": "updateLimit","rict":GameRestrict,"str":gameStr,"ID":_CardTypeID};
			$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
				success: function(result) {
				    if(result.Message == ""){
				    	alert("修改成功！");
				    	$("#CardAstEdit").hide();
				    }
				    else
				    	alert(result.Message);
				    LoadCard();
				},
				error: function(e) {alert(_msgURL);}
			});
		}
    }
}

function btnSearchClickHandler()
{
	_Currenpage = 1
	LoadCard();
}

function SumbitForCheck()
{
	var temp = true;
    var message = '';

    if (strlen($('#txtName').val()) < 5 || strlen($('#txtName').val()) > 50) {
        message += "卡名称长度5-50字节!<br />";
        temp = false;
    }
    if (_CardTypeID == null) {
        if ($('#selGameRestrict').val() == "1" && _CGData.size() == 0) {
            message += "游戏种类未选择!<br />";
            temp = false;
        }

        else if ($('#selGameRestrict').val() == "2" && _CGData.size() == 0) {
            message += "游戏分区未选择!<br />";
            temp = false;
        }

        else if ($('#selGameRestrict').val() == "3" && _CGData.size() == 0) {
            message += "游戏服务器未选择!<br />";
            temp = false;
        }
    }
    if (!/^\d{1,8}$/.test($('#txtPoint').val())) {
        message += "点数要求不能为空,并且由1-8位数字组成!<br />";
        temp = false;
    }
    if (!/^(\d*|\d*\.\d{0,2}|0\.\d{0,1}[1-9])$/.test($('#txtPrice').val())) {
        message += "面额要求不能为空,并且非负整数组成!<br />";
        temp = false;
    }
    if ($.trim($('#CardRemark').val()).length == 0) {
        message += "备注不能为空!<br />";
        temp = false;
    }

    var HTML = "保存没有成功，请按照以下提示信息检查输入是否正确：<br />" + message ;
    if (!temp) {
        $("#DivMessage").html(HTML);
        $("#DivMessage").show();
    }
    else {
        $("#DivMessage").hide();
    }
    return temp;
}

//-----------------------------------------CardLimit---------------------------------

function ChangeRestrict(index) {
    switch (parseInt(index)) {
        case 0: //不限制
            $('#trRestrict').hide();
            break;
        case 1: //游戏限制
            $('#trRestrict').show();
            $('#divAddClassList').show();
            $('#divAddAreaList').hide();
            $('#divAddServerList').hide();
            $('#ipClass').show();
            $('#list_title').html("选择的游戏种类列表");
            $('#'+_PageSelGame).val("-1");
            break;
        case 2: //游戏分区限制
            $('#trRestrict').show();
            $('#divAddClassList').show();
            $('#divAddAreaList').show();
            $('#divAddServerList').hide();
            $('#ipClass').hide();
            $('#ipArea').show();
            $('#list_title').html("选择的游戏分区列表");
            $('#'+_PageSelGame).val("-1");
            $('#'+_PageSelArea).val("-1");
            selGameChange();
            break;
        case 3: //游戏服务器限制
            $('#trRestrict').show();
            $('#divAddClassList').show();
            $('#divAddAreaList').show();
            $('#divAddServerList').show();
            $('#ipClass').hide();
            $('#ipArea').hide();
            $('#ipServer').show();
            $('#list_title').html("选择的游戏服务器列表");
            $('#'+_PageSelGame).val("-1");
            $('#'+_PageSelArea).val("-1");
            $('#'+_PageSelServ).val("-1");
            selGameChange();
            selAreaChange();
            break;
        default:
            $('#trRestrict').hide();
            break;
    }
    _CGData = new LG.CardGTCollection();
    if (_ClassTbodyObj != null) {
    	_ClassTbodyObj.DelAll();
    }
}

function ChangeRestrictAst(index) {
    $('#tb_ListAst').empty();
    switch (parseInt(index)) {
        case 0: //不限制
            $('#trRestrictAst').hide();
            break;
        case 1: //游戏限制
            $('#trRestrictAst').show();
            $('#divAddClassListAst').show();
            $('#divAddAreaListAst').hide();
            $('#divAddServerListAst').hide();
            $('#ipClassAst').show();
            $('#list_titleAst').html("选择的游戏种类列表");
            $('#selectClassAst').val("-1");
            break;
        case 2: //游戏分区限制
            $('#trRestrictAst').show();
            $('#divAddClassListAst').show();
            $('#divAddAreaListAst').show();
            $('#divAddServerListAst').hide();
            $('#ipClassAst').hide();
            $('#ipAreaAst').show();
            $('#list_titleAst').html("选择的游戏分区列表");
            $('#selectClassAst').val("-1");
            $('#selectAreaAst').val("-1");
            selGameChangeAst();
            break;
        case 3: //游戏服务器限制
            $('#trRestrictAst').show();
            $('#divAddClassListAst').show();
            $('#divAddAreaListAst').show();
            $('#divAddServerListAst').show();
            $('#ipClassAst').hide();
            $('#ipAreaAst').hide();
            $('#ipServerAst').show();
            $('#list_titleAst').html("选择的游戏服务器列表");
            $('#selectClassAst').val("-1");
            $('#selectAreaAst').val("-1");
            $('#selectServerAst').val("-1");
            selGameChangeAst();
            selAreaChangeAst();
            break;
        default:
            $('#trRestrict').hide();
            break;
    }

    _CGData = new LG.CardGTCollection();
    if (_ClassTbodyObj != null) {
        _ClassTbodyObj.DelAll();
    }
}

function selGameChange()
{
	var gameValue = $("#"+_PageSelGame).val();
	if(gameValue == "-1")
		SelectAddOptions($("#"+_PageSelArea),null,true,"请选择游戏分区");
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
}

function selGameChangeAst()
{
	var gameValue = $("#selectClassAst").val();
	if(gameValue == "-1")
		SelectAddOptions($("#selectAreaAst"),null,true,"请选择游戏分区");
	else{
		var object = $("#selectAreaAst")[0];
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
}

function selAreaChange()
{
	var areaValue = $("#"+_PageSelArea).val();
	if(areaValue == "-1")
	{
		SelectAddOptions($("#"+_PageSelServ),null,true,"请选择服务器");
	}
	else{
		var object = $("#"+_PageSelServ)[0];
		object.options.length = 0;
		object.options.add(new Option("请选择服务器", "-1"));
		if (_ServList != null && _ServList.length > 0) {
	        for (var i = 0; i < _ServList.length; i++) {
	        	var row = _ServList[i]; 
	        	if(row[2] == areaValue)
	        		object.options.add(new Option(row[1], row[0]));
	        }
	    }
	}
}

function selAreaChangeAst()
{
	var areaValue = $("#selectAreaAst").val();
	if(areaValue == "-1")
	{
		SelectAddOptions($("#selectServerAst"),null,true,"请选择服务器");
	}
	else{
		var object = $("#selectServerAst")[0];
		object.options.length = 0;
		object.options.add(new Option("请选择服务器", "-1"));
		if (_ServList != null && _ServList.length > 0) {
	        for (var i = 0; i < _ServList.length; i++) {
	        	var row = _ServList[i]; 
	        	if(row[2] == areaValue)
	        		object.options.add(new Option(row[1], row[0]));
	        }
	    }
	}
}

function AddClass(obj, tbObj) {
    var classValues = $('#' + obj).val();
    if (classValues == "-1") {
        return;
    }
    var cardGameType = new LG.CardGameType(classValues, classValues, null, null, $("#" + obj + " option:selected").html(), null, null);
    if (_CGData.indexOf(classValues) != -1) {
        alert('已经有相同的游戏种类!');
        return;
    }
    else if (_CGData.indexOfKey(classValues) != -1) {
        alert('已经有相同的游戏种类!');
        return;
    }
    else {
    	_CGData.add(cardGameType);
    }
    _ClassTbodyObj = new Tbody(2, tbObj);
    var ophtm = "游戏种类:" + $("#" + obj + " option:selected").html();
    _ClassTbodyObj.AddRow(new Array('<input id=\'class' + classValues + '\' class="btn" onclick="DelClass(this.id,\'' + classValues + '\')" type="button" value="删除" />', ophtm), null, null, new Array("30", null));

}

function AddArea(obj, obj1, tbObj) {
    var classValues = $('#' + obj).val();
    var areaValues = $('#' + obj1).val();
    if (areaValues == "-1") {
        return;
    }
    var cardGameType = new LG.CardGameType(areaValues, classValues, areaValues, null, $("#" + obj + " option:selected").html(), $("#" + obj1 + " option:selected").html(), null);
    if (_CGData.indexOf(areaValues) != -1) {
        alert('已经有相同的游戏分区!');
        return;
    }
    else if (_CGData.indexOfKey(areaValues) != -1) {
        alert('已经有相同的游戏分区!');
        return;
    }
    else {
    	_CGData.add(cardGameType);
    }
    _ClassTbodyObj = new Tbody(2, tbObj);
    var ophtm = "游戏种类:" + $("#" + obj + " option:selected").html() + " 游戏分区:" + $("#" + obj1 + " option:selected").html();
    _ClassTbodyObj.AddRow(new Array('<input id=\'area' + areaValues + '\' class="btn" onclick="DelArea(this.id,\'' + areaValues + '\')" type="button" value="删除" />', ophtm), null, null, new Array("30", null));
}

function AddServer(obj, obj1, obj2, tbObj) {
    var classValues = $('#' + obj).val();
    var areaValues = $('#' + obj1).val();
    var serverValues = $('#' + obj2).val();
    if (serverValues == "-1") {
        return;
    }
    var cardGameType = new LG.CardGameType(serverValues, classValues, areaValues, serverValues, $("#" + obj + " option:selected").html(), $("#" + obj1 + " option:selected").html(), $("#" + obj2 + " option:selected").html());
    if (_CGData.indexOf(serverValues) != -1) {
        alert('已经有相同的游戏服务器!');
        return;
    }
    else if (_CGData.indexOfKey(serverValues) != -1) {
        alert('已经有相同的游戏服务器!');
        return;
    }
    else {
    	_CGData.add(cardGameType);
    }
    _ClassTbodyObj = new Tbody(2, tbObj);
    var ophtm = "游戏种类:" + $("#" + obj + " option:selected").html() + " 游戏分区:" + $("#" + obj1 + " option:selected").html() + " 游戏服务器:" + $("#" + obj2 + " option:selected").html();
    _ClassTbodyObj.AddRow(new Array('<input id=\'server' + serverValues + '\' class="btn" onclick="DelServer(this.id,\'' + serverValues + '\')" type="button" value="删除" />', ophtm), null, null, new Array("30", null));
}

function DelClass(obj, classValues) {
    _CGData.removeOfKey(classValues);
    $('#' + obj).parent('td').parent('tr').remove();
}

function DelArea(obj, areaValues) {
	_CGData.removeOfKey(areaValues);
    $('#' + obj).parent('td').parent('tr').remove();
}
function DelServer(obj, serverValues) {
	_CGData.removeOfKey(serverValues);
    $('#' + obj).parent('td').parent('tr').remove();
}

function LoadBaseData()
{
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "game"},
		success: function(result) {
			_GameList = result.DataList[0];
			_AreaList = result.DataList[1];
			_ServList = result.DataList[2];
			SelectAddOptions($("#"+_PageSelGame),_GameList,true,"请选择游戏种类");
			SelectAddOptions($("#"+_PageSelArea),null,true,"请选择游戏分区");
			SelectAddOptions($("#"+_PageSelServ),null,true,"请选择服务器");
			SelectAddOptions($("#selectClassAst"),_GameList,true,"请选择游戏种类");
		},
		error: function(e) {alert(_msgURL);}
	});
}

function getGameName(gameID)
{
	reStr = "";
	if (_GameList != null && _GameList.length > 0) {
        for (var i = 0; i < _GameList.length; i++) {
        	var row = _GameList[i]; 
        	if(row[1] == gameID){
        		reStr = row[0];
        		break;
        	}
        }
    }
	return reStr;
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

//---------------------------------------------------CLASS-----------------------------

var LG = { Version: '1.0.0.0' };
LG.CardGameType = BMClass.create();
LG.CardGameType.prototype = {
    initialize: function(key, GameID, AreaID, ServerID, GameName, AreaName, ServerName) {
        this.key = key;
        this.GameID = GameID;
        this.AreaID = AreaID;
        this.ServerID = ServerID;
        this.GameName = GameName;
        this.AreaName = AreaName;
        this.ServerName = ServerName;

    },
    equals: function(cardGameType) {
        if (cardGameType.key == this.key) {
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
LG.CardGTCollection = BMClass.create();
LG.CardGTCollection.prototype = {
    initialize: function() {
        this.CardGameTypes = new ArrayList();
    },
    add: function(cardGameType) {
        this.CardGameTypes.add(cardGameType);
    },
    remove: function(cardGameType) {
        var it = this.CardGameTypes.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equals(cardGameType)) {
                this.CardGameTypes.remove(p);
                break;
            }
        }
    },
    removeOfKey: function(key) {
        var it = this.CardGameTypes.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equalsofkey(key)) {
                this.CardGameTypes.remove(p);
                break;
            }
        }
    },
    update: function(cardGameType) {
        var index = this.indexOf(cardGameType);
        this.CardGameTypes.set(index, cardGameType);
    },
    size: function() {
        return this.CardGameTypes.size();
    },
    indexOf: function(cardGameType) {
        var number = 0;
        var it = this.CardGameTypes.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equals(cardGameType)) {
                return number;
            }
            number++;
        }
        return -1;
    },
    indexOfKey: function(key) {
        var number = 0;
        var it = this.CardGameTypes.iterator();
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
        return this.CardGameTypes.get(index);
    }

};