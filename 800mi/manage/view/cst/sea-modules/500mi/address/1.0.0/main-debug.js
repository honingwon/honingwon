define(function(require){

	//加载公共模块，加载即执行
	require("common");
	require("cart");
	
	var _ = require('underscore');
	var $ = require("$");
	var Validator = require("validator");
	
	var validator = new Validator({
		element: '#form'
	});	
	validator.addItem({
		element: '#name',
		required: true,
		display: '门店名称'
	}).
	addItem({
		element: '#city',
		required: true,
		display: '城市名称'
	}).
	addItem({
		element: '#district',
		required: true,
		display: '区/县名称',
		showMessage: function(message, element) {
			var startErr = $.trim(this.getExplain(element).html());
			if (!startErr) {
				this.getExplain(element).html(message);
				this.getItem(element).addClass(this.get('itemErrorClass'));
			}
		},
		hideMessage: function(message, element) {
			var startErr = $.trim(this.getExplain(element).html());
			if (!startErr) {
				this.getExplain(element).html(element.attr('data-explain') || ' ');
				this.getItem(element).removeClass(this.get('itemErrorClass'));
			}
		}
	}).
	addItem({
		element: '#street',
		required: true,
		display: '街道地址'
	}).
	addItem({
		element: '#phone',
		required: true,
		display: '手机号码'
	});	
	
	//添加地址		
	$('button[type="submit"]').bind('click',function(){
		//品牌列表、类型列表加载完成之后才可以进行表单验证、提交。
		validator.execute(function(error, results, element) {
			if(!error) save();
		});
		return false;
	});

	function save()
	{
		var data = {
			"method": "Add",
			"name": $(".searchForm input[name='name']").val(),
			"province": '浙江省',
			"city": $(".searchForm select[name='city']").val(),
			"district": $(".searchForm select[name='district']").val(),
			"addr": $(".searchForm textarea[name='street']").val(),
			"contacts":'联系方式???',
			"phone": $(".searchForm input[name='phone']").val()	
		};
		if(OP == "edit")
		{
			data.method="edit";
			data.storeId = $(".searchForm input[name='id']").val();
		}
		$.ajax({type: "post",url: "/view/model/BMManage/StoreManageMethod.php",dataType: "json",
			data: data,
			success: function(result) {
				if(result.Success){
					if(OP == "edit") 
						alert('编辑成功'); 
					else 
						alert('添加成功');
					window.location.href="/view/cst/myaddress.php";
				}
				else
					alert('添加失败');
			},
			error: function(e) {alert("链接错误");}
		});
	}	
	
	//加载地址列表	
	$.ajax({type: "get",url: "/view/model/BMManage/StoreManageMethod.php",dataType: "json",
		data: {"method":"List"},
		success: function(result) {
			console.log(result)
			if(result.Success){
				var html = '',data=result.DataList,dataItem;
				for(var i=0;i<data.length;i++)
				{
					dataItem = data[i];
					html += '<tr class="'+(i%2==1?'even':'')+'">';
					html += '</tr>';
					html += '<td>'+dataItem.shop_name+'</td>';
					html += '<td>'+dataItem.shop_city+dataItem.shop_district+'</td>';
					html += '<td>'+dataItem.shop_addr+'</td>';
					html += '<td>'+dataItem.shop_phone+'</td><td></td>';
					
					html += '<td class="t-operate"><a href="/view/cst/myaddress.php?op=edit&id='+dataItem.shop_id+'&name='+dataItem.shop_name+'&street='+dataItem.shop_addr+'&phone='+dataItem.shop_phone+'">修改</a>|<a class="delete" href="javascript:address.deleteItem('+dataItem.shop_id+');">删除</a></td>';
				}
				$('#addressList').html(html);
			}
		},
		error: function(e) {alert("链接错误");}
	});
	
	var address = {};
	address.deleteItem = function(id){
	
		$.ajax({type: "post",url: "/view/model/BMManage/StoreManageMethod.php",dataType: "json",
			data: {"method":"Del","storeId":id},
			success: function(result) {
				if(result.Success){
					alert('删除成功');
					window.location.href="/view/cst/myaddress.php";
				}
				else
					alert('删除失败');
			},
			error: function(e) {alert("链接错误");}
		});
	};
	window.address = address
});