define(function(require){
	var $ = require("$");
	var Backbone = require("backbone");
	var _ = require("underscore");
	
	// Load the application once the DOM is ready, using `jQuery.ready`:
	$(function(){
	
		// 商品模型 goods Model
		// 只fetch，不save
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
			setAmount: function(value) {
				var currAmount = value;
				if(currAmount < 1) currAmount = 1;
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
		//-------------------------
		
		//商品列表数据来自服务器端。
		//选择进货数量为临时量不save		
		var GoodsList = Backbone.Collection.extend({
		
			//url
			url : "/500mi/data/goods_list.json",
		
			//列表的模型
			model: Goods

		});
		
		//创建当前页的商品列表
		var currPageGoods = new GoodsList;
		
		var Market = Backbone.Model.extend({
			
			//url
			url: "url",
			
		});
		
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
				console.log(this.model)
			}
		});
		
		//app
		//---
		
		var AppView = Backbone.View.extend({
		
			el: $("#market-app"),
			
			events : {
				"click #get-goods": "getData",
				"click #page a": "getData"
			},
			
			initialize: function() {
				this.listenTo(currPageGoods, 'add', this.addOne);
				//this.listenTo(currPageGoods, 'reset', this.addAll);
				//this.listenTo(currPageGoods, 'all', this.render);
			},
			
			addOne: function(goods){
				var view = new GoodsView({model: goods});
				this.$("#goods-list").append(view.render().el);
				
			},
			
			getData : function(){
				$("#market-app").addClass("loading-goods");				
				$("#goods-list").html('');
				currPageGoods.set([]);
				currPageGoods.fetch({
					data : {
						page : 5,
						t : (new Date()).getTime()
					},
					success: function(model, response, options){
						$("#market-app").removeClass("loading-goods");
						//console.log(model);
						//console.log(response);
						//console.log(options);
					},
					error: function(model, response, options){
						$("#market-app").removeClass("loading-goods");
						//console.log(model);
						//console.log(response);
						//console.log(options);
					},
				});
			}
		});
		
		var App = new AppView;
		
	});
});