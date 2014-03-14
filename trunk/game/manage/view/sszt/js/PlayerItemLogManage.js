var _class_serverRights = null;
var _isChecked = 0;

$(document).ready(function() {
	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',2);
	$("input[name='IDType']:radio").click(function(){
		radioClickValueChange($(this).val());
	});
	$("input[id='DateCheck']:checkbox").click(function(){
		checkboxClick();
	});
	$("#btnSubmit").bind("click",btnSumbitOnclickHandler);
	radioClickValueChange("1");
});

function checkboxClick()
{	
	if(_isChecked == 0)
	{
		$("#beginDate").hide();
		$("#endDate").hide();
		_isChecked=1;
	}
	else
	{
		$("#beginDate").show()
		$("#endDate").show()
		_isChecked=0;
	}
}

function radioClickValueChange(value)
{
	$("#templateID").val('');
	$("#itemID").val('');
	switch(value)
	{
		case "1":
			$("#templateType").show();
			$("#itemType").hide();
			break;
		case "2":
			$("#itemType").show();
			$("#templateType").hide();
			break;
	}
}

function btnSumbitOnclickHandler()
{
	var nickName =  Trim($("#playerNickName").val());
	var itemID =  Trim($("#itemID").val());
	var templateID =  Trim($("#templateID").val());
	var itemType =  $("input[name='itemOpType']:checked").val(); 
	var server = _class_serverRights.getBoxValue();
	var beginDate = $("#beginDate").val();
	var endDate = $("#endDate").val();

	if(server == undefined )
	{
		setOnburPline("btnSubmit","请选择合作商");
		return;
	}

	if(strlen(nickName)  <= 0){
		showCommonMsg(false,"请输入角色名！",'msg');
		return;
	}

	if(strlen(itemID)  > 0 && !ck_int(itemID)){
		showCommonMsg(false,"物品唯一编号必须是整数！",'msg');
		return;
	}	
	
	if(strlen(templateID)  > 0 && !ck_int(templateID)){
		showCommonMsg(false,"物品模板必须是整数！",'msg');
		return;
	}	
	if(_isChecked == 1)
	{
		beginDate=0;
		endDate=0;
	}
	setOnburPline("btnSubmit","");

	$("#btnSubmit").hide();
	setOnburPline("btnSubmit","正在查询... 请耐心等待，不要刷新页面！");
	$.ajax({type: "post",url: 'interface/DataAbalysisManageMethod.php',
		dataType: "json",
		data: {
				"method":"playerItemLog",
				"nickname":nickName,
				"itemid":itemID,
				"templateid":templateID,
				"itemtype":itemType,
				"startTime":beginDate,
				"endTime":endDate,
				"server":server},
		success: function(result) {
			if(result.Success){
				FormatData(result,beginDate,endDate,server,nickName,itemID,itemType);
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

function FormatData(objData,startTime,endTime,selectValue,nickName,itemID,itemType)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body").html("<tr><td colspan='7' class='tc_rad'>暂未有数据信息</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null ) {
    	$("#List_Body").html("<tr><td colspan='7' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    var i = 0;
    var row = DataList[i];
    var html="";
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	html += "<tr class='"+className+"'><td>"+row[0]+"</td><td>"+row[1]+"</td>"+
    			"<td>"+row[2]+"</td><td>"+GetItemOpType(row[3])+"</td>" +
    					"<td>"+row[4]+"</td><td>"+row[5]+"</td>" +
    							"<td>"+row[6]+"</td></tr>";
        i++;
        row = DataList[i];
    }
    $("#List_Body").html(html);

}

function GetItemOpType(type)
{
	var r = "";
	switch(type)
	{
	case "5":		r="物品出售";	break;
	case "6":		r="物品丢弃";	break;
	case "7":		r="物品喂养";	break;
	case "8":		r="物品使用";	break;
	case "9":		r="强化";		break;
	case "10":		r="镶嵌";		break;
	case "11":		r="合成";		break;
	case "12":		r="分解";		break;
	case "13":		r="融合";		break;
	case "14":		r="洗炼";		break;
	case "15":		r="PK掉落";	break;
	case "16":		r="升级品阶";	break;
	case "17":		r="任务扣除";	break;
	case "18":		r="移动覆盖";	break;
	case "19":		r="整理消失";	break;
	case "20":		r="回收";		break;
	case "21":		r="邮件";		break;
	default:		r="未知："+type;	break;
	}
	return r;
}
