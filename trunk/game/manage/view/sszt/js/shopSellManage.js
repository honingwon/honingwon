var _class_serverRights = null;
var _shopType = "-1";
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
	var shopType = $("input[name='shopType']:checked").val();
	var server = _class_serverRights.getBoxValue();
	var beginDate = $("#beginDate").val();
	var endDate = $("#endDate").val();
	
	if(server == "" || beginDate == "")
	{
		setOnburPline("btnSubmit","请输入查看条件");
		return;
	}
	if(shopType == _shopType && server == _server && beginDate == _beginDate && endDate == _endData)
	{
		setOnburPline("btnSubmit","与上次输入的查询条件相同，不能重复提交");
		return;
	}
	setOnburPline("btnSubmit","");
	_shopType = shopType;
	_server = server;
	_beginDate = beginDate;
	_endData = endDate;


	$("#btnSubmit").hide();
	setOnburPline("btnSubmit","正在查询... 请耐心等待，不要刷新页面！");
	$.ajax({type: "post",url: 'interface/DataAbalysisManageMethod.php',
		dataType: "json",
		data: {
				"method":"mallSelling",
				"shopType":shopType,
				"startTime":beginDate,
				"endTime":endDate,
				"server":server},
		success: function(result) {
			if(result.Success){
				FormatData(result,beginDate,endDate,server,shopType);
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

function FormatData(objData,startTime,endTime,selectValue,shopType)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body").html("<tr><td colspan='7' class='tc_rad'>暂未有数据信息</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#List_Body").html("<tr><td colspan='7' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    var serverName = _class_serverRights.getServerName(selectValue);
    var shopTypeName = shopType == 1 ? "游戏商城" : shopType == 2 ? "神秘商城" : shopType == 3 ? "功勋商店" : shopType == 4 ? "优惠商品": shopType == 5 ? "其它消耗":"null Type";
    var i = 0;
    var tamount = DataList[0][0][0];
    var tnum = DataList[0][0][1];
    var ttimes = DataList[0][0][2];
    var tyuanbao= DataList[0][0][3];
    var tbind_yuanbao= DataList[0][0][4];
    var row = DataList[1][i];
    var html ='<tr><td colspan="7"><span style="color:#F00" ><b>'+shopTypeName+'</b>   出售情况统计：'+serverName+';时间：'+startTime+'~'+endTime+'; </span></td></tr>'; 
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	html += "<tr class='"+className+"'><td>"+row[0]	+"</td><td>"+row[1]+"</td>"+
    			"<td>"+row[2]+"("+(row[2]/tamount*100).toFixed(2)+"%)</td><td>"+row[3]+"("+(row[3]/tnum*100).toFixed(2)+"%)</td>" +
    					"<td>"+row[4]+"("+(row[4]/ttimes*100).toFixed(2)+"%)</td><td>"+row[5]+"("+(row[5]/tyuanbao*100).toFixed(2)+"%)</td>" +
    							"<td>"+row[6]+"("+(row[6]/tbind_yuanbao*100).toFixed(2)+"%)</td></tr>";;
        i++;
        row = DataList[1][i];
    }
    $("#List_Body").html(html);

}
