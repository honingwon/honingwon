var _URL = "../model/ServerManager/serverManage.php";
var _msgURL = "链接出错";
var _Currenpage = 1;
var _CurrentPageLine = 20;
var _OperIndex = null;
var _DoneIndex = null;
var _DataGameList = null;
var _DataAreaList = null;
var _DataServList = null;
$(document).ready(function() {
	loadGame();
	$("#btnAddGame").bind("click",btnAddGameClickHandler);
	$("#btncanleGame").bind("click",btncanleGameClickHander);
	$("#btnAddArea").bind("click",btnAddAreaClickHandler);
	$("#btnCanelArea").bind("click",btnCanelAreaClickHandler);
	$("#btnSerSearch").bind("click",btnSerSearchClickHandler);
	$("#btnSerAddServer").bind("click",btnSerAddServerClickHandler);
	$("#btnSerSaveServer").bind("click",btnSerSaveServerClickHandler);
	$("#btnCoseServerEdit").bind("click",btnCoseServerEditClickHandler);
	$("#btnCancelAddServer").bind("click",btnCoseServerEditClickHandler);
});

function typeChange(type,obj)
{
	$("#gameDiv").hide();
	$("#areaDiv").hide();
	$("#serverDiv").hide();
	_OperIndex = null;
	$(".tagSort a").removeClass();
	$(obj).addClass("selected");
	switch(type)
	{
		case 1:
			$("#gameDiv").show();
			_OperIndex = 1;
			break;
		case 2:
			$("#areaDiv").show();
			_OperIndex = 2;
			FormateAreaGameSelect();
			btnCanelAreaClickHandler();
			loadArea();
			break;
		case 3:
			$("#serverDiv").show();
			_OperIndex = 3;
			loadAllArea();
			break;
	}
}

////////////////////////////////////game///////////////////////////////////////////////
function loadGame()
{
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "gamelist"},
		success: function(result) {
			_DataGameList = result;
			gameDivFormatData();
		},
		error: function(e) {alert(_msgURL);}
	});
}

function  gameDivFormatData(){
	if (_DataGameList == null || _DataGameList.Success == false) {
        $("#gameBody").html("<tr><td  colspan='2'>系统忙，请稍后再试！</td></tr>");
        return;
    }
	var DataList = _DataGameList.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#gameBody").html("<tr><td  colspan='2'>暂无数据</td></tr>");
        return;
    }
    var i = 0;
    var row = DataList[i];
    var html ="";
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var oper = '[<a href="javascript:void(0);" onclick="javascript:editGame(\'' + row.bm_GameID + '\',\'' + escape(row.bm_GameName) + '\')">修改</a>]' +
    				'[<a href="javascript:void(0);" onclick="javascript:delGame(\'' + row.bm_GameID + '\')">删除</a>]';;
    	html += "<tr class='"+className+"' ><td width='250' >"+row.bm_GameName+"</td><td>"+oper+"</td></tr>";
        i++;
        row = DataList[i];
    }
    $("#gameBody").html(html);
}

function editGame(gameID,gameName)
{
	$("#gameTile").html("编辑游戏信息");
	_DoneIndex = gameID;
	$("#btncanleGame").show();
	$("#gameName").val(unescape(gameName));
	$('#gameName').focus();
}

function delGame(gameID)
{
	if (!confirm("您确定删除?"))
        return;
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "delGame","ID":gameID},
		success: function(result) {
		   if(result.Success){
			   alert("删除成功!");
			   _Currenpage = 1;
			   loadGame();
			}
		   else
			   alert(result.Message);	
		},
		error: function(e) {alert(_msgURL);}
	});
}

function btnAddGameClickHandler()
{
	var gameName = $("#gameName").val();
	if(gameName.length <= 0 || gameName.length >32){
		setOnburPline("gameName","请您输入游戏名称，在0-32个字符之内！");
		return;
	}
	setOnburPline("gameName","");
	if(_DoneIndex == null){
		$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "addGame","name":gameName},
			success: function(result) {
				if(result.Success){
					$("#gameName").val("");
					loadGame();
				}
				else
					alert(result.Message);
			},
			error: function(e) {alert(_msgURL);}
		});
	}
	else{
		$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "updateGame","name":gameName,"ID":_DoneIndex},
			success: function(result) {
				if(result.Success){
					btncanleGameClickHander();
					loadGame();
				}
				else
					alert(result.Message);
			},
			error: function(e) {alert(_msgURL);}
		});
	}
}

function btncanleGameClickHander()
{
	$("#gameTile").html("添加新游戏");
	_DoneIndex = null;
	$("#gameName").val("");
	$("#btncanleGame").hide();
}
////////////////////////////////////gameArea///////////////////////////////////////////////
function loadArea()
{
	var selGame = $("#AreaselectGame").val(); 
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "arealist","ID":selGame},
		success: function(result) {
			areaDivFormatData(result);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function  areaDivFormatData(objData){
	if (objData == null || objData.Success == false) {
        $("#areaBody").html("<tr><td  colspan='5'>系统忙，请稍后再试！</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#areaBody").html("<tr><td  colspan='5'>暂无数据</td></tr>");
        return;
    }
    var i = 0;
    var row = DataList[i];
    var html ="";
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var oper = '[<a href="javascript:void(0);" onclick="javascript:editArea(\'' + row.bm_AreaID + '\',\'' + escape(row.bm_AreaName) + '\',\'' + escape(row.bm_AreaDesc) + '\',\'' + row.bm_AreaPRI + '\')">修改</a>]' +
    				'[<a href="javascript:void(0);" onclick="javascript:delArea(\'' + row.bm_AreaID + '\')">删除</a>]';;
    	html += "<tr class='"+className+"' ><td>"+row.bm_AreaPRI+"</td><td>"+row.bm_GameName+"</td>"+
    			"<td>"+row.bm_AreaName+"</td><td>"+row.bm_AreaDesc+"</td><td>"+oper+"</td></tr>";
        i++;
        row = DataList[i];
    }
    $("#areaBody").html(html);
}

function FormateAreaGameSelect()
{
	var object = $("#AreaselectGame")[0];
	object.options.length = 0;
	if (_DataGameList == null || _DataGameList.Success == false){
		object.options.add(new Option("请选择游戏服务器", "-1"));
		return;
	}
	if (_DataGameList.DataList != null && _DataGameList.DataList.length > 0) {
        for (var i = 0; i < _DataGameList.DataList.length; i++) {
        	var row = _DataGameList.DataList[i]; 
        	object.options.add(new Option(row.bm_GameName, row.bm_GameID));
        }
    }
	else
		object.options.add(new Option("请选择游戏服务器", "-1"));
}
function AreaselGameChange()
{
	loadArea();
}
function editArea(areaID,areaName,areaDesc,areaARI)
{
	_DoneIndex = areaID;
	$('#AreaselectGame').attr('disabled', 1);
	areaValueEidt(areaName,areaDesc,areaARI);
	$("#btnCanelArea").show();
	$("#areaTile").html("修改游戏分区");
}

function delArea(areaID)
{
	if (!confirm("您确定删除?"))
        return;
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "delArea","ID":areaID},
		success: function(result) {
		   if(result.Success){
			   alert("删除成功!");
			   loadArea();
			}
		   else
			   alert(result.Message);	
		},
		error: function(e) {alert(_msgURL);}
	});
}

function btnAddAreaClickHandler()
{
	var selGameValue = $("#AreaselectGame").val();
	var areaName = $("#areaName").val();
	var areARI = $("#areaPRI").val();
	var areDesc = $("#areaDesc").val();
	if(!areaEditCheckValue(selGameValue,areaName,areARI,areDesc) || _OperIndex != 2)
		return;
	if(_DoneIndex == null){
		var dataStr = {"method": "addArea","name":areaName,"ari":areARI,"desc":areDesc,"ID":selGameValue};
		$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
			success: function(result) {
				if(result.Success){
					areaValueEidt("","","");
					loadArea();
				}
				else
					alert(result.Message);
			},
			error: function(e) {alert(_msgURL);}
		});
	}
	else{
		var dataStr = {"method": "updateArea","name":areaName,"ari":areARI,"desc":areDesc,"ID":_DoneIndex};
		$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
			success: function(result) {
				if(result.Success){
					btnCanelAreaClickHandler();
					loadArea();
				}
				else
					alert(result.Message);
			},
			error: function(e) {alert(_msgURL);}
		});
	}
}

function btnCanelAreaClickHandler()
{
	$('#AreaselectGame').attr('disabled', 0);
	_DoneIndex = null;
	areaValueEidt("","","");
	$("#btnCanelArea").hide();
}

function areaValueEidt(areaName,areDesc,areARI)
{
	$("#areaName").val(areaName == "" ? "" :unescape(areaName));
	$("#areaPRI").val(areARI);
	$("#areaDesc").val(areDesc == "" ? "" :unescape(areDesc));
	setOnbur("AreaselectGame","");
	setOnbur("areaName","");
	setOnbur("areaPRI","");
	setOnbur("areDesc","");
	if(areaName == "")
		$("#areaTile").html("新增游戏分区");
}

function areaEditCheckValue(selGameValue,areaName,areARI,areDesc)
{
	if(selGameValue == -1){
		setOnbur("AreaselectGame","请先维护游戏种类");
		return false;
	}
	setOnbur("AreaselectGame","");
	if(areaName.length <= 0 || areaName.length >32){
		setOnbur("areaName","请输入游戏分区，在0-32个字符之内！");
		return false;
	}
	setOnbur("areaName","");
	if(areARI.length <= 0){
		setOnbur("areaPRI","请您输入分区优先级！");
		return false;
	}
	else if(!/^\d{1,5}$/.test(areARI)){
        setOnbur("areaPRI","分区优先级号输入有误!");
        return false;
    }
	setOnbur("areaPRI","");
	if(areDesc.length <= 0 || areDesc.length >256){
		setOnbur("areaDesc","请您输入介绍，在0-256个字符之内！");
		return false;
	}
	setOnbur("areDesc","");
	return true;
}

////////////////////////////////////gameServer///////////////////////////////////////////////
function loadAllArea()
{
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "areaALLlist"},
		success: function(result) {
			_DataAreaList = result;
			FormateSerGameSelect();
			loadServer();
		},
		error: function(e) {alert(_msgURL);}
	});
}
function loadServer()
{
	var gameID = $("#serSelGame").val();
	var areaID = $("#serSelArea").val();
	var dataStr = {"method": "servlist","curpage":_Currenpage,"pagesize":_CurrentPageLine,"game":gameID,"area":areaID};
	$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
		success: function(result) {
			serverDivFormatData(result);
			_DataServList = result;
		},
		error: function(e) {alert(_msgURL);}
	});
}

function serverDivFormatData(objData){
	if (objData == null || objData.Success == false) {
        $("#serverBody").html("<tr><td  colspan='6'>系统忙，请稍后再试！</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#serverBody").html("<tr><td  colspan='6'>暂无数据</td></tr>");
        return;
    }
    var i = 0;
    var row = DataList[i];
    var html ="";
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var connStr = "";
    	if(row.bm_ServerConnString.socket.ip != "")
    		connStr += 'socket:' + row.bm_ServerConnString.socket.ip + ":" + row.bm_ServerConnString.socket.port;
		if( typeof(row.bm_ServerConnString.server) != "undefined" && row.bm_ServerConnString.server.serverIP != ''){
		  connStr += '服务器:' + row.bm_ServerConnString.server.serverIP;
		}
		if( typeof(row.bm_ServerConnString.log) != "undefined" && row.bm_ServerConnString.log.logIP != ''){
		  connStr += '日志记录:' + row.bm_ServerConnString.log.logIP;
		}
		var heID = row.bm_ServerID + "_heRPI"; 
		var oper = '[<a href="javascript:void(0);" onclick="javascript:editServer(\'' + row.bm_ServerID + '\')">修改</a>]' +
				   '[<a href="javascript:void(0);" onclick="javascript:delServer(\'' + row.bm_ServerID + '\')">删除</a>]';
		if(row.bm_GameID == GameID_HLQS())
    	     oper = '[<a href="javascript:void(0);" onclick="javascript:editServer(\'' + row.bm_ServerID + '\')">修改</a>]' +
    				'[<a href="javascript:void(0);" onclick="javascript:delServer(\'' + row.bm_ServerID + '\')">删除</a>]'+
    				'[<a href="javascript:void(0);" onclick="javascript:closeServer(\'' + row.bm_ServerID + '\',\'' + row.bm_ServerName + '\')">关服</a>]';
    				//'<br/>合服:<input type="text" id="'+heID+'" class="input" size="5" />[<a href="javascript:void(0);" onclick="javascript:heServer(\'' + row.bm_ServerID + '\',\'' + heID + '\',\'' + row.bm_GameID + '\',\'' + row.bm_ServerPRI + '\',\'' + escape(row.bm_ServerRemark) + '\')">确认</a>]';
    	html += "<tr class='"+className+"' ><td>"+row.bm_GameName+"</td><td>"+row.bm_AreaName+"</td>"+
    			"<td>"+row.bm_ServerName+"("+row.bm_ServerID+")</td><td>"+row.bm_ServerPRI+"</td><td>"+connStr+"</td><td>"+oper+"</td></tr>";
        i++;
        row = DataList[i];
    }
    var FSumCount = objData.Tag;
    var FPageCount = Math.ceil(FSumCount / _CurrentPageLine);
    var pagingation = new Pagination("Pagination1", FPageCount, _Currenpage, FSumCount, _CurrentPageLine, "serPageChange", "divPagination", 1)
    $("#serverBody").html(html);
}

function serPageChange(num)
{
	_Currenpage = num;
	loadServer();
}

function FormateSerGameSelect()
{
	var object = $("#serSelGame")[0];
	var editObject = $("#serEditSelGame")[0];
	object.options.length = 0;
	object.options.add(new Option("请选择游戏服务器", "-1"));
	editObject.options.length = 0;
	editObject.options.add(new Option("请选择游戏服务器", "-1"));
	if (_DataGameList == null || _DataGameList.Success == false)   return;
	if (_DataGameList.DataList != null && _DataGameList.DataList.length > 0) {
        for (var i = 0; i < _DataGameList.DataList.length; i++) {
        	var row = _DataGameList.DataList[i]; 
        	object.options.add(new Option(row.bm_GameName, row.bm_GameID));
        	editObject.options.add(new Option(row.bm_GameName, row.bm_GameID));
        }
    }
}
function serSelGameChange()
{
	gamechangeAreaData("serSelGame","serSelArea");
}
function serEditSelGameChange()
{
	gamechangeAreaData("serEditSelGame","serEditSelSelect");
}
function  gamechangeAreaData(gameObj,areaObj){
	var selGame = $("#"+gameObj).val();
	var object = $("#"+areaObj)[0];
	object.options.length = 0;
	object.options.add(new Option("请选择游戏分区", "-1"));
	if(selGame == -1) return;
	if (_DataAreaList == null || _DataAreaList.Success == false)   return; 
	if (_DataAreaList.DataList != null && _DataAreaList.DataList.length > 0) {
        for (var i = 0; i < _DataAreaList.DataList.length; i++) {
        	var row = _DataAreaList.DataList[i];  
        	if(row.bm_GameID == selGame)
        		object.options.add(new Option(row.bm_AreaName, row.bm_AreaID));
        }
    }
}
function editServer(serverID)
{
	if (_DataServList == null || _DataServList.Success == false)  return;
	var dataRow = null;
    for(var i = 0 ; i < _DataServList.DataList.length; ++i)
    {
    	if(_DataServList.DataList[i].bm_ServerID == serverID){
    		dataRow = _DataServList.DataList[i];
    		break;
    	}
    }
    if(dataRow!= null){
    	_DoneIndex = serverID;
    	initEditData(dataRow);
    	$("#editServer").show();
    }
}

function delServer(serverID)
{
	if (!confirm("您确定删除?"))
        return;
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "delSer","ID":serverID},
		success: function(result) {
		   if(result.Success){
			   alert("删除成功!");
			   _Currenpage = 1;
			   loadServer();
			}
		   else
			   alert(result.Message);	
		},
		error: function(e) {alert(_msgURL);}
	});
}


function closeServer(serverID,serverName)
{
	if (!confirm("您确定对["+serverName+"]关服吗?"))
        return;
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "closeSer","ID":serverID},
		success: function(result) {
		   if(result.Success){
			   if(result.Success){
					var error = "";
					if(result.DataList.length > 0)
					{
						for (var i = 0; i < result.DataList.length; i++) {
							error +=  result.DataList[i]+"<br />";
						}
					}
					if(error != ""){
						error = "操作失败，请查看错误日志<br />" + error;
						alert(error);
					}
					else{
						alert("关服成功!");
					}
				}
				else
					alert("操作失败!");
			   
//			   _Currenpage = 1;
//			   loadServer();
			}
		   else
			   alert(result.Message);	
		},
		error: function(e) {alert(_msgURL);}
	});
}

function heServer(serverID,inputID,gameID,serverID_RPI,serverRemark)
{
	if(GameID_HLQS() == gameID){
		//幻龙骑士的处理方案
		if (!confirm("您确定对这个服务器操作合服，执行成功后，该服务器会不显示?"))
	        return;
		var serverRPI = $("#"+inputID).val();
		if(serverRPI.length <= 0){
			alert("请输入要合的目标服务器的优先级");
			return;
		}
		else if(!/^\d{1,9}$/.test(serverRPI)){
	        alert("请输入要合的目标服务器的优先号输入有误");
	        return;
	    }
		var remark = serverRemark + "  合服(优先级) ：" + serverID_RPI + "->" +serverRPI +" time：";
		$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "heSer","ID":serverID,"game":gameID,"RPI":serverRPI,"desc":remark},
			success: function(result) {
			alert(result.Tag);
			   if(result.Success){
				   if(result.Tag)
					   alert("操作成功!");
				   else
					   alert("部分服务器修改未成功，请及时check服务器信息!");
				   _Currenpage = 1;
				   loadServer();
				}
			   else
				   alert(result.Message);	
			},
			error: function(e) {alert(_msgURL);}
		});
	}
}	

function btnSerSearchClickHandler()
{
	_Currenpage = 1;
	loadServer();
}

function btnSerAddServerClickHandler()
{
	$("#editServer").show();
	_DoneIndex = null
	initEditData(null);
}

function btnCoseServerEditClickHandler()
{
	$("#editServer").hide();
	_DoneIndex = null
	initEditData(null);
}

function btnSerSaveServerClickHandler()
{
	if(!editServerDataValue() || _OperIndex != 3) return;
	var gameValue = $("#serEditSelGame").val();
	var areaValue = $("#serEditSelSelect").val();
	var serName   = $("#serverName").val();
	var serRPI	  = $("#serverPRI").val();
	var serDesc	  = $("#serverRemark").val();
	var serSHH	  = $("#shh").val();
	var serCon	  = returnCon(); 
	if(_DoneIndex == null){
		var dataStr = {"method": "addServer","game":gameValue,"area":areaValue,"name":serName,"ari":serRPI,"con":serCon,"desc":serDesc,"shh":serSHH};
		$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
			success: function(result) {
				if(result.Success){
					btnCoseServerEditClickHandler();
					_Currenpage = 1;
					loadServer();
				}
				else
					alert(result.Message);
			},
			error: function(e) {alert(_msgURL);}
		});
	}
	else{
		var dataStr = {"method": "updateSer","ID":_DoneIndex,"name":serName,"ari":serRPI,"con":serCon,"desc":serDesc,"shh":serSHH};
		$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
			success: function(result) {
				if(result.Success){
					alert("修改成功！");
					loadServer();
				}
				else
					alert(result.Message);
			},
			error: function(e) {alert(_msgURL);}
		});
	}
}

function initEditData(data)
{
	$("#serEditSelGame").val(data == null ? -1 : data.bm_GameID);
	serEditSelGameChange();
	$("#serEditSelSelect").val(data == null ? -1 : data.bm_AreaID);
	
	$("#serverName").val(data == null ? "" : data.bm_ServerName);
	$("#serverPRI").val(data == null ? "" : data.bm_ServerPRI);
	$("#serverRemark").val(data == null ? "" : data.bm_ServerRemark);
	
	$("#socketIP").val(data == null ? "" : data.bm_ServerConnString.socket.ip);
	$("#socketPort").val(data == null ? "" : data.bm_ServerConnString.socket.port);
	$("#serverIP").val(data == null ? "" : data.bm_ServerConnString.server.serverIP);
	$("#serverUser").val(data == null ? "" : data.bm_ServerConnString.server.serverUser);
	$("#serverPSW").val(data == null ? "" : data.bm_ServerConnString.server.serverPSW);
	$("#dataport").val(data == null ? "" : data.bm_ServerConnString.server.port);
	$("#serverDataName").val(data == null ? "" : data.bm_ServerConnString.server.serverDataName);
	$("#logIP").val(data == null ? "" : data.bm_ServerConnString.log.logIP);
	$("#logUser").val(data == null ? "" : data.bm_ServerConnString.log.logUser);
	$("#logPSW").val(data == null ? "" : data.bm_ServerConnString.log.logPSW);
	$("#logDataName").val(data == null ? "" : data.bm_ServerConnString.log.logDataName);
	$("#shh").val(data == null ? "" : data.bm_ServerSHH);
	setOnbur("serEditSelGame","");
	setOnbur("serEditSelSelect","");
	setOnbur("serverName","");
	setOnbur("serverPRI","");
	setOnbur("serverRemark","");
	if(data == null){
		$('#serEditSelGame').attr('disabled', 0);
		$('#serEditSelSelect').attr('disabled', 0);
	}
	else{
		$('#serEditSelGame').attr('disabled',1);
		$('#serEditSelSelect').attr('disabled', 1);
	}
}

function editServerDataValue()
{
	var gameValue = $("#serEditSelGame").val();
	var areaValue = $("#serEditSelSelect").val();
	var serName   = $("#serverName").val();
	var serRPI	  = $("#serverPRI").val();
	var serDesc	  = $("#serverRemark").val();
	var dataPort  = $("#dataport").val();
	var serverSHH  = $("#shh").val();
	if(gameValue == -1){
		setOnbur("serEditSelGame","请选择游戏种类");
		return false;
	}
	setOnbur("serEditSelGame","");
	if(areaValue == -1){
		setOnbur("serEditSelSelect","请选择游戏分区");
		return false;
	}
	setOnbur("serEditSelSelect","");
	if(serName.length <= 0 || serName.length >32){
		setOnbur("serverName","请输入服务器名，在0-32个字符之内！");
		return false;
	}
	setOnbur("serverName","");
	if(serRPI.length <= 0){
		setOnbur("serverPRI","请您输入服务器优先级！");
		return false;
	}
	else if(!/^\d{1,9}$/.test(serRPI)){
        setOnbur("serverPRI","服务器优先级号输入有误!");
        return false;
    }
	setOnbur("serverPRI","");
	if(dataPort.length <= 0){
		setOnbur("dataport","请您数据库端口！");
		return false;
	}
	setOnbur("dataport","");
	if(serDesc.length <= 0 || serDesc.length >256){
		setOnbur("serverRemark","请您输入介绍，在0-256个字符之内！");
		return false;
	}
	setOnbur("serverRemark","");
	if(serverSHH.length <= 0 || serverSHH.length >2000){
		setOnbur("shh","请您输入介绍，在0-2000个字符之内！");
		return false;
	}
	setOnbur("shh","");
	return true;
}

function returnCon()
{
   var socketIp 	= $("#socketIP").val();
   var socketPort 	= $("#socketPort").val();
   var servIP		= $("#serverIP").val();
   var servUser		= $("#serverUser").val();
   var servDataName	= $("#serverDataName").val();
   var servDataPWD	= $("#serverPSW").val();
   var logIP		= $("#logIP").val();
   var logUser		= $("#logUser").val();
   var logDataName	= $("#logDataName").val();
   var logDataPWD	= $("#logPSW").val();
   var dataPort     = $("#dataport").val();
   return '{"server":{"serverIP":"'+servIP+'","serverUser":"'+servUser+'","serverPSW":"'+servDataPWD+'","serverDataName":"'+servDataName+'","port":"'+dataPort+'"},'+
	   				'"log":{"logIP":"'+logIP+'","logUser":"'+logUser+'","logPSW":"'+logDataPWD+'","logDataName":"'+logDataName+'","port":"'+dataPort+'"},'+
	   				'"socket":{"ip":"'+socketIp+'","port":"'+socketPort+'"}}';
}