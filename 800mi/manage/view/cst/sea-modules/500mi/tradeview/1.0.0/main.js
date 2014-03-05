define(function(require){

	//加载公共模块，加载即执行
	require("common");
	require("cart");
	
	var _ = require('underscore');
	var $ = require("$");
	
	
	$.ajax({type: "get",url: "/view/model/BMManage/PurchaseManageMethod.php",dataType: "json",
		data: {
			"method":"List"
			},
		success: function(result) {
			if(result.Success){
				alert('111');
			}
		},
		error: function(e) {alert("链接错误");}
	});
});