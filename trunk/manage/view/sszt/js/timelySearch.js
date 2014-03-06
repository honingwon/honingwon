var _class_serverRights = null;
var _server = "";
var _beginDate = "";
var _endData = "";

$(document).ready(function() {
	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',1);
	$("#btnSubmit").bind("click",btnSumbitOnclickHandler);
});

function btnSumbitOnclickHandler()
{
	clean();
	var server = _class_serverRights.getBoxValue();
	var beginDate = $("#beginDate").val();
	var endDate = $("#endDate").val();
	
	if(server == "" || beginDate == "")
	{
		setOnburPline("btnSubmit","请输入查看条件");
		return;
	}
	
	setOnburPline("btnSubmit","");
	_server = server;
	_beginDate = beginDate;
	_endData = endDate;

	$("#btnSubmit").hide();
	setOnburPline("btnSubmit","正在查询... 请耐心等待，不要刷新页面！");
	$.ajax({type: "post",url: 'interface/DataAbalysisManageMethod.php',
		dataType: "json",
		data: {
				"method":"searchtimely",
				"startTime":beginDate,
				"endTime":endDate,
				"server":server},
		success: function(result) {
			if(result.Success){
				FormatData(result);
				setOnburPline("btnSubmit","");
			}
			else{
				clean();
				setOnburPline("btnSubmit",result.Message);
			}
			$("#btnSubmit").show();
		},
		error: function(e) {
			$("#btnSubmit").show();
			clean();
			setOnburPline("btnSubmit",'out data config 检查这个服配置信息');
		}
	});
}

function FormatData(objData)
{
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	clean();
        return;
    }
    var servers = _server.split(",");
    
    var i = 0;
    var Data = DataList[i];
    var html =''; 
    var TotalRegister =0;
    var TotalPay =0;
    var TotalPayPlayer =0;
    while (Data != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var Register = parseInt(Data[0][0]);
    	TotalRegister += Register;
    	var Pay = parseInt(Data[1][0][0]) ;
    	TotalPay += Pay;
    	var PayPlayer = parseInt(Data[1][0][1]) ;
    	TotalPayPlayer += PayPlayer;
    	var serveName = _class_serverRights.getServerName(servers[i]);
    	html += "<tr class='"+className+"'><td>"+serveName+"</td><td>"+Register+"</td><td>"+PayPlayer+"</td><td>"+Pay+"</td></tr>";
        i++;
        Data = DataList[i];
    }
    
    $("#List_Body").html(html);
    $("#List_Body1").html("<tr><td>"+TotalRegister+"</td><td>"+TotalPayPlayer+"</td><td>"+TotalPay+"</td></tr>");
}

function clean() 
{
	$("#List_Body").html("<tr><td colspan='4' class='tc_rad'>暂未有数据信息</td></tr>");
	$("#List_Body1").html("<tr><td colspan='3' class='tc_rad'>暂未有数据信息</td></tr>");
}
