define(function(require){

	//加载公共模块，加载即执行
	require("common");
	require("cart");
	
	var $ = require("$");
	
	//首页slide
	var Slide = require("slide");
	var slide1 = new Slide({
		element: '#slide',
		effect: 'scrollx',
		interval: 3000
	}).render();
});