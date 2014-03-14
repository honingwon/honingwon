var _class_serverRights = null;
var _type = "-1";
var _server = "";
var _beginDate = "";

$(document).ready(function() {
	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',2);
	$("#btnSubmit").bind("click",btnSumbitOnclickHandler);
});

function btnSumbitOnclickHandler()
{
	clean();
	var type = $("input[name='type']:checked").val();
	var server = _class_serverRights.getBoxValue();
	var beginDate = $("#beginDate").val();
	if(server == "" || server == undefined || beginDate == "")
	{
		setOnburPline("btnSubmit","请输入查看条件");
		return;
	}
//	if(type == _type && server == _server && beginDate == _beginDate )
//	{
//		setOnburPline("btnSubmit","与上次输入的查询条件相同，不能重复提交");
//		return;
//	}
	setOnburPline("btnSubmit","");
	_type = type;
	_server = server;
	_beginDate = beginDate;

	$("#btnSubmit").hide();
	setOnburPline("btnSubmit","正在查询... 请耐心等待，不要刷新页面！");
	$.ajax({type: "post",url: 'interface/DataAbalysisManageMethod.php',
		dataType: "json",
		data: {
				"method":"levelLostSearch",
				"type":type,
				"startTime":beginDate,
				"server":server},
		success: function(result) {
			if(result.Success){
				FormatData(result,beginDate,server,type);
				setOnburPline("btnSubmit","");
			}
			else{
				setOnburPline("btnSubmit",result.Message);
			}
			$("#btnSubmit").show();
		},
		error: function(e) {
			$("#btnSubmit").show();
			setOnburPline("btnSubmit",'out data config 检查这个服配置信息');
		}
	});
}

function FormatData(objData,startTime,selectValue,type)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body").html("<tr><td colspan='2' class='tc_rad'>暂未有数据信息</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#List_Body").html("<tr><td colspan='2' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    var serverName = _class_serverRights.getServerName(selectValue);
    var typeName = type == 1 ? "所有玩家" : type == 2 ? "流失玩家" :"null Type";
    var i = 0;
    var tamount = DataList[0][0][0];
    var html = '';// '<tr><td colspan="2"><span style="color:#F00" ><b>'+typeName+'</b>  统计：'+serverName+';时间：'+startTime+'; </span></td></tr>'; 
    var row = DataList[1][0];
    var t1 = 0;
    var t2 = 0;
    var t3 = 0;
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	html += "<tr class='"+className+"'><td>"+row[0]	+"</td>"+
    			"<td>"+row[1]+"("+(row[1]/tamount*100).toFixed(2)+"%)</td></tr>";;
        i++;
        if(row[0] <= 37) {
        	t1 += parseInt(row[1]);
        }
        else if(row[0] <= 43) {
        	t2 += parseInt(row[1]);
        }
        else {
        	t3 += parseInt(row[1]);       	
        }
        row = DataList[1][i];
    }
    html = '<tr><td colspan="2"><span style="color:#F00" ><b>'+typeName+'</b>  统计：'+serverName+';时间：'+startTime+
    '[<= 37 :'+t1+'('+(t1/tamount*100).toFixed(2)+'%)] [<=43:'+t2+'('+(t2/tamount*100).toFixed(2)+'%)] [>43:'+t3+'('+(t3/tamount*100).toFixed(2)+'%)]  </span></td></tr>' + html; 
    $("#List_Body").html(html);

}

function clean() 
{
	$("#List_Body").html("<tr><td colspan='2' class='tc_rad'>暂时未有数据</td></tr>");
}
