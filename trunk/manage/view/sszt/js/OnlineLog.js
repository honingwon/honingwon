var _class_serverRights = null;
var realTimeXY = null;
var realTimeData = null;
var _plat = "-1";
var _server = "";
var _beginDate = "";

$(document).ready(function() {
	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',2);
//	realTimeXY = new InitRealTimeOnlineXY();
//	realTimeData = new InitRealTimeOnlineDatas();
	$("#btnSubmit").bind("click",btnSumbitOnclickHandler);
});

function btnSumbitOnclickHandler()
{
	var plat = _class_serverRights.getAreaValue();
	var server = _class_serverRights.getBoxValue();
	var beginDate = $("#beginDate").val();
	
	if(plat == "-1" || server == "" || beginDate == "")
	{
		setOnburPline("btnSubmit","请输入查看条件");
		return;
	}
//	if(plat == _plat && server == _server && beginDate == _beginDate)
//	{
//		setOnburPline("btnSubmit","与上次输入的查询条件相同，不能重复提交");
//		return;
//	}
	setOnburPline("btnSubmit","");
	_plat = plat;
	_server = server;
	_beginDate = beginDate;
	
//	realTimeXY.initOk = 0;
//	realTimeData.initOk = 0;
	
	$('#imgDiv').html("<span name = 'loading'>Loading...</span>");
	
	$("#btnSubmit").hide();
	var imgWidth = $('#imgDiv').innerWidth() - 30; 
	var str = "draw/OnlineLogDraw.php?plat="+plat;
	str += "&server="+server;
	str += "&dateTime="+beginDate;
	str += "&imgWidth="+imgWidth;
	str += "&r="+Math.random();
	
	var img = document.getElementById("img");
	img = document.createElement("img");
	img.id = "img";
	img.border = "0"; 
	img.src = str;
	$('#imgDiv').append(img);
	$('#img').bind("mouseover",function(){info.ShowInfo(img);});
	img.onload=function(){
		img.style.display = "block";
		$("span[name='loading']").remove();
		$("#btnSubmit").show();
	}
	img.onerror = function(){
		img.style.display = "none";
		$("span[name='loading']").html('null Data!');
		$("#btnSubmit").show();
	}
	
}


//function InitRealTimeOnlineXY()
//{
//	this.initOk = 0;
//}
//
//function InitRealTimeOnlineDatas()
//{
//	this.initOk = 0;
//}
//
//
//var info=
//{
//	$:function(ele)
//	{ 
//	  if(typeof(ele)=="object") 
//	    return ele; 
//	  else if(typeof(ele)=="string"||typeof(ele)=="number") 
//	    return document.getElementById(ele.toString()); 
//	  return null; 
//  },
//  mousePos:function(e)
//  { 
//    var x,y; 
//    var e = e||window.event; 
//    return{x:e.clientX+document.body.scrollLeft+document.documentElement.scrollLeft,y:e.clientY+document.body.scrollTop+document.documentElement.scrollTop}; 
//  },
//  // 获取相对坐标
//  getRelatePoint:function(mouse)
//  {
//  	var img = document.getElementById("img");
//  	var x = img.offsetLeft, y = img.offsetTop, h = img.clientHeight, w = img.clientWidth;
//    while (img = img.offsetParent) 
//    {
//        x += img.offsetLeft;
//        y += img.offsetTop;          
//    }
//    var point = { "l": x, "t": y, "h": h, "w": w };
//    var infoX = 0;
//    if(mouse.x <= point["l"] + 70)
//    {
//    	infoX = 1;
//    }
//    else if(mouse.x >= point["l"] + point["w"] - 20)
//    {
//    	infoX = point["w"] - 20 - 70 - 1;
//    }
//    else
//    {
//    	infoX = mouse.x - (point["l"] + 70);
//    }
//    var infoY = 0;
//    if(mouse.y < point["t"] + 30)
//    {
//    	infoY = point["h"] - 30 - 50;
//    }
//    else if(mouse.y > point["t"] + point["h"] - 50)
//    {
//    	infoY = 0;
//    }	
//    else
//    {
//    	infoY = (point["t"] + point["h"] - 50) - mouse.y;
//    }
//    point = {"x": infoX, "y": infoY};
//    return point;
//  },
//  getAbsPoint:function(e)  //e为元素对象,获得此元素的左上角坐标 (x,y)和宽、高
//  {
//    var x = e.offsetLeft, y = e.offsetTop, h = e.clientHeight, w = e.clientWidth;
//    while (e = e.offsetParent) {
//        x += e.offsetLeft;
//        y += e.offsetTop;           
//    }
//    var ePoint = { "l": x, "t": y, "h": h, "w": w };
//    return ePoint;
//  },
//  getY:function(yValue) // 根据y的值计算其坐标
//  {
//  	var img = document.getElementById("img");
//  	var x = img.offsetLeft, y = img.offsetTop, h = img.clientHeight, w = img.clientWidth;
//    while (img = img.offsetParent) 
//    {
//        x += img.offsetLeft;
//        y += img.offsetTop;           
//    }
//    //alert(y + (realTimeXY.GArea_Y2 - (yValue-realTimeXY.VMin) * realTimeXY.DivisionRatio));
//  	return (y - 25 + (realTimeXY.GArea_Y2 - (yValue-realTimeXY.VMin) * realTimeXY.DivisionRatio));
//  },
//  ShowInfo:function(obj)
//  {
//  	var img = document.getElementById("img");
//  	var absPoint = this.getAbsPoint(img);
//  	var plat = _plat;
//  	var server = _server;
//  	var beginDate = _beginDate;
//
//  	// 是否需要重新初始化XY坐标信息
//  	if(realTimeXY.initOk == 0)
//  	{
//  		$.ajax({type: "get",url: "../../../control/swjt/draw/onlineManageXYInfo.php",dataType: "string",
//  			data:{"plat":plat,"server":server,"beginDate":beginDate},
//  			success: function(result) {
//  				var retAry = result.split(",");
//  				if(retAry.length == 4)
//  				{
//			      	realTimeXY.xDiff = retAry[0];
//			      	realTimeXY.GArea_Y2 = retAry[1];
//			      	realTimeXY.VMin = retAry[2];
//			      	realTimeXY.DivisionRatio = retAry[3];
//			      	realTimeXY.initOk = 1;
//  				}
//  			}
//  		});
//  	}
//
//    var self = this; 
//    var t = self.$("info"); 
//    obj.onmousemove=function(e)
//    {
//    	
//    	// 是否需要初始化数据模型 
//    	if(realTimeData.initOk == 0)
//      	{
//    		$.ajax({type: "get",url: "../../../control/swjt/draw/onlineManageGetYValue.php",dataType: "string",
//      			data:{"plat":plat,"server":server,"beginDate":beginDate,"xIndex":xIndex},
//      			success: function(result) { 
//      				realTimeData.datas = new Array();
//					var line = result.split("|");
//					for(var i = 1;i != line.length;++i)
//					{
//						realTimeData.datas[i] = new Array();
//						var ary = line[i].split(",");
//						for(var j = 0;j != ary.length;++j)
//						{
//							realTimeData.datas[i][j] = ary[j];
//						}
//					}
//					if(realTimeData.datas.length != 0)
//					{
//						realTimeData.initOk = 1;
//					}
//      			}
//      		});
//  		}
//    	
//		var mouse = self.mousePos(e);
//    	var point = self.getRelatePoint(mouse);
//    	var xIndex = 0;
//    	xIndex = Math.ceil(point["x"]/realTimeXY.xDiff) - 1;
//    	if(realTimeData.initOk == 1 && realTimeData.datas.length > xIndex)
//    	{
//  			t.style.left = 70 + absPoint["l"] + xIndex * realTimeXY.xDiff + "px";
//  			t.style.top = self.getY(realTimeData.datas[xIndex + 1][1]) - 50 + "px";
//  			t.innerHTML = realTimeData.datas[xIndex + 1][0] + "-" +  realTimeData.datas[xIndex + 1][1] + "在线"; 
//			t.style.display = 'block';
//    	}
//    	else
//    	{
//    		t.style.left = 70 + absPoint["l"] + xIndex * realTimeXY.xDiff + "px";
////  			t.style.top = self.getY(realTimeData.datas[xIndex + 1][1]) - 50 + "px";
//  			t.innerHTML = "Loading..."; 
//			t.style.display = 'block';
//    	}
//		
//    }; 
//    
//    obj.onmouseout=function()
//    { 
//      t.style.display = 'none'; 
//    };
//    
//  } 
//} 