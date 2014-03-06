var _class_serverRights = null;
$(document).ready(function() {
	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',2);
	
	$("input[name='banChatType']:radio").click(function(){
		radioClickValueChange($(this).val());
	});
	
	$("#btnSumbit").bind("click",btnSumbitOnclickHandler);
});


function radioClickValueChange(value)
{
	if(value == 0)
	{
		$("#rowdate").show();
	}
	if(value == 1)
	{
		$("#rowdate").hide();
	}
}



function btnSumbitOnclickHandler()
{
	var doneType = $("input[name='banChatType']:checked").val(); 
	var doneKind = 0; 
	if(doneType == 0) //禁登
	{
		doneKind = $("#endTime").val();
	}
	var nickName =  Trim($("#playerNickName").val());
	if(strlen(nickName) == 0){
		showMsg(false,"请输入操作玩家的角色名！");
		return;
	}

	var selectValue = _class_serverRights.getBoxValue();
	if(selectValue == null || selectValue == "")
	{
		showMsg(false,"请选择合作商！");
		return;
	}
	$("#btnSumbit").hide();
	showMsg(false,"正在提交... 请耐心等待，不要刷新页面!");
	$.ajax({type: "post",url: 'interface/AdminInterface.php',
		dataType: "json",
		data: {"method":"forbid","user_name":nickName,"is_forbid":doneType,"forbid_date":doneKind,"server":selectValue},
		success: function(result) {
			if(result.Success){
				var error = "";
				if(result.DataList.length > 0)
				{
					for (var i = 0; i < result.DataList.length; i++) {
						error +=  result.DataList[i]+"<br />";
					}
				}
				if(error != ""){
					error = "操作失败，请查看错误日志<br />" + error;
					showMsg(false,error);
				}
				else{
					showMsg(true,"");
					alert("操作成功!");
					$("#playerNickName").val("");
					$("#forbidDesc").val("");
				}
			}
			else
				showMsg(false,"操作失败!");
			$("#btnSumbit").show();
		},
		error: function(e) {
			//alert("链接出错");
			$("#btnSumbit").show(); showMsg(true,"");}
	});
}

function showMsg(falg,msg){
	if(!falg){
		document.getElementById('msg').innerHTML =msg;
		document.getElementById('msg').style.visibility="visible";
	}
	else
		document.getElementById('msg').style.visibility="hidden";
}