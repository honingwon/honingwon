define(function(require){
	
	var $ = require("$");
	var Backbone = require("backbone");
	var _ = require("underscore");
	
	//扩展'backbone'模块
	require("localStorage");
	
	//加载公共模块，加载即执行
	require("common");
	
	$(function(){
	
		// 商品模型 goods Model
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
			//view为CartItmView时，设save为true将同步数据到本地存储
			setAmount: function(value,save) {
				var currAmount = value;
				if(currAmount < 1) currAmount = 1;
				save ? this.save({amount: currAmount}) : this.set({amount: currAmount});
			},
			
			//进货数量增加1
			//view为CartItmView时，设save为true将同步数据到本地存储
			increase: function(save) {
				var currAmount = this.get("amount");
				currAmount++;
				save ? this.save({amount: currAmount}) : this.set({amount: currAmount});
			},
			
			//进货数量减少1
			//view为CartItmView时，设save为true将同步数据到本地存储
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
		//商品列表数据来自服务器端。
		//选择进货数量为临时量不save		
		var GoodsList = Backbone.Collection.extend({
		
			//列表的模型
			model: Goods
		});
		
		//购物车商品集合
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
		
		var Market = Backbone.Model.extend({
			
			//url
			url : "/500mi/data/market.json",
			query : {
				page : 1,
				cateId: 0,
				brand: '',
				t : (new Date()).getTime()
			}
			
		});
		
		//创建当前页的商品列表
		var currPageGoods = new GoodsList;
		
		//创建cart
		var cart = new Cart;
		
		var market = new Market;
		//market.on('all',function(m){console.log(m)})
		//cart.on('all',function(m){
		//	console.log(m)
		//})
		
		//单个商品视图
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
				
				//此模型只有amount会change
				this.listenTo(this.model, 'change:amount', this.amountChanged);
			},
			
			amountChanged: function(){
				this.$input.val(this.model.get('amount'));
			},
			
			//初始化模型，先渲染才能进行别的操作
			//执行this.setAmount时this.$input已准备好
			render: function(){
				this.$el.html(this.template(this.model.toJSON()));
				this.$input = this.$("input[type='text']");
				return this;
			},
			
			//非同步数据操作
			increase : function(){
				this.model.increase();
			},
			
			//非同步数据操作
			decrease : function(){
				this.model.decrease();
			},
			
			//非同步数据操作
			setAmount : function(){
				var value = this.$input.val();
				this.model.setAmount(value);
			},
			
			//收藏
			favoriteIt: function() {
				console.log(this.model)
			},
			
			//进货
			buyIt: function() {
				//如果购物车里无此商品，那么添加此商品
				if(!_.include(cart.localStorage.records, this.model.id.toString()))
					cart.create(_.clone(this.model.attributes));
				//如果购物车里已有此商品，增加该商品的数量，数量为input的值
				else
				{	
					var cartItem = cart.get(this.model.id);
					cartItem.setAmount(parseInt(cartItem.get("amount")) + parseInt(this.$input.val()),true);
				}
			}
		});
		
		//cart item view
		var CartItemView = Backbone.View.extend({
			
			tagName: 'li',
			
			template: _.template($('#cart-item-template').html()),
			
			events: {
				'click .destroy' : 'clear',
				'click .btn-plus' : 'increase',
				'click .btn-minus' : 'decrease',
				'bur input[type="text"]': 'setAmount'
			},
			
			initialize: function() {
				this.listenTo(this.model, 'change:amount', this.amountChanged);
				this.listenTo(this.model, 'destroy', this.remove);
			},
			
			amountChanged: function(){
				this.$input.val(this.model.get('amount'));
			},
			
			//初始化模型，只执行一次，先渲染才能进行别的操作
			//执行this.setAmount时this.$input已准备好
			render: function() {
				this.$el.html(this.template(this.model.toJSON()));
				this.$input = this.$("input[type='text']");
				return this;
			},
			
			clear: function() {
			  this.model.destroy();
			},
			
			increase : function(){
				this.model.increase(true);
			},
			
			decrease : function(){
				this.model.decrease(true);
			},
			
			setAmount : function(){
				var value = this.$input.val();
				this.model.setAmount(value,true);
			}
		});
		
		//cart view
		var CartView = Backbone.View.extend({
		
			el: $('#cart'),
			
			events:{
				'click .b-yellow': 'submit'
			},
			
			initialize: function() {				
				this.listenTo(cart, 'add', this.addToCart);
				this.listenTo(cart, 'add remove change sync', this.renderCart);
				
				this.$cartNumber = $('#cartNumber');
				this.$emptyAttention = this.$('.empty');
				this.$total = this.$('.op-settlement em');
				this.$cartState = this.$('.op-settlement');
				this.$submit = this.$('.b-yellow');
				this.$form = this.$('form');
				this.$data = this.$('input[type="hidden"]');
				
				cart.fetch();
			},
			
			submit: function(){
				if(cart.length > 0)
				{
					var data = [];
					cart.each(function(goods){
						var dataItem = {};
						dataItem.id = goods.get('id');
						dataItem.amount = goods.get('amount');
						data.push(dataItem);
					});				
					this.$data.val(JSON.stringify(data));
					this.$form.submit();					
				}
			},
			
			addToCart: function(goods){
				var view = new CartItemView({model: goods});
				this.$("#cart-item-list").append(view.render().el);	
			},
			
			//add,remove,change
			renderCart: function(){
			
				//更新购物车物品件数
				this.$cartNumber.text(cart.length);
				if(cart.length > 0)
				{	
					this.$emptyAttention.hide();
					this.$cartState.show();
				}
				else
				{
					this.$emptyAttention.show();
					this.$cartState.hide();
				}					
				
				//更新总价格
				this.$total.text('￥'+cart.calc());
				
				//更新其他
				this.$submit.text('结算('+cart.length+')件');
			}
		});
		
		//app
		//---
		
		var MarketView = Backbone.View.extend({
		
			el: $("#market"),
			
			events : {
				"click #page a": "changePage"
			},
			
			initialize: function() {
			
				new CartView;
				
				this.listenTo(currPageGoods, 'add', this.addToGoodsList);
				this.listenTo(market, 'sync', this.marketUpdate);
				
				this.getData();
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
		
		var router = Backbone.Router.extend({
			routes: {
				"help":                 "help",    // #help
				"search/:query":        "search",  // #search/kiwis
				"search/:query/p:page": "search"   // #search/kiwis/p7
			},

			help: function() {
			},

			search: function(query, page) {
			}
		});
		
	});
});