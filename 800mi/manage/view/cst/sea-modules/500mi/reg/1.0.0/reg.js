define(function(require){	

	var $ = require("$");
	
	function btnSubmit()
	{
		var account = $('#account').val();
		if(account == ""){
			alert("请输入帐号！");
			return false;
		}
		var name = $('#name').val();
		if(name == ""){
			alert("请输入昵称！");
			return false;
		}
		
		$.ajax({type: "post",url: "/view/model/BaseData/AccountManageMethod.php",dataType: "json",
			data: {
				'method':'Add',
				'account':account,
				'name':name,
				'level':1,
				'type':3,
				'dec':'1111111'
			},
			success: function(result) {
				if(result.Success){
					alert('注册成功');
					location.reload();
				}
				else
					alert('注册失败，请稍后重试。');
			},
			error: function(e) {alert("链接错误");}
		});
		
		return false;
	}

	
	$('#submit').on('click',btnSubmit)
})