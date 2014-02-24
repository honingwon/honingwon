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
<?php
echo '<script>';
echo 'var TYPE_ID='.$_GET['typeId'].', ';
echo 'TYPE_ID_LEVEL='.$_GET['lv'].', ';
if(isset($_GET['brandId']))
{
	echo 'BRAND_ID='.$_GET['brandId'].', ';
}
else
{
	echo 'BRAND_ID=0, ';
}
echo 'PAGE_SIZE=999999;';
echo '</script>';
?>
</head>

<body id="store">
<div class="w_980">
<?php   include_once("head.php");	?>
	
	<div id="mainBody"><div id="market">
        <div id="crumbClip" class="crumbClip">加载中...</div>
        <div class="filter-searchForm">
            <div class='f-lists'>
                <dl class='fore'>
                    <dt><em>品牌：</em></dt>
                    <dd id="brandList">
                        加载中...<!--<em class="select"><a href='#'>华味亨</a></em>
                        <em><a href='#'>超龙</a></em>-->
                    </dd>
                </dl>
                <dl>
                    <dt><em>分类：</em></dt>
                    <dd id="type3IdList">加载中...</dd>
                </dl>
                <!--<dl>
                    <dt><em>供货商：</em></dt>
                    <dd>
                        <em><a href='#'>科学与自然</a></em>
                        <em><a href='#'>计算机与互联网</a></em>
                        <em><a href='#'>体育/运动</a></em>
                    </dd>
                </dl>-->
            </div>
        </div><!-- filter-navForm end -->
        <div class="filter-navForm">
            <ul class='f-sort'>
               <li class="select"><a href="javascript:;">全部商品</a></li>
            </ul>
            <div class="select-page">
                <span class="p-total">共2905个商品</span>  
                <div class="p-pages">                
                    <a href="javascript:;">上一页</a>
                    <a href="javascript:;">下一页</a>
                </div>
            </div>
        </div><!-- filter-navForm end -->
        
		<div class="output-list">
			<ul id="goods-list" class="Commodity"></ul>
		</div>
		<div id="page" class="select-page"></div>
	</div></div>
</div>
<?php 
   include_once("foot.php");
?>
<script>
seajs.use("500mi/market/1.0.0/main");
</script>
<script type="text/template" id="goods-template">
<div class="item-box">
	<div class="code" title="条形码"><%- goods_barcode %></div>
	<img src="<%- goods_pic_url %>">
	<div class="price"><em>￥<%- goods_active_price %>/<%- goods_unit %></em><!--<span>216G*6盒</span>--></div>
	<div class="title" title="<%- goods_name %>"><%- goods_name %></div>
	<div class="inforBar">
		<p><span class="b-tong" title="统一配送">统</span><span class="b-tui" title="过期可退">退</span></p>
		<a href="javascript:;" class="b-favorite">收藏到货架</a>
	</div>
	<div class="bar">
		<div class="op-amount">
			<input type="text" maxlength="4" value="<%- amount %>">
			<a class="btn-plus" href="javascript:;" title="增加物品"></a>
			<a class="btn-minus" href="javascript:;" title="减少物品"></a>
		</div>
		<a class="b-blue" href="javascript:;" >进货</a>
	</div>
</div>
</script>
</body>
</html>
