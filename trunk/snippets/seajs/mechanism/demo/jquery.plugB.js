console.log('executing jquery.plugB.js define...');
define(function (require, exports, module) {
	console.log('executing jquery.plugB.js factory...');
	require('jquery');	
	console.log('executing jquery.plugB.js factory completed!');
	return 'jquery.plugB';}
)
console.log('executing jquery.plugB.js define completed!');