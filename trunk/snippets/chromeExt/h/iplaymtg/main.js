(function(document){
	
	var currentHref = location.href;
	
	var HREF_REG = 'id=bgtrend_hearthstone:forge-pick-card';
	
	function hide(selector){
		$(selector).hide();
	};
	
	function style(selector,val){
		$(selector).attr('style',val);
	};
	
	if(currentHref.indexOf(HREF_REG) != -1)
	{
		hide('.masthead');
		hide('.nav');
		hide('.nav');
		hide('.forge-stat .picked_hero');
		
		style('.wp','position:relative;min-height: 480px;');
		style('.hint','margin:0');
		style('.hero_picker','width:400px');
		style('.picked-cards','float:left;min-height:280px');
		style('.hero_picker a.hero img','width:120px');
		style('.hero_picker a.hero','width:120px');
		style('.forge-stat','float:none; width:331px;position:absolute;left:0;top:256px');
	}
	
	
	
	/*var ACCOUNT_LENGTH = 10;
	var KEY = '123456';
	var NAME = '我勒个去';
	var ID = '110101196501012857';
	var EMAIL = 'honingwon@gmail.com';
	
	
	var STRING_START_INDEX = 4;
	var ACCOUNT_LENGTH_MAX = 20;
	
	var HREF_REG = 'www.37wan.com/users/register.php';
	var HREF_REG_SUC = 'reg_suc';
	var HREF_LOGGIN = 'anhei.37wan.com/404.html';
	var HREF_LOGGIN_BACK = 'anhei.37wan.com/game_login.php';
	var HREF_GAME = '';
	
	var MSG_ALL_FILLED = 'all filled!';
	var MES_REG_SUC = 'register suc!';
	var MES_LOGIN = 'please login!';
	var MES_LOGIN_SUC = 'login suc!';
	
	
	var currentHref = location.href;
	
	var removeIframe = function(){
		$('iframe').remove();
	};
	
	var getRandomString = function(len){
		len = len || ACCOUNT_LENGTH_MAX;
		var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'; 
		var nums = '1234567890'
		var maxPos = chars.length;
		var numsMaxPos = nums.length;
		var str = '';
		for (i = 0; i < len; i++) {
			if(i % 2 == 0)
				str += chars.charAt(Math.floor(Math.random() * maxPos));
			else 
				str += nums.charAt(Math.floor(Math.random() * numsMaxPos));
		}
		return str;
	};
	
	if(currentHref.indexOf(HREF_REG) != -1 )
	{
		console.log(MSG_ALL_FILLED);
		
		//var account = getRandomString(ACCOUNT_LENGTH);
		
		//$('#login_account').val(account);
		/*$('#password').val(KEY);
		$('#password1').val(KEY);
		$('#name').val(NAME);
		$('#email').val(EMAIL);		
		$('#id_card_number').val(ID);*/
		
		//$.getScript('http://127.0.0.1/honingwon/snippets/php/37csjz/r.php?account='+account);
		//setTimeout(function(){
		//	window.location.reload();
		//},10000);
	/*}
	else if(currentHref.indexOf(HREF_REG_SUC) != -1)
	{
		console.log(MES_REG_SUC);
	}
	else if(currentHref.indexOf(HREF_LOGGIN) != -1)
	{
		console.log(MES_LOGIN);
		
		$.getScript('http://127.0.0.1/honingwon/snippets/php/37csjz/login.php');
	}
	else if(currentHref.indexOf(HREF_LOGGIN_BACK) != -1)
	{	
		console.log(MES_LOGIN_SUC);	
		$.getScript('http://127.0.0.1/honingwon/snippets/php/37csjz/m.php');
	}*/
})(document);




