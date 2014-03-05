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
<script>
<?php 
if(isset($_GET['op']) )
	echo "var OP='edit'";
else
	echo "var OP='add'";
?>
</script>
</head>

<body id="cutoverWidth">
<div class="w_980">
<?php   include_once("head.php");	?>	
	
    <div id="mainBody">
	
	<?php   include_once("side.php");	?>	
		
		<div class="right-container" style="width: 985px;">
			<div class="headerForm"><h2>进货交易</h2></div>	
			<table class="dataTab">
				<thead>
					<tr>
                        <th width="35%">商品名称</th>
                        <th width="12%">规格</th>
                        <th width="7%" class="t-c">数量</th>
                        <th width="12%">价格</td>
                        <th width="9%">配送时间</td>
                        <th width="9%" class="t-r">订单状态</th>
                        <th width="11%" class="t-r">操作</th>
					</tr>
				</thead>
				<tbody id="orderList"></tbody>
			</table>			
		</div>
		
	</div>
</div>
<?php 
   include_once("foot.php");
?>
<script> 
seajs.use("500mi/tradeview/1.0.0/main");
</script>
</body>
</html>
