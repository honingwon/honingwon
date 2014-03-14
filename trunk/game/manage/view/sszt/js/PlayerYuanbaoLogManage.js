var _class_serverRights = null;
var _isChecked = 0;

$(document).ready(function() {
	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',2);
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

function btnSumbitOnclickHandler()
{
	var nickName =  Trim($("#playerNickName").val());
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
				"method":"playerYuanbaoLog",
				"nickname":nickName,
				"startTime":beginDate,
				"endTime":endDate,
				"server":server},
		success: function(result) {
			if(result.Success){
				FormatData(result,beginDate,endDate,server,nickName);
				setOnburPline("btnSubmit","");
			}
			else{
				setOnburPline("btnSubmit",result.Message);
			}
			$("#btnSubmit").show();
		},
		error: function(e) {
			$("#btnSubmit").show();
			setOnburPline("btnSubmit",'out data config 检查这个服配置信息'+e);
		}
	});
}

function FormatData(objData,startTime,endTime,selectValue,nickName)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body").html("<tr><td colspan='8' class='tc_rad'>暂未有数据信息</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null ) {
    	$("#List_Body").html("<tr><td colspan='8' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    var i = 0;
    var row = DataList[i];
    var html="";
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	html += "<tr class='"+className+"'><td>"+row[0]+"</td><td>"+row[1]+"</td>"+
    			"<td>"+row[2]+"</td><td>"+GetYuanbaoOpType(row[3])+"</td>"+
    			"<td>"+row[4]+"</td><td>"+row[5]+"</td><td>"+row[6]+"</td>"+
    			"<td>"+row[7]+"</td></tr>";
        i++;
        row = DataList[i];
    }
    $("#List_Body").html(html);

}

function GetYuanbaoOpType(type)
{
	var r = "";
	switch(type)
	{
	case "1":		r="元宝商店购买";	break;
	case "2":		r="原地复活（复活地图模版id）";	break;
	case "3":		r="元宝寄售（寄售编号）";	break;
	case "4":		r="元宝购买寄售物品（寄售编号）";	break;
	case "5":		r="公会捐献（）？？？？";	break;
	case "6":		r="使用玫瑰花(物品模版id，数量)";	break;
	case "7":		r="发送邮件（接收人ID）";	break;
	case "8":		r="刷新坐骑技能（刷新次数）";	break;
	case "9":		r="宠物洗髓（宠物模版编号）";		break;
	case "10":		r="刷新宠物技能（刷新次数）";		break;
	case "11":		r="立即完成江湖令任务（任务类型）";		break;
	case "12":		r="清除穴位cd";		break;
	case "13":		r="离线经验兑换";		break;
	case "14":		r="副本商店购买";		break;
	case "15":		r="委托任务元宝完成";	break;
	case "16":		r="物品购买";	break;
	case "17":		r="背包扩展";	break;
	case "18":		r="优惠商品出售";	break;
	case "19":		r="淘宝消耗元宝";	break;
	case "20":		r="重置副本消耗（副本id）";		break;
	case "21":		r="功勋商店购买";		break;
	case "22":		r="切换资源战场阵营消耗(阵营)";	break;
	case "23":		r="神秘商店刷新";	break;
	case "24":		r="神秘商店购买";	break;
	
	case "26":		r="任务直接完成";		break;
	case "27":		r="兑换银两";		break;
	case "28":		r="结婚消耗";	break;
	case "29":		r="结婚送礼";	break;
	case "30":		r="结婚发送喜糖";	break;
	case "31":		r="强制离婚";	break;
	case "32":		r="将小妾提升为妻子，如果有妻子着妻子转换成小妾";		break;
	case "33":		r="宠物斗坛减cd（操作时间）";		break;
	case "34":		r="宠物斗坛增加次数（总次数）";		break;
	

	case "100":		r="活力点奖励";		break;
	case "101":		r="GM 命令增加";		break;
	case "102":		r="每日领取奖励";	break;
	case "103":		r="邮件收取";	break;
	case "104":		r="副本奖励";	break;
	case "105":		r="采集获得";	break;
	case "106":		r="任务奖励";		break;
	case "107":		r="充值获得";		break;
	case "108":		r="拍卖行销售";		break;
	case "109":		r="拍卖行撤销";	break;
	
	case "120":		r="目标奖励";		break;
	case "121":		r="vip奖励";		break;
	case "122":		r="道具出售";		break;
	case "123":		r="道具使用";		break;
	case "124":		r="开箱子";		break;
	case "125":		r="活动获取";		break;
	
	case "127":		r="兑换银两";		break;
	
	default:		r="未知："+type;	break;
	}
	return r;
}
