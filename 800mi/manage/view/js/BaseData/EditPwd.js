$(document).ready(function() {
	$("#btnSave").bind("click",btnSaveClickHandler);
	$("#btnCancel").bind("click",function(){
		$("#oldpwd").val("");
		$("#newpwd").val("");
		$("#reNewpwd").val("");
		setOnburPline('oldpwd','');
		setOnburPline('newpwd','');
		setOnburPline('reNewpwd','');
	});
});

function btnSaveClickHandler()
{
	var oldPWD 	 = $("#oldpwd").val();
	var newPWD 	 = $("#newpwd").val();
	var RenewPWD = $("#reNewpwd").val();
	if(strlen(Trim(oldPWD)) == 0){
		setOnburPline('oldpwd','请输入原密码！');
		return;
	}
	setOnburPline('oldpwd','');
	if(!ValidatePassword(newPWD,'新密码','newpwd'))
		return;
	if(!ValidatePassword(RenewPWD,'确认新密码','reNewpwd'))
		return;
	$.ajax({type: "post",url: "../model/BaseData/AccountManageMethod.php",dataType: "json",
		data: {"method": "pwd","old":oldPWD,"new":newPWD},
		success: function(result) {
			if(result.Success){
				alert("修改成功！");
				if(result.Tag){
				   parent.location.reload();
				}
				else{
					$("#oldpwd").val("");
					$("#newpwd").val("");
					$("#reNewpwd").val("");
				}
			}
			else
				alert("修改失败："+result.Message);
		},
		error: function(e) {alert("链接错误");}
	});
}

function ValidatePassword(value, msg, obj) {
  var message = '';
  if (value.length < 6 || value.length > 15) {
      message = msg + "最短6位，最长15位！";
      setOnburPline(obj,message);
      return false;
  }
  var test = value.match(new RegExp(/[a-zA-Z]+/));
  if (test == null) {
      message = msg + "必须含有字母！";
      setOnburPline(obj,message);
      return false;
  }
  test = value.match(new RegExp(/\d+/))
  if (test == null) {
      message = msg + "必须含有数字！";
      setOnburPline(obj,message);
      return false;
  }

  if (!value.match(new RegExp(/^[0-9a-zA-Z_]+$/gi))) {
      message = msg + "只允许字母、数字、下划线！";
      setOnburPline(obj,message);
      return false;
  }
  setOnburPline(obj,'');
  return true;
}