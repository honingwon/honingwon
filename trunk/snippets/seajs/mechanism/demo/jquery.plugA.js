console.log('executing jquery.plugA.js define...');
define(function (require, exports, module) {
	console.log('executing jquery.plugA.js factory...');
	require('jquery');
	require('jquery.plugB');
	console.log('executing jquery.plugA.js factory complete!');
	return 'jquery.plugA';
})
console.log('executing jquery.plugA.js complete!');