var _class_serverRights = null;
var _server = "";
var _beginDate = "";
var _endData = "";

$(document).ready(function() {
	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',2);
	$("#btnSubmit").bind("click",btnSumbitOnclickHandler);
});

function btnSumbitOnclickHandler()
{
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
				"method":"searchArpu",
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
  
    var i = 0;
    var row = DataList[i];
    var html =''; 
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var total = (row[5]/10+row[6]/1+row[7]/1)/10;
    	html += "<tr class='"+className+"'><td>"+row[0]+"</td><td>"+row[1]+"</td><td>"+row[2]+"</td><td>"+row[3]+"</td><td>"+row[4]+"</td><td>"+total+"</td><td>"+row[8]+"</td><td>"+row[9]+"</td><td>"+(row[8]/row[4] * 100).toFixed(2)+"</td><td>"+(total/row[8]).toFixed(2)+"</td></tr>";;
        i++;
        row = DataList[i];
    }
    
    $("#List_Body").html(html);

}

function clean() 
{
	$("#List_Body").html("<tr><td colspan='9' class='tc_rad'>暂未有数据信息</td></tr>");
}
