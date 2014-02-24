<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMAccount/IsLogin.php');	
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>500</title>
<link href="css/base.css" rel="stylesheet"/>
<link href="css/tradeConfirm.css" rel="stylesheet"/>
</head>

<body>
<div class="w_980">
	<div id="header">
    	<div id="Logo"><a href="index.php">超市通</a><b>杭州站</b></div>
        <div id="mallSearch">
        	<div class="search-box clear">
            	<input type="text" class="search-text" x-webkit-grammar="builtin:search" autocomplete="off" tabindex="9" accesskey="s" placeholder="商品名/条形码"></input>
                <button class="search-btn" type="submit">搜索</button>
            </div>           
        </div>
        <div class="sn-container">
        	<p class="sn-login">
                Hi, <?php if(isset($_SESSION['user'])) {$userName = $_SESSION['user'];echo $userName;}?> ! <a href="LoginOut.php">退出</a><i></i></p>
            <p class="sn-menu"><a href="myaddress.php">我的订单</a><a href="myaddress.php">个人资料</a></p>
        </div>
    </div>
    
	<div class="confirmBody">
		<div class="flow-steps">
            <ol>
                <li class="select"><h4>加入进货清单</h4><div class="frist">1</div></li>
                <li><h4>确认订单信息</h4><div class="mid">2</div></li>
                <li><h4>提交订单付款</h4><div class="mid">3</div></li>
                <li><h4>线下签收验货</h4><div class="last">4</div></li>
            </ol>
        </div>
		<div class="head"><h2>选择收货地址</h2><span></span></div>
		<ul class="select-address" id="select-address">
            <!--<li class="select">
                <label>
                    <input type="radio" name="r-address">
                    <em>汪星人杂货店</em> 
                    <span class="s-address">杭州市滨江区 闲林大道爵士风情小区大门口旁</span>
                    <span class="s-tel">13868029449</span>
                    <a class="s-edit" href="javascript:;">修改地址</a>
                </label>
            </li>
            <li>
                <label>
                    <input type="radio" name="r-address">
                    <em>汪星人杂货店</em> 
                    <span class="s-address">杭州市滨江区 闲林大道爵士风情小区大门口旁</span>
                    <span class="s-tel">13868029449</span>
                    <a class="s-edit" href="javascript:;">修改地址</a>
                </label>
            </li>-->
        </ul>
		
	</div>
	
	
</div>

<?php 
   include_once("foot.php");	
?>

<script>
seajs.use("500mi/confirm/1.0.0/main");
</script>
</body>
</html>
