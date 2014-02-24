define(function(require){
	var $ = require('$');
	
	// JavaScript Document
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
		$(".category .item").hoverForIE6({delay:0});
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