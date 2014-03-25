define(function(require){

	//加载公共模块，加载即执行
	require("common");
	require("cart");
	
	var $ = require('$');
	var _ = require('underscore');
	var Validator = require("validator");
	
	var validator = new Validator({
		element: '#form'
	});	
	if(LV != 1)
		validator.addItem({
			element: '#type',
			required: true,
			errormessageRequired: '请选择类型'
		});	
	validator.addItem({
		element: '#name',
		required: true,
		errormessageRequired: '类型名称不能为空'
	});	
	validator.addItem({
		element: '#order',
		required: true,
		errormessageRequired: '排序号不能为空'
	});	
	
		
	$('button[type="submit"]').bind('click',function(){
		validator.execute(function(error, results, element) {
			if(!error){
				var data = {
					'method':'Add',
					'parentId':-1,
					'index':LV,
					'name':$(".searchForm input[name='name']").val(),
					'order':$(".searchForm input[name='order']").val()
					//'order':0
				};
				if(LV != 1)
					data.parentId = $(".searchForm select[name='type']").val()
				console.log(data);
				$.ajax({type: "post",url: "/view/model/BMManage/GoodsTypeManageMethod.php",dataType: "json",
					data: data,
					success: function(result) {
						if(result.Success){
							alert('添加成功');
							location.reload();
						}
						else
							alert('添加失败');
					},
					error: function(e) {alert("链接错误");}
				});
			} 
		});
		return false;
	});	
	//加载类型列表
	if(LV != 1)
	{
		var data = {'method':'ListType'+(LV-1),'type1Id':0};
		$.ajax({type: "post",url: "/view/model/BMManage/GoodsTypeManageMethod.php",dataType: "json",
			data:data,
			
			success: function(result) {
				if(result.Success){
					var typeListView = $('#type');
					var data1 = result.DataList;
					_.each(data1, function(item){
						var viewItem;
						if(LV == 2)viewItem = '<option value="'+item.type1_id+'">'+item.type1_name+'</option>';
						if(LV == 3)viewItem = '<option value="'+item.type2_id+'">'+item.type2_name+'</option>';
						typeListView.append(viewItem);
					});
				}
				else
					alert('获取类型列表失败，请稍后重试。');
			},
			error: function(e) {alert("链接错误");}
		});
	}	
})