package sszt.consign.components.yuanBaoSecs
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.consign.data.GoldConsignItem;
	import sszt.consign.events.ConsignEvent;
	import sszt.consign.mediator.ConsignMediator;
	import sszt.core.manager.LanguageManager;
	
	public class OtherItemView extends Sprite
	{
		private var _price:MAssetLabel;
		private var _count:MAssetLabel;
		private var _operate:TextField;
		private var _shape:Sprite;
		/**
		 *0，买入；1，卖出 
		 */		
		private var _type:int;
		private var _mediator:ConsignMediator;
		private var _money:int;
		private var _info:GoldConsignItem;
		
		public function OtherItemView(mediator:ConsignMediator,info:GoldConsignItem)
		{
			_info = info;
			_mediator = mediator;
			super();
			initView();
		}
		
		public function get info():GoldConsignItem
		{
			return _info;
		}
		
		private function initView():void
		{
			mouseEnabled = false;
			mouseChildren = true;
			
			_money = _info.price;
			_price = new MAssetLabel(_money +"两",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_price.move(36,3);
			addChild(_price);
			
			_count = new MAssetLabel(_info.count.toString(),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_count.move(122,3);
			addChild(_count);
			
			_operate = new TextField();
			_operate.textColor = 0x00ff1d;
			_operate.mouseEnabled = _operate.mouseWheelEnabled = false;
			_operate.x = 206;
			_operate.y = 3;
			_operate.width = 30;
			_operate.height = 24;
			if(_type == 0)
				_operate.htmlText = "<u>"+LanguageManager.getWord("ssztl.consign.buyIn")+"<u>";
			else
				_operate.htmlText = "<u>"+LanguageManager.getWord("ssztl.consign.sellOut")+"<u>";
			addChild(_operate);
			
			_shape = new Sprite();
			_shape.buttonMode = true;
			_shape.graphics.beginFill(0,0);
			_shape.graphics.drawRect(206,3,30,24);
			_shape.graphics.endFill();
			addChild(_shape);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_shape.addEventListener(MouseEvent.CLICK,clickHandler);	
			_info.addEventListener(ConsignEvent.GOLD_ITEM_UPDATE,infoUpdateHandler);
		}
		
		private function removeEvent():void
		{
			_shape.removeEventListener(MouseEvent.CLICK,clickHandler);
			_info.removeEventListener(ConsignEvent.GOLD_ITEM_UPDATE,infoUpdateHandler);
		}
		
		private function infoUpdateHandler(evt:ConsignEvent):void
		{
			_count.setValue(String(_info.count));
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
//			_mediator.showPopUpPanel(_type,false,_info.listId,_money);
		}
	
		public function dispose():void
		{
			removeEvent();
			_mediator = null;
			_info = null;
			_price = null;
			_count = null;
			_operate = null;
			removeChild(_shape);
			_shape = null;
			if(parent) parent.removeChild(this);
		}
	}
}