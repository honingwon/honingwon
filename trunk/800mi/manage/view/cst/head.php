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
    <div id="actionBar">
    	<ul class="nav-main clear">
            <li class="select"><a href="index.php">首页</a></li>
            <!--<li><a href="store.php">超市进货</a></li>
            <li><a href="sell.html">活动区</a></li>-->
        </ul>
        <div class="nai-other clear">
            <!--<a href="favorites.html" class="btn-favorites">我的货架<s></s></a>-->
            <i class="gap"></i>
            <div class="tradeCart">
                <a href="tradeCart.html" class="btn-cart">进货清单<s></s></a>
                <b id="cartNumber" class="cartNumber">0</b>
                <div id="cart" class="s-tradeList">
					<form action="submit.php" method="post" style="display:none">
						<input type="hidden" name="cartdata"/>
					</form>
                    <ul id="cart-item-list"></ul>
                    <div class="empty">当前无进货清单！</div>
                    <div class="op-settlement">
                        <p>总金额：<em>￥0.0</em></p>
                        <a class="b-yellow" href="javascript:;">结算 (0件)</a>
                    </div>
                </div>
            </div><!--tradeCart end -->
        </div>
        <div class="category">
			<h2 class="c-mt">全部商品分类</h2>
			<div class="c-menu" id="category"></div>        
        </div><!-- category end -->
    </div>
	