define(function(require){

	var cart = require('cart');
	console.log(cart);
	//cart.create({"barcode":1000,"name":"王老3吉","imgSrc":"/500mi/app/img/1.jpg","price":100,"unitName":"箱","id":10003,"amount":5})

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
		}		
	});	
	
	//商品集合 goods collection
	//商品列表数据来自服务器端。
	//选择进货数量为临时量不save		
	var GoodsList = Backbone.Collection.extend({
	
		//列表的模型
		model: Goods
	});
	
	var Market = Backbone.Model.extend({
		
		//url
		url : "./data/index.json",
		query : {
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
});
