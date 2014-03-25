<?php 
$openid = $_GET['user'];
$ip = $_GET['server'];
$serverid = $_GET['fcm'];
$fcm = 1;
$y1 = $_GET['y1'];
$y2 = $_GET['y2'];
$y3 = $_GET['y3'];
$y4 = $_GET['y4'];

if($fcm=="")$fcm = 1;
$tstamp = time();
$site = "sszt";
$key = "qq-zone-710-5000-cm3d";
$tick = $tstamp."|".$y1."|".$y2."|".$y3."|".$y4."|".$fcm;
$sign = md5($openid.$site.$serverid.$tick.$key);
$port = 8010;
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
	flashvars.guest = '%s'",
	$openid,
	$site,
	$serverid,
	$tick,
	$sign,
	$fcm,
	"","","",0,"119.147.19.43",
	$ip,
	$port,
	$y1,
	$y2,
	$y3,
	$y4,
	$guest
	);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 <title>盛世遮天</title>      
 <meta name="google" value="notranslate" />         
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <script type="text/javascript" src="game.js"></script>
        <script type="text/javascript" src="swfobject.js"></script>

<style type="text/css" media="screen"> 
html,body{height:100%;width:100%;padding:0px;margin:0px;}
body {
		padding:0; height:100%; overflow:hidden; 
		clear:both; text-align:center; 
		background-color: #293739; width:100%; 
} 
a:link {
	color: #333333;
	text-decoration: none;
}
a:visited {
	text-decoration: none;
	color: #333333;
}
a:hover {
	text-decoration: underline;
	color: #FF3300;
	ackground:#f29901;
}
a:active {
	text-decoration: none;
}
.jianju{
margin: 0 5px;
}
#flashContent {display:none;}

</style>

<script type="text/javascript">
	var swfVersionStr = "10.0.0";
	var xiSwfUrlStr = "playerProductInstall.swf";
	var flashvars = {};
	<?php
	
	echo $param;
	?>
	
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
	var htmlImg = '';
	setTimeout(function(){ 
		document.getElementById('preload').innerHTML = htmlImg;
		document.getElementById('preload').height = 12; 
		document.getElementById('preload').width=1;}, 2000);
</script>
<script type="text/javascript"> 

function reloadPage(){
	window.location.reload();
}

function onBodyLoad(){
	var div = document.getElementById('sszt_game'); 
	if(div){
		div.focus();
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
<div id="preload" style="height:6px; overflow:hidden; display:none; width:6px; clear:both;">
</div>

</body>
</html>
