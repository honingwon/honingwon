define(function(require){

	var cart = require('cart');

	var $ = require("$");
	var Backbone = require("backbone");
	var _ = require("underscore");	
	//扩展'backbone'模块
	require("localStorage");
	
	// 商品模型 goods Model
	var Goods = Backbone.Model.extend({
	
		//商品缺省属性
		defaults: function() {
			return {
				id : 0,
				goods_barcode: 0,
				goods_name: "",
				goods_weight:"",
				goods_pic_url: "",
				goods_active_price: 0,
				goods_unit: "",
				amount: 1
			};
		},
		//设置进货数量
		setAmount: function(value) {
			var currAmount = value;
			if(currAmount < 1) currAmount = 1;
			//fix：如果旧的值是1，输入为小于1的值，则不会触发change事件
			if(value < 1)
				this.set({amount: 0},{silent:true});
			this.set({amount: currAmount});
		},
		
		//进货数量增加1
		increase: function() {
			var currAmount = this.get("amount");
			currAmount++;
			this.set({amount: currAmount});
		},
		
		//进货数量减少1
		decrease: function(){
			var currAmount = this.get("amount");
			currAmount--;
			if(currAmount < 1) currAmount = 1;
			this.set({amount: currAmount});
		}
	});	
	
	//商品集合 goods collection	
	var GoodsList = Backbone.Collection.extend({
	
		//列表的模型
		model: Goods
	});
	
	var Market = Backbone.Model.extend({
		//url
		//url : "./data/market.json",
		url : "/view/model/BMManage/GoodsManageMethod.php",
		query : {
			lv : TYPE_ID_LEVEL,
			type3Id : TYPE_ID,
			offset : 0,
			pageSize : PAGE_SIZE,
			brandId : BRAND_ID,
			method: 'List',
			t : (new Date()).getTime()
		}
		
	});
	
	//创建当前页的商品列表
	var currPageGoods = new GoodsList;
	
	var market = new Market;
	
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
			"change input[type='text']" : "setAmount",
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
		
		increase : function(){
			this.model.increase();
		},
		
		decrease : function(){
			this.model.decrease();
		},
		
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

	var MarketView = Backbone.View.extend({
	
		el: $("#market"),
		
		events : {
			"click #page a": "changePage"
		},
		
		initialize: function() {
			
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
			currPageGoods.set(market.get('DataList'),{});
			
			//$('#page').html(market.get('page'));
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
