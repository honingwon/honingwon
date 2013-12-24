define(function(require){
	var $ = require("$");
	var Backbone = require("backbone");
	var _ = require("underscore");
	
	// Load the application once the DOM is ready, using `jQuery.ready`:
	$(function(){
	
		// 商品模型 goods Model
		// --------------------
		
		//基本的商品模型，包括条形码，名称，图片地址，单价，单位，选择进货数量		
		var Goods = Backbone.Model.extend({
		
			//商品缺省属性
			defaults: function() {
				return {
					barcode: "none",
					name: "none",
					imgSrc: "none",
					price: 0,
					unitName: "none",
					amount: 1
				};
			},
			
			//设置进货数量
			setAmount: function(value) {
				this.save({amount: value});
			},
			
			//进货数量增加1
			increase: function() {
				var currAmount = this.get("amount");
				currAmount++;
				this.save({amount: currAmount});
			},
			
			//进货数量减少1
			decrease: function(){
				var currAmount = this.get("amount");
				currAmount--;
				if(currAmount < 1) currAmount = 1;
				this.save({amount: currAmount});
			},
			
		});
		
		//商品集合 goods collection
		//-------------------------
		
		//商品列表数据来自服务器端。
		//选择进货数量不保存		
		var GoodsList = Backbone.Collection.extend({
		
			//url
			url : "/500mi/data/goods_list.json",
		
			//列表的模型
			model: Goods,

		});
		
		//创建当前页的商品列表
		var currPageGoods = new GoodsList;
		
		//单个商品视图
		//------------
		
		//定义单个商品的dom元素
		var GoodsView = Backbone.View.extend({
		
			//列表标签
			tagName: "li",
			
			//缓存单个商品的模版函数
			//template: _.template($('#goods-template').html()),
			template: _.template('<input type="text"/>'),
			
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
				this.listenTo(this.model, 'change', this.render);
				this.listenTo(this.model, 'destroy', this.remove);
			},
			
			render: function(){
				this.$el.html(this.template(this.model.toJSON()));
				this.input = this.$("input[type='text']");
				this.input.val(this.model.get('amount'));
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
				this.model.save({amount: value});
			},
		});
		
		//app
		//---
		
		var AppView = Backbone.View.extend({
		
			el: $("#market-app"),
			
			events : {
				"click #get-goods": "getData"
			},
			
			initialize: function() {
				this.listenTo(currPageGoods, 'add', this.addOne);
				//this.listenTo(currPageGoods, 'reset', this.addAll);
				this.listenTo(currPageGoods, 'all', this.render);
			},
			
			addOne: function(goods){
				var view = new GoodsView({model: goods});
				this.$("#goods-list").append(view.render().el);
				console.log(goods)
			},
			
			getData : function(){
				currPageGoods.fetch({
					success: function(model,resp,option){
						//console.log(currPageGoods);
					}
				});
			}
		});
		
		var App = new AppView;
		
	});
});