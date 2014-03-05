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
<?php 
if(isset($_POST['cartdata']))
{
	echo '<script>var CART_DATA = '.$_POST['cartdata'].'</script>';
}
else
{
	echo '<script>location.href="/view/cst/index.php"</script>';
}
?>
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
            <p class="sn-menu"><a href="tradeView.php">我的订单</a><a href="myaddress.php">个人资料</a></p>
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
		<ul class="select-address" id="select-address"></ul>
		<div class="head"><h2>进货清单确认</h2><span>享全部商品满 500元免运费, 0~500元需 10 元运费(补贴物流商)</span></div>
		<table class="order-table">
            <thead>
                <tr>
                    <th class="s-code">条形码</th>
                    <th class="s-title">商品名称</th>
                    <th class="s-sp">规格</th>
                    <th class="s-amount">数量</th>
                    <th class="s-price">单价(元)</th>
                    <th class="s-agio">优惠(元)</th>
                    <th class="s-total">小计(元)</th>
                </tr>
            </thead>
            <tbody id="goodList"></tbody>
			<tfoot>
                <tr class="statistics">
                    <td colspan="3">
                        <!--<p class="delivery">配送时间：<em>2013-12-20 17:00:00</em></p>-->
                    </td>
                    <td colspan="4">                	
                        <div class="total">
                            <p>总计:<em id="total">0</em></p>
                            <p>运费:<em>0</em></p>
                        </div>
                        <div class="amout">
                            <em id="amount">0</em>件商品
                        </div>
                    </td>
                </tr>
                <tr class="actualPaid">
                    <td colspan="7">
                        实付款：<em id="total2"><!--¥219.00--></em>
                    </td>
                </tr>
                <tr class="submit">
                    <td colspan="7">
                        <a class="return" href="/view/cst/index.php">继续进货</a>
                        <button id="submit" type="button" class="b-blue">提交订单</button>
                    </td>
                </tr>
            </tfoot>
		</table>
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
