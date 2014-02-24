var game_graph_php = "";

var xmlHttp;

function LoadData(url,func)
{
	if (window.XMLHttpRequest)
	{
		// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlHttp=new XMLHttpRequest();
	}
	else
	{
		// code for IE6, IE5
		xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlHttp.onreadystatechange=func;
	xmlHttp.open("GET",url,true);
	xmlHttp.send();
}

function selectAll(obj,name)
{
	if(obj.checked){
		$("input[name='"+name+"']").attr("checked",true);
	}
	else{
		$("input[name='"+name+"']").attr("checked",false);
	}
}

function SelectPlat(type)
{
	$.ajax({type: "post",url: game_graph_php+"LoadPlats.php",dataType: "string",
		success: function(result) {
			var selectPlat = document.getElementById("selectPlat");
			var plats = result.split("|");
			for(var i = 0;i != plats.length;++i)
			{
				var platInfo = plats[i].split(",");
				var option = "<option value='"+platInfo[0]+"'>"+platInfo[1]+"</option>";
				$("#selectPlat").append(option);
			}
			SelectServer(type);
		}
	});
}

function SelectServer(type)
{
	var plat = document.getElementById("selectPlat").value;
	if(plat == -1)
	{
		$("#serverDiv").html("");
		return;
	}
	$.ajax({type: "post",url: game_graph_php+"LoadServers.php",dataType: "string",
		data:{"plat":plat},
		success: function(result) {
//			$("#serverDiv").html("");
//			$("#serverDiv").append("<p>请选择服务器:<br/><br/><p/>");
//			$("#serverDiv").append("<tab id='serverTab'></tab>");
			var servers = result.split("|");
			if(type == "checkbox")
			{
				$("#serverTab").html("");
				$("#serverTab").append("请选择服务器: <input id='selectAll' type='checkbox' value='0' checked='checked'>全选/取消</input> <br/> <br/>");
				$("#selectAll").unbind("click");
				$("#selectAll").bind("click",function(){selectAll(this,"chk");});
			}
			for(var i = 0;i < servers.length;++i)
			{
				var serverInfo = servers[i].split(",");
				$("#serverTab").append(" <input name='chk' type='"+type+"' value='"+serverInfo[0]+"'>"+serverInfo[1]+"</input>");
			}
			$("input[name='chk']").attr("checked",true);
		},
		error: function(e) {alert("查询数据失败");}
	});
}
