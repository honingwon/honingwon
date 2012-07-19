console.log('executing do.js define...');
define(function (require, exports, module) {
	console.log('executing do.js factory...');
	require('jquery');
	require('jquery.plugA');	
	console.log('executing do.js factory completed!');
})
console.log('executing do.js define completed!');