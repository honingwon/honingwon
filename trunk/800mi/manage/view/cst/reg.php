<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>500</title>
<link href="css/login.css" rel="stylesheet"></link>
</head>

<body>
<div class="login">
	<div class="web-info">
    	<h2>超市通</h2>
        <dl>
        	<dt>一键完成订单所有操作，免去线上繁琐订货步骤！</dt>
            <dd>1、电话申请入驻超市通</dd>
            <dd>2、登录挑选进货物品</dd>
            <dd>3、提交进货清单</dd>
            <dd>4、坐等收货</dd>
        </dl>        
        <ul>
        	<li class="i1">
            	<h3>超市进货</h3>
                <span>0571-87382079</span>
            </li>
            <li class="i2">
            	<h3>供应商入驻</h3>
                <span>0571-87382079</span>
            </li>
        </ul>
    </div>
    <div class="form-login"><form name="form1" method="post" action="Login.php">
    	<h2>用户注册</h2>
        <div class="field">
        	<label>帐号</label>
            <input type="text" class="input" name="account" id="account" />
			<label>昵称</label>
            <input type="text" class="input" name="name" id="name" />
            <p class="btn" style="padding:18px 0 0"><button id="submit" type="submit">注册</button></p>
        </div>
    </div></form>
</div>
<div id="footer">
	<p>Copyright© 超市通 2013，All Rights Reserved 浙ICP备12019345</p>
</div>
<script src="./sea-modules/seajs/seajs/2.1.1/sea.js"></script>
<script>
seajs.config({
	base: "./sea-modules/",
	alias: {
		"$": "jquery/jquery/1.10.1/jquery.js"
	}
});  
seajs.use('500mi/reg/1.0.0/reg');
</script>
</body>
</html>
