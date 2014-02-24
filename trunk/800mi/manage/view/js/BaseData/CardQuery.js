$(document).ready(function() {
	initShow(null);
	$("#btnSearch").bind("click",btnSearchClickHandler);
});

function btnSearchClickHandler()
{
	var cardText = $("#searchcardtext").val();
	var type = $("#seltype").val();
	if(strlen(Trim(cardText)) < 1 || strlen(Trim(cardText)) > 16)
	{
		var msg = type == 0 ? "请正确输入卡密码！":"请正确输入卡号！";
		setOnbur("searchcardtext",msg);
		return;
	}
	setOnbur("searchcardtext","");
	$.ajax({type: "post",url: "../model/BaseData/CardQueryMethod.php",dataType: "json",data: {"method": "info","type":type,"txt":cardText},
		success: function(result) {
		   if(result.Success){
			   if(result.DataList!=null && result.DataList.length == 1){
				   initShow(result.DataList[0])
			   }
			   else{
				   initShow(null);
				   alert("不存在此信息，请重新输入");
			   }
			}
		   else
		   {
			   initShow(null);
			   alert(result.Message);
		   }
		},
		error: function(e) {initShow(null);alert("连接错误");}
	});
	
}

function initShow(data)
{
	var cardTypeName = data == null ? "":data.cardTypeName;
	var cardNumber	 = data == null ? "":data.cardSN;
	var cardPWD		 = data == null ? "":data.cardPassword;
	var cardChangeTime = data == null ? "":data.cardChargeTime;
	var cardState	   = "";
	if(data!=null)
	{
		switch (parseInt(data.cardState)) {
			case 0: cardState = '未充值';  break;
			case 1: cardState = '已充值';  break;
			case 91: cardState = '锁定'; break;
			case 92: cardState = '作废'; break;
			default: cardState = '未充值'; break;
		}
	}
	
	var groupIndex	 = data == null ? "":data.cardGroupID;
	var groupState	 = "";
    if(data != null){
    	switch (parseInt(data.cardGroupState)) {
            case 0: groupState = '已生成'; break;
            case 1: groupState = '启用'; break;
            case 90: groupState = '过期'; break;
            case 91: groupState = '锁定'; break;
            case 92: groupState = '作废'; break;
            default: groupState = '已生成'; break;
    	}
    }
    var changeStart = data == null ? "":data.cardGroupStartTime;
    var changeEnd 	= data == null ? "":data.cardGroupEndTime;
    
	$("#cardTypeName").html(cardTypeName);
	$("#cardNumber").html(cardNumber);
	$("#cardPassword").html(cardPWD);
	$("#cardState").html(cardState);
	$("#cardChangeTime").html(cardChangeTime);
	$("#groupNumber").html(groupIndex);
	$("#groupState").html(groupState);
	$("#groupchangeTimeStart").html(changeStart);
	$("#groupchangeTimeEnd").html(changeEnd);
	if(data == null){
		$("#card").hide();
	}
	else
		$("#card").show();
}