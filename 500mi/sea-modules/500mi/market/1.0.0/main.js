define(function(require){
	var $ = require("$");
	var Backbone = require("backbone");
	var _ = require("underscore");
	require("localStorage");
	require("common");
	
	// Load the application once the DOM is ready, using `jQuery.ready`:
	$(function(){
	
		// 商品模型 goods Model
		// --------------------
		
		//基本的商品模型，包括条形码，名称，图片地址，单价，单位，选择进货数量		
		var Goods = Backbone.Model.extend({
		
			//商品缺省属性
			defaults: function() {
				return {
					id : 0,
					barcode: 0,
					name: "",
					imgSrc: "",
					price: 0,
					unitName: "",
					amount: 1
				};
			},
			
			//设置进货数量
			setAmount: function(value,save) {
				var currAmount = value;
				if(currAmount < 1) currAmount = 1;
				save ? this.save({amount: currAmount}) : this.set({amount: currAmount});
			},
			
			//进货数量增加1
			increase: function(save) {
				var currAmount = this.get("amount");
				currAmount++;
				save ? this.save({amount: currAmount}) : this.set({amount: currAmount});
			},
			
			//进货数量减少1
			decrease: function(save){
				var currAmount = this.get("amount");
				currAmount--;
				if(currAmount < 1) currAmount = 1;
				save ? this.save({amount: currAmount}) : this.set({amount: currAmount});
			},
			
			//计算价钱
			calc : function(){
				return this.get('price') * this.get('amount');				
			}			
		});
		
		//商品集合 goods collection
		//-------------------------
		
		//商品列表数据来自服务器端。
		//选择进货数量为临时量不save		
		var GoodsList = Backbone.Collection.extend({
		
			//url
			url : "/500mi/data/goods_list.json",
		
			//列表的模型
			model: Goods

		});
		
		//购物车商品集合
		//--------------
		var Cart = Backbone.Collection.extend({
		
			// Reference to this collection's model.
			model: Goods,
			
			// Save all of the cart items under the `"cart"` namespace.
			localStorage: new Backbone.LocalStorage("cart"),
			
			//计算总价格
			calc: function(){
				var total = 0;
				this.each(function(goods){
					total += goods.calc();					
				});
				return total;
			}
		});
		
		//创建当前页的商品列表
		var currPageGoods = new GoodsList;
		
		//创建cart
		var cart = new Cart;
		
		var Market = Backbone.Model.extend({
			
			//url
			url : "/500mi/data/market.json",
			query : {
				page : 1,
				cateId: 0,
				brand: 'noname',
				t : (new Date()).getTime()
			}
			
		});
		
		var market = new Market;
		//market.on('all',function(m){console.log(m)})
		cart.on('all',function(m){console.log(m)})
		
		//单个商品视图
		//------------
		
		//定义单个商品的dom元素
		var GoodsView = Backbone.View.extend({
		
			//列表标签
			tagName: "li",
			
			//缓存单个商品的模版函数
			template: _.template($('#goods-template').html()),
			
			//dom events
			events: {
				"click .btn-plus" : "increase",
				"click .btn-minus" : "decrease",
				"blur input[type='text']" : "setAmount",
				"click .b-favorite" : "favoriteIt",
				"click .b-blue" : "buyIt"
			},
			
			//商品视图监听其模型数据，在模型改变时重新渲染。
			initialize: function(){
				//只有选择进货数量时才会触发change
				this.listenTo(this.model, 'change', this.render);
			},
			
			render: function(){
				this.$el.html(this.template(this.model.toJSON()));
				this.input = this.$("input[type='text']");
				return this;
			},
			
			increase : function(){
				this.model.increase();
			},
			
			decrease : function(){
				this.model.decrease();
			},
			
			setAmount : function(){
				var value = this.input.val();
				this.model.setAmount(value);
			},
			
			favoriteIt: function() {
				console.log(this.model)
			},
			
			buyIt: function() {
				if(!_.include(cart.localStorage.records, this.model.id.toString()))
					cart.create(_.clone(this.model.attributes));
				else
				{	
					var cartItem = cart.get(this.model.id);
					cartItem.setAmount(parseInt(cartItem.get("amount")) + parseInt(this.input.val()),true);
				}
			}
		});
		
		//app
		//---
		
		var MarketView = Backbone.View.extend({
		
			el: $("#market"),
			
			events : {
				"click #get-goods": "getData",
				"click #page a": "changePage"
			},
			
			initialize: function() {
				this.listenTo(currPageGoods, 'add', this.addToGoodsList);
				this.listenTo(market, 'sync', this.marketUpdate);
				
				this.listenTo(cart, 'add', this.addToCart);
				this.listenTo(cart, 'all', this.renderCart);
				
				cart.fetch();
			},
			
			addToCart: function(){
			
			},
			
			renderCart: function(){
			
				//更新购物车物品件数
				this.$('.cartNumber').text(cart.length);
				if(cart.length > 0)
					this.$('.tradeCart .empty').hide();
				else
					this.$('.tradeCart .empty').show();
				
				//更新总价格
				console.log(cart.calc());
				this.$('.tradeCart .op-settlement em').text('￥'+cart.calc());
				//更新其他
			},
			
			changePage: function(e){
				console.log(e);
			},
			
			marketUpdate: function(market){
				
				currPageGoods.set([]);
				//set商品集合
				currPageGoods.set(market.get('goodsList'),{});
				
				$('#page').html(market.get('page'));
			},
			
			addToGoodsList: function(goods){
				var view = new GoodsView({model: goods});
				this.$("#goods-list").append(view.render().el);				
			},
			
			getData : function(){				
				$("#market").addClass("loading-goods");
				$("#goods-list").html('');
				$("#page").html('');
				
				market.fetch({
					data : market.query,
					success: function(model, response, options){
						$("#market").removeClass("loading-goods");
					},
					error: function(model, response, options){
						$("#market").removeClass("loading-goods");
					}
				});
			}
		});
		
		var Market = new MarketView;
		
	});
});