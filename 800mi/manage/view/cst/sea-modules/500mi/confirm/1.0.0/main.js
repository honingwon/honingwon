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
					html += ('<li data-id="'+dataItem.shop_id+'" '+str+'><label><input type="radio" name="r-address" '+str2+' /><em>');					
					html += dataItem.shop_name+'</em><span class="s-address">';
					html += dataItem.shop_addr+'</span><span class="s-tel"> ';
					html += dataItem.shop_phone+'</span>';
					html += '<a class="s-edit" href="/view/cst/myaddress.php?op=edit&id='+dataItem.shop_id+'&name='+dataItem.shop_name+'&street='+dataItem.shop_addr+'&phone='+dataItem.shop_phone+'">修改地址</a>';
				}
				
				$("#select-address").append(html);
				
				$("#select-address label").on('click',function(){
					$("#select-address li").removeClass('select');
					$(this).parent().addClass('select');
				});
			}
		},
		error: function(e) {alert("链接错误");}
	});
	
	//构建商品列表 
	
	(function(root){
		var CART_ITEM_TEMPLATE = 
			'<tr class="item">'+
				'<td class="s-code"><%- goods_barcode %></td>'+
				'<td class="s-title"><%- goods_name %></td>'+
				'<td class="s-sp"></td>'+
				'<td class="s-amount"><%- amount %></td>'+
				'<td class="s-price"><%- goods_active_price %></td>'+
				'<td class="s-agio">0.00</td>'+
				'<td class="s-total"><%- total %></td>'+
			'</tr>';
		var template = _.template(CART_ITEM_TEMPLATE);
		var html = '',totalAmount = 0,totalPrice = 0,totalPrice2 = 0;
		var key='',value='',data='';
		_.each(CART_DATA,function(dataItem){
		
			dataItem.total = dataItem.amount * dataItem.goods_active_price;
			html += template(dataItem);
			totalAmount += dataItem.amount;
			totalPrice += dataItem.total;
			
			key += dataItem.id+',';
			value += dataItem.amount+',';
		});
		
		key = key.slice(0,key.length - 1);
		value = value.slice(0,value.length - 1);
		data = key+'|'+value;
		
		totalPrice2 = totalPrice;
		$('#goodList').html(html);
		$('#amount').html(totalAmount);
		$('#total').html(totalPrice);
		$('#total2').html(totalPrice2);
		
		console.log(data);
		
		$('#submit').on('click',function(){
			var storeId = $("#select-address li.select").attr('data-id');
			$.ajax({type: "post",url: "/view/model/BMManage/PurchaseManageMethod.php",dataType: "json",
				data: {
					"method":"Add",
					"list":data,
					"storeId":storeId,
					"remark":'123',
					},
				success: function(result) {
					if(result.Success){
						alert('oooh')
					}
				},
				error: function(e) {alert("链接错误");}
			});
			return false;
		});
	})(window);
});