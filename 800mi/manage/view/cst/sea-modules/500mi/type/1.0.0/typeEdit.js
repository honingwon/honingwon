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
	var dataList;
	//加载类型列表
	var data = {'method':'ListType'+LV};
	if(LV == 2) data.type1Id = 0;
	if(LV == 3) data.type2Id = 0;
	$.ajax({type: "post",url: "/view/model/BMManage/GoodsTypeManageMethod.php",dataType: "json",
		data:data,
		success: function(result) {
			if(result.Success){
				var typeListView = $('#type');
				dataList = result.DataList;
				_.each(dataList, function(item){
					var viewItem;
					if(LV == 1)viewItem = '<option value="'+item.type1_id+'">'+item.type1_name+'</option>';
					if(LV == 2)viewItem = '<option value="'+item.type2_id+'">'+item.type2_name+'</option>';
					if(LV == 3)viewItem = '<option value="'+item.type2_id+'">'+item.type2_name+'</option>';
					typeListView.append(viewItem);
				});
			}
			else
				alert('获取类型列表失败，请稍后重试。');
		},
		error: function(e) {alert("链接错误");}
	});
	
	$('button[type="submit"]').bind('click',function(){
		validator.execute(function(error, results, element) {
			if(!error){
				var data = {
					'method':'edit'+LV,
					'id':$(".searchForm select[name='type']").val(),
					'name':$(".searchForm input[name='name']").val(),
					'order':$(".searchForm input[name='order']").val(),
					//'order':0
					'state':0
				};
				if(LV == 2)
				{
					for(var i=0; i< dataList.length;i++)
					{
						if(dataList[i].type2_id == data.id)
						{
							data.type1_id = dataList[i].type1_id;
							break;
						}
					}
				}
				if(LV == 3)
				{
					for(var j=0; j< dataList.length;j++)
					{
						if(dataList[j].type2_id == data.id)
						{
							data.type2_id = dataList[j].type1_id;
							break;
						}
					}
				}
				$.ajax({type: "post",url: "/view/model/BMManage/GoodsTypeManageMethod.php",dataType: "json",
					data: data,
					success: function(result) {
						if(result.Success){
							alert('编辑成功');
							location.reload();
						}
						else
							alert('编辑失败');
					},
					error: function(e) {alert("链接错误");}
				});
			} 
		});
		return false;
	});		
})