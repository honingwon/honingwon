var _class_serverRights = null;
var _server = "";
var _beginDate = "";

var _Currenpage = 1;
var _CurrentPageLine = 50;

$(document).ready(function() {
	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',2);
	$("#btnSubmit").bind("click",btnSumbitOnclickHandler);
});

function btnSumbitOnclickHandler()
{
	server = _class_serverRights.getBoxValue();
	beginDate = $("#beginDate").val();
	
	if(server == "" || beginDate == "")
	{
		setOnburPline("btnSubmit","请输入查看条件");
		return;
	}
//	if( server == _server && beginDate == _beginDate )
//	{
//		setOnburPline("btnSubmit","与上次输入的查询条件相同，不能重复提交");
//		return;
//	}
	_Currenpage = 1;
	setOnburPline("btnSubmit","");
	_server = server;
	_beginDate = beginDate;
	doSearchList();
}

function PageChange(num)
{
	_Currenpage = num
	doSearchList();
}

function doSearchList()
{
	$("#btnSubmit").hide();
	setOnburPline("btnSubmit","正在查询... 请耐心等待，不要刷新页面！");
	$.ajax({type: "post",url: 'interface/DataAbalysisManageMethod.php',
		dataType: "json",
		data: {
				"method":"qpaysearch",
				"startTime":beginDate,
				"server":server,
				"pagesize":_CurrentPageLine,
				"curpage":_Currenpage},
		success: function(result) {
			if(result.Success){
				FormatData(result);
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




function FormatData(objData)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body").html("<tr><td colspan='4' class='tc_rad'>暂未有数据信息</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#List_Body").html("<tr><td colspan='4' class='tc_rad'>暂时未有数据</td></tr>");
    	$("#List_Body_Total").html("<tr><td colspan='3' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    
    var i = 0;
    var row = DataList[0][i];
    var html =''; 
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	html += "<tr class='"+className+"'><td>"+row[4]+"</td><td>"+row[0]/10+"</td><td>"+row[1]+"</td><td>"+row[2]+"</td><td>"+row[3]+"</td></tr>";;
        i++;
        row = DataList[0][i];
    }
    var FSumCount = objData.Tag;
    var FPageCount = Math.ceil(FSumCount / _CurrentPageLine);
    var pagingation = new Pagination("Pagination1", FPageCount, _Currenpage, FSumCount, _CurrentPageLine, "PageChange", "divPagination", 1)
    $("#List_Body").html(html);
    
    var html1 =''; 
    i = 0;
    row = DataList[1][i];
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	html1 += "<tr class='"+className+"'><td>"+(row[0]/10+row[1]/1+row[2]/1)/10+"</td><td>"+row[0]/10+"</td><td>"+row[1]+"</td><td>"+row[2]+"</td></tr>";;
        i++;
        row = DataList[1][i];
    }
    $("#List_Body_Total").html(html1);
    
    

}
