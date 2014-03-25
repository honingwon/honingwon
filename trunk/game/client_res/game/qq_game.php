<?php 
require_once 'OpenApiV3.php';
require_once 'config/config.php';

$openid = $_GET['openid'];
$openkey = $_GET['openkey'];
$pf = $_GET['pf'];
$pfkey = $_GET['pfkey'];

// 应用基本信息
$appid = $GLOBALS['APPID'];
$appkey = $GLOBALS['APPKEY'];
$server_name = $GLOBALS['SERVER_NAME'];


$sdk = new OpenApiV3($appid, $appkey);
$sdk->setServerName($server_name);
$ret = get_user_info($sdk, $openid, $openkey, $pf);

if($ret['ret'] <> 0)
{
	print_r("===========================\n");
	print_r($ret['msg']);
	die();
	return;
}
	

$ip = $GLOBALS['SERVER_IP'];
$fcm = $GLOBALS['DEFAULT_FCM'];
if($fcm=="")$fcm = 1;
$tstamp = time();
$site = $GLOBALS['SITE'] ;
$serverid = $GLOBALS['SERVERID'] ;
$key = $GLOBALS['LOGIN_SERVER_KEY'];

$tick = $tstamp."|".$ret['is_yellow_vip']."|".$ret['is_yellow_year_vip']."|".$ret['yellow_vip_level']."|".$ret['is_yellow_high_vip']."|".$fcm;
$sign = md5($openid.$site.$serverid.$tick.$key);
$port = $GLOBALS['SERVER_PORT'];
$guest = 0;
$param = sprintf("
	flashvars.user = '%s';
	flashvars.site = '%s';
	flashvars.serverid = %s;
	flashvars.tick ='%s';
	flashvars.sign = '%s';
	flashvars.fcm = %s;
	flashvars.pf = '%s';
	flashvars.pfKey = '%s';
	flashvars.openKey = '%s';
	flashvars.zoneId = %s;
	flashvars.domain = '%s';
	flashvars.ip = '%s';
	flashvars.port = %s;
	flashvars.isYellowVip = %s;
	flashvars.isYellowYearVip = %s;
	flashvars.yellowVipLevel = %s;
	flashvars.isYellowHighVip = %s;
	flashvars.guest = '%s';",
	$openid,
	$site,
	$serverid,
	$tick,
	$sign,
	$fcm,
	$pf,
	$pfkey,
	$openkey,
	$GLOBALS['ZONE_ID'],
	$GLOBALS['SERVER_NAME'],
	$ip,
	$port,
	$ret['is_yellow_vip'],
	$ret['is_yellow_year_vip'],
	$ret['yellow_vip_level'],
	$ret['is_yellow_high_vip'],
	$guest
	);	

$qq_param = sprintf("
	var appid = %s;
	var openid = '%s';
	var pf = '%s';
	var zone_id = %s;
	var isSandbox = %s;",
	$appid,$openid,$pf,$GLOBALS['ZONE_ID'],$GLOBALS['IS_SANDBOX']
);

	
function get_user_info($sdk, $openid, $openkey, $pf)
{
	$params = array(
		'openid' => $openid,
		'openkey' => $openkey,
		'pf' => $pf,
	);	
	$script_name = '/v3/user/get_info';
	return $sdk->api($script_name, $params,'post');
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 <title>盛世遮天</title>      
 <meta name="google" value="notranslate" />         
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <script type="text/javascript" src="jquery.js"></script>
 <script type="text/javascript" src="swfobject.js"></script>

<style type="text/css" media="screen"> 
body,html{height:100%;}
body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,form,fieldset,input,button,textarea,p,blockquote,th,td{margin:0;padding:0;}
table{border-collapse:collapse;border-spacing:0;}
img{border:0;}
a{ color:#FC6; outline:none; text-decoration:none;}
a:hover{text-decoration:underline;}
#flashContent {display:none;}

#mainBody{ width:100%; height:100%;}
#footerBar{ z-index:1000; position:absolute; bottom:0; width:100%; background:#000; color:#fffccc;font-size:12px; font-family:"Microsoft Yahei"; height:30px;}
	.barInfo{ position:absolute; top:5px; right:10px;}
	.barMenu{ position:absolute; top:5px; left:15px;}
	
</style>
<script type="text/javascript" charset="utf-8" src="http://fusion.qq.com/fusion_loader?appid=<?php echo $appid."&platform=".$pf?>"> </script>
 <script type="text/javascript" src="game.js?rn=<?php echo rand(); ?> "></script>
<script type="text/javascript">
	<?php echo $qq_param;?>
	
	var swfVersionStr = "10.0.0";
	var xiSwfUrlStr = "playerProductInstall.swf";
	var flashvars = {};
	<?php echo $param;?>
	
	var params = {};
	var wmodeOpaque = 0;
	var isFF = 0;
	if(navigator.userAgent.toLowerCase().indexOf("firefox") != -1)
		isFF = 1;
	var isChrome = 0;
	if(navigator.userAgent.toLowerCase().indexOf("chrome") != -1)
		isChrome = 1;
	var isOpera = 0;
	if(navigator.userAgent.toLowerCase().indexOf("opera") != -1)
		isOpera = 1;
	
	if(!isOpera && !isFF && !isChrome && wmodeOpaque){
		params.wmode = "opaque"; 
	} else {
		params.wmode = "window"; 
	} 
	
	params.quality = "high";
	params.bgcolor = "#293739";
	params.allowscriptaccess = "always";
	params.allowfullscreen = "true";
	            
	var attributes = {};
	attributes.id = "sszt_game";
	attributes.name = "sszt_game";
	attributes.align = "middle";
	swfobject.embedSWF("ssztStarter.swf?<?php echo time();?>", 
						"sszt_game", 
	                   	"100%", 
	                   	"100%", 
	                   	swfVersionStr, 
	                   	xiSwfUrlStr, 
	                   	flashvars, 
	                   	params, 
	                   	attributes);
	swfobject.createCSS("#flashContent", "display:block;text-align:left;");
//	var htmlImg = '';
//	setTimeout(function(){ 
//		document.getElementById('preload').innerHTML = htmlImg;
//		document.getElementById('preload').height = 12; 
//		document.getElementById('preload').width=1;}, 2000);
	
	function reloadPage(){
		window.location.reload();
	}

	function onBodyLoad(){
		var div = document.getElementById('sszt_game'); 
		if(div){
			div.focus();
		}
	}

	function doFullScene() {
			document.getElementById('container').style.height = "100%";
			document.getElementById('container').style.width = "100%";
			document.getElementById('sszt_game').style.height = "100%";
			document.getElementById('sszt_game').style.width = "100%";
	}


	function exitFullScene() {
			document.getElementById('container').style.height = "600px";
			document.getElementById('container').style.width = "1000px";
			document.getElementById('sszt_game').style.height = "600px";
			document.getElementById('sszt_game').style.width = "1000px";
	}
	
	function AddFavorite(url, name) {
		var url = "http://app100722626.openwebgame.pengyou.com/pengyou";
		var name = "盛世遮天";
	    try{
	        window.external.addFavorite(url, name);
	    }
	    catch(e){
	        try{
	                window.sidebar.addPanel(name, url, "");
	        }
	        catch(e){
	            alert("亲，你的浏览器不支持点击收藏，请猛击[Ctrl+D]收藏哦");
	        }
	    }
	}
	
</script>

</head>
<body scroll="no" onunload="showFavourite();" onload="onBodyLoad();">
<div id="container" style="margin:auto; height:100%;width:100%;">
<div id="sszt_game">
    <a href="http://www.adobe.com/go/getflashplayer">
                <font style="font-size:18px; color:#FFF; font-weight:800;">Get Adobe Flash player</font>
        </a>
</div>
</div>

<div id="footerBar">
	<div class="barMenu">
		<a href="javascript:qq_game.inviteFriend();" id=blink><img src="link_add.jpg" alt="邀请好友" /></a>
		<a href="http://bbs.open.qq.com/group-1032-1.html" target="_blank"><img src="link_forum.jpg" alt="论坛" /></a>
		<a href="javascript:AddFavorite('', '');" ><img src="link_sc.jpg" alt="添加收藏" /></a>
		<a href="http://wpa.qq.com/msgrd?v=3&uin=190639018&site=qq&menu=yes" target="_blank"><img src="link_service.jpg" alt="联系客服" /></a>
	</div>
	<div class="barInfo">
	官方Q群 326438140 您的OPENID是：<?php echo $openid;?> 本应用由北京华清飞扬提供，客服电话：(010)65101801 
    </div>
 </div>

</body>
</html>

<script type="text/javascript">

$(document).ready(function (){
	function resizeFlashDiv(){//调整右面flash框的宽度
        var container = $("#sszt_game");
        var containerHeight = $(document.body).height() - 30;
        var flashDivW = document.documentElement.clientWidth;
        container.css({"left":0,"width":flashDivW,"height":containerHeight});
	}
	resizeFlashDiv();
	$(window).resize(function(){
	        resizeFlashDiv();
	});

	try{
		 qq_game.initialize(appid, zone_id, isSandbox, openid, pf);
	}
	catch(err){
		alert('qq_game class error~');
	}
	   
    
});  



</script>

