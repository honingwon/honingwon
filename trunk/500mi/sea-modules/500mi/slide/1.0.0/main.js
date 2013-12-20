define(function(require){
	var Slide = require("slide");
	var slide1 = new Slide({
		element: '#slide-demo-1',
		effect: 'scrollx',
		interval: 3000
	}).render();
});