define(function(require){var e=require("underscore"),t=require("$");t.ajax({type:"get",url:"/view/model/BMManage/StoreManageMethod.php",dataType:"json",data:{method:"List"},success:function(e){if(e.Success){var n="",r=e.DataList,i,s,o;for(var u=0;u<r.length;u++)i=r[u],s=u==0?' class="select"':"",o=u==0?' checked="checked"':"",n+='<li data-id="'+i.shop_id+'" '+s+'><label><input type="radio" name="r-address" '+o+" /><em>",n+=i.shop_name+'</em><span class="s-address">',n+=i.shop_addr+'</span><span class="s-tel"> ',n+=i.shop_phone+"</span>",n+='<a class="s-edit" href="/view/cst/myaddress.php?op=edit&id='+i.shop_id+"&name="+i.shop_name+"&street="+i.shop_addr+"&phone="+i.shop_phone+'">修改地址</a>';t("#select-address").append(n),t("#select-address label").on("click",function(){t("#select-address li").removeClass("select"),t(this).parent().addClass("select")})}},error:function(e){alert("链接错误")}}),function(n){var r='<tr class="item"><td class="s-code"><%- goods_barcode %></td><td class="s-title"><%- goods_name %></td><td class="s-sp"></td><td class="s-amount"><%- amount %></td><td class="s-price"><%- goods_active_price %></td><td class="s-agio">0.00</td><td class="s-total"><%- total %></td></tr>',i=e.template(r),s="",o=0,u=0,a=0,f="",l="",c="";e.each(CART_DATA,function(e){e.total=e.amount*e.goods_active_price,s+=i(e),o+=e.amount,u+=e.total,f+=e.id+",",l+=e.amount+","}),f=f.slice(0,f.length-1),l=l.slice(0,l.length-1),c=f+"|"+l,a=u,t("#goodList").html(s),t("#amount").html(o),t("#total").html(u),t("#total2").html(a),console.log(c),t("#submit").on("click",function(){var e=t("#select-address li.select").attr("data-id");return t.ajax({type:"post",url:"/view/model/BMManage/PurchaseManageMethod.php",dataType:"json",data:{method:"Add",list:c,storeId:e,remark:"123"},success:function(e){e.Success&&(alert("订单提交成功"),location.href="/view/cst/index.php")},error:function(e){alert("链接错误")}}),!1})}(window)})