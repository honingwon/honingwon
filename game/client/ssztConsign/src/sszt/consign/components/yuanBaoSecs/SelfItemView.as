package sszt.consign.components.yuanBaoSecs
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.consign.data.GoldConsignItem;
	import sszt.consign.events.ConsignEvent;
	import sszt.consign.mediator.ConsignMediator;
	import sszt.core.manager.LanguageManager;
	
	public class SelfItemView extends Sprite
	{
		private var _price:MAssetLabel;
		private var _count:MAssetLabel;
		private var _operate:TextField;
		private var _type:int;
		private var _typeLabel:MAssetLabel;
		private var _shape:Sprite;
		private var _mediator:ConsignMediator;
		private var _info:GoldConsignItem;
		
		public function SelfItemView(mediator:ConsignMediator,info:GoldConsignItem)
		{
			_mediator = mediator;
			_info = info;
			super();
			initView();
		}
		 public function get info():GoldConsignItem
		 {
			 return _info;
		 }
		
		public function get type():int
		{
			return _type;
		}
		
		private function initView():void
		{
			mouseEnabled = false;
			mouseChildren = true;
			
			_typeLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_typeLabel.move(18,3);
			addChild(_typeLabel);
			if(_type == 0)
				_typeLabel.setValue(LanguageManager.getWord("ssztl.consign.requireBuy"));
			else
				_typeLabel.setValue(LanguageManager.getWord("ssztl.common.sell"));
			
			_price = new MAssetLabel(LanguageManager.getWord("ssztl.consign.tenDolllar"),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_price.move(95,3);
			addChild(_price);
			
			_count = new MAssetLabel("78",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_count.move(175,3);
			addChild(_count);
			
			_operate = new TextField();
			_operate.textColor = 0x00ff1d;
			_operate.x = 228;
			_operate.y = 3;
			_operate.width = 30;
			_operate.height = 24;
			_operate.htmlText = "<u>撤销<u>";
			addChild(_operate);
			
			_shape = new Sprite();
			_shape.buttonMode = true;
			_shape.graphics.beginFill(0,0);
			_shape.graphics.drawRect(228,3,30,24);
			_shape.graphics.endFill();
			addChild(_shape);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_shape.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function removeEvent():void
		{
			_shape.removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			MAlert.show(LanguageManager.getWord("ssztl.consign.isSureRepeal"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,alertHandler);
		}
		
		private function alertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				_mediator.sendDeleteBill(_info.listId);
			}
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			_price = null;
			_count = null;
			_operate = null;
			_typeLabel = null;
			removeChild(_shape);
			_shape = null;
			if(parent) parent.removeChild(this);
		}
	}
}