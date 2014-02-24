define(function(require){
	
	var _ = require('underscore');
	var $ = require("$");
	
	//加载地址列表	
	$.ajax({type: "get",url: "/view/model/BMManage/StoreManageMethod.php",dataType: "json",
		data: {"method":"List"},
		success: function(result) {
			if(result.Success){
				var html = '',data=result.DataList,dataItem;
				var str,str2;
				for(var i=0;i<data.length;i++)
				{
					dataItem = data[i];
					str = (i==0 ? ' class="select"' : '');
					str2 = (i==0 ? ' checked="checked"' : '');
					html += ('<li'+str+'><label><input type="radio" name="r-address" '+str2+' /><em>');					
					html += dataItem.shop_name+'</em><span class="s-address">';
					html += dataItem.shop_addr+'</span><span class="s-tel"> ';
					html += dataItem.shop_phone+'</span>';
					html += '<a class="s-edit" href="/view/cst/myaddress.php?op=edit&id='+dataItem.shop_id+'&name='+dataItem.shop_name+'&street='+dataItem.shop_addr+'&phone='+dataItem.shop_phone+'">修改地址</a>';
				}
				
				$("#select-address").append(html);
				
				$("#select-address label").on('click',function(){
					$("#select-address li").removeClass('select');
					$(this).parent().addClass('select');
				})
			}
		},
		error: function(e) {alert("链接错误");}
	});
});