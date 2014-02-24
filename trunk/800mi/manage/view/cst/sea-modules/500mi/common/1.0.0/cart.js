//公共模块 ： 购物车模块
define(function(require,exports,module){
	
	var $ = require("$");
	var Backbone = require("backbone");
	var _ = require("underscore");
	
	//扩展'backbone'模块
	require("localStorage");
	
	//$(function(){
	
		
		var CART_ITEM_TEMPLATE = 
		'<img src="<%- goods_pic_url %>">' +
		'<h3><%- goods_name %></h3>' +
		'<div class="op-amount">' +
		'	<input type="text" value="<%- amount %>" maxlength="4">' +
		'	<a class="btn-plus" href="javascript:;" title="增加物品">+</a>' +
		'	<a class="btn-minus" href="javascript:;" title="减少物品">-</a>' +
		'</div>' +
		'<p><em>￥<%- goods_active_price %></em><a class="destroy" href="javascript:;">删除</a></p>';
		
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
					this.save({amount: 0},{silent:true});
				this.save({amount: currAmount})
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
			
			//计算价钱
			calc : function(){
				return this.get('goods_price') * this.get('amount');				
			}			
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
		
		//创建cart
		var cart = new Cart;
		
		//cart item view
		var CartItemView = Backbone.View.extend({
			
			tagName: 'li',
			
			template: _.template(CART_ITEM_TEMPLATE),
			
			events: {
				'click .destroy' : 'clear',
				'click .btn-plus' : 'increase',
				'click .btn-minus' : 'decrease',
				'change input[type="text"]': 'setAmount'
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
				this.model.increase();
			},
			
			decrease : function(){
				this.model.decrease();
			},
			
			setAmount : function(){
				var value = this.$input.val();
				this.model.setAmount(value);
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
		new CartView;
		
		module.exports = cart;
	//});
	
});