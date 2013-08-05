(function(document){
	
	var ACCOUNT_LENGTH = 10;
	var KEY = '123456';
	var NAME = '我勒个去';
	var ID = '110101196501012857';
	
	
	var STRING_START_INDEX = 6;
	var ACCOUNT_LENGTH_MAX = 47;
	
	var HREF_REG = 'http://reg.qule.com/register.jsp';
	var HREF_REG_SUC = 'reg.qule.com/reg_suc.jsp';
	var HREF_LOGGIN = 'login.qule.com/oauth.php';
	var HREF_LOGGIN_BACK = 'api.qule.com/login/loginBack?login=1';
	var HREF_GAME = 'http://9.qule.com/game.shtml?game=1026&zone=4';
	
	var MSG_ALL_FILLED = 'all filled!';
	var MES_REG_SUC = 'register suc!';
	var MES_LOGIN = 'please login!';
	var MES_LOGIN_SUC = 'login suc!';
	
	
	var currentHref = location.href;
	
	var removeIframe = function(){
		$('iframe').remove();
	};
	
	/*var getRandomString = function(len){
		len = len || ACCOUNT_LENGTH_MAX;
		var $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'; 
		var maxPos = $chars.length;
		var str = '';
		for (i = 0; i < len; i++) {
			str += $chars.charAt(Math.floor(Math.random() * maxPos));
		}
		return str;
	};*/
	
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
		
		removeIframe();
		$('title').text('');
		$('link').attr('href','');
		$('.regUl li').hide();
		//$('.regUl li:nth-child(1)').show();
		//$('.regUl li:nth-child(1) *').hide();
		//$('.regUl li:nth-child(1) .reg_input').show();
		$('.regUl li:nth-child(6)').show();
		$('.regUl li:nth-child(6) *').hide();
		$('.regUl li:nth-child(6) .reg_input').show();
		$('.regUl li:nth-child(6) img').show();
		$('.regUl li:nth-child(8)').show();	
		$('.regUl li:nth-child(8) *').hide();
		$('#vcode').attr('width','');
		$('#vcode').attr('height','');
		$('#submitBut').show().text('GO');
		
		$('#username').val(getRandomString(ACCOUNT_LENGTH));
		$('#userpwd').val(KEY);
		$('#realname').val(NAME);
		$('#idnum').val(ID);
		
		setTimeout(function(){
			window.location.reload();
		},20000);
	}
	else if(currentHref.indexOf(HREF_REG_SUC) != -1)
	{
		console.log(MES_REG_SUC);
		
		removeIframe();
	
		var allChar = $('.bar_middle_main_1 .d1').text();
		var account = allChar.slice(STRING_START_INDEX, STRING_START_INDEX + ACCOUNT_LENGTH);
		
		//记录已注册
		account = 'http://127.0.0.1/honingwon/snippets/php/csjz/w.php?account=' + account;
		$('body').append('<img src="' + account + '" />');
		
		location.href = HREF_REG;
	}
	else if(currentHref.indexOf(HREF_LOGGIN) != -1)
	{
		console.log(MES_LOGIN);
		
		$('title').text('');
		$('link').attr('href','');
		
		$('#password').val(KEY);
		
		$.getScript('http://127.0.0.1/honingwon/snippets/php/csjz/g.php');
	}
	else if(currentHref.indexOf(HREF_LOGGIN_BACK) != -1)
	{	
		console.log(MES_LOGIN_SUC);
		//希望能减少‘请从官网登录’弹出的概率，未验证
		setTimeout(function(){
			location.href = 'http://127.0.0.1/honingwon/snippets/php/csjz/m.php';
		},1000);	
	}
	
})(document);




