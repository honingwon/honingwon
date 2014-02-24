define(function(require){
	require("common");
	require('cart');
	require("goodList");
	var $ = require('$');	
	
	$.ajax({type: "post",url: "/view/model/BMManage/GoodsTypeManageMethod.php",dataType: "json",
		data: {"method": "List"},
		success: function(result) {
			if(result.Success){
				var data = result.DataList,dataItem;
				var itemName,itemLevel,itemId;
				
				//生成面包屑导航
				var found;
				for(var i = 0; i < data.length; i++)
				{
					dataItem = data[i];
					if(dataItem['type'+TYPE_ID_LEVEL+'_id'] == TYPE_ID)
					{
						found = dataItem;
						break;
					}					
				}
				
				var html = '全部商品';
				for(var j = 1; j <= TYPE_ID_LEVEL; j++)
				{
					itemName = found['type'+j+'_name'];
					itemLevel = j;
					itemId = found['type'+j+'_id'];
					html += '>';					
					html += '<a href="/view/cst/store.php?typeId='+itemId+'&lv='+itemLevel+'">'+itemName+'</a>';
					
				}
				$("#crumbClip").html(html);
				
				//生成分类
				var foundList = [];
				var foundLi;
				for(var k = 0; k < data.length; k++)
				{
					dataItem = data[k];
					if(dataItem['type'+TYPE_ID_LEVEL+'_id'] == TYPE_ID)
						foundList.push(dataItem);
				}
				
				html = '';
				for(var l = 0; l < foundList.length; l++)
				{
					foundLi = foundList[l];
					itemName = foundLi.type3_name;
					itemLevel = 3;
					itemId = foundLi.type3_id;
					html += '<em>';
					html += '<a href="/view/cst/store.php?typeId='+itemId+'&lv='+itemLevel+'">'+itemName+'</a>';
					html += '</em>';
				}
				$("#type3IdList").html(html);				
			}
		},
		error: function(e) {alert("链接错误");}
	});
	
	
	$.ajax({type: "get",url: "/view/model/BMManage/GoodsBrandManageMethod.php",dataType: "json",
		data: {
			"method": "List",
			"type3Id": TYPE_ID,
			"lv": TYPE_ID_LEVEL,
		},
		success: function(result) {
			var data = result.DataList,dataItem;
			var html = '';
			var itemName,itemLevel,itemId,brandId;
			var pre='';
			
			//品牌列表			
			for(var i = 0; i < data.length; i++)
			{
				dataItem = data[i];
				
				itemName = dataItem.brand_name;
				itemLevel = TYPE_ID_LEVEL;
				itemId = TYPE_ID;
				brandId = dataItem.brand_id;
				
				pre = (brandId==BRAND_ID ? ' class="select"' : '');
				html += '<em'+pre+'>';				
				html += '<a href="/view/cst/store.php?typeId='+itemId+'&lv='+itemLevel+'&brandId='+brandId+'">'+itemName+'</a>';
				html += '</em>';
				
			}
			$("#brandList").html(html);
		},
		error: function(e) {alert("链接错误");}
	});
});