define(function(require){
	var $ = require('$');
	var _ = require('underscore');
	
	//jQuery扩展：鼠标移入
	(function($){
		$.fn.hoverForIE6=function(option){
			var s=$.extend({current:"hover",delay:10},option||{});
			$.each(this,function(){
				var timer1=null,timer2=null,flag=false;
				$(this).bind("mouseover",function(){
					if (flag){
						clearTimeout(timer2);
					}else{
						var _this=$(this);
						timer1=setTimeout(function(){
							_this.addClass(s.current);
							flag=true;
						},s.delay/2);
					}
				}).bind("mouseout",function(){
					if (flag){
						var _this=$(this);timer2=setTimeout(function(){
							_this.removeClass(s.current);
							flag=false;
						},s.delay);
					}else{
						clearTimeout(timer1);
					}
				})
			})
		}
	})($);

	//动态商品分类
	(function(root){
	
		var findItemByTypeId = function(list,id,type){
			var ret = false;
			for(var i=0;i<list.length;i++)
			{
				if(list[i]['type'+type+'_id'] == id)
				{	
					ret = list[i];
					break;
				}
			}
			return ret;
		};
		//重组数据
		var rebuildData = function(data){
			/*
			ret:
			[
				{
					type1_id:1,
					type1_name:日化,
					type2List:[
						{
							type2_id:2,
							type2_name:洗衣液,
							type3List:[
								{
									type3_id: "1",
									type3_name: "天然"
								},
								{}
							]							
						},
						{}
					]
				},
				{}				
			]
			*/
			var ret = [];
			_.each(data,function(item){
				var retItem = findItemByTypeId(ret,item.type1_id,1);
				if(!retItem)
				{
					retItem = {
						type1_id:item.type1_id,
						type1_name:item.type1_name,
						type2List:[]
					};
					ret.push(retItem);
				}
				
				var retItemType2Item = findItemByTypeId(retItem.type2List,item.type2_id,2);
				if(!retItemType2Item)
				{
					retItemType2Item = {
						type2_id:item.type2_id,
						type2_name:item.type2_name,
						type3List:[]
					};
					retItem.type2List.push(retItemType2Item);
				}
				
				var retItemType3Item = findItemByTypeId(retItemType2Item.type3List,item.type3_id,3);
				if(!retItemType3Item)
				{
					retItemType3Item = {
						type3_id:item.type3_id,
						type3_name:item.type3_name,
					};
					retItemType2Item.type3List.push(retItemType3Item);
				}
				
			});	
			
			return ret;
		};
		
		var createItem = function(itemData,index){
			var ret = '';
			ret += '<div class="item'+(index%2 ? ' itemEven' : '')+'">'
			
            ret += '<span><h3><a href="/view/cst/store.php?typeId='+itemData.type1_id+'&lv=1'+'">'+itemData.type1_name+'</a></h3><p>';
			for(var i=0; i < itemData.type2List.length; i++)
			{
				ret += createType2Item(itemData.type2List[i],i);
			}			
            ret += '</p></span>';
			
			ret += '<div class="i-mc"><div class="shoadw"></div>';			
			for(var j=0; j < itemData.type2List.length; j++)
			{
				ret += createType3ListItem(itemData.type2List[j],j);
			}
			
			ret += '</div></div>';
			return ret
		};
		
		var createType2Item = function(type2ItemData,index){
			var ret = '';
			ret += '<a href="/view/cst/store.php?typeId='+type2ItemData.type2_id+'&lv=2'+'">'+type2ItemData.type2_name+'</a>';
			return ret
		}
		
		var createType3ListItem = function(type2ItemData,index){
			var ret = '';
			
			ret += '<dl'+(index==0 ? ' class="fore"' : '')+'>';
			ret += '<dt><a href="/view/cst/store.php?typeId='+type2ItemData.type2_id+'&lv=2'+'">'+type2ItemData.type2_name+'</a></dt><dd>';
			
			for(var i=0; i < type2ItemData.type3List.length; i++)
			{
				ret += createType3Item(type2ItemData.type3List[i],i);
			}
			
			ret += '</dd></dl>';
			
			return ret
		}
		
		var createType3Item = function(type3ItemData,index){
			var ret = '';
			ret += '<em><a href="/view/cst/store.php?typeId='+type3ItemData.type3_id+'&lv=3'+'">'+type3ItemData.type3_name+'</a></em>';
			return ret
		}
		
		$.ajax({type: "post",url: "/view/model/BMManage/GoodsTypeManageMethod.php",dataType: "json",
			data: {"method": "List"},
			success: function(result) {
				if(result.Success){
					var rebuildedData = rebuildData(result.DataList);					
					//console.log('rebuildedData:');
					//console.log(rebuildedData);
					var html = '',i=0;
					_.each(rebuildedData,function(dataItem){
						html += createItem(dataItem,i);
						i++
					});
					$('#category').append(html);
					$(".category .item").hoverForIE6({delay:0});
				}
			},
			error: function(e) {alert("链接错误");}
		});
		
	})(this);	
	
	//添加分类导航行为，等。
	//itemWidth,leftGap,minItemAmount
	var wArray = [0,0,0];
	$(document).ready(function(){
		setFixedLeft(980);
		var currentPage = $("body").attr("id");
		if(currentPage == "index")
			$(".category").addClass("categoryHover");
		else
			$(".category").hoverForIE6({current:"categoryHover",delay:0});
			
		switch(currentPage)
		{
			case "index":
				break;
			case "store":
				wArray = [222,0,5];
				setContentWidth(wArray);
				$(window).bind("resize",function(){setContentWidth(wArray);});
				break;
			case "favorites":		
				wArray = [222,215,4];
				setContentWidth(wArray);
				$(window).bind("resize",function(){setContentWidth(wArray);});
				$(window).bind("scroll",reckonFixed);
				$(window).bind("resize",reckonFixed);
				break;
			case "cutoverWidth":
				cutoverWidth();
				$(window).bind("resize",cutoverWidth);
				break;
			default:
		}
		setFixedLeft();
		$(window).bind("resize",setFixedLeft);
		$(".tradeCart").hoverForIE6({current:"tradeCartHover",delay:200});
		$(".contact").hoverForIE6({current:"contactHover",delay:0});
		
		$(".toTop").click(function(){$(document).scrollTop(0);});
		$(window).bind("scroll",function(){
			if($(document).scrollTop() > 200) $(".toTop").show(10); else $(".toTop").hide();
		});
	});

	function navigateFixed(){
		if($(document).scrollTop() >80)
			$("#actionBar").addClass("cateFixed");
		else
			$("#actionBar").removeClass("cateFixed");
	}
	function reckonFixed(){
		if($(document).scrollTop() >= 130)
		{
			$(".side-reckon").addClass("side-reckon-fixed");
			$(".side-reckon").css("left",Math.max(($(window).width()-$(".w_980").width())/2,0) + "px");
		}
		else
		{
			$(".side-reckon").removeClass("side-reckon-fixed");
			$(".side-reckon").css("left",0);
		}
	}
	function setContentWidth(iArray){
		if(iArray[0] < 1) return;
		var conWidth = $(window).width() - 200 - iArray[1];
		var colNumber = Math.floor(conWidth/iArray[0]);
		var setWidth = colNumber * iArray[0] + iArray[1];
		if(setWidth < 980) setWidth = iArray[2] * iArray[0] + iArray[1];
		$(".w_980").css("width",setWidth + "px");
	}
	function cutoverWidth(){
		var conWidth = $(window).width();	
		if(conWidth > 1200)
		{
			$(".w_980").css("width",1200 + "px");
			$(".right-container").css("width",985 + "px");
		}
		else
		{
			$(".w_980").css("width",980 + "px");
			$(".right-container").css("width",765 + "px");
		}
	}
	function setFixedLeft(){
		var conWidth = $(document).width();	
		var w = $(".w_980").width();
		var leftGap = conWidth<=(w+65)?10:(conWidth-w)/2 - 65;
		$(".ft-fixed-right").css("right",leftGap + "px");
		if($(document).scrollTop() > 200) $(".toTop").show(10); else $(".toTop").hide();
	}	
	
});