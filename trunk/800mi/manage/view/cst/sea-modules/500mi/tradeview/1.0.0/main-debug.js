define(function(require){

	//加载公共模块，加载即执行
	require("common");
	require("cart");
	
	var _ = require('underscore');
	var $ = require("$");
	
	var orderItemTemplate1Str =
		'<tr class="order">'+
		'	<td colspan="7">'+
		'		<span>交易号：<em class="s-1"><%- purchase_id %></em></span>'+
		'		<span>进货时间：<em class="s-2"><%- date %></em></span>'+
		'		<span>进货金额：<em class="s-3"><%- total %></em></span>'+
		'	</td>'+
		'</tr>';
	var orderItemTemplate1 = _.template(orderItemTemplate1Str);
	var orderItemTemplate2Str =
		'<tr class="item">'+
		'	<td><%- goods_name %></td>'+
		'	<td></td>'+
		'	<td class="t-c"><%- goods_num %></td>'+
		'	<td class="price"><%- purchase_price %> <s title="原价"><%- goods_price %></s></td>'+
		'	<td></td>'+
		'	<td class="t-r"><%- purchase_state %></td>'+
		'	<td class="t-operate"></td>'+
		//'	<td class="t-operate"><a href="javascript:tradeView.closeOrder(<%- purchase_id %>);">关闭</a></td>'+
		'</tr>'
	var orderItemTemplate2 = _.template(orderItemTemplate2Str);
	
	window.tradeView = {};
	tradeView.closeOrder = function(id){
		alert(id)
	};
	
	$.ajax({type: "get",url: "/view/model/BMManage/PurchaseManageMethod.php",dataType: "json",
		data: {
			"method":"List"
			},
		success: function(result) {
			if(result.Success){
				var data = result.DataList;
				var orders = [],order;
				var find = function(purchase_id){
					var ret;
					for(var i=0; i<orders.length;i++)
					{
						if(purchase_id == orders[i].purchase_id)
						{
							ret = orders[i];
							break;
						}
					}
					return ret;
				};
				_.each(data,function(dataItem){
					order = find(dataItem.purchase_id);
					var state = '未知';
					switch(dataItem.purchase_state)
					{
						case '0' :
							state = '提交';
							break;
						case '1' :
							state = '已付款';
							break;
						case '2' :
							state = '已发货';
							break;
						case '3' :
							state = '已收获';
							break;
						case '4' :
							state = '退货';
							break;
						case '98' :
							state = '关闭';
							break;
					}			
					dataItem.purchase_state = state
					if(!order)
					{
						var date = new Date();
						date.setTime(dataItem.add_time*1000);
						
						order = {
							purchase_id:dataItem.purchase_id,
							date:date.toLocaleString(),
							total:0,
							html1:'',
							html2:''
						};
						orders.push(order);
					}
					order.total += dataItem.goods_num * dataItem.purchase_price;
					order.html1 = orderItemTemplate1(order);
					order.html2 += orderItemTemplate2(dataItem);
				});
				_.each(orders,function(order){
					$('#orderList').append(order.html1+order.html2);
				});
			}
		},
		error: function(e) {alert("链接错误");}
	});
});