define(function(require){

	//加载公共模块，加载即执行
	require("common");
	require("cart");
	require('ajaxfileupload');
	
	var _ = require('underscore');
	var $ = require("$");
	var Validator = require("validator");
	
	var validator = new Validator({
		element: '#form'
	});	
	validator.addItem({
		element: '#brandId',
		required: true,
		errormessageRequired: '请选择品牌'
	}).
	addItem({
		element: '#type3Id',
		required: true,
		errormessageRequired: '请选择类型'
	}).
	addItem({
		element: '#picUrl',
		required: true,
		errormessageRequired: '请上传图片'
	});
	
	var typeListLoaded,brandListLoaded;
	
	//加载品牌列表
	$.ajax({type: "get",url: "/view/model/BMManage/GoodsBrandManageMethod.php",dataType: "json",
		data: {
			'method':'List','lv':3,'type3Id':1
		},
		success: function(result) {
			if(result.Success){
				brandListLoaded = true;
				var brandListView = $('#brandId');
				var data = result.DataList;
				var addBrandItem =  function(brandItem){
					var viewItem = '<option value="'+brandItem.brand_id+'">'+brandItem.brand_name+'</option>';
					brandListView.append(viewItem);
				};
				_.each(data, addBrandItem);
			}
			else
				alert('获取品牌列表失败，请稍后重试。');
		},
		error: function(e) {alert("链接错误");}
	});
	
	//加载类型列表
	$.ajax({type: "post",url: "/view/model/BMManage/GoodsTypeManageMethod.php",dataType: "json",
		data: {
			'method':'List'
		},
		success: function(result) {
			if(result.Success){
				typeListLoaded = true;
				var typeListView = $('#type3Id');
				var data = result.DataList;
				var addTypeItem =  function(typeItem){
					var viewItem = '<option value="'+typeItem.type3_id+'">'+typeItem.type3_name+'</option>';
					typeListView.append(viewItem);
				};
				_.each(data, addTypeItem);
			}
			else
				alert('获取类型列表失败，请稍后重试。');
		},
		error: function(e) {alert("链接错误");}
	});
	
	$('button[type="submit"]').bind('click',function(){
		//品牌列表、类型列表加载完成之后才可以进行表单验证、提交。
		if(!typeListLoaded || !brandListLoaded)
		{
			alert('类型列表或品牌列表未加载完成，请稍后重试。');
			return false;
		}
		validator.execute(function(error, results, element) {
			if(!error) save();
		});
		return false;
	});

	function save()
	{
		var data = {
			"method": "Add",
			"brandId": $(".searchForm select[name='brandId']").val(),
			"type3Id": $(".searchForm select[name='type3Id']").val(),
			"barcode": $(".searchForm input[name='barcode']").val(),
			"name": $(".searchForm input[name='name']").val(),
			"weight": $(".searchForm input[name='weight']").val(),
			"stime": $(".searchForm input[name='stime']").val(),
			"etime": $(".searchForm input[name='etime']").val(),
			"picUrl": $(".searchForm input[name='picUrl']").val(),
			"number": $(".searchForm input[name='number']").val(),
			"price": $(".searchForm input[name='price']").val(),
			"aprice": $(".searchForm input[name='aprice']").val(),
			"remark": $(".searchForm input[name='remark']").val(),
			"unit": $(".searchForm input[name='unit']").val()			
		};
		$.ajax({type: "post",url: "/view/model/BMManage/GoodsManageMethod.php",dataType: "json",
			data: data,
			success: function(result) {
				if(result.Success){
					alert('添加成功');
				}
				else
					alert('添加失败');
			},
			error: function(e) {alert("链接错误");}
		});
	}	
	
	//ajax上传图片
	$('#doUpload').click(function(){
		$.ajaxFileUpload
        (
            {
                url:'doajaxfileupload.php', 
                secureuri:false,
                fileElementId:'fileToUpload',
                dataType: 'json',
                success: function (data, status)
                {
                    if(typeof(data.error) != 'undefined')
                    {
                        if(data.error != '')
                        {
                            alert(data.error);
                        }else
                        {
							//上传成功
							$('#fileToUploadWrapper').html('<div style="color:green">上传成功</div>');
							$('#fileToUploadWrapper').append('<img style="width:100px;height:100px;margin-top:5px" src="/view/cst/upload/'+data.filename+'"/>');
							
							$(".searchForm input[name='picUrl']").val('/view/cst/upload/'+data.filename);
                        }
                    }
                },
                error: function (data, status, e)
                {
                    alert(e);
                }
            }
        )
		return false;
	});
});